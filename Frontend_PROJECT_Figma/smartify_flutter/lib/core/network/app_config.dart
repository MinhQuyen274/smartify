class AppConfig {
  const AppConfig._();

  static const apiBaseUrl = String.fromEnvironment(
    'SMARTIFY_API_BASE_URL',
    defaultValue: 'http://10.116.9.151:3000',
  );

  static const socketUrl = String.fromEnvironment(
    'SMARTIFY_SOCKET_URL',
    defaultValue: 'http://10.116.9.151:3000',
  );

  static List<String> get apiBaseUrls => _orderedUrls(apiBaseUrl, const [
    'http://HP:3000',
    'http://HP.local:3000',
    'http://localhost:3000',
    'http://127.0.0.1:3000',
    'http://192.168.137.1:3000',
    'http://10.0.2.2:3000',
    "http://192.168.137.1:3000",
  ]);

  static List<String> get socketUrls => _orderedUrls(socketUrl, const [
    'http://HP:3000',
    'http://HP.local:3000',
    'http://localhost:3000',
    'http://127.0.0.1:3000',
    'http://192.168.137.1:3000',
    'http://10.0.2.2:3000',
    "http://192.168.137.1:3000",
  ]);

  static List<String> _orderedUrls(String primary, List<String> fallbacks) {
    final urls = <String>[];

    void addUrl(String value) {
      final trimmed = value.trim();
      if (trimmed.isEmpty || urls.contains(trimmed)) return;
      urls.add(trimmed);
    }

    addUrl(primary);
    for (final value in fallbacks) {
      addUrl(value);
    }

    return urls;
  }
}
