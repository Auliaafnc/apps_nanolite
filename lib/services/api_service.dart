// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/customer.dart';

/// Item sederhana buat dropdown (id & name)
class OptionItem {
  final int id;
  final String name;

  OptionItem({required this.id, required this.name});

  factory OptionItem.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final idVal = (rawId is int) ? rawId : int.tryParse('$rawId') ?? 0;
    final nameVal =
        (json['name'] ?? json['nama'] ?? json['title'] ?? '').toString();
    return OptionItem(id: idVal, name: nameVal);
  }
}

/// Input alamat saat create customer
class AddressInput {
  final String provinsiCode;
  final String kotaKabCode;
  final String kecamatanCode;
  final String kelurahanCode;
  final String? kodePos;
  final String detailAlamat;

  AddressInput({
    required this.provinsiCode,
    required this.kotaKabCode,
    required this.kecamatanCode,
    required this.kelurahanCode,
    required this.detailAlamat,
    this.kodePos,
  });

  Map<String, dynamic> toMap() => {
        'provinsi': provinsiCode,
        'kota_kab': kotaKabCode,
        'kecamatan': kecamatanCode,
        'kelurahan': kelurahanCode,
        if (kodePos != null) 'kode_pos': kodePos,
        'detail_alamat': detailAlamat,
      };
}

class ApiService {
  static const String baseUrl = 'http://localhost/api'; // tetap localhost

  // ---------------- Helpers ----------------
  static Future<Map<String, String>> _authorizedHeaders(
      {bool jsonContent = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Accept': 'application/json',
      if (jsonContent) 'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static dynamic _decodeBody(http.Response res) => jsonDecode(res.body);

  /// Ekstrak list dari payload yang bisa berbentuk:
  /// - { data: { data: [...] } } (paginator)
  /// - { data: [...] }
  /// - [...]
  static List<Map<String, dynamic>> _extractList(dynamic decoded) {
    if (decoded is List) {
      return decoded
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    }
    if (decoded is Map) {
      // { data: { data: [...] } }
      final d = decoded['data'];
      if (d is Map && d['data'] is List) {
        final inner = d['data'] as List;
        return inner
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      }
      // { data: [...] }
      if (d is List) {
        return d
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      }
      // { items: [...] } (jaga2)
      final items = decoded['items'];
      if (items is List) {
        return items
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      }
    }
    return <Map<String, dynamic>>[];
  }

  static Map<String, dynamic>? _extractMap(dynamic decoded) {
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
    if (decoded is Map && decoded['data'] is Map) {
      return Map<String, dynamic>.from(decoded['data'] as Map);
    }
    return null;
  }

  static Uri _buildUri(String path, {Map<String, String>? query}) {
    final base = '$baseUrl/$path';
    if (query == null || query.isEmpty) return Uri.parse(base);
    return Uri.parse(base).replace(queryParameters: {...query});
  }

  // ---------------- LOGIN ----------------
  static Future<bool> login(String email, String password) async {
    try {
      final url = _buildUri('auth/login');
      final res = await http.post(
        url,
        headers: await _authorizedHeaders(jsonContent: true),
        body: jsonEncode({'email': email, 'password': password}),
      );
      final body = _decodeBody(res);

      if ((res.statusCode == 200 || res.statusCode == 201) &&
          body is Map &&
          body['success'] == true &&
          body['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', body['token']);
        return true;
      } else {
        // ignore: avoid_print
        print('Login gagal: ${res.statusCode} => ${res.body}');
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

  // ---------------- CUSTOMERS (GET) ----------------
  static Future<List<Customer>> fetchCustomers({int? perPage}) async {
    try {
      final headers = await _authorizedHeaders();
      final uri = _buildUri(
        'customers',
        query: {
          if (perPage != null) 'per_page': '$perPage',
        },
      );

      final res = await http.get(uri, headers: headers);

      if (res.statusCode != 200) {
        // ignore: avoid_print
        print('GET /customers error ${res.statusCode}: ${res.body}');
        throw Exception('Error ${res.statusCode}: ${res.body}');
      }

      final decoded = _decodeBody(res);
      final items = _extractList(decoded);

      return items.map(Customer.fromJson).toList();
    } catch (e) {
      // ignore: avoid_print
      print('fetchCustomers exception: $e');
      rethrow;
    }
  }

  // ---------------- Generic: fetch options (dengan filter) ----------------
  static Future<List<OptionItem>> _fetchOptions(
    String path, {
    Map<String, String>? query,
    bool onlyActive = false,
    bool onlyApproved = false,
  }) async {
    // kirim filter ke backend; kalau tidak didukung, nanti difilter client-side
    final q = {
      ...(query ?? {}),
      if (onlyActive) 'filter[status]': 'active',
      if (onlyApproved) 'filter[status_pengajuan]': 'approved',
    };

    final headers = await _authorizedHeaders();
    final uri = _buildUri(path, query: q);
    final res = await http.get(uri, headers: headers);

    if (res.statusCode != 200) {
      // ignore: avoid_print
      print('GET /$path error ${res.statusCode}: ${res.body}');
      return <OptionItem>[];
    }

    final decoded = _decodeBody(res);
    final list = _extractList(decoded);

    // fallback filter di client kalau backend nggak dukung filter di atas
    List<Map<String, dynamic>> filtered = list;
    if (onlyActive || onlyApproved) {
      filtered = list.where((m) {
        bool ok = true;

        if (onlyActive) {
          final raw =
              (m['status'] ?? m['status_akun'] ?? '').toString().toLowerCase();
          ok = ok && (raw.isEmpty || raw == 'active' || raw == 'aktif' || raw == '1');
        }

        if (onlyApproved) {
          final raw = (m['status_pengajuan'] ?? m['statusPengajuan'] ?? '')
              .toString()
              .toLowerCase();
          ok = ok && (raw.isEmpty || raw == 'approved' || raw == 'disetujui');
        }

        return ok;
      }).toList();
    }

    return filtered.map(OptionItem.fromJson).toList();
  }

  // ---- dropdown sources (sudah include filter) ----
  static Future<List<OptionItem>> fetchDepartments() =>
      _fetchOptions('departments',
          query: {'per_page': '1000'}, onlyActive: true);

  static Future<List<OptionItem>> fetchCustomerCategories() =>
      _fetchOptions('customer_categories',
          query: {'per_page': '1000'}, onlyActive: true);

  static Future<List<OptionItem>> fetchCustomerPrograms() =>
      _fetchOptions('customer_programs',
          query: {'per_page': '1000'}, onlyActive: true, onlyApproved: true);

  /// Ambil employees berdasarkan department.
  /// 1) Coba dari /departments/{id} (detail) -> cari key "employees"
  /// 2) Fallback ke /employees?department_id=...
  static Future<List<OptionItem>> fetchEmployees({int? departmentId}) async {
    final headers = await _authorizedHeaders();

    // 1) detail department jika ada id
    if (departmentId != null) {
      final detailUri = _buildUri('departments/$departmentId');
      final res = await http.get(detailUri, headers: headers);

      if (res.statusCode == 200) {
        final decoded = _decodeBody(res);

        Map<String, dynamic>? obj;
        if (decoded is Map && decoded['data'] is Map) {
          obj = Map<String, dynamic>.from(decoded['data'] as Map);
        } else if (decoded is Map) {
          obj = Map<String, dynamic>.from(decoded as Map);
        }

        List? rawEmployees;
        if (obj != null) {
          if (obj['employees'] is List) {
            rawEmployees = obj['employees'] as List;
          } else if (obj['data'] is Map &&
              (obj['data'] as Map)['employees'] is List) {
            rawEmployees = (obj['data'] as Map)['employees'] as List;
          }
        }

        if (rawEmployees != null) {
          final filtered = rawEmployees.whereType<Map>().where((e) {
            final s =
                (e['status'] ?? e['status_akun'] ?? '').toString().toLowerCase();
            return s.isEmpty || s == 'active' || s == 'aktif' || s == '1';
          }).toList();

          return filtered
              .map((e) => OptionItem(
                    id: (e['id'] is int)
                        ? e['id']
                        : int.tryParse('${e['id']}') ?? 0,
                    name: (e['name'] ?? '').toString(),
                  ))
              .toList();
        }
      }
    }

    // 2) fallback: /employees?department_id=...
    try {
      return _fetchOptions('employees', query: {
        if (departmentId != null) 'department_id': '$departmentId',
        'per_page': '1000',
      }, onlyActive: true);
    } catch (_) {
      // ignore: avoid_print
      print('Employees endpoint fallback gagal / tidak tersedia.');
      return <OptionItem>[];
    }
  }

  // ---------------- POSTAL CODE (opsional) ----------------
  /// Coba cari kode pos berdasarkan village_code.
  /// Endpoint disesuaikan dengan route backend. Kalau tidak ada, return null.
  static Future<String?> fetchPostalCodeByVillage(String villageCode) async {
    final headers = await _authorizedHeaders();
    final candidates = <Uri>[
      _buildUri('postal-codes', query: {'village_code': villageCode}),
      _buildUri('postal_codes', query: {'village_code': villageCode}),
    ];

    for (final uri in candidates) {
      final res = await http.get(uri, headers: headers);
      if (res.statusCode == 200) {
        final decoded = _decodeBody(res);
        final list = _extractList(decoded);
        if (list.isNotEmpty) {
          final item = list.first;
          final code =
              (item['postal_code'] ?? item['kode_pos'])?.toString().trim();
          if (code != null && code.isNotEmpty) return code;
        }
      }
    }
    return null;
  }

  // ---------------- CUSTOMERS (CREATE) ----------------
  static Future<bool> createCustomer({
    required int departmentId,
    required int employeeId,
    required String name,
    required String phone,
    String? email,
    required int customerCategoryId,
    int? customerProgramId,
    String? gmapsLink,
    required AddressInput address, // backend butuh array -> kita bungkus satu
  }) async {
    final url = _buildUri('customers/create');

    final payload = <String, dynamic>{
      'department_id': departmentId,
      'employee_id': employeeId,
      'name': name,
      'phone': phone,
      if (email != null && email.isNotEmpty) 'email': email,
      'customer_categories_id': customerCategoryId,
      if (customerProgramId != null) 'customer_program_id': customerProgramId,
      if (gmapsLink != null && gmapsLink.isNotEmpty) 'gmaps_link': gmapsLink,
      'address': [address.toMap()],
      // NOTE: upload image via multipart (terutama untuk mobile; web agak terbatas)
    };

    final res = await http.post(
      url,
      headers: await _authorizedHeaders(jsonContent: true),
      body: jsonEncode(payload),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return true;
    }

    // Log supaya gampang debug validasi backend
    // ignore: avoid_print
    print('POST /customers/create gagal: ${res.statusCode} => ${res.body}');
    return false;
  }
}
