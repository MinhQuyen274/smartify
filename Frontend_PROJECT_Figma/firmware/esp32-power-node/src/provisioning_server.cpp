#include "provisioning_server.h"

#include <Arduino.h>
#include <ArduinoJson.h>
#include <WebServer.h>
#include <WiFi.h>
#include <qrcode.h>

#include "secrets.h"

namespace {
WebServer server(80);
String provisioningPayload;
bool serverStarted = false;

String buildQrMarkup() {
  constexpr uint8_t version = 5;
  uint8_t buffer[qrcode_getBufferSize(version)];
  QRCode qrcode;
  qrcode_initText(&qrcode, buffer, version, ECC_LOW, provisioningPayload.c_str());

  String html;
  html.reserve(4096);
  html += "<div class='qr' style='grid-template-columns:repeat(";
  html += qrcode.size;
  html += ",10px)'>";

  for (uint8_t y = 0; y < qrcode.size; y++) {
    for (uint8_t x = 0; x < qrcode.size; x++) {
      html += "<span class='";
      html += qrcode_getModule(&qrcode, x, y) ? "b" : "w";
      html += "'></span>";
    }
  }

  html += "</div>";
  return html;
}

String buildPage() {
  String page;
  page.reserve(6000);
  page += "<!doctype html><html><head><meta charset='utf-8'>";
  page += "<meta name='viewport' content='width=device-width,initial-scale=1'>";
  page += "<title>Smartify Device QR</title>";
  page += "<style>";
  page += "body{font-family:Arial,sans-serif;background:#f4f7ff;padding:24px;color:#172033;}";
  page += ".card{max-width:460px;margin:0 auto;background:#fff;border-radius:24px;padding:24px;box-shadow:0 16px 40px rgba(0,0,0,.08);}";
  page += "h1{font-size:24px;margin:0 0 10px;}p{line-height:1.5;color:#4b5563;}";
  page += ".qr{display:grid;gap:0;justify-content:center;background:#fff;padding:16px;border-radius:18px;border:1px solid #dbe3ff;margin:22px 0;}";
  page += ".qr span{width:10px;height:10px;display:block;}.b{background:#111827;}.w{background:#ffffff;}";
  page += "code{display:block;white-space:pre-wrap;word-break:break-word;background:#eef2ff;padding:14px;border-radius:14px;font-size:13px;}";
  page += ".meta{margin-top:12px;font-size:14px;color:#334155;}";
  page += "</style></head><body><div class='card'><h1>Smartify Provisioning QR</h1>";
  page += "<p>Open this page on another screen and scan the QR with the Smartify mobile app.</p>";
  page += buildQrMarkup();
  page += "<div class='meta'><strong>Device ID:</strong> ";
  page += DEVICE_ID;
  page += "<br><strong>Claim code:</strong> ";
  page += CLAIM_CODE;
  page += "</div><p>QR payload</p><code>";
  page += provisioningPayload;
  page += "</code></div></body></html>";
  return page;
}

void printAsciiQr() {
  constexpr uint8_t version = 5;
  uint8_t buffer[qrcode_getBufferSize(version)];
  QRCode qrcode;
  qrcode_initText(&qrcode, buffer, version, ECC_LOW, provisioningPayload.c_str());

  Serial.println();
  Serial.println("Smartify provisioning payload:");
  Serial.println(provisioningPayload);
  Serial.println();
  for (int row = -1; row <= qrcode.size; row++) {
    String line;
    for (int col = -1; col <= qrcode.size; col++) {
      const bool filled =
          row >= 0 && row < qrcode.size && col >= 0 && col < qrcode.size &&
          qrcode_getModule(&qrcode, col, row);
      line += filled ? "##" : "  ";
    }
    Serial.println(line);
  }
  Serial.println();
  Serial.print("Open provisioning page at http://");
  Serial.print(WiFi.localIP());
  Serial.println("/");
}
}  // namespace

namespace ProvisioningServer {
void begin() {
  if (serverStarted || WiFi.status() != WL_CONNECTED) return;

  StaticJsonDocument<128> doc;
  doc["deviceId"] = DEVICE_ID;
  doc["claimCode"] = CLAIM_CODE;
  serializeJson(doc, provisioningPayload);

  server.on("/", HTTP_GET, []() { server.send(200, "text/html", buildPage()); });
  server.on("/payload", HTTP_GET, []() {
    server.send(200, "application/json", provisioningPayload);
  });
  server.begin();
  serverStarted = true;
  printAsciiQr();
}

void handleClient() {
  if (!serverStarted) return;
  server.handleClient();
}

const char* payload() {
  return provisioningPayload.c_str();
}
}  // namespace ProvisioningServer
