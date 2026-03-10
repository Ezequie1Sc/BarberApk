import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:convert';
import 'package:flutter_application_4/src/services/user_api.dart'; // Adjust import as needed

class AgendarCitasScreen extends StatefulWidget {
  const AgendarCitasScreen({super.key});

  @override
  State<AgendarCitasScreen> createState() => _AgendarCitasScreenState();
}

class _AgendarCitasScreenState extends State<AgendarCitasScreen> {
  final _formKey = GlobalKey<FormState>();
  final _clientNameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  String? _selectedService;
  bool _isForSelf = true;
  double _scrollOffset = 0.0;

  // Lista de horarios disponibles
  List<Map<String, dynamic>> _timeSlots = [];

  final List<String> _services = ['Corte de cabello', 'Afeitado', 'Corte y barba', 'Tinte'];
  final Map<String, String> _serviceEmojis = {
    'Corte de cabello': '✂️',
    'Afeitado': '🪒',
    'Corte y barba': '💈',
    'Tinte': '🎨',
  };

  @override
  void initState() {
    super.initState();
    _timeSlots = generateTimeSlots();
    initializeDateFormatting('es', null).then((_) {
      setState(() {
        _fetchReservations();
      });
    });
  }

  // Generate time slots dynamically (9 AM to 7 PM, 30-minute intervals)
  List<Map<String, dynamic>> generateTimeSlots() {
    List<Map<String, dynamic>> slots = [];
    for (int hour = 9; hour <= 19; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        final timeOfDay = TimeOfDay(hour: hour, minute: minute);
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour == 0 ? 12 : hour > 12 ? hour - 12 : hour;
        final timeString = '$displayHour:${minute.toString().padLeft(2, '0')} $period';
        slots.add({'time': timeString, 'isReserved': false});
      }
    }
    return slots;
  }

  // Normalize server time to HH:mm
  String normalizeServerTime(String serverTime) {
    final parts = serverTime.split(':');
    if (parts.length >= 2) {
      return '${parts[0]}:${parts[1].padLeft(2, '0')}';
    }
    return serverTime;
  }

  // Convert military time (HH:mm) to AM/PM
  String _convertToAMPM(String militaryTime) {
    try {
      final parts = militaryTime.split(':');
      if (parts.length != 2) return militaryTime;
      int hour = int.parse(parts[0]);
      final minute = parts[1].padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour == 0 ? 12 : hour > 12 ? hour - 12 : hour;
      return '$displayHour:$minute $period';
    } catch (e) {
      print('Error converting time: $e');
      return militaryTime;
    }
  }

  Future<void> _fetchReservations() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.107:5000/reservaciones/'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> reservaciones = jsonDecode(response.body) as List;
        setState(() {
          _timeSlots = _timeSlots.map((slot) {
            final isReserved = reservaciones.any((reserva) {
              try {
                final reservaFecha = DateTime.parse(reserva['Fecha']).toLocal();
                final reservaHora = normalizeServerTime(reserva['Hora']);
                final formattedServerTime = _convertToAMPM(reservaHora);
                return reservaFecha.day == _selectedDate.day &&
                    reservaFecha.month == _selectedDate.month &&
                    reservaFecha.year == _selectedDate.year &&
                    slot['time'] == formattedServerTime;
              } catch (e) {
                print('Error parsing reservation: $e');
                return false;
              }
            });
            return {'time': slot['time'], 'isReserved': isReserved};
          }).toList();
        });
      } else {
        print('Failed to fetch reservations: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching reservations: $e');
    }
  }

  void _bookAppointment() async {
    final validServices = ['Corte', 'Afeitado', 'Tinte', 'Peinado'];
    if (_formKey.currentState!.validate() && _selectedTime != null && _selectedService != null) {
      try {
        final mappedService = _selectedService!.contains('Corte') ? 'Corte' :
                             _selectedService!.contains('Afeitado') ? 'Afeitado' :
                             _selectedService!.contains('Tinte') ? 'Tinte' : 'Peinado';

        if (!validServices.contains(mappedService)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Servicio no válido.'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
          return;
        }

        // Convert AM/PM to 24-hour format
        final timeParts = _selectedTime!.split(' ');
        if (timeParts.length != 2) {
          throw Exception('Formato de hora inválido: $_selectedTime');
        }
        final time = timeParts[0].split(':');
        if (time.length != 2) {
          throw Exception('Formato de hora inválido: $_selectedTime');
        }
        final isPM = timeParts[1].toUpperCase() == 'PM';
        int hour = int.parse(time[0]);
        final minute = int.parse(time[1]);

        // Handle 12 AM/PM edge cases
        if (hour == 12) {
          hour = isPM ? 12 : 0;
        } else {
          hour = isPM ? hour + 12 : hour;
        }

        // Validate business hours (9 AM to 7 PM)
        if (hour < 9 || hour > 19 || (hour == 19 && minute > 0)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('La hora debe estar entre 09:00 y 19:00.'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
          return;
        }

        final timeOfDay = TimeOfDay(hour: hour, minute: minute);
        final fechaFormateada = DateFormat('yyyy-MM-dd').format(_selectedDate);
        final horaFormateada = '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';

        final int userId = await _getAuthenticatedUserId();
        final body = {
          'IdUser': userId,
          'Servicio': mappedService,
          'Fecha': fechaFormateada,
          'Hora': horaFormateada,
          'ParaOtraPersona': !_isForSelf,
          if (!_isForSelf && _clientNameController.text.isNotEmpty) 'NombrePersona': _clientNameController.text,
          'Estado': 'Pendiente',
        };

        print('Request Body: ${jsonEncode(body)}');

        final response = await http.post(
          Uri.parse('http://192.168.1.107:5000/reservaciones/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );

        print('Reservation Response Status: ${response.statusCode}');
        print('Reservation Response Body: ${response.body}');

        if (response.statusCode == 201) {
          await _fetchReservations();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.grey[900],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 30),
                  SizedBox(width: 8),
                  Text(
                    '¡Reserva Confirmada!',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: Text(
                'Cita reservada para ${_isForSelf ? 'ti' : _clientNameController.text} el '
                '${DateFormat('dd/MM/yyyy').format(_selectedDate)} a las $_selectedTime',
                style: const TextStyle(color: Colors.white),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _selectedTime = null;
                      _selectedService = null;
                      _isForSelf = true;
                      _clientNameController.clear();
                    });
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        } else {
          throw Exception('Error al crear reservación: ${response.statusCode} - ${response.body}');
        }
      } catch (e) {
        String errorMessage = 'Error al procesar la reservación: ${e.toString()}';
        if (e is http.ClientException) {
          errorMessage = 'Error de conexión: verifica tu conexión a internet y que el servidor esté activo.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor, completa todos los campos requeridos'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Future<int> _getAuthenticatedUserId() async {
    return UserApi.currentUserId ?? 0; // Adjust based on your UserApi implementation
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.amber,
              onPrimary: Colors.black,
              surface: Color(0xFF1A1A1A),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF1A1A1A),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectedTime = null;
        _fetchReservations();
      });
    }
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final reservedColor = isDarkTheme ? Colors.grey[600]! : Colors.grey[400]!;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            setState(() {
              _scrollOffset = scrollNotification.metrics.pixels;
            });
          }
          return false;
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  final double shrinkPercentage = (_scrollOffset / (200.0 - kToolbarHeight)).clamp(0.0, 1.0);
                  final double imageHeight = 200.0 - shrinkPercentage * (200.0 - kToolbarHeight);

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                        child: Image.asset(
                          'assets/barbero.jpg',
                          fit: BoxFit.cover,
                          height: imageHeight,
                          width: double.infinity,
                          alignment: Alignment.center,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reservar Cita',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Elige tu fecha y horario',
                      style: TextStyle(color: Colors.grey[400], fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DropdownButtonFormField<String>(
                              value: _selectedService,
                              decoration: InputDecoration(
                                labelText: 'Servicio',
                                labelStyle: TextStyle(color: Colors.grey[400]),
                                filled: true,
                                fillColor: Colors.grey[900],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Colors.amber, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Colors.amber, width: 2),
                                ),
                              ),
                              dropdownColor: Colors.grey[900],
                              style: const TextStyle(color: Colors.white),
                              items: _services.map((service) {
                                return DropdownMenuItem(
                                  value: service,
                                  child: Row(
                                    children: [
                                      Text(_serviceEmojis[service] ?? ''),
                                      const SizedBox(width: 8),
                                      Text(service),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedService = value;
                                });
                              },
                              validator: (value) => value == null ? 'Por favor, selecciona un servicio' : null,
                            ),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.amber, width: 1),
                              ),
                              child: ToggleButtons(
                                isSelected: [_isForSelf, !_isForSelf],
                                onPressed: (index) {
                                  setState(() {
                                    _isForSelf = index == 0;
                                    _clientNameController.clear();
                                  });
                                },
                                borderRadius: BorderRadius.circular(10),
                                selectedColor: Colors.black,
                                fillColor: Colors.amber,
                                color: Colors.white,
                                constraints: BoxConstraints(
                                  minWidth: (MediaQuery.of(context).size.width - 64) / 2,
                                  minHeight: 40,
                                ),
                                children: const [
                                  Text('Para mí'),
                                  Text('Para otra persona'),
                                ],
                              ),
                            ),
                            if (!_isForSelf) ...[
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _clientNameController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Nombre del cliente',
                                  labelStyle: TextStyle(color: Colors.grey[400]),
                                  filled: true,
                                  fillColor: Colors.grey[900],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Colors.amber, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Colors.amber, width: 2),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Colors.red, width: 1),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Colors.red, width: 2),
                                  ),
                                ),
                                validator: (value) {
                                  if (!_isForSelf && (value == null || value.isEmpty)) {
                                    return 'Por favor, ingresa el nombre del cliente';
                                  }
                                  return null;
                                },
                              ),
                            ],
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () => _selectDate(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  border: Border.all(color: Colors.amber, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      DateFormat('dd/MM/yyyy').format(_selectedDate),
                                      style: const TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                    const Icon(Icons.calendar_today, color: Colors.amber),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Días Disponibles',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(7, (index) {
                                  final date = DateTime.now().add(Duration(days: index));
                                  final isSelected = date.day == _selectedDate.day &&
                                      date.month == _selectedDate.month &&
                                      date.year == _selectedDate.year;
                                  final dayName = DateFormat('EEEE', 'es').format(date).substring(0, 3).toUpperCase();
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedDate = date;
                                        _selectedTime = null;
                                        _fetchReservations();
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: isSelected ? Colors.amber : Colors.grey[900],
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: isSelected ? Colors.amber : Colors.grey[800]!, width: 1),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            dayName,
                                            style: TextStyle(
                                              color: isSelected ? Colors.black : Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          Text(
                                            date.day.toString(),
                                            style: TextStyle(
                                              color: isSelected ? Colors.black : Colors.white,
                                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Horarios Disponibles',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _timeSlots.map((slot) => _buildTimeSlot(slot['time'], slot['isReserved'], reservedColor)).toList(),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _bookAppointment,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Reservar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 50),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlot(String time, bool isReserved, Color reservedColor) {
    final isSelected = _selectedTime == time && !isReserved;
    return GestureDetector(
      onTap: isReserved
          ? null
          : () {
              setState(() {
                _selectedTime = time;
              });
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isReserved
              ? reservedColor.withOpacity(0.5)
              : isSelected
                  ? Colors.amber.withOpacity(0.2)
                  : Colors.grey[900],
          border: Border.all(
            color: isReserved
                ? reservedColor
                : isSelected
                    ? Colors.amber
                    : Colors.grey[800]!,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              time,
              style: TextStyle(
                color: isReserved
                    ? Colors.grey[400]
                    : isSelected
                        ? Colors.amber
                        : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                decoration: isReserved ? TextDecoration.lineThrough : null,
              ),
            ),
            if (isReserved) ...[
              const SizedBox(width: 4),
              const Icon(Icons.lock, color: Colors.grey, size: 16),
            ],
          ],
        ),
      ),
    );
  }
}