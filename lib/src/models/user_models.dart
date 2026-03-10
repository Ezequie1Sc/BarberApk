class UserModel {
  final int idUser;
  final String usuario;
  final String nombre;
  final String apellido;
  final String email;
  final String telefono;
  final String password;

  UserModel({
    required this.idUser,
    required this.usuario,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.telefono,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'IdUser': idUser,
      'Usuario': usuario,
      'Nombre': nombre,
      'Apellido': apellido,
      'Email': email,
      'Telefono': telefono,
      'Passsword': password, // Changed to match backend's expected typo
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUser: json['IdUser'] ?? 0,
      usuario: json['Usuario'] ?? '',
      nombre: json['Nombre'] ?? '',
      apellido: json['Apellido'] ?? '',
      email: json['Email'] ?? '',
      telefono: json['Telefono'] ?? '',
      password: json['Passsword'] ?? '', // Match the typo here too
    );
  }
}