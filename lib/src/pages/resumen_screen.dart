import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter_application_4/src/models/user_models.dart'; // Asegúrate de importar el modelo UserModel

class SummaryScreen extends StatefulWidget {
  final int userId; // ID del usuario logueado
  const SummaryScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  // Colores de la paleta
  static const Color backgroundColor = Color(0xFF1A1A1A);
  static const Color accentColor = Color(0xFFFFC107); // Colors.amber
  static const Color textSecondary = Color(0xFF9E9E9E); // Colors.grey[400]
  static const Color inputBackground = Color(0xFF212121); // Colors.grey[900]
  static const Color textPrimary = Colors.white;
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.green;

  // Datos de la reservación (se cargarán dinámicamente)
  Map<String, dynamic>? reservationData;

  // Productos destacados con imágenes reales
  final List<Map<String, dynamic>> featuredProducts = [
    {
      'name': 'Pomada para Cabello',
      'price': '\$15.00',
      'image': 'assets/pomada.jpg',
    },
    {
      'name': 'Aceite para Barba',
      'price': '\$12.00',
      'image': 'assets/aceite.jpg',
    },
    {
      'name': 'Champú Premium',
      'price': '\$18.00',
      'image': 'assets/shampoo.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserReservations();
  }

  Future<void> _fetchUserReservations() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.30.39:5000/reservaciones/'),
        headers: {'Content-Type': 'application/json'},
        
      );
      if (response.statusCode == 200) {
        final List<dynamic> reservations = jsonDecode(response.body) as List;
        // Filtrar reservaciones por el userId del usuario logueado
        final userReservations = reservations.where((res) => res['IdUser'] == widget.userId).toList();
        if (userReservations.isNotEmpty) {
          // Tomar la primera reservación (puedes ajustar esto para mostrar todas si es necesario)
          final reservation = userReservations.first;
          setState(() {
            reservationData = {
              'id': reservation['Id'], // Asegúrate de que el campo 'Id' exista en la respuesta
              'date': DateFormat('dd \'de\' MMMM, yyyy').format(DateTime.parse(reservation['Fecha'])),
              'time': reservation['Hora'],
              'service': reservation['Servicio'],
              'barber': reservation['Barbero'] ?? 'Carlos Mendoza', // Ajusta según el backend
              'price': reservation['Precio'] ?? '\$25.00', // Ajusta según el backend
              'status': reservation['Estado'],
            };
          });
        } else {
          setState(() {
            reservationData = null; // No hay reservaciones
          });
        }
      } else {
        print('Failed to fetch reservations: ${response.statusCode} - ${response.body}');
        setState(() {
          reservationData = null; // Manejo de error
        });
      }
    } catch (e) {
      print('Error fetching reservations: $e');
      setState(() {
        reservationData = null; // Manejo de error
      });
    }
  }

  void _showCancelDialog() {
    if (reservationData == null) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: inputBackground,
          title: const Text(
            '¿Cancelar Reservación?',
            style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Esta acción no se puede deshacer. ¿Estás seguro de que deseas cancelar tu reservación?',
            style: TextStyle(color: textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'No, mantener',
                style: TextStyle(color: textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _cancelReservation();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: errorColor,
                foregroundColor: textPrimary,
              ),
              child: const Text('Sí, cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _cancelReservation() async {
    if (reservationData == null) return;
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.1.107:5000/reservaciones/${reservationData!['id']}'),
         //Uri.parse('http://192.168.1.110:5000/${reservationData!['id']}'),
        headers: {'Content-Type': 'application/json'},
        
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reservación cancelada exitosamente'),
            backgroundColor: successColor,
          ),
        );
        setState(() {
          reservationData = null;
          _fetchUserReservations(); // Actualizar la lista
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al cancelar la reservación'),
            backgroundColor: errorColor,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: errorColor,
        ),
      );
    }
  }

  void _showModifyDialog() {
    if (reservationData == null) return;
    String newDate = reservationData!['date'];
    String newTime = reservationData!['time'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: inputBackground,
          title: const Text(
            'Modificar Reservación',
            style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: const TextStyle(color: textPrimary),
                decoration: InputDecoration(
                  labelText: 'Fecha',
                  labelStyle: const TextStyle(color: textSecondary),
                  filled: true,
                  fillColor: inputBackground,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: accentColor.withOpacity(0.3)),
                  ),
                ),
                onChanged: (value) {
                  newDate = value;
                },
                controller: TextEditingController(text: reservationData!['date']),
              ),
              const SizedBox(height: 16),
              TextField(
                style: const TextStyle(color: textPrimary),
                decoration: InputDecoration(
                  labelText: 'Hora',
                  labelStyle: const TextStyle(color: textSecondary),
                  filled: true,
                  fillColor: inputBackground,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: accentColor.withOpacity(0.3)),
                  ),
                ),
                onChanged: (value) {
                  newTime = value;
                },
                controller: TextEditingController(text: reservationData!['time']),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  reservationData!['date'] = newDate;
                  reservationData!['time'] = newTime;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reservación actualizada exitosamente'),
                    backgroundColor: successColor,
                  ),
                );
                // Aquí iría la llamada al backend para actualizar la reservación
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: textPrimary,
              ),
              child: const Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }
  //desplazamiento 
 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: backgroundColor,
    body: SingleChildScrollView(  // Cambiado a SingleChildScrollView
      child: Column(
        children: [
          // Encabezado con imagen (simulando el SliverAppBar)
          Stack(
            children: [
              Image.asset(
                'assets/corte.jpg',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top,
                left: 0,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Positioned(
                bottom: 20,
                left: 20,
                child: Text(
                  'Resumen',
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          // Contenido desplazable
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (reservationData == null)
                  const Text(
                    'No tienes reservaciones activas.',
                    style: TextStyle(color: textSecondary, fontSize: 16),
                  )
                else
                  _buildReservationCard(),
                const SizedBox(height: 30),
                _buildFeaturedProducts(),
                const SizedBox(height: 30),
                _buildLocationSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
  Widget _buildReservationCard() {
    if (reservationData == null) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: inputBackground,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: accentColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tu Reservación',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: successColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  reservationData!['status'],
                  style: const TextStyle(
                    color: successColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildReservationDetail('Fecha', reservationData!['date']),
          _buildReservationDetail('Hora', reservationData!['time']),
          _buildReservationDetail('Servicio', reservationData!['service']),
          _buildReservationDetail('Barbero', reservationData!['barber']),
          _buildReservationDetail('Precio', reservationData!['price']),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _showModifyDialog,
                  icon: const Icon(Icons.edit, color: accentColor),
                  label: const Text(
                    'Modificar',
                    style: TextStyle(color: accentColor),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: accentColor),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _showCancelDialog,
                  icon: const Icon(Icons.cancel, color: textPrimary),
                  label: const Text(
                    'Cancelar',
                    style: TextStyle(color: textPrimary),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: errorColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReservationDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Productos Destacados',
          style: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 170,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: featuredProducts.length,
            itemBuilder: (context, index) {
              final product = featuredProducts[index];
              return Container(
                width: 130,
                margin: const EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  color: inputBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accentColor.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.asset(
                        product['image'],
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 32),
                            child: Text(
                              product['name'],
                              style: const TextStyle(
                                color: textPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            product['price'],
                            style: const TextStyle(
                              color: accentColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: inputBackground,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: accentColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.asset(
              'assets/local.jpg',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: accentColor,
                      size: 24,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Ubicación del Local',
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  'BarberShop Elite',
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Av. Principal 123, Centro\nCiudad de México, CDMX 06000',
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Icon(
                      Icons.phone,
                      color: accentColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '+52 55 1234 5678',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: accentColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Lun - Sáb: 9:00 AM - 8:00 PM',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Abrir mapa o navegación
                    },
                    icon: const Icon(Icons.directions, color: accentColor),
                    label: const Text(
                      'Cómo llegar',
                      style: TextStyle(color: accentColor),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: accentColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
      );
    }
}