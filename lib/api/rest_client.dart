import 'package:dio/dio.dart';
import 'package:health_med_app/api/exceptions/problem_details.dart';
import 'package:health_med_app/api/models/consulta_models.dart';
import 'package:health_med_app/api/models/especialidade_models.dart';
import 'package:health_med_app/api/models/medico_models.dart';

class RestClient {
  final Dio dio;

  RestClient(this.dio);

  Future<List<EspecialidadeViewModel>?> obterEspecialidades() async {
    var response = await _request('/api/Especialidade', method: 'GET');
    return (response.data as List).isEmpty
        ? null
        : (response.data as List)
            .map((especialidade) =>
                EspecialidadeViewModel.fromJson(especialidade))
            .toList();
  }

  Future<List<MedicoViewModel>?> obterMedicos(String especialidadeId) async {
    var response = await _request('/api/Consulta/ObterMedicos',
        method: 'GET',
        queryParameters: {
          'especialidadeId': especialidadeId,
        });
    return (response.data as List).isEmpty
        ? null
        : (response.data as List)
            .map((medico) => MedicoViewModel.fromJson(medico))
            .toList();
  }

  Future<MedicoViewModel> obterMedico(String medicoId) async {
    var response = await _request(
      '/api/Medico/$medicoId',
      method: 'GET',
    );
    return MedicoViewModel.fromJson(response.data);
  }

  Future<List<ConsultaViewModel>?> obterConsultasPendentesMedico(String medicoId) async {
    var response = await _request(
      '/api/Consulta/ObterConsultasPendentesMedico/$medicoId',
      method: 'GET',
    );
    return (response.data as List).isEmpty
        ? null
        : (response.data as List)
            .map((consulta) => ConsultaViewModel.fromJson(consulta))
            .toList();
  }

  Future<void> agendarConsulta(AgendarConsultaInputModel consulta) async {
    await _request(
      '/api/Consulta',
      method: 'POST',
      data: consulta.toJson(),
    );
  }

  Future<Response> _request(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await dio.request(
        path,
        options: Options(
          method: method,
          headers: headers,
        ),
        queryParameters: queryParameters,
        data: data,
      );
    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        throw ProblemDetails.fromJson(e.response!.data);
      }
      throw ProblemDetails(detail: e.message, status: e.response?.statusCode);
    } catch (e) {
      throw ProblemDetails(detail: 'Erro inesperado: $e');
    }
  }
}
