import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/customer.dart';

class ApiService {
  static const String baseUrl = 'http://localhost/api'; // tetap localhost

  // ---------------- LOGIN ----------------
  static Future<bool> login(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/auth/login');

      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final body = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          body['success'] == true &&
          body['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', body['token']);
        return true;
      } else {
        // log biar gampang debug
        // ignore: avoid_print
        print('Login gagal: ${response.statusCode} => ${response.body}');
        return false;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error login: $e');
      return false;
    }
  }

  // ---------------- LOGOUT ----------------
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // ---------------- GET CUSTOMER LIST ----------------
  static Future<List<Customer>> fetchCustomers({int? perPage}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final uri = Uri.parse(
      perPage == null
          ? '$baseUrl/customers'
          : '$baseUrl/customers?per_page=$perPage',
    );

    final res = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Error ${res.statusCode}: ${res.body}');
    }

    final decoded = jsonDecode(res.body);

    // dukung 2 bentuk: { data: [...] } atau langsung [...]
    final list = (decoded is Map && decoded['data'] != null)
        ? decoded['data']
        : decoded;

    if (list is! List) return [];

    return list
        .map((e) => Customer.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
