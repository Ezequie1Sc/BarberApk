import 'package:flutter/material.dart';
import 'package:flutter_application_4/src/pages/agendar_citas_screen.dart';
import 'package:flutter_application_4/src/pages/productos_screen.dart';
import 'package:flutter_application_4/src/pages/profile_screen%20.dart';

import 'package:flutter_application_4/src/pages/resumen_screen.dart';

class MainNavigation extends StatefulWidget {
  final int userId;
  
  const MainNavigation({Key? key, required this.userId}) : super(key: key);
  
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Inicializamos las pantallas aquí para tener acceso a widget.userId
    _screens = [
      SummaryScreen(userId: widget.userId),
      const AgendarCitasScreen(),
      const ProductoScreen(),
      ProfileScreen(), // Pass userId to ProfileScreen
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _screens[_currentIndex],
        ],
      ),
      bottomNavigationBar: _buildAnimatedBottomNavBar(),
    );
  }

  Widget _buildAnimatedBottomNavBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 15,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 70,
          color: const Color(0xFF222222),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.dashboard, 'Resumen', 0),
              _buildNavItem(Icons.calendar_today, 'Agendar', 1),
              _buildNavItem(Icons.shopping_bag, 'Productos', 2),
              _buildNavItem(Icons.person, 'Perfil', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.amber : Colors.grey,
              size: isSelected ? 26 : 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.amber : Colors.grey,
                fontSize: isSelected ? 12 : 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}