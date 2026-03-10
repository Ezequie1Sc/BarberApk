import 'package:flutter/material.dart';
import 'package:flutter_application_4/src/pages/LoginMonitor_screen.dart';
import 'package:flutter_application_4/src/pages/home_screen.dart';
import 'package:flutter_application_4/src/pages/main_navigation.dart';
import 'package:flutter_application_4/src/pages/register_screen.dart';
import 'package:flutter_application_4/src/pages/resumen_screen.dart';
import 'package:flutter_application_4/src/services/user_api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // Logo ajustado sin fondo blanco
              Container(
                margin: const EdgeInsets.only(top: 40, bottom: 30),
                child: Image.asset(
                  'assets/lou.png',
                  width: 202,  // Mantenemos las dimensiones originales
                  height: 197,
                  fit: BoxFit.contain,
                  // Eliminamos los filtros de color que podrían afectar la imagen
                ),
              ),

              // Título
              const Text(
                'INICIAR SESIÓN',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // Campo Usuario
              TextField(
                controller: _usuarioController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  labelStyle: const TextStyle(color: Colors.amber),
                  hintText: 'Ingresa tu usuario',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.person_outline, color: Colors.amber),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.amber),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.amber, width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.grey[900],
                ),
              ),
              const SizedBox(height: 25),

              // Campo Contraseña
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: const TextStyle(color: Colors.amber),
                  hintText: 'Ingresa tu contraseña',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.amber),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.amber),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.amber, width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.grey[900],
                ),
              ),
              const SizedBox(height: 15),

              // Recordar contraseña y olvidé contraseña
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: Colors.amber,
                        ),
                        child: Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                          checkColor: Colors.black,
                          activeColor: Colors.amber,
                        ),
                      ),
                      const Text(
                        'Recordarme',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // Navegar a pantalla de recuperación
                    },
                    child: const Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(color: Colors.amber),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Botón de Iniciar Sesión
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _iniciarSesion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'INGRESAR',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Opción para registrarse
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¿No tienes una cuenta? ',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navegar a pantalla de registro
                       Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen()));
                    },
                    child: const Text(
                      'Regístrate',
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
void _iniciarSesion() async {
  if (_usuarioController.text.isEmpty || _passwordController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Por favor ingresa usuario y contraseña'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  // Acceso directo al monitor (sin verificar contraseña)
  if (_usuarioController.text.toLowerCase() == 'monitor') {
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginMonitorScreen()),
    );
    return;
  }

  try {
    final response = await UserApi.login(
      _usuarioController.text,
      _passwordController.text,
    );

    print('API Response: $response');

    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inicio de sesión exitoso'),
          backgroundColor: Colors.green,
        ),
      );

      final userId = response['user']?['id'] ??
                     response['data']?['userId'] ??
                     response['data']?['id'] ??
                     response['userId'];
      if (userId == null) {
        throw Exception('No se pudo obtener el userId de la respuesta. Verifica la estructura: $response');
      }
      print('User ID: $userId');

      if (!context.mounted) {
        print('Context is not mounted, cannot navigate');
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainNavigation(userId: userId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Error al iniciar sesión'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    print('Error during login: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

}