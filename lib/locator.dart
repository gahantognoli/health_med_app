import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:health_med_app/api/auth_interceptor.dart';
import 'package:health_med_app/api/rest_client.dart';
import 'package:health_med_app/services/auth_service.dart';
import 'package:health_med_app/services/config_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<Dio>(
    () {
      final dio = Dio(
        BaseOptions(
          baseUrl: ConfigService.apiBaseUrl,
          connectTimeout: kReleaseMode
              ? const Duration(seconds: 10)
              : const Duration(minutes: 3),
          receiveTimeout: kReleaseMode
              ? const Duration(seconds: 10)
              : const Duration(minutes: 3),
        ),
      );
      dio.interceptors.add(AuthInterceptor());
      return dio;
    },
  );

  getIt.registerLazySingleton<RestClient>(() => RestClient(getIt<Dio>()));
  getIt.registerLazySingleton<AuthService>(() => AuthService());
}
