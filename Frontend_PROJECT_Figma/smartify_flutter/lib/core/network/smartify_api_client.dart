import 'package:dio/dio.dart';
import 'package:smartify_flutter/core/models/auth_models.dart';
import 'package:smartify_flutter/core/network/app_config.dart';
import 'package:smartify_flutter/core/network/smartify_backend_discovery.dart';

class SmartifyApiClient {
  SmartifyApiClient()
    : _dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 8),
          receiveTimeout: const Duration(seconds: 8),
          headers: {'Content-Type': 'application/json'},
        ),
      );

  final Dio _dio;
  String? _resolvedBaseUrl;

  Future<AuthSession> signUp({
    required String email,
    required String password,
  }) async {
    final response = await _requestWithFallback(
      (baseUrl) => _dio.post(
        '$baseUrl/auth/sign-up',
        data: {'email': email, 'password': password},
      ),
    );
    return AuthSession.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _requestWithFallback(
      (baseUrl) => _dio.post(
        '$baseUrl/auth/sign-in',
        data: {'email': email, 'password': password},
      ),
    );
    return AuthSession.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<Map<String, dynamic>>> getDevices(String token) async {
    final response = await _requestWithFallback(
      (baseUrl) => _dio.get(
        '$baseUrl/devices',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      ),
    );
    return List<Map<String, dynamic>>.from(response.data as List);
  }

  Future<Map<String, dynamic>> getDevice(String token, String deviceId) async {
    final response = await _requestWithFallback(
      (baseUrl) => _dio.get(
        '$baseUrl/devices/$deviceId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      ),
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<List<Map<String, dynamic>>> getDeviceHistory(
    String token,
    String deviceId,
  ) async {
    final response = await _requestWithFallback(
      (baseUrl) => _dio.get(
        '$baseUrl/devices/$deviceId/history',
        queryParameters: {'interval': 'minute'},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      ),
    );
    return List<Map<String, dynamic>>.from(response.data as List);
  }

  Future<Map<String, dynamic>> claimDevice(
    String token, {
    required String deviceId,
    required String claimCode,
    String? name,
  }) async {
    final response = await _requestWithFallback(
      (baseUrl) => _dio.post(
        '$baseUrl/devices/claim',
        data: {'deviceId': deviceId, 'claimCode': claimCode, 'name': name},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      ),
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> sendPowerCommand(
    String token, {
    required String deviceId,
    required bool relayOn,
  }) async {
    final response = await _requestWithFallback(
      (baseUrl) => _dio.post(
        '$baseUrl/devices/$deviceId/commands/power',
        data: {'relayOn': relayOn},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      ),
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> getReportSummary(String token) async {
    final response = await _requestWithFallback(
      (baseUrl) => _dio.get(
        '$baseUrl/reports/summary',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      ),
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Response<dynamic>> _requestWithFallback(
    Future<Response<dynamic>> Function(String baseUrl) send,
  ) async {
    DioException? lastError;
    final candidates = <String>[
      if (_resolvedBaseUrl != null) _resolvedBaseUrl!,
      ...await SmartifyBackendDiscovery.resolveCandidateUrls(
        AppConfig.apiBaseUrls,
      ),
    ];
    final tried = <String>{};

    for (final baseUrl in candidates) {
      if (!tried.add(baseUrl)) continue;
      try {
        final response = await send(baseUrl);
        _resolvedBaseUrl = baseUrl;
        SmartifyBackendDiscovery.remember(baseUrl);
        return response;
      } on DioException catch (error) {
        if (!_shouldTryNextBaseUrl(error)) rethrow;
        lastError = error;
      }
    }

    throw lastError ??
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: 'No reachable Smartify API base URL.',
        );
  }

  bool _shouldTryNextBaseUrl(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout;
  }
}
