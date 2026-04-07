import 'dart:async';
import 'dart:io';

import 'package:network_info_plus/network_info_plus.dart';

class SmartifyBackendDiscovery {
  SmartifyBackendDiscovery._();

  static final NetworkInfo _networkInfo = NetworkInfo();

  static const int _apiPort = 3000;
  static const Duration _probeTimeout = Duration(milliseconds: 450);
  static const int _batchSize = 24;

  static String? _rememberedBaseUrl;
  static Future<String?>? _activeDiscovery;

  static String? get rememberedBaseUrl => _rememberedBaseUrl;

  static void remember(String baseUrl) {
    _rememberedBaseUrl = _normalize(baseUrl);
  }

  static Future<List<String>> resolveCandidateUrls(
    List<String> seededUrls,
  ) async {
    final urls = <String>[];

    void addUrl(String? value) {
      final normalized = _normalize(value);
      if (normalized == null || urls.contains(normalized)) return;
      urls.add(normalized);
    }

    addUrl(_rememberedBaseUrl);
    final discovered = await discoverBaseUrl();
    addUrl(discovered);
    for (final value in seededUrls) {
      addUrl(value);
    }
    return urls;
  }

  static Future<String?> discoverBaseUrl() async {
    if (_rememberedBaseUrl != null) return _rememberedBaseUrl;
    if (_activeDiscovery != null) return _activeDiscovery!;

    final discovery = _discoverOnCurrentLan();
    _activeDiscovery = discovery;
    final found = await discovery;
    if (identical(_activeDiscovery, discovery)) {
      _activeDiscovery = null;
    }
    if (found != null) {
      remember(found);
    }
    return found;
  }

  static Future<String?> _discoverOnCurrentLan() async {
    final wifiIp = await _networkInfo.getWifiIP();
    final prefix = _subnetPrefix(wifiIp);
    if (prefix == null) return null;

    final ownHost = int.tryParse(wifiIp!.split('.').last);
    final candidates = _orderedHostOctets(
      ownHost,
    ).map((host) => 'http://$prefix.$host:$_apiPort').toList(growable: false);

    for (var index = 0; index < candidates.length; index += _batchSize) {
      final end = (index + _batchSize < candidates.length)
          ? index + _batchSize
          : candidates.length;
      final found = await _probeBatch(candidates.sublist(index, end));
      if (found != null) {
        return found;
      }
    }

    return null;
  }

  static String? _subnetPrefix(String? wifiIp) {
    if (wifiIp == null || wifiIp.isEmpty) return null;
    final parts = wifiIp.split('.');
    if (parts.length != 4) return null;
    return '${parts[0]}.${parts[1]}.${parts[2]}';
  }

  static List<int> _orderedHostOctets(int? ownHost) {
    final prioritized = <int>[
      if (ownHost != null && ownHost > 1 && ownHost < 254) ownHost - 1,
      if (ownHost != null && ownHost > 2) ownHost - 2,
      if (ownHost != null && ownHost < 254) ownHost + 1,
      if (ownHost != null && ownHost < 253) ownHost + 2,
      10,
      20,
      50,
      100,
      101,
      151,
      200,
      224,
      254,
      1,
    ];

    final ordered = <int>[];
    for (final host in prioritized) {
      if (host < 1 || host > 254 || ordered.contains(host)) continue;
      ordered.add(host);
    }

    for (var host = 1; host <= 254; host++) {
      if (ordered.contains(host) || host == ownHost) continue;
      ordered.add(host);
    }

    return ordered;
  }

  static Future<String?> _probeBatch(List<String> baseUrls) async {
    final completer = Completer<String?>();
    var remaining = baseUrls.length;

    for (final baseUrl in baseUrls) {
      _looksLikeSmartifyApi(baseUrl)
          .then((matches) {
            if (matches && !completer.isCompleted) {
              completer.complete(baseUrl);
            }
          })
          .whenComplete(() {
            remaining -= 1;
            if (remaining == 0 && !completer.isCompleted) {
              completer.complete(null);
            }
          });
    }

    return completer.future;
  }

  static Future<bool> _looksLikeSmartifyApi(String baseUrl) async {
    final client = HttpClient()
      ..connectionTimeout = _probeTimeout
      ..idleTimeout = _probeTimeout;

    try {
      final request = await client
          .openUrl('POST', Uri.parse('$baseUrl/auth/sign-in'))
          .timeout(_probeTimeout);
      request.headers.contentType = ContentType.json;
      request.write('{}');
      final response = await request.close().timeout(_probeTimeout);
      await response.drain<void>();

      return response.statusCode == 400 || response.statusCode == 401;
    } on TimeoutException {
      return false;
    } on SocketException {
      return false;
    } on HandshakeException {
      return false;
    } catch (_) {
      return false;
    } finally {
      client.close(force: true);
    }
  }

  static String? _normalize(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed.endsWith('/')
        ? trimmed.substring(0, trimmed.length - 1)
        : trimmed;
  }
}
