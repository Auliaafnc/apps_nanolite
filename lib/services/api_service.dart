import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost/api'; // Ganti jika bukan emulator

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

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', body['token']); // ← token di root
        return true;
      } else {
        print('Login gagal: ${response.statusCode} => ${response.body}');
        return false;
      }
    } catch (e) {
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
  static Future<List<dynamic>> getCustomers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception('Token tidak tersedia');

    final url = Uri.parse('$baseUrl/customers');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['data']; // ← pastikan backend mengembalikan key 'data'
    } else {
      print('Gagal fetch customer: ${response.statusCode} => ${response.body}');
      throw Exception('Gagal mengambil data customer');
    }
  }
}
