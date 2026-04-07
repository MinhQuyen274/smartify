#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/event_groups.h"
#include "esp_system.h"
#include "esp_wifi.h"
#include "esp_event.h"
#include "esp_log.h"
#include "nvs_flash.h"
#include "driver/gpio.h"
#include "mqtt_client.h"
#include "esp_http_server.h"
#include "cJSON.h"

// Configuration
#define RELAY_PIN       GPIO_NUM_4
#define BUTTON_PIN      GPIO_NUM_5
#define DEVICE_ID       "demo-power-node-01"
#define CLAIM_CODE      "KAN-POWER-01"
#define MQTT_URL        "mqtt://10.79.219.151:1883" // As per secrets.h
#define WIFI_SSID       "SMARTIFY_DEMO"
#define WIFI_PASS       "replace-with-local-demo-password"

static const char *TAG = "SMARTIFY";

// State
static bool relay_on = false;
static esp_mqtt_client_handle_t mqtt_client = NULL;
static bool wifi_connected = false;

// Function Prototypes
static void apply_relay(bool next_state);
static void mqtt_event_handler(void *handler_args, esp_event_base_t base, int32_t event_id, void *event_data);

// NVS Persistence
static void save_relay_state(bool state) {
    nvs_handle_t my_handle;
    if (nvs_open("storage", NVS_READWRITE, &my_handle) == ESP_OK) {
        nvs_set_u8(my_handle, "relay_on", state ? 1 : 0);
        nvs_commit(my_handle);
        nvs_close(my_handle);
    }
}

static bool load_relay_state() {
    nvs_handle_t my_handle;
    uint8_t state = 0;
    if (nvs_open("storage", NVS_READONLY, &my_handle) == ESP_OK) {
        nvs_get_u8(my_handle, "relay_on", &state);
        nvs_close(my_handle);
    }
    return state == 1;
}

// MQTT Actions
static void publish_state(const char* source) {
    if (!mqtt_client) return;
    cJSON *root = cJSON_CreateObject();
    cJSON_AddNumberToObject(root, "ts", (double)xTaskGetTickCount() * portTICK_PERIOD_MS);
    cJSON_AddBoolToObject(root, "relayOn", relay_on);
    cJSON_AddStringToObject(root, "source", source);
    char *buffer = cJSON_PrintUnformatted(root);
    
    char topic[64];
    snprintf(topic, sizeof(topic), "devices/%s/state", DEVICE_ID);
    esp_mqtt_client_publish(mqtt_client, topic, buffer, 0, 1, 0);
    
    free(buffer);
    cJSON_Delete(root);
}

static void publish_ack(const char* request_id, bool success) {
    if (!mqtt_client) return;
    cJSON *root = cJSON_CreateObject();
    cJSON_AddStringToObject(root, "requestId", request_id);
    cJSON_AddBoolToObject(root, "relayOn", relay_on);
    cJSON_AddBoolToObject(root, "success", success);
    char *buffer = cJSON_PrintUnformatted(root);
    
    char topic[64];
    snprintf(topic, sizeof(topic), "devices/%s/ack", DEVICE_ID);
    esp_mqtt_client_publish(mqtt_client, topic, buffer, 0, 0, 0);
    
    free(buffer);
    cJSON_Delete(root);
}

static void apply_relay(bool next_state) {
    relay_on = next_state;
    gpio_set_level(RELAY_PIN, relay_on ? 1 : 0); // Using 1 for ON, 0 for OFF. Adjust if Active Low.
    save_relay_state(relay_on);
    ESP_LOGI(TAG, "Relay state -> %s", relay_on ? "ON" : "OFF");
}

// Button Task with Toggle Logic
static void button_handler_task(void* arg) {
    int last_level = gpio_get_level(BUTTON_PIN);
    while (1) {
        int current_level = gpio_get_level(BUTTON_PIN);
        if (current_level != last_level) {
            // State changed (Flip detected)
            vTaskDelay(pdMS_TO_TICKS(100)); // Debounce
            if (gpio_get_level(BUTTON_PIN) == current_level) {
                last_level = current_level;
                ESP_LOGI(TAG, "Switch flipped -> Toggling relay");
                apply_relay(!relay_on);
                publish_state("local_switch");
            }
        }
        vTaskDelay(pdMS_TO_TICKS(50));
    }
}

// Web Server for Provisioning
static esp_err_t root_get_handler(httpd_req_t *req) {
    const char* resp = "<html><body><h1>Smartify Provisioning</h1>"
                       "<p>Device ID: " DEVICE_ID "</p>"
                       "<p>Claim Code: " CLAIM_CODE "</p>"
                       "<p>Check Serial Monitor for ASCII QR if needed.</p>"
                       "</body></html>";
    httpd_resp_send(req, resp, HTTPD_RESP_USE_STRLEN);
    return ESP_OK;
}

