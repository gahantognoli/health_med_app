import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:health_med_app/api/rest_client.dart';
import 'package:health_med_app/services/config_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: ConfigService.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    ),
  );
  getIt.registerLazySingleton<RestClient>(() => RestClient(getIt<Dio>()));
}
