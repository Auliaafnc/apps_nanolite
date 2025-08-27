// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

import '../models/customer.dart';
import '../models/order_row.dart';
import '../models/return_row.dart';
import '../models/garansi_row.dart';

/// Item sederhana utk dropdown
/// Item sederhana utk dropdown
class OptionItem {
  final int id;
  final String name;
  final int? categoryId;
  final String? phone;
  final String? address;
  final String? programName;   // ✅ Tambahan
  final int? programId;        // ✅ Tambahan

  OptionItem({
    required this.id,
    required this.name,
    this.categoryId,
    this.phone,
    this.address,
    this.programName,
    this.programId,
  });

  factory OptionItem.fromJson(Map<String, dynamic> json) {
  // --- id ---
  final idCandidates = [
    json['id'],
    json['customer_id'],
    json['category_id'],
    json['program_id'],
    json['value'],
  ];
  int idVal = 0;
  for (final c in idCandidates) {
    if (c is int) {
      idVal = c;
      break;
    }
    final parsed = int.tryParse('${c ?? ''}');
    if (parsed != null) {
      idVal = parsed;
      break;
    }
  }

  // --- name ---
  final nameCandidates = [
    json['name'],
    json['nama'],
    json['title'],
    json['label'],
    json['text'],
    json['customer_name'],
    '${json['name'] ?? ''} ${json['phone'] ?? ''}',
  ];
  String nameVal = '-';
  for (final c in nameCandidates) {
    final s = (c ?? '').toString();
    if (s.trim().isNotEmpty) {
      nameVal = s;
      break;
    }
  }

  // --- address ✅ pakai parser readable ---
  // --- address ✅ pakai parser readable ---
String addressText = '-';
if (json['address'] is List && (json['address'] as List).isNotEmpty) {
  final addr = json['address'][0];
  if (addr is Map) {
    final detail = addr['detail_alamat']?.toString() ?? '';
    final kel = addr['kelurahan']?['name']?.toString() ?? '';
    final kec = addr['kecamatan']?['name']?.toString() ?? '';
    final kota = addr['kota_kab']?['name']?.toString() ?? '';
    final prov = addr['provinsi']?['name']?.toString() ?? '';
    final kodePos = addr['kode_pos']?.toString() ?? '';

    final parts = [detail, kel, kec, kota, prov, kodePos]
        .where((e) => e.trim().isNotEmpty && e.toLowerCase() != 'null')
        .toList();

    addressText = parts.isEmpty ? '-' : parts.join(', ');
  }
} else if (json['alamat_detail'] != null) {
  addressText = json['alamat_detail'].toString();
} else if (json['address'] is String) {
  addressText = json['address'];
}

return OptionItem(
  id: idVal,
  name: nameVal,
  categoryId: ApiService._extractCategoryId(json),
  phone: json['phone']?.toString(),
  address: addressText,  // ✅ selalu string sekarang
  programName: json['customer_program']?['name'],
  programId: json['customer_program']?['id'],
);
}
}


/// Input alamat sesuai repeater di CustomerResource
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
        'provinsi_code': provinsiCode,
        'kota_kab_code': kotaKabCode,
        'kecamatan_code': kecamatanCode,
        'kelurahan_code': kelurahanCode,
        if (kodePos != null) 'kode_pos': kodePos,
        'detail_alamat': detailAlamat,
      };
}

class ApiService {
  static const String baseUrl = 'http://localhost/api'; // jangan diubah

  static int? _extractCategoryId(Map<String, dynamic> json) {
  if (json['customer_category'] is Map) {
    return int.tryParse('${json['customer_category']['id']}');
  }
  return int.tryParse(
    '${json['customer_categories_id'] ?? json['customer_category_id'] ?? ''}',
  );
}


  static String formatAddress(dynamic json) {
  // cek alamat_detail
  if (json is Map && json['alamat_detail'] is List && (json['alamat_detail'] as List).isNotEmpty) {
    final addr = json['alamat_detail'][0];
    if (addr is Map) {
      final detail  = addr['detail_alamat']?.toString() ?? '';
      final kel     = addr['kelurahan']?['name']?.toString() ?? '';
      final kec     = addr['kecamatan']?['name']?.toString() ?? '';
      final kota    = addr['kota_kab']?['name']?.toString() ?? '';
      final prov    = addr['provinsi']?['name']?.toString() ?? '';
      final kodePos = addr['kode_pos']?.toString() ?? '';

      final parts = [detail, kel, kec, kota, prov, kodePos]
          .where((e) => e.trim().isNotEmpty && e.toLowerCase() != 'null')
          .toList();

      return parts.isEmpty ? '-' : parts.join(', ');
    }
  }

  // fallback cek langsung "address"
  if (json is List && json.isNotEmpty) {
    final addr = json[0];
    if (addr is Map) {
      final detail  = addr['detail_alamat']?.toString() ?? '';
      final kel     = addr['kelurahan']?['name']?.toString() ?? '';
      final kec     = addr['kecamatan']?['name']?.toString() ?? '';
      final kota    = addr['kota_kab']?['name']?.toString() ?? '';
      final prov    = addr['provinsi']?['name']?.toString() ?? '';
      final kodePos = addr['kode_pos']?.toString() ?? '';

      final parts = [detail, kel, kec, kota, prov, kodePos]
          .where((e) => e.trim().isNotEmpty && e.toLowerCase() != 'null')
          .toList();

      return parts.isEmpty ? '-' : parts.join(', ');
    }
  }

  if (json is String && json.trim().isNotEmpty) {
    return json;
  }

  return '-';
}


  // ====================== PARSER KHUSUS CUSTOMER ======================
   static OptionItem _parseCustomer(Map<String, dynamic> json) {
  final id = int.tryParse('${json['id'] ?? json['customer_id']}') ?? 0;

  // Ambil nama
  final nameCandidates = [
    json['name'],
    json['nama'],
    json['customer_name'],
    '${json['name'] ?? ''} ${json['phone'] ?? ''}',
  ];
  String nameVal = '-';
  for (final c in nameCandidates) {
    final s = (c ?? '').toString();
    if (s.trim().isNotEmpty) {
      nameVal = s;
      break;
    }
  }

  // ✅ perbaiki ambil kategori id
  int? catId;
  if (json['customer_category'] is Map) {
    catId = int.tryParse('${json['customer_category']['id']}');
  } else {
    catId = int.tryParse(
      '${json['customer_categories_id'] ?? json['customer_category_id'] ?? ''}',
    );
  }



  


  return OptionItem(
    id: id,
    name: nameVal,
    phone: json['phone']?.toString(),
    categoryId: ApiService._extractCategoryId(json),
    // ✅ panggil helper
    address: ApiService.formatAddress(json),

  );
}




