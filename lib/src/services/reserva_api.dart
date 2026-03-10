import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ReservaApi {
  static const String _baseUrl = 'http://192.168.1.107:5000';
  
  //static const String _baseUrl = 'http://192.168.1.110:5000';
   // Cambia esto por tu URL del servidor
  static const String _reservacionesEndpoint = '/reservaciones';

  // Método para crear una reservación
  static Future<Map<String, dynamic>> crearReservacion({
    required int idUser,
    required String servicio,
    required DateTime fecha,
    required TimeOfDay hora,
    required bool paraOtraPersona,
    String? nombrePersona,
  }) async {
    try {
      // Formatear fecha y hora según lo esperado por el backend
      final fechaFormateada = DateFormat('yyyy-MM-dd').format(fecha);
      final horaFormateada = '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}';

      // Crear el cuerpo de la solicitud
      final Map<String, dynamic> body = {
        'IdUser': idUser,
        'Servicio': servicio,
        'Fecha': fechaFormateada,
        'Hora': horaFormateada,
        'ParaOtraPersona': paraOtraPersona,
        if (paraOtraPersona && nombrePersona != null) 'NombrePersona': nombrePersona,
        'Estado': 'Pendiente', // Estado por defecto
      };

      // Realizar la solicitud POST
      final response = await http.post(
        Uri.parse('$_baseUrl$_reservacionesEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      // Procesar la respuesta
      if (response.statusCode == 201) {
        // Reservación creada exitosamente
        return jsonDecode(response.body);
      } else {
        // Error en la solicitud
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Error al crear la reservación');
      }
    } catch (e) {
      throw Exception('Error al conectar con el servidor: ${e.toString()}');
    }
  }

  // Método para verificar disponibilidad de horario
  static Future<bool> verificarDisponibilidad(DateTime fecha, TimeOfDay hora) async {
    try {
      // Formatear fecha y hora
      final fechaFormateada = DateFormat('yyyy-MM-dd').format(fecha);
      final horaFormateada = '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}';

      // Obtener todas las reservaciones para la fecha específica
      final response = await http.get(
        Uri.parse('$_baseUrl$_reservacionesEndpoint'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> reservaciones = jsonDecode(response.body);
        
        // Verificar si hay alguna reservación en el mismo horario
        final reservacionExistente = reservaciones.any((reserva) {
          final reservaFecha = DateTime.parse(reserva['Fecha']).toLocal();
          final reservaHoraParts = reserva['Hora'].split(':');
          final reservaHora = TimeOfDay(
            hour: int.parse(reservaHoraParts[0]),
            minute: int.parse(reservaHoraParts[1]),
          );
          
          return reservaFecha.day == fecha.day &&
                 reservaFecha.month == fecha.month &&
                 reservaFecha.year == fecha.year &&
                 reservaHora.hour == hora.hour &&
                 reservaHora.minute == hora.minute;
        });

        return !reservacionExistente;
      } else {
        throw Exception('Error al verificar disponibilidad');
      }
    } catch (e) {
      throw Exception('Error de conexión: ${e.toString()}');
    }
  }

  // Método para obtener las reservaciones de un usuario
  static Future<List<dynamic>> obtenerReservacionesUsuario(int idUser) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_reservacionesEndpoint'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> todasReservaciones = jsonDecode(response.body);
        return todasReservaciones.where((reserva) => reserva['IdUser'] == idUser).toList();
      } else {
        throw Exception('Error al obtener reservaciones');
      }
    } catch (e) {
      throw Exception('Error de conexión: ${e.toString()}');
    }
  }
}