class LoginLog {
  final int id;
  final DateTime fecha;
  final String nombreCompleto;
  final String usuarioIngresado;
  final bool exito;
  final String ip;
  final String userAgent;

  LoginLog({
    required this.id,
    required this.fecha,
    required this.nombreCompleto,
    required this.usuarioIngresado,
    required this.exito,
    required this.ip,
    required this.userAgent,
  });

  factory LoginLog.fromJson(Map<String, dynamic> json) {
    return LoginLog(
      id: json['id'],
      fecha: DateTime.parse(json['fecha']),
      nombreCompleto: json['nombre_completo'],
      usuarioIngresado: json['usuario_ingresado'],
      exito: json['exito'],
      ip: json['ip'],
      userAgent: json['user_agent'],
    );
  }
}