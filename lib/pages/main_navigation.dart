//import 'dart:convert';
//import 'dart:io';
//import 'package:image_picker/image_picker.dart';
//import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:flutter/widgets.dart';
//import 'package:flutter/animation.dart';

//import '../config/app_config.dart';

//import '../models/sports_space.dart';
//import '../models/reserved_space.dart';
//import '../models/notification_item.dart';

//import '../services/space_service.dart';
//import '../services/user_service.dart';

//import '../state/app_state.dart';

import 'profile_page.dart';
import 'sport_home_page.dart';
import 'favorites_pages.dart';
import 'my_reservations_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = const SportsHomePage();
        break;
      case 1:
        page = const FavoritesSpacesPage();
        break;
      case 2:
        page = const MyReservationsPage();
        break;
      case 3:
        page = const ProfilePage();
        break;
      default:
        page = const SportsHomePage();
    }
    return Scaffold(
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Reservas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}