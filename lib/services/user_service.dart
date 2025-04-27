import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:futzone/config/app_config.dart';

class UserService {
  static Future<Map<String, dynamic>> fetchUser(String email) async {
    final response =
        await http.get(Uri.parse('${AppConfig.backendUrl}/users?email=$email'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      if (data.isNotEmpty) return data.first;
      throw Exception('Usuário não encontrado');
    } else {
      throw Exception('Erro ao buscar usuário');
    }
  }

  static Future<void> updateUser(String id, Map<String, dynamic> update) async {
    final response = await http.put(
      Uri.parse('${AppConfig.backendUrl}/users/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(update),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar usuário');
    }
  }
}