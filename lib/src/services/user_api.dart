import 'dart:convert';
import 'package:flutter_application_4/src/models/user_models.dart';
import 'package:http/http.dart' as http;

class UserApi {
  static const String _baseUrl = 'http://192.168.1.107:5000'; // Cambia esto por tu URL de producción
  
  //static const String _baseUrl = 'http://192.168.1.110:5000';
  // Variable estática para almacenar el userId del usuario logueado
  static int? _currentUserId;

  // Getter para obtener el userId actual
  static int? get currentUserId => _currentUserId;

  // Método para iniciar sesión
static Future<Map<String, dynamic>> login(String usuario, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$_baseUrl/usuarios/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'Usuario': usuario,
        'Passsword': password, // Changed to match backend's expected field name
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _currentUserId = data['IdUser'];
      return {
        'success': true,
        'data': data,
        'userId': _currentUserId,
      };
    } else {
      return {
        'success': false,
        'message': jsonDecode(response.body)['error'] ?? 'Error desconocido',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Error de conexión: $e',
    };
  }
}
     

  // Método para obtener información de un usuario
  static Future<Map<String, dynamic>> getUser(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/usuarios/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['error'] ?? 'Error al obtener usuario',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

static Future<Map<String, dynamic>> register(UserModel user) async {
  try {
    final userData = user.toJson()..remove('IdUser');
    print('Request body: $userData'); // Log the request body for debugging

    final response = await http.post(
      Uri.parse('$_baseUrl/usuarios/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      _currentUserId = data['IdUser'];
      return {
        'success': true,
        'data': data,
        'userId': _currentUserId,
      };
    } else {
      print('Response body: ${response.body}'); // Log the response for debugging
      return {
        'success': false,
        'message': jsonDecode(response.body)['error'] ?? 'Error al registrar: ${response.statusCode}',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Error de conexión: $e',
    };
  }
}
  // Método para actualizar un usuario
  static Future<Map<String, dynamic>> updateUser(int id, UserModel user) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/usuarios/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['error'] ?? 'Error al actualizar',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  // Método para cerrar sesión (opcional, resetea el userId)
  static void logout() {
    _currentUserId = null;
  }

 
}