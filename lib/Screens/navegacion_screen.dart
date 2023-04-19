import 'package:app_payment/Screens/home_screen.dart';
import 'package:app_payment/Screens/lista_screen.dart';
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
        ],
      ),
      //_screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.print),
            label: 'Comprobante',
          ),
        ],
      ),
    );
  }
}
