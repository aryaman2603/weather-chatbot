import 'package:flutter/material.dart';
import 'package:weather_app_tutorial/screens/detailed_forecast_screen.dart';
import 'package:weather_app_tutorial/screens/search_screen.dart';
import 'package:weather_app_tutorial/screens/settings_screen.dart';
import 'package:weather_app_tutorial/screens/weather_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPageIndex = 0;
  
  final _destinations = const [
    NavigationDestination(
      icon: Icon(Icons.home_outlined, color: Colors.white,),
      selectedIcon: Icon(Icons.home, color: Colors.white,),
      label: '',
    ),
    NavigationDestination(
      icon: Icon(Icons.search_outlined, color: Colors.white,),
      selectedIcon: Icon(Icons.search, color: Colors.white,),
      label: '',
    ),
    NavigationDestination(
      icon: Icon(Icons.wb_sunny_outlined, color: Colors.white,),
      selectedIcon: Icon(Icons.wb_sunny, color: Colors.white,),
      label: '',
    ),
    NavigationDestination(
      icon: Icon(Icons.settings_outlined, color: Colors.white,),
      selectedIcon: Icon(Icons.settings, color: Colors.white,),
      label: '',
    ),
  ];

  @override
Widget build(BuildContext context) {
  final _screens = [
    WeatherScreen(
      onViewFullForecast: () {
        setState(() {
          _currentPageIndex = 2; // Navigate to DetailedForecastScreen
        });
      },
    ),
    SearchScreen(),
    DetailedForecastScreen(),
    ChatScreen(),
  ];

  return Scaffold(
    body: _screens[_currentPageIndex],
    bottomNavigationBar: NavigationBarTheme(
      data: NavigationBarThemeData(backgroundColor: Colors.black),
      child: NavigationBar(
        destinations: _destinations,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: _currentPageIndex,
        indicatorColor: Colors.transparent,
        onDestinationSelected: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
      ),
    ),
  );
}

}
