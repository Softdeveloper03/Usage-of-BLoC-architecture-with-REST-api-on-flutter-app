import 'dart:convert';
import 'package:frnt/model/model.dart';
import 'package:http/http.dart' as http;

class NameProvider {
  final String baseUrl = 'http://192.168.1.109:3000';

  Future<List<NameModel>> fetchNames() async {
    final response = await http.get(Uri.parse("$baseUrl/getname"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['names'];
      return data.map((e) => NameModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch names');
    }
  }

  Future<NameModel> createName(String name) async {
    final response = await http.post(
      Uri.parse("$baseUrl/name"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}),
    );
    if (response.statusCode == 201) {
      return NameModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create name');
    }
  }

  Future<NameModel> updateName(int id, String name) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}),
    );
    if (response.statusCode == 200) {
      return NameModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update name');
    }
  }

  Future<void> deleteName(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/delete/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete name');
    }
  }
}
