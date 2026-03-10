import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Paleta de colores
  static const Color backgroundColor = Color(0xFF1A1A1A);
  static const Color accentColor = Color(0xFFFFC107);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color inputBackground = Color(0xFF212121);
  static const Color textPrimary = Colors.white;
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.green;

  // Controladores y estados
  final _phoneFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _notificationsEnabled = true;
  bool _emailNotifications = false;
  bool _smsNotifications = true;
  bool _darkModeEnabled = true;

  String currentPhone = "+52 555 123 4567";
  String currentEmail = "ezequiel@email.com";

  @override
  void initState() {
    super.initState();
    _phoneController.text = currentPhone;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Métodos para diálogos y acciones
  void _showPhoneUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: inputBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            'Actualizar Teléfono',
            style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: _phoneFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ingresa tu nuevo número de teléfono',
                  style: TextStyle(color: textSecondary, fontSize: 14),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Número de teléfono',
                    labelStyle: const TextStyle(color: textSecondary),
                    prefixIcon: const Icon(Icons.phone, color: accentColor),
                    filled: true,
                    fillColor: backgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: accentColor.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: accentColor, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa un número de teléfono';
                    }
                    if (value.length < 10) {
                      return 'Número de teléfono inválido';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar', style: TextStyle(color: textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                if (_phoneFormKey.currentState!.validate()) {
                  setState(() {
                    currentPhone = _phoneController.text;
                  });
                  Navigator.of(context).pop();
                  _showSuccessMessage('Teléfono actualizado correctamente');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.black,
              ),
              child: const Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

  void _showPasswordUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: inputBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            'Cambiar Contraseña',
            style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: _passwordFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPasswordField(
                  controller: _currentPasswordController,
                  label: 'Contraseña Actual',
                  obscureText: _obscureCurrentPassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscureCurrentPassword = !_obscureCurrentPassword;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu contraseña actual';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  controller: _newPasswordController,
                  label: 'Nueva Contraseña',
                  obscureText: _obscureNewPassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa una nueva contraseña';
                    }
                    if (value.length < 8) {
                      return 'Mínimo 8 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  label: 'Confirmar Contraseña',
                  obscureText: _obscureConfirmPassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                  validator: (value) {
                    if (value != _newPasswordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearPasswordFields();
              },
              child: const Text('Cancelar', style: TextStyle(color: textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                if (_passwordFormKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                  _showSuccessMessage('Contraseña actualizada correctamente');
                  _clearPasswordFields();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.black,
              ),
              child: const Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

  void _clearPasswordFields() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: inputBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            'Cerrar Sesión',
            style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            '¿Estás seguro de que deseas cerrar sesión?',
            style: TextStyle(color: textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar', style: TextStyle(color: textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showSuccessMessage('Sesión cerrada correctamente');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: errorColor,
                foregroundColor: textPrimary,
              ),
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }

  // Widgets de la interfaz
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Configuración',
          style: TextStyle(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserProfile(),
                  const SizedBox(height: 30),
                  _buildSectionTitle('Cuenta'),
                  _buildSettingCard([
                    _buildSettingItem(
                      icon: Icons.phone,
                      title: 'Teléfono',
                      subtitle: currentPhone,
                      onTap: _showPhoneUpdateDialog,
                    ),
                    _buildDivider(),
                    _buildSettingItem(
                      icon: Icons.lock,
                      title: 'Cambiar Contraseña',
                      subtitle: 'Actualiza tu contraseña de acceso',
                      onTap: _showPasswordUpdateDialog,
                    ),
                    _buildDivider(),
                    _buildSettingItem(
                      icon: Icons.email,
                      title: 'Email',
                      subtitle: currentEmail,
                      onTap: () {},
                      showArrow: false,
                    ),
                  ]),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Notificaciones'),
                  _buildSettingCard([
                    _buildSwitchItem(
                      icon: Icons.notifications,
                      title: 'Notificaciones Push',
                      subtitle: 'Recibe alertas de tus citas',
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                    ),
                    _buildDivider(),
                    _buildSwitchItem(
                      icon: Icons.email_outlined,
                      title: 'Notificaciones por Email',
                      subtitle: 'Confirmaciones y recordatorios',
                      value: _emailNotifications,
                      onChanged: (value) {
                        setState(() {
                          _emailNotifications = value;
                        });
                      },
                    ),
                    _buildDivider(),
                    _buildSwitchItem(
                      icon: Icons.sms,
                      title: 'Notificaciones SMS',
                      subtitle: 'Mensajes de texto importantes',
                      value: _smsNotifications,
                      onChanged: (value) {
                        setState(() {
                          _smsNotifications = value;
                        });
                      },
                    ),
                  ]),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Apariencia'),
                  _buildSettingCard([
                    _buildSwitchItem(
                      icon: Icons.dark_mode,
                      title: 'Modo Oscuro',
                      subtitle: 'Tema oscuro para la aplicación',
                      value: _darkModeEnabled,
                      onChanged: (value) {
                        setState(() {
                          _darkModeEnabled = value;
                        });
                      },
                    ),
                  ]),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Otros'),
                  _buildSettingCard([
                    _buildSettingItem(
                      icon: Icons.help_outline,
                      title: 'Ayuda y Soporte',
                      subtitle: 'Preguntas frecuentes y contacto',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildSettingItem(
                      icon: Icons.info_outline,
                      title: 'Acerca de',
                      subtitle: 'Versión 1.0.0',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildSettingItem(
                      icon: Icons.logout,
                      title: 'Cerrar Sesión',
                      subtitle: 'Salir de tu cuenta',
                      onTap: _showLogoutDialog,
                      titleColor: errorColor,
                    ),
                  ]),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserProfile() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: inputBackground,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: accentColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: accentColor, width: 2),
            ),
            child: const Icon(
              Icons.person,
              size: 40,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Ezequiel Salazar',
            style: TextStyle(
              color: textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            currentEmail,
            style: const TextStyle(
              color: textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: inputBackground,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: accentColor.withOpacity(0.2)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? titleColor,
    bool showArrow = true,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: accentColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: textSecondary,
          fontSize: 14,
        ),
      ),
      trailing: showArrow
          ? Icon(Icons.arrow_forward_ios, color: textSecondary, size: 16)
          : null,
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: accentColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: textSecondary,
          fontSize: 14,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: accentColor,
        activeTrackColor: accentColor.withOpacity(0.3),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: textSecondary.withOpacity(0.2),
      height: 1,
      indent: 60,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: textSecondary),
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: accentColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: accentColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: errorColor),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: textSecondary,
          ),
          onPressed: onToggleVisibility,
        ),
      ),
      validator: validator,
    );
  }
}