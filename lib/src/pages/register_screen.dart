import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_4/src/models/user_models.dart';
import 'package:flutter_application_4/src/pages/home_screen.dart';
import 'package:flutter_application_4/src/services/user_api.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _focusNodes = List.generate(7, (index) => FocusNode());

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    _usuarioController.dispose();
    _nombreController.dispose();
    _apellidoController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Validador de email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un email válido';
    }
    return null;
  }

  // Validador de teléfono
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu teléfono';
    }
    // Remover espacios y caracteres especiales para validación
    final cleanPhone = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone.length < 10) {
      return 'El teléfono debe tener al menos 10 dígitos';
    }
    return null;
  }

  // Formatear teléfono mientras se escribe
  void _formatPhoneNumber() {
    String value = _telefonoController.text;
    String cleaned = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleaned.length >= 10) {
      String formatted = '';
      if (cleaned.startsWith('52')) {
        // Formato internacional +52 555 123 4567
        formatted = '+52 ${cleaned.substring(2, 5)} ${cleaned.substring(5, 8)} ${cleaned.substring(8, 12)}';
      } else {
        // Formato nacional 555 123 4567
        formatted = '${cleaned.substring(0, 3)} ${cleaned.substring(3, 6)} ${cleaned.substring(6, 10)}';
      }
      
      if (formatted != value) {
        _telefonoController.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () => Navigator.pop(context),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: const Color(0xFF1A1A1A),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                // Animación de icono
                AnimatedScale(
                  scale: _isLoading ? 0.9 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(
                    Icons.person_add_alt_1,
                    size: 80,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedOpacity(
                  opacity: _isLoading ? 0.7 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: const Text(
                    'Crear Cuenta',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Completa el formulario para registrarte',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                
                // Campo Usuario
                _buildTextField(
                  controller: _usuarioController,
                  label: 'Usuario',
                  hint: 'Ingresa tu nombre de usuario',
                  prefixIcon: Icons.person_outline,
                  focusNode: _focusNodes[0],
                  nextFocus: _focusNodes[1],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un usuario';
                    }
                    if (value.length < 4) {
                      return 'El usuario debe tener al menos 4 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                
                // Campo Nombre
                _buildTextField(
                  controller: _nombreController,
                  label: 'Nombre',
                  hint: 'Ingresa tu nombre',
                  prefixIcon: Icons.badge_outlined,
                  focusNode: _focusNodes[1],
                  nextFocus: _focusNodes[2],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                
                // Campo Apellido
                _buildTextField(
                  controller: _apellidoController,
                  label: 'Apellido',
                  hint: 'Ingresa tu apellido',
                  prefixIcon: Icons.badge_outlined,
                  focusNode: _focusNodes[2],
                  nextFocus: _focusNodes[3],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu apellido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                
                // Campo Email
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'ejemplo@correo.com',
                  prefixIcon: Icons.email_outlined,
                  focusNode: _focusNodes[3],
                  nextFocus: _focusNodes[4],
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 18),
                
                // Campo Teléfono
                _buildTextField(
                  controller: _telefonoController,
                  label: 'Teléfono',
                  hint: '555 123 4567',
                  prefixIcon: Icons.phone_outlined,
                  focusNode: _focusNodes[4],
                  nextFocus: _focusNodes[5],
                  keyboardType: TextInputType.phone,
                  validator: _validatePhone,
                  onChanged: (value) => _formatPhoneNumber(),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Formato: 555 123 4567 o +52 555 123 4567',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                
                // Campo Contraseña
                _buildPasswordField(
                  controller: _passwordController,
                  label: 'Contraseña',
                  hint: 'Crea una contraseña segura',
                  obscureText: _obscurePassword,
                  focusNode: _focusNodes[5],
                  nextFocus: _focusNodes[6],
                  onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una contraseña';
                    }
                    if (value.length < 8) {
                      return 'La contraseña debe tener al menos 8 caracteres';
                    }
                    // Validación de seguridad mejorada
                    if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
                      return 'Debe contener al menos una letra y un número';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Mínimo 8 caracteres, incluye letras y números',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                
                // Campo Confirmar Contraseña
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  label: 'Confirmar Contraseña',
                  hint: 'Repite tu contraseña',
                  obscureText: _obscureConfirmPassword,
                  focusNode: _focusNodes[6],
                  onToggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor confirma tu contraseña';
                    }
                    if (value != _passwordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 35),
                
                // Botón de Registro
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 50,
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: _registrarUsuario,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 3,
                            shadowColor: Colors.amber.withOpacity(0.5),
                          ),
                          child: const Text(
                            'REGISTRARME',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 20),
                
                // Enlace a términos y condiciones
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Navegar a términos y condiciones
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Al registrarte, aceptas nuestros ',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                        children: const <TextSpan>[
                          TextSpan(
                            text: 'Términos y Condiciones',
                            style: TextStyle(
                              color: Colors.amber,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(text: ' y '),
                          TextSpan(
                            text: 'Política de Privacidad',
                            style: TextStyle(
                              color: Colors.amber,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    required FocusNode focusNode,
    FocusNode? nextFocus,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      textInputAction: nextFocus != null ? TextInputAction.next : TextInputAction.done,
      onFieldSubmitted: (_) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.amber),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(prefixIcon, color: Colors.amber),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.amber, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.amber, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        errorStyle: const TextStyle(color: Colors.red),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool obscureText,
    required FocusNode focusNode,
    FocusNode? nextFocus,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      focusNode: focusNode,
      style: const TextStyle(color: Colors.white),
      textInputAction: nextFocus != null ? TextInputAction.next : TextInputAction.done,
      onFieldSubmitted: (_) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.amber),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.amber),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.amber,
          ),
          onPressed: onToggle,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.amber, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.amber, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        errorStyle: const TextStyle(color: Colors.red),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
    );
  }
//METODOOOOOOOOOOOOOOOOOOOOOOOOOOOOO 

 Future<void> _registrarUsuario() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  setState(() => _isLoading = true);

  try {
    final cleanedPhone = _telefonoController.text.replaceAll(RegExp(r'[^\d]'), '');

    final user = UserModel(
      idUser: 0,
      usuario: _usuarioController.text.trim(),
      nombre: _nombreController.text.trim(),
      apellido: _apellidoController.text.trim(),
      email: _emailController.text.trim(),
      telefono: cleanedPhone,
      password: _passwordController.text.trim(),
    );

    final response = await UserApi.register(user);
    print('Registro response: $response'); // Depuración

    setState(() => _isLoading = false);

    if (response['success']) {
      // Asegúrate de que _currentUserId se actualiza
      if (response['userId'] != null) {
        print('Nuevo userId asignado: ${response['userId']}');
      } else {
        print('userId no recibido en la respuesta');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '¡Registro exitoso!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Bienvenido/a ${_nombreController.text} ${_apellidoController.text}'),
            ],
          ),
          backgroundColor: Colors.green[800],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 3),
        ),
      );

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Error al registrar'),
          backgroundColor: Colors.red[800],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  } catch (e) {
    setState(() => _isLoading = false);
    print('Error durante registro: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error de conexión: $e'),
        backgroundColor: Colors.red[800],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}



}