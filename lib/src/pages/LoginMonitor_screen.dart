import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Colores base
const Color kBackgroundColor = Color(0xFF1A1A1A);     // Fondo general oscuro
const Color kPrimaryColor = Colors.amber;            // Color principal (resaltado, botones, íconos, texto destacado)
const Color kTextColor = Colors.white;               // Texto normal (etiquetas, texto común)
const Color kHintColor = Colors.grey;                // Texto de sugerencia (hintText)
const Color kInputFillColor = Color(0xFF212121);     // Fondo de los TextFields (aprox. Colors.grey[900])
const Color kBorderColor = Colors.amber;             // Bordes de los campos de texto
const Color kButtonTextColor = Colors.black;         // Texto dentro de botones destacados
const Color kErrorColor = Colors.red;                // Mensajes de error, validaciones fallidas
const Color kSuccessColor = Colors.green;            // Mensajes de éxito

class LoginMonitorScreen extends StatelessWidget {
  const LoginMonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitor de Logins',
      theme: ThemeData(
        brightness: Brightness.dark, // Tema oscuro como base
        scaffoldBackgroundColor: kBackgroundColor,
        primaryColor: kPrimaryColor,
        cardTheme: CardTheme(
          elevation: 4,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: kBorderColor.withOpacity(0.5)),
          ),
          color: kInputFillColor,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: kTextColor),
          bodyMedium: TextStyle(color: kTextColor),
          titleLarge: TextStyle(color: kTextColor, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: kPrimaryColor),
        appBarTheme: AppBarTheme(
          backgroundColor: kBackgroundColor,
          titleTextStyle: TextStyle(color: kTextColor, fontSize: 20, fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: kTextColor),
        ),
      ),
      home: const LoginMonitorScreenContent(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginMonitorScreenContent extends StatefulWidget {
  const LoginMonitorScreenContent({super.key});

  @override
  _LoginMonitorScreenContentState createState() => _LoginMonitorScreenContentState();
}

class _LoginMonitorScreenContentState extends State<LoginMonitorScreenContent> {
  late Future<LoginStats> _loginStats;

  @override
  void initState() {
    super.initState();
    _loginStats = fetchLoginStats();
  }

  Future<LoginStats> fetchLoginStats() async {
    final response = await http.get(Uri.parse('http://192.168.1.107:5000/login_auditoria'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      int total = data.length;
      int successful = data.where((login) => login['exito'] == true).length;
      int failed = total - successful;
      List<LoginAttempt> recentAttempts = data.map((json) => LoginAttempt(
        id: json['id'],
        nombreCompleto: json['nombre_completo'],
        usuarioIngresado: json['usuario_ingresado'],
        successful: json['exito'],
        time: DateTime.parse(json['fecha']),
        ipAddress: json['ip'],
        userAgent: json['user_agent'],
      )).toList();
      return LoginStats(
        totalAttempts: total,
        successfulAttempts: successful,
        failedAttempts: failed,
        recentAttempts: recentAttempts,
      );
    } else {
      throw Exception('Failed to load login stats');
    }
  }

  void refreshData() {
    setState(() {
      _loginStats = fetchLoginStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitor de Logins'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshData,
          ),
        ],
      ),
      body: FutureBuilder<LoginStats>(
        future: _loginStats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: kPrimaryColor));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: kErrorColor),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No hay datos disponibles', style: TextStyle(color: kTextColor)));
          }

          final loginStats = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tarjetas de resumen
                  _buildSummaryCards(loginStats),
                  const SizedBox(height: 24),
                  
                  // Lista de últimos intentos
                  _buildRecentAttemptsList(loginStats.recentAttempts),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(LoginStats stats) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Column(
            children: [
              _buildStatCard(
                title: 'Total Intentos',
                value: stats.totalAttempts.toString(),
                icon: Icons.timeline,
                color: kPrimaryColor,
              ),
              _buildStatCard(
                title: 'Logins Exitosos',
                value: stats.successfulAttempts.toString(),
                icon: Icons.check_circle,
                color: kSuccessColor,
              ),
              _buildStatCard(
                title: 'Logins Fallidos',
                value: stats.failedAttempts.toString(),
                icon: Icons.error,
                color: kErrorColor,
              ),
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Total Intentos',
                  value: stats.totalAttempts.toString(),
                  icon: Icons.timeline,
                  color: kPrimaryColor,
                ),
              ),
              Expanded(
                child: _buildStatCard(
                  title: 'Logins Exitosos',
                  value: stats.successfulAttempts.toString(),
                  icon: Icons.check_circle,
                  color: kSuccessColor,
                ),
              ),
              Expanded(
                child: _buildStatCard(
                  title: 'Logins Fallidos',
                  value: stats.failedAttempts.toString(),
                  icon: Icons.error,
                  color: kErrorColor,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: kHintColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAttemptsList(List<LoginAttempt> attempts) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Últimos intentos de login',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kTextColor,
                ),
              ),
            ),
            const Divider(height: 1, color: kBorderColor),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: attempts.length,
              itemBuilder: (context, index) {
                final attempt = attempts[index];
                return ListTile(
                  leading: Icon(
                    attempt.successful ? Icons.check_circle : Icons.cancel,
                    color: attempt.successful ? kSuccessColor : kErrorColor,
                  ),
                  title: Text(
                    attempt.nombreCompleto ?? attempt.usuarioIngresado,
                    style: TextStyle(color: kTextColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'IP: ${attempt.ipAddress}',
                        style: TextStyle(color: kHintColor),
                      ),
                      Text(
                        'Agente: ${attempt.userAgent}',
                        style: TextStyle(color: kHintColor, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  trailing: Text(
                    DateFormat('HH:mm').format(attempt.time),
                    style: TextStyle(
                      fontSize: 12,
                      color: kTextColor.withOpacity(0.8),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  tileColor: kInputFillColor,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Modelos de datos
class LoginStats {
  final int totalAttempts;
  final int successfulAttempts;
  final int failedAttempts;
  final List<LoginAttempt> recentAttempts;

  LoginStats({
    required this.totalAttempts,
    required this.successfulAttempts,
    required this.failedAttempts,
    required this.recentAttempts,
  });
}

class LoginAttempt {
  final int id;
  final String? nombreCompleto;
  final String usuarioIngresado;
  final bool successful;
  final DateTime time;
  final String? ipAddress;
  final String? userAgent;

  LoginAttempt({
    required this.id,
    this.nombreCompleto,
    required this.usuarioIngresado,
    required this.successful,
    required this.time,
    this.ipAddress,
    this.userAgent,
  });
}