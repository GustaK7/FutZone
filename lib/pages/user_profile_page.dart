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

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil do Usuário')),
      body: Column(
        children: [
          const SizedBox(height: 32),
          const Center(
            child: CircleAvatar(
              radius: 56,
              child: Icon(Icons.person, size: 64),
            ),
          ),
          const SizedBox(height: 16),
          Text(appState.userName,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(appState.userEmail,
              style: TextStyle(fontSize: 16, color: Colors.grey[700])),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Futuramente: editar perfil
            },
            icon: const Icon(Icons.edit),
            label: const Text('Editar perfil'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }
}