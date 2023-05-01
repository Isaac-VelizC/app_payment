import 'package:app_payment/Screens/home_screen.dart';
import 'package:app_payment/Screens/lista_screen.dart';
import 'package:app_payment/Screens/profile_screen.dart';
import 'package:app_payment/themes/colors.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      backgroundColor: fondo1,
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
        backgroundColor: fondo1,
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
            icon: SvgPicture.asset(
                'assets/icons/home.svg',
                color: boton2,
                height: 30,
                width: 30,
              ),
            title: const Text('Home'),
            activeColor: boton2,
            inactiveColor: boton1,
          ),
          BottomNavyBarItem(
            icon: SvgPicture.asset(
                'assets/icons/lista.svg',
                color: boton2,
                height: 30,
                width: 30,
              ),
            title: const Text('Listado'),
            activeColor: boton2,
            inactiveColor: boton1
          ),
          BottomNavyBarItem(
            icon: SvgPicture.asset(
                'assets/icons/ajustes.svg',
                color: boton2,
                height: 30,
                width: 30,
              ),
            title: const Text('Ajustes'),
            activeColor: boton2,
            inactiveColor: boton1
          ),
        ],
      ),
    );
  }
}
