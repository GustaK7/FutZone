//import 'dart:convert';
//import 'dart:io';
//import 'package:image_picker/image_picker.dart';
//import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:flutter/widgets.dart';
//import 'package:flutter/animation.dart';

//import '../config/app_config.dart';

//import '../models/sports_space.dart';
//import '../models/reserved_space.dart';
//import '../models/notification_item.dart';

//import '../services/space_service.dart';
//import '../services/user_service.dart';

import '../state/app_state.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações do app')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Modo escuro'),
            value: appState.darkMode,
            onChanged: (value) => appState.toggleDarkMode(value),
            secondary: const Icon(Icons.dark_mode),
          ),
          SwitchListTile(
            title: const Text('Notificações'),
            value: appState.notificationsEnabled,
            onChanged: (value) => appState.toggleNotifications(value),
            secondary: const Icon(Icons.notifications_active),
          ),
        ],
      ),
    );
  }
}
