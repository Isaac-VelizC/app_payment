import 'package:app_payment/Screens/home_screen.dart';
import 'package:app_payment/Screens/lista_screen.dart';
import 'package:app_payment/Screens/profile_screen.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

class NavegadorScreen extends StatefulWidget {
  const NavegadorScreen({super.key});

  @override
  State<NavegadorScreen> createState() => _NavegadorScreenState();
}

class _NavegadorScreenState extends State<NavegadorScreen> {
  final PageController _pageController = PageController();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          HomeScreen(),
          ListScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: false,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
        },
        items: <BottomNavyBarItem> [
          BottomNavyBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Home'),
            activeColor: Colors.red,
            inactiveColor: Colors.green,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.print),
            title: const Text('Comprobante'),
            activeColor: Colors.red,
            inactiveColor: Colors.green
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.people),
            title: const Text('Perfil'),
            activeColor: Colors.red,
            inactiveColor: Colors.green
          ),
        ],
      ),
    );
  }
}