  // ---------- helpers ----------
  static Future<Map<String, String>> _authorizedHeaders({bool jsonContent = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Accept': 'application/json',
      if (jsonContent) 'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static dynamic _safeDecode(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }

  static Uri _buildUri(String path, {Map<String, String>? query}) {
    final normalizedBase = baseUrl.replaceAll(RegExp(r'/+$'), '');
    final normalizedPath = path.replaceAll(RegExp(r'^/+'), '');
    final raw = '$normalizedBase/$normalizedPath';
    return (query == null || query.isEmpty)
        ? Uri.parse(raw)
        : Uri.parse(raw).replace(queryParameters: {...query});
  }

  static List<Map<String, dynamic>> _extractList(dynamic decoded) {
  if (decoded is List) {
    return decoded.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }
  if (decoded is Map) {
    final d = decoded['data'];

    if (d is List) {
      return d.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    }

    if (d is Map && d['data'] is List) {
      return (d['data'] as List)
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    final items = decoded['items'];
    if (items is List) {
      return items.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    }

    // ✅ tambahan untuk case {"customers": [...]}
    final cust = decoded['customers'];
    if (cust is List) {
      return cust.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    }
  }
  return <Map<String, dynamic>>[];
}



  // ---------- AUTH ----------
  static Future<bool> login(String email, String password) async {
    try {
      final url = _buildUri('auth/login');
      final res = await http.post(
        url,
        headers: await _authorizedHeaders(jsonContent: true),
        body: jsonEncode({'email': email, 'password': password}),
      );
      final body = _safeDecode(res.body);
      if ((res.statusCode == 200 || res.statusCode == 201) &&
          body is Map &&
          body['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', body['token']);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // ---------- DROPDOWN ----------
  Future<List<OptionItem>> _fetchOptionsTryPaths(
    List<String> paths, {
    Map<String, String>? query,
    bool filterActive = true,
  }) async {
    final headers = await _authorizedHeaders();
    for (final p in paths) {
      final uri = _buildUri(p, query: {'per_page': '1000', ...(query ?? const {})});
      try {
        final res = await http.get(uri, headers: headers);
        if (res.statusCode != 200) continue;

        final decoded = _safeDecode(res.body);
        var list = _extractList(decoded);
        if (list.isEmpty) continue;

        if (filterActive) {
          list = list.where((m) {
            final status = (m['status'] ?? '').toString().toLowerCase().trim();
            final pengajuan = (m['status_pengajuan'] ?? '').toString().toLowerCase().trim();
            final okStatus = status.isEmpty || status == 'active' || status == 'aktif' || status == '1' || status == 'true';
            final okApproved = pengajuan.isEmpty || pengajuan == 'disetujui' || pengajuan == 'approved' || pengajuan == '1' || pengajuan == 'true';
            return okStatus && okApproved;
          }).toList();
        }

        final options = list.map(OptionItem.fromJson).where((o) => o.id != 0 && o.name.isNotEmpty).toList();
        if (options.isNotEmpty) return options;
      } catch (_) {}
    }
    return <OptionItem>[];
  }

  // Departments
static Future<List<OptionItem>> fetchDepartments() =>
    ApiService()._fetchOptionsTryPaths(['departments']);

static Future<List<OptionItem>> fetchEmployees({required int departmentId}) async {
  return ApiService()._fetchOptionsTryPaths(
    ['customers'],
    query: {
      'type': 'employees',
      'department_id': '$departmentId',
    },
    filterActive: false,
  );
}


  /// Customer Categories
static Future<List<OptionItem>> fetchCustomerCategories() =>
    ApiService()._fetchOptionsTryPaths(['customer-categories'], filterActive: true);

// Customer Programs
static Future<List<OptionItem>> fetchCustomerPrograms() =>
    ApiService()._fetchOptionsTryPaths(['customer-programs'], filterActive: true);

// Customer Programs by Category
static Future<List<OptionItem>> fetchCustomerProgramsByCategory(int categoryId) async {
  return ApiService()._fetchOptionsTryPaths(
    ['customer-programs'],
    query: {'customer_category_id': '$categoryId'},
    filterActive: true,
  );
}

static Future<List<OptionItem>> fetchCustomersByCategory(int categoryId) async {
  final headers = await _authorizedHeaders();
  final uri = _buildUri('customers', query: {'per_page': '1000'});
  final res = await http.get(uri, headers: headers);
  if (res.statusCode != 200) {
    print("DEBUG fetchCustomersByCategory failed: ${res.statusCode} ${res.body}");
    return [];
  }

  final decoded = _safeDecode(res.body);
  print("DEBUG raw customers response: $decoded"); // 🔥 Debug isi API
  final list = _extractList(decoded);

  // ✅ langsung parse ke OptionItem tanpa filter status dulu
  final customers = list.map<OptionItem>((m) => _parseCustomer(m)).toList();

  print("DEBUG all parsed customers: $customers");
  print("DEBUG filter by catId: $categoryId");

  // ✅ filter kategori customer
  return customers.where((c) => c.categoryId == categoryId).toList();
}


static Future<List<OptionItem>> fetchCustomersFiltered({
  required int departmentId,
  required int employeeId,
  required int categoryId,
}) async {
  final headers = await _authorizedHeaders();
  final uri = _buildUri('customers', query: {'per_page': '1000'});
  final res = await http.get(uri, headers: headers);
  if (res.statusCode != 200) return [];

  final decoded = _safeDecode(res.body);
  final list = _extractList(decoded);

  // parse jadi OptionItem
  final customers = list.map<OptionItem>((m) => _parseCustomer(m)).toList();

  // ✅ filter langsung dari OptionItem
  return customers.where((c) {
    final deptOk = c.categoryId != null && c.categoryId == categoryId; // kalau kategori cocok
    final empOk  = true; // nanti tambahkan employee_id di OptionItem kalau perlu
    return deptOk && empOk;
  }).toList();
}





/// Ambil semua customer aktif + approved (tanpa filter kategori)
  static Future<List<OptionItem>> fetchCustomersDropdown() async {
    final headers = await _authorizedHeaders();
    final uri = _buildUri('customers', query: {'per_page': '1000'});
    final res = await http.get(uri, headers: headers);
    if (res.statusCode != 200) return [];

    final decoded = _safeDecode(res.body);
    final list = _extractList(decoded);

    final customers = list.where((m) {
      final status = (m['status'] ?? '').toString().toLowerCase();
      final pengajuan = (m['status_pengajuan'] ?? '').toString().toLowerCase();
      return (status == 'active' || status == 'aktif' || status == '1' || status == 'true') &&
             (pengajuan == 'disetujui' || pengajuan == 'approved' || pengajuan == '1' || pengajuan == 'true');
    }).map<OptionItem>((m) => _parseCustomer(m)).toList();

    return customers;
  }


// Categories
static Future<List<OptionItem>> fetchProductCategories() =>
    ApiService()._fetchOptionsTryPaths(['categories'], filterActive: true);

// Brands
static Future<List<OptionItem>> fetchBrands() =>
    ApiService()._fetchOptionsTryPaths(['brands'], filterActive: true);

// Products
static Future<List<OptionItem>> fetchProducts() =>
    ApiService()._fetchOptionsTryPaths(['products'], filterActive: true);

// Colors (dummy, karena tidak ada endpoint di backend)
static Future<List<OptionItem>> fetchColors() async => <OptionItem>[];


  static Future<List<OptionItem>> fetchProvinces() =>
      ApiService()._fetchOptionsTryPaths(['customers'], query: {'type': 'provinces'}, filterActive: false);
  static Future<List<OptionItem>> fetchCities(String provinceCode) =>
      ApiService()._fetchOptionsTryPaths(['customers'], query: {'type': 'cities', 'province_code': provinceCode}, filterActive: false);
  static Future<List<OptionItem>> fetchDistricts(String cityCode) =>
      ApiService()._fetchOptionsTryPaths(['customers'], query: {'type': 'districts', 'city_code': cityCode}, filterActive: false);
  static Future<List<OptionItem>> fetchVillages(String districtCode) =>
      ApiService()._fetchOptionsTryPaths(['customers'], query: {'type': 'villages', 'district_code': districtCode}, filterActive: false);

  static Future<String?> fetchPostalCodeByVillage(String villageCode) async {
    final headers = await _authorizedHeaders();
    final uri = _buildUri('customers', query: {'type': 'postal_code', 'village_code': villageCode});
    try {
      final res = await http.get(uri, headers: headers);
      if (res.statusCode == 200) {
        final decoded = _safeDecode(res.body);
        if (decoded is Map && decoded['postal_code'] != null) {
          return decoded['postal_code'].toString();
        }
      }
    } catch (_) {}
    return null;
  }

  // ---------- CUSTOMERS ----------
    // ---------- CUSTOMERS ----------
  static Future<bool> createCustomer({
    required int companyId,
    required int departmentId,
    required int employeeId,
    required String name,
    required String phone,
    String? email,
    required int customerCategoryId,
    int? customerProgramId,
    String? gmapsLink,
    required AddressInput address,
    List<XFile>? photos, // multi foto
  }) async {
    final url = _buildUri('customers');
    final headers = await _authorizedHeaders();

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);

    // field biasa
    request.fields['company_id'] = companyId.toString();
    request.fields['department_id'] = departmentId.toString();
    request.fields['employee_id'] = employeeId.toString();
    request.fields['name'] = name;
    request.fields['phone'] = phone;
    if (email != null && email.isNotEmpty) request.fields['email'] = email;
    request.fields['customer_categories_id'] = customerCategoryId.toString();
    if (customerProgramId != null) {
      request.fields['customer_program_id'] = customerProgramId.toString();
    }
    if (gmapsLink != null && gmapsLink.isNotEmpty) {
      request.fields['gmaps_link'] = gmapsLink;
    }

    // address
    request.fields['address[0][provinsi_code]'] = address.provinsiCode;
    request.fields['address[0][kota_kab_code]'] = address.kotaKabCode;
    request.fields['address[0][kecamatan_code]'] = address.kecamatanCode;
    request.fields['address[0][kelurahan_code]'] = address.kelurahanCode;
    if (address.kodePos != null) {
      request.fields['address[0][kode_pos]'] = address.kodePos!;
    }
    request.fields['address[0][detail_alamat]'] = address.detailAlamat;

    // upload multi foto
    if (photos != null && photos.isNotEmpty) {
      for (final photo in photos) {
        if (kIsWeb) {
          final bytes = await photo.readAsBytes();
          request.files.add(
            http.MultipartFile.fromBytes('image[]', bytes, filename: photo.name),
          );
        } else {
          request.files.add(
            await http.MultipartFile.fromPath('image[]', photo.path),
          );
        }
      }
    }

    final streamedResponse = await request.send();
    final res = await http.Response.fromStream(streamedResponse);

    print('DEBUG createCustomer => ${res.statusCode} ${res.body}');

    return res.statusCode == 200 || res.statusCode == 201;
  }

  

  static Future<List<Customer>> fetchCustomers({int page = 1, int perPage = 20, String? q}) async {
    final headers = await _authorizedHeaders();
    final params = <String, String>{
      'page': '$page',
      'per_page': '$perPage',
      if (q != null && q.isNotEmpty) 'filter[search]': q,
    };
    final uri = _buildUri('customers', query: params);
    final res = await http.get(uri, headers: headers);
    if (res.statusCode != 200) {
      throw Exception('GET /customers ${res.statusCode}: ${res.body}');
    }
    final items = _extractList(_safeDecode(res.body));
    return items.map(Customer.fromJson).toList();
  }

  // ---------- SALES ORDERS ----------
  // ---------- SALES ORDERS ----------
// CREATE ORDER
static Future<bool> createOrder({
  required int companyId,
  required int departmentId,
  required int employeeId,
  required int customerId,
  required int categoryId,
  int? programId,
  required String phone,
  required String addressText, // konsisten sama createReturn
  bool programEnabled = false,
  bool rewardEnabled = false,
  String? rewardPoint,
  double diskon1 = 0,
  double diskon2 = 0,
  String? penjelasanDiskon1,
  String? penjelasanDiskon2,
  bool diskonsEnabled = false,
  required List<Map<String, dynamic>> products,
  String paymentMethod = "tempo",
  String statusPembayaran = "belum bayar",
  String status = "pending",
  List<XFile>? files, // kalau ada lampiran kayak return
}) async {
  final url = _buildUri('orders');
  final headers = await _authorizedHeaders();

  var request = http.MultipartRequest('POST', url);
  request.headers.addAll(headers);

  // ===== Field utama =====
  request.fields['company_id'] = companyId.toString();
  request.fields['department_id'] = departmentId.toString();
  request.fields['employee_id'] = employeeId.toString();
  request.fields['customer_id'] = customerId.toString();
  request.fields['customer_categories_id'] = categoryId.toString();
  if (programId != null) {
    request.fields['customer_program_id'] = programId.toString();
  }
  request.fields['phone'] = phone;
  request.fields['address'] = addressText;
  request.fields['program_enabled'] = programEnabled ? '1' : '0';
  request.fields['reward_enabled'] = rewardEnabled ? '1' : '0';
  if (rewardPoint != null) request.fields['reward_point'] = rewardPoint;
  request.fields['diskon_1'] = diskon1.toString();
  request.fields['diskon_2'] = diskon2.toString();
  request.fields['diskons_enabled'] = diskonsEnabled ? '1' : '0';
  if (penjelasanDiskon1 != null) request.fields['penjelasan_diskon_1'] = penjelasanDiskon1;
  if (penjelasanDiskon2 != null) request.fields['penjelasan_diskon_2'] = penjelasanDiskon2;
  request.fields['payment_method'] = paymentMethod;
  request.fields['status_pembayaran'] = statusPembayaran;
  request.fields['status'] = status;

  // ===== Produk list =====
  for (int i = 0; i < products.length; i++) {
    final p = products[i];
    request.fields['products[$i][brand]'] = (p['brand'] ?? '').toString();
    request.fields['products[$i][category]'] = (p['category'] ?? '').toString();
    request.fields['products[$i][product]'] = (p['product'] ?? '').toString();
    request.fields['products[$i][color]'] = (p['color'] ?? '').toString();
    request.fields['products[$i][quantity]'] = (p['quantity'] ?? 0).toString();
    if (p['price'] != null) {
      request.fields['products[$i][price]'] = p['price'].toString();
    }
  }

  // ===== Upload file (optional) =====
  if (files != null && files.isNotEmpty) {
    for (final file in files) {
      if (kIsWeb) {
        final bytes = await file.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'files[]', bytes, filename: file.name,
        ));
      } else {
        request.files.add(await http.MultipartFile.fromPath('files[]', file.path));
      }
    }
  }

  final streamed = await request.send();
  final res = await http.Response.fromStream(streamed);

  print("DEBUG createOrder => ${res.statusCode} ${res.body}");

  return res.statusCode == 200 || res.statusCode == 201;
}

// FETCH ALL ORDER
static Future<List<OrderRow>> fetchOrderRows({
  int page = 1,
  int perPage = 20,
  String? q,
  String? status,
}) async {
  final headers = await _authorizedHeaders();
  final paths = ['orders', 'sales-orders', 'sales_orders'];
  for (final p in paths) {
    final params = <String, String>{
      'page': '$page',
      'per_page': '$perPage',
      if (q != null && q.isNotEmpty) 'filter[search]': q,
      if (status != null && status.isNotEmpty) 'filter[status]': status,
    };
    final uri = _buildUri(p, query: params);
    final res = await http.get(uri, headers: headers);
    if (res.statusCode != 200) continue;
    final items = _extractList(_safeDecode(res.body));
    if (items.isEmpty) continue;

    return items.map((raw) {
      final map = Map<String, dynamic>.from(raw);
      map['file_pdf_url'] = _absoluteUrl(
        (map['file_pdf_url'] ??
         map['invoice_pdf_url'] ??
         map['order_file'] ??
         map['pdf_url'] ??
         map['document_url'] ??
         '').toString(),
      );
      return OrderRow.fromJson(map);
    }).toList();
  }
  return <OrderRow>[];
}

// FETCH DETAIL ORDER
static Future<OrderRow> fetchOrderRowDetail(int id) async {
  final headers = await _authorizedHeaders();
  final paths = ['orders/$id', 'sales-orders/$id', 'sales_orders/$id'];
  for (final p in paths) {
    final uri = _buildUri(p);
    final res = await http.get(uri, headers: headers);
    if (res.statusCode != 200) continue;
    final decoded = _safeDecode(res.body);
    final data = (decoded is Map) ? (decoded['data'] ?? decoded) : decoded;
    final map = Map<String, dynamic>.from(data as Map);
    map['file_pdf_url'] = _absoluteUrl(
      (map['file_pdf_url'] ??
       map['invoice_pdf_url'] ??
       map['order_file'] ??
       map['pdf_url'] ??
       map['document_url'] ??
       '').toString(),
    );
    return OrderRow.fromJson(map);
  }
  throw Exception('GET /orders/$id not found');
}


static Future<bool> createReturn({
  required int companyId,
  required int departmentId,
  required int employeeId,
  required int customerId,
  required int categoryId,
  required String phone,
  required AddressInput address,
  required int amount,
  required String reason,
  String? note,
  required List<Map<String, dynamic>> products,
  List<XFile>? photos,
}) async {
  final uri = Uri.parse('$baseUrl/product-returns');
  final req = http.MultipartRequest('POST', uri);

  req.fields['company_id'] = companyId.toString();
  req.fields['department_id'] = departmentId.toString();
  req.fields['employee_id'] = employeeId.toString();
  req.fields['customer_id'] = customerId.toString();
  req.fields['customer_categories_id'] = categoryId.toString();
  req.fields['phone'] = phone;
  req.fields['address'] = jsonEncode(address.toMap());
  req.fields['amount'] = amount.toString();
  req.fields['reason'] = reason;
  if (note != null) req.fields['note'] = note;
  req.fields['products'] = jsonEncode(products); // <== JSON array produk

  if (photos != null && photos.isNotEmpty) {
  for (final p in photos) {
    if (kIsWeb) {
      final bytes = await p.readAsBytes();
      req.files.add(http.MultipartFile.fromBytes(
        'photos[]',
        bytes,
        filename: p.name,
      ));
    } else {
      req.files.add(await http.MultipartFile.fromPath('photos[]', p.path));
    }
  }
}

  final res = await req.send();
  return res.statusCode == 200;
}

static Future<List<OptionItem>> fetchColorsByProduct(int productId) async {
  final headers = await _authorizedHeaders();
  final uri = _buildUri('products/$productId');
  final res = await http.get(uri, headers: headers);
  if (res.statusCode != 200) return [];

  final decoded = _safeDecode(res.body);
  Map<String, dynamic> data;
  if (decoded is Map && decoded['data'] != null) {
    data = Map<String, dynamic>.from(decoded['data']);
  } else {
    data = Map<String, dynamic>.from(decoded);
  }

  final colors = data['colors'];
  if (colors is List) {
    return colors.map<OptionItem>((c) {
      return OptionItem(
        id: int.tryParse('${c['id'] ?? 0}') ?? 0,
        name: c['name']?.toString() ?? '-',
      );
    }).toList();
  }
  return [];
}


static Future<List<ReturnRow>> fetchReturnRows({int page = 1, int perPage = 20, String? q, String? status}) async {
  final headers = await _authorizedHeaders();
  final paths = ['product-returns', 'product_returns', 'returns'];
  for (final p in paths) {
    final params = <String, String>{
      'page': '$page',
      'per_page': '$perPage',
      if (q != null && q.isNotEmpty) 'filter[search]': q,
      if (status != null && status.isNotEmpty) 'filter[status]': status,
    };
    final uri = _buildUri(p, query: params);
    final res = await http.get(uri, headers: headers);
    if (res.statusCode != 200) continue;
    final items = _extractList(_safeDecode(res.body));
    if (items.isEmpty) continue;
    return items.map((raw) {
      final map = Map<String, dynamic>.from(raw);
      map['file_pdf_url'] = _absoluteUrl((map['file_pdf_url'] ?? map['pdf_url'] ?? map['document_url'] ?? map['invoice_pdf_url'] ?? '').toString());
      map['image'] = _absoluteUrl((map['image'] ?? map['image_url'] ?? '').toString());
      return ReturnRow.fromJson(map);
    }).toList();
  }
  return <ReturnRow>[];
}

static Future<ReturnRow> fetchReturnRowDetail(int id) async {
  final headers = await _authorizedHeaders();
  final paths = ['product-returns/$id', 'product_returns/$id', 'returns/$id'];
  for (final p in paths) {
    final uri = _buildUri(p);
    final res = await http.get(uri, headers: headers);
    if (res.statusCode != 200) continue;
    final decoded = _safeDecode(res.body);
    final data = (decoded is Map) ? (decoded['data'] ?? decoded) : decoded;
    final map = Map<String, dynamic>.from(data as Map);
    map['file_pdf_url'] = _absoluteUrl((map['file_pdf_url'] ?? map['pdf_url'] ?? map['document_url'] ?? map['invoice_pdf_url'] ?? '').toString());
    map['image'] = _absoluteUrl((map['image'] ?? map['image_url'] ?? '').toString());
    return ReturnRow.fromJson(map);
  }
  throw Exception('GET /product-returns/$id not found');
}


  // ---------- WARRANTIES ----------
  static Future<List<GaransiRow>> fetchWarrantyRows({int page = 1, int perPage = 20, String? q, String? status}) async {
    final headers = await _authorizedHeaders();
    final paths = ['garansis', 'warranties', 'garansi', 'warranty-claims', 'warranty_claims'];
    for (final p in paths) {
      final params = <String, String>{
        'page': '$page',
        'per_page': '$perPage',
        if (q != null && q.isNotEmpty) 'filter[search]': q,
        if (status != null && status.isNotEmpty) 'filter[status]': status,
      };
      final uri = _buildUri(p, query: params);
      final res = await http.get(uri, headers: headers);
      if (res.statusCode != 200) continue;
      final items = _extractList(_safeDecode(res.body));
      if (items.isEmpty) continue;
      return items.map((raw) {
        final map = Map<String, dynamic>.from(raw);
        map['file_pdf_url'] = _absoluteUrl((map['file_pdf_url'] ?? map['pdf_url'] ?? map['document_url'] ?? map['invoice_pdf_url'] ?? '').toString());
        map['image'] = _absoluteUrl((map['image'] ?? map['image_url'] ?? '').toString());
        return GaransiRow.fromJson(map);
      }).toList();
    }
    return <GaransiRow>[];
  }

  static Future<GaransiRow> fetchWarrantyRowDetail(int id) async {
    final headers = await _authorizedHeaders();
    final paths = ['garansis/$id', 'warranties/$id', 'garansi/$id', 'warranty-claims/$id', 'warranty_claims/$id'];
    for (final p in paths) {
      final uri = _buildUri(p);
      final res = await http.get(uri, headers: headers);
      if (res.statusCode != 200) continue;
      final decoded = _safeDecode(res.body);
      final data = (decoded is Map) ? (decoded['data'] ?? decoded) : decoded;
      final map = Map<String, dynamic>.from(data as Map);
      map['file_pdf_url'] = _absoluteUrl((map['file_pdf_url'] ?? map['pdf_url'] ?? map['document_url'] ?? map['invoice_pdf_url'] ?? '').toString());
      map['image'] = _absoluteUrl((map['image'] ?? map['image_url'] ?? '').toString());
      return GaransiRow.fromJson(map);
    }
    throw Exception('GET /garansis/$id not found');
  }

  // ---------- Utility ----------
  static String get _origin {
    final u = Uri.parse(baseUrl);
    final port = u.hasPort ? ':${u.port}' : '';
    return '${u.scheme}://${u.host}$port';
  }

  static String _absoluteUrl(String? maybe) {
    if (maybe == null || maybe.isEmpty) return '';
    if (maybe.startsWith('http://') || maybe.startsWith('https://')) return maybe;
    final path = maybe.startsWith('/') ? maybe : '/$maybe';
    return '$_origin$path';
  }
}
