#include <Arduino.h>
#include <ArduinoJson.h>
#include <Preferences.h>
#include <PubSubClient.h>
#include <WiFi.h>
#include <PZEM004Tv30.h>

#include "provisioning_server.h"
#include "secrets.h"

namespace {
constexpr uint8_t RELAY_PIN = 4;
constexpr uint8_t BUTTON_PIN = 5;
constexpr uint8_t PZEM_RX_PIN = 16;
constexpr uint8_t PZEM_TX_PIN = 17;
constexpr unsigned long TELEMETRY_INTERVAL_MS = 5000;
constexpr unsigned long BUTTON_DEBOUNCE_MS = 220;
constexpr unsigned long RELAY_SETTLE_MS = 350;
constexpr bool HARD_SWITCH_ACTIVE_LOW = true;
constexpr char STATE_KEY[] = "relayOn";
}

WiFiClient wifiClient;
PubSubClient mqttClient(wifiClient);
Preferences preferences;
PZEM004Tv30 pzem(Serial2, PZEM_RX_PIN, PZEM_TX_PIN);

bool relayOn = false;
bool rawButtonLevel = HIGH;
bool stableButtonLevel = HIGH;
unsigned long lastTelemetryMs = 0;
unsigned long lastButtonChangeMs = 0;
unsigned long lastRelayChangeMs = 0;

String topicFor(const char* channel) {
  return String("devices/") + DEVICE_ID + "/" + channel;
}

void applyRelay(bool nextState) {
  relayOn = nextState;
  const auto relayLevel = relayOn
      ? (RELAY_ACTIVE_LOW ? LOW : HIGH)
      : (RELAY_ACTIVE_LOW ? HIGH : LOW);
  digitalWrite(RELAY_PIN, relayLevel);
  lastRelayChangeMs = millis();
  preferences.putBool(STATE_KEY, relayOn);
  Serial.printf("Relay state -> %s\n", relayOn ? "ON" : "OFF");
}

bool hardSwitchWantsRelayOn(bool level) {
  return HARD_SWITCH_ACTIVE_LOW ? level == LOW : level == HIGH;
}

float normalizeTelemetry(float value) {
  return isnan(value) ? 0.0f : value;
}

void publishState(const char* source) {
  StaticJsonDocument<160> doc;
  doc["ts"] = millis();
  doc["relayOn"] = relayOn;
  doc["source"] = source;
  char buffer[160];
  serializeJson(doc, buffer);
  mqttClient.publish(topicFor("state").c_str(), buffer, true);
}

void publishTelemetry() {
  const float rawVoltage = pzem.voltage();
  const float rawCurrent = pzem.current();
  const float rawActivePower = pzem.power();
  const float rawEnergyKwh = pzem.energy();
  const float rawFrequency = pzem.frequency();
  const float rawPowerFactor = pzem.pf();
  const bool pzemResponding = !isnan(rawVoltage) && !isnan(rawFrequency);

  StaticJsonDocument<256> doc;
  doc["ts"] = millis();
  doc["voltage"] = normalizeTelemetry(rawVoltage);
  doc["current"] = normalizeTelemetry(rawCurrent);
  doc["activePower"] = normalizeTelemetry(rawActivePower);
  doc["energyKwh"] = normalizeTelemetry(rawEnergyKwh);
  doc["frequency"] = normalizeTelemetry(rawFrequency);
  doc["powerFactor"] = normalizeTelemetry(rawPowerFactor);
  doc["relayOn"] = relayOn;
  char buffer[256];
  serializeJson(doc, buffer);
  mqttClient.publish(topicFor("telemetry").c_str(), buffer, false);
  if (!pzemResponding) {
    Serial.println("PZEM invalid reading - check module power and TX/RX wiring");
    return;
  }
  Serial.printf(
      "PZEM -> V=%.1fV I=%.3fA P=%.1fW E=%.3fkWh F=%.1fHz PF=%.2f\n",
      rawVoltage,
      rawCurrent,
      rawActivePower,
      rawEnergyKwh,
      rawFrequency,
      rawPowerFactor);
}

