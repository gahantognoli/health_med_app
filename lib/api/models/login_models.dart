enum TipoUsuario { administrador, medico, paciente }

class LoginRequest {
  String usuario;
  String senha;
  int tipoUsuario;

  LoginRequest({
    required this.usuario,
    required this.senha,
    required this.tipoUsuario,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['usuario'] = usuario;
    data['senha'] = senha;
    data['tipoUsuario'] = tipoUsuario;
    return data;
  }
}

class ApiResponse<T> {
  final T data;
  final String message;
  final bool success;

  ApiResponse({
    required this.data,
    required this.message,
    required this.success,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      data: json['data'],
      message: json['message'],
      success: json['success'],
    );
  }

  factory ApiResponse.fromJsonWithData(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ApiResponse(
      data: fromJsonT(json['data']),
      message: json['message'],
      success: json['success'],
    );
  }
}

class LoginResponse {
  String? accessToken;
  String? expiresIn;
  String? refreshTokenExpiresIn;
  String? refreshToken;
  String? tokenType;
  int? notValidBeforePolicy;
  String? sessionState;
  String? scope;

  LoginResponse({
    this.accessToken,
    this.expiresIn,
    this.refreshTokenExpiresIn,
    this.refreshToken,
    this.tokenType,
    this.notValidBeforePolicy,
    this.sessionState,
    this.scope,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'],
      expiresIn: json['expiresIn'],
      refreshTokenExpiresIn: json['refreshTokenExpiresIn'],
      refreshToken: json['refreshToken'],
      tokenType: json['tokenType'],
      notValidBeforePolicy: json['notValidBeforePolicy'],
      sessionState: json['sessionState'],
      scope: json['scope'],
    );
  }
}