static void start_webserver(void) {
    httpd_handle_t server = NULL;
    httpd_config_t config = HTTPD_DEFAULT_CONFIG();
    if (httpd_start(&server, &config) == ESP_OK) {
        httpd_uri_t root = { .uri = "/", .method = HTTP_GET, .handler = root_get_handler };
        httpd_register_uri_handler(server, &root);
    }
}

// WiFi/MQTT handlers
static void wifi_event_handler(void* arg, esp_event_base_t event_base, int32_t event_id, void* event_data) {
    if (event_base == WIFI_EVENT && event_id == WIFI_EVENT_STA_START) {
        esp_wifi_connect();
    } else if (event_base == WIFI_EVENT && event_id == WIFI_EVENT_STA_DISCONNECTED) {
        wifi_connected = false;
        esp_wifi_connect();
    } else if (event_base == IP_EVENT && event_id == IP_EVENT_STA_GOT_IP) {
        ip_event_got_ip_t* event = (ip_event_got_ip_t*) event_data;
        ESP_LOGI(TAG, "Got IP: " IPSTR, IP2STR(&event->ip_info.ip));
        wifi_connected = true;
        start_webserver();
    }
}

static void mqtt_event_handler(void *handler_args, esp_event_base_t base, int32_t event_id, void *event_data) {
    esp_mqtt_event_handle_t event = event_data;
    switch (event->event_id) {
        case MQTT_EVENT_CONNECTED:
            mqtt_client = event->client;
            char topic[64];
            snprintf(topic, sizeof(topic), "devices/%s/command", DEVICE_ID);
            esp_mqtt_client_subscribe(mqtt_client, topic, 1);
            publish_state("boot");
            break;
        case MQTT_EVENT_DATA:
            {
                cJSON *root = cJSON_Parse(event->data);
                if (root) {
                    cJSON *relay_json = cJSON_GetObjectItem(root, "relayOn");
                    cJSON *req_id_json = cJSON_GetObjectItem(root, "requestId");
                    if (cJSON_IsBool(relay_json)) {
                        apply_relay(cJSON_IsTrue(relay_json));
                        publish_state("remote_command");
                        if (cJSON_IsString(req_id_json)) {
                            publish_ack(req_id_json->valuestring, true);
                        }
                    }
                    cJSON_Delete(root);
                }
            }
            break;
        default: break;
    }
}

void app_main(void) {
    // Initialize NVS
    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES || ret == ESP_ERR_NVS_NEW_VERSION_FOUND) {
        nvs_flash_erase();
        nvs_flash_init();
    }

    // Initialize GPIO
    gpio_reset_pin(RELAY_PIN);
    gpio_set_direction(RELAY_PIN, GPIO_MODE_OUTPUT);
    gpio_reset_pin(BUTTON_PIN);
    gpio_set_direction(BUTTON_PIN, GPIO_MODE_INPUT);
    gpio_set_pull_mode(BUTTON_PIN, GPIO_PULLUP_ONLY);

    // Load last state
    relay_on = load_relay_state();
    gpio_set_level(RELAY_PIN, relay_on ? 1 : 0);

    // Net Interface
    esp_netif_init();
    esp_event_loop_create_default();
    esp_netif_create_default_wifi_sta();
    wifi_init_config_t cfg = WIFI_INIT_CONFIG_DEFAULT();
    esp_wifi_init(&cfg);
    esp_event_handler_instance_register(WIFI_EVENT, ESP_EVENT_ANY_ID, &wifi_event_handler, NULL, NULL);
    esp_event_handler_instance_register(IP_EVENT, IP_EVENT_STA_GOT_IP, &wifi_event_handler, NULL, NULL);
    
    wifi_config_t wifi_config = {
        .sta = {
            .ssid = WIFI_SSID,
            .password = WIFI_PASS,
        },
    };
    esp_wifi_set_mode(WIFI_MODE_STA);
    esp_wifi_set_config(WIFI_IF_STA, &wifi_config);
    esp_wifi_start();

    // MQTT
    esp_mqtt_client_config_t mqtt_cfg = {
        .broker.address.uri = MQTT_URL,
    };
    esp_mqtt_client_handle_t client = esp_mqtt_client_init(&mqtt_cfg);
    esp_mqtt_client_register_event(client, ESP_EVENT_ANY_ID, mqtt_event_handler, NULL);
    esp_mqtt_client_start(client);

    // Tasks
    xTaskCreate(button_handler_task, "button_task", 4096, NULL, 5, NULL);
}