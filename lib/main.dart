//import 'dart:convert';
//import 'dart:io';
//import 'package:image_picker/image_picker.dart';
//import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:flutter/widgets.dart';
//import 'package:flutter/animation.dart';

//import '../config/app_config.dart';

//import '../models/sports_space.dart';
//import '../models/reserved_space.dart';
//import '../models/notification_item.dart';

//import '../services/space_service.dart';
//import '../services/user_service.dart';

import '../state/app_state.dart';

import '../pages/main_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: Consumer<AppState>(
        builder: (context, appState, _) {
          return MaterialApp(
            title: 'Reserva Esportiva',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green,
                brightness:
                    appState.darkMode ? Brightness.dark : Brightness.light,
              ),
            ),
            supportedLocales: const [
              Locale('pt', 'BR'),
              Locale('en', ''),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const MainNavigation(),
          );
        },
      ),
    );
  }
}

