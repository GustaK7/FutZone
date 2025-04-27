import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/sports_space.dart';

class SpaceService {
  static Future<List<SportsSpace>> fetchSpaces() async {
    final response =
        await http.get(Uri.parse('${AppConfig.backendUrl}/spaces'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((json) => SportsSpace(
                id: json['_id'] ?? '',
                name: json['name'] ?? '',
                pricePerHour: (json['pricePerHour'] ?? 0).toDouble(),
                imageUrl: json['imageUrl'] ?? '',
                rating: (json['rating'] ?? 0).toDouble(),
                sportType: json['sportType'] ?? '',
                description: json['description'] ?? '',
                hostName: json['hostName'] ?? '',
                address: json['address'] ?? '',
              ))
          .toList();
    } else {
      throw Exception('Erro ao buscar espaços');
    }
  }

  static Future<void> createSpace({
    required String name,
    required String type,
    required double price,
    required String address,
    required String description,
    required String host,
    required String imageUrl,
  }) async {
    final response = await http.post(
      Uri.parse('${AppConfig.backendUrl}/spaces'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'sportType': type,
        'pricePerHour': price,
        'address': address,
        'description': description,
        'hostName': host,
        'imageUrl': imageUrl,
        'rating': 0,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Erro ao cadastrar espaço');
    }
  }
}