void publishAck(const char* requestId, bool success) {
  StaticJsonDocument<128> doc;
  doc["requestId"] = requestId;
  doc["relayOn"] = relayOn;
  doc["success"] = success;
  char buffer[128];
  serializeJson(doc, buffer);
  mqttClient.publish(topicFor("ack").c_str(), buffer, false);
}

void handleCommand(char* payload, unsigned int length) {
  StaticJsonDocument<128> doc;
  const auto error = deserializeJson(doc, payload, length);
  if (error) return;
  const bool requestedRelayOn = doc["relayOn"] | false;
  const bool hardSwitchRelayOn = hardSwitchWantsRelayOn(stableButtonLevel);
  if (requestedRelayOn != hardSwitchRelayOn) {
    if (relayOn != hardSwitchRelayOn) {
      applyRelay(hardSwitchRelayOn);
    }
    publishState("remote_blocked_by_switch");
    publishAck(doc["requestId"] | "", false);
    Serial.printf(
        "Remote %s blocked because local switch is %s\n",
        requestedRelayOn ? "ON" : "OFF",
        hardSwitchRelayOn ? "ON" : "OFF");
    return;
  }
  applyRelay(requestedRelayOn);
  publishState("remote_command");
  publishAck(doc["requestId"] | "", true);
}

void mqttCallback(char* topic, byte* payload, unsigned int length) {
  const auto expectedTopic = topicFor("command");
  if (expectedTopic != topic) return;
  char buffer[128];
  const auto maxLength = static_cast<unsigned int>(sizeof(buffer) - 1);
  const auto copyLength = length < maxLength ? length : maxLength;
  memcpy(buffer, payload, copyLength);
  buffer[copyLength] = '\0';
  handleCommand(buffer, copyLength);
}

void ensureWifi() {
  if (WiFi.status() == WL_CONNECTED) return;
  for (int index = 0; index < WIFI_NETWORK_COUNT; index++) {
    WiFi.begin(WIFI_SSIDS[index], WIFI_PASSWORDS[index]);
    const unsigned long started = millis();
    while (WiFi.status() != WL_CONNECTED && millis() - started < 12000) {
      delay(300);
    }
    if (WiFi.status() == WL_CONNECTED) return;
  }
}

void ensureMqtt() {
  if (mqttClient.connected() || WiFi.status() != WL_CONNECTED) return;
  const auto clientId = String(DEVICE_ID) + "-client";
  if (mqttClient.connect(clientId.c_str())) {
    mqttClient.subscribe(topicFor("command").c_str());
    publishState("boot");
  }
}

void handleButton() {
  const bool currentLevel = digitalRead(BUTTON_PIN);
  if (currentLevel != rawButtonLevel) {
    rawButtonLevel = currentLevel;
    lastButtonChangeMs = millis();
  }
  if (rawButtonLevel == stableButtonLevel) return;
  if (millis() - lastButtonChangeMs < BUTTON_DEBOUNCE_MS) return;
  if (millis() - lastRelayChangeMs < RELAY_SETTLE_MS) return;
  stableButtonLevel = rawButtonLevel;
  const bool desiredRelayOn = hardSwitchWantsRelayOn(stableButtonLevel);
  if (desiredRelayOn != relayOn) {
    applyRelay(desiredRelayOn);
    publishState("local_switch");
    Serial.printf("Local switch -> %s\n", relayOn ? "ON" : "OFF");
  }
}

void setup() {
  Serial.begin(115200);
  pinMode(RELAY_PIN, OUTPUT);
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  preferences.begin("smartify", false);
  rawButtonLevel = digitalRead(BUTTON_PIN);
  stableButtonLevel = rawButtonLevel;
  applyRelay(hardSwitchWantsRelayOn(stableButtonLevel));
  WiFi.mode(WIFI_STA);
  mqttClient.setServer(SERVER_HOST, MQTT_PORT);
  mqttClient.setCallback(mqttCallback);
}

void loop() {
  ensureWifi();
  ProvisioningServer::begin();
  ensureMqtt();
  mqttClient.loop();
  ProvisioningServer::handleClient();
  handleButton();

  if (mqttClient.connected() && millis() - lastTelemetryMs >= TELEMETRY_INTERVAL_MS) {
    lastTelemetryMs = millis();
    publishTelemetry();
  }
}
