import 'package:dio/dio.dart';
import 'package:health_med_app/api/exceptions/problem_details.dart';
import 'package:health_med_app/api/models/consulta_models.dart';
import 'package:health_med_app/api/models/especialidade_models.dart';
import 'package:health_med_app/api/models/medico_models.dart';
import 'package:health_med_app/api/models/paciente_models.dart';

class RestClient {
  final Dio dio;

  RestClient(this.dio);

  Future<List<EspecialidadeViewModel>?> obterEspecialidades() async {
    var response = await _request('/med/Especialidade', method: 'GET');
    return (response.data as List).isEmpty
        ? null
        : (response.data as List)
            .map((especialidade) =>
                EspecialidadeViewModel.fromJson(especialidade))
            .toList();
  }

  Future<List<MedicoViewModel>?> obterMedicos(String especialidadeId) async {
    var response = await _request('/med/Consulta/ObterMedicos',
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
      '/med/Medico/$medicoId',
      method: 'GET',
    );
    return MedicoViewModel.fromJson(response.data);
  }

  Future<List<ConsultaViewModel>?> obterConsultasPendentesMedico(String medicoId) async {
    var response = await _request(
      '/med/Consulta/ObterConsultasPendentesMedico/$medicoId',
      method: 'GET',
    );
    return (response.data as List).isEmpty
        ? null
        : (response.data as List)
            .map((consulta) => ConsultaViewModel.fromJson(consulta))
            .toList();
  }

  Future<void> cancelarConsulta(String consultaId, String motivoCancelamento) async {
    await _request(
      '/med/Consulta/Cancelar/$consultaId',
      method: 'PATCH',
      data: {
        'justificativaCancelamento': motivoCancelamento,
      },
    );
  }

  Future<void> agendarConsulta(AgendarConsultaInputModel consulta) async {
    await _request(
      '/med/Consulta',
      method: 'POST',
      data: consulta.toJson(),
    );
  }

  Future<List<ConsultaViewModel>?> obterConsultasPaciente(String pacienteId) async {
    var response = await _request(
      '/med/Consulta/ObterConsultasPaciente/$pacienteId',
      method: 'GET',
    );
    return (response.data as List).isEmpty
        ? null
        : (response.data as List)
            .map((consulta) => ConsultaViewModel.fromJson(consulta))
            .toList();
  }

  Future<PacienteViewModel> obterPaciente(String pacienteId) async {
    var response = await _request(
      '/med/Paciente/$pacienteId',
      method: 'GET',
    );
    return PacienteViewModel.fromJson(response.data);
  }

  Future<void> atualizarPaciente(
      String pacienteId, AtualizacaoPacienteInputModel paciente) async {
    await _request(
      '/med/Paciente/$pacienteId',
      method: 'PATCH',
      data: paciente.toJson(),
    );
  }

  Future<void> excluirPaciente(String pacienteId) async {
    await _request(
      '/med/Paciente/$pacienteId',
      method: 'DELETE',
    );
  }

  Future<void> cadastrarPaciente(CadastroPacienteInputModel paciente) async {
    await _request(
      '/med/Paciente',
      method: 'POST',
      data: paciente.toJson(),
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
