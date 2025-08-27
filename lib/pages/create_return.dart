// lib/pages/create_return.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

import '../services/api_service.dart';
import '../models/customer.dart';

class CreateReturnScreen extends StatefulWidget {
  const CreateReturnScreen({super.key});

  @override
  State<CreateReturnScreen> createState() => _CreateReturnScreenState();
}

class _CreateReturnScreenState extends State<CreateReturnScreen> {
  // ====== Controllers ======
  final _phoneCtrl = TextEditingController();
  final _addrCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  // ====== State ======
  List<OptionItem> _departments = [];
  List<OptionItem> _employees = [];
  List<OptionItem> _categories = [];
  List<Customer> _customers = [];
  List<OptionItem> _products = [];
List<OptionItem> _colors = [];
List<OptionItem> _brands = [];
List<OptionItem> _productCategories = [];




  int? _deptId;
  int? _empId;
  int? _catId;
  int? _custId;

  Customer? _selectedCustomer;

  bool _loadingOptions = false;
  bool _loadingEmployees = false;
  bool _loadingCustomers = false;
  bool _submitting = false;

  // Produk list
  final _items = <_ProductItem>[ _ProductItem() ];

  // Foto
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _photos = [];

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _addrCtrl.dispose();
    _amountCtrl.dispose();
    _reasonCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  // ====== LOAD OPTIONS ======
  Future<void> _loadOptions() async {
  setState(() => _loadingOptions = true);
  try {
    final depts = await ApiService.fetchDepartments();
    final cats  = await ApiService.fetchCustomerCategories();
    final prods = await ApiService.fetchProducts(); // tambahkan
    final cols  = await ApiService.fetchColors();   // tambahkan
    final brands = await ApiService.fetchBrands();
final categories = await ApiService.fetchProductCategories();


    if (!mounted) return;
    setState(() {
      _departments = depts;
      _categories  = cats;
      _products    = prods;
      _colors      = cols;
      _brands = brands;
_productCategories = categories;

    });
  } finally {
    if (mounted) setState(() => _loadingOptions = false);
  }
}


  Future<void> _onSelectDepartment(int? id) async {
    setState(() {
      _deptId = id;
      _empId = null;
      _employees = [];
      _loadingEmployees = true;
    });

    if (id == null) return;

    final emps = await ApiService.fetchEmployees(departmentId: id);
    if (!mounted) return;
    setState(() {
      _employees = emps;
      _loadingEmployees = false;
    });
  }

  Future<void> _onSelectEmployee(int? id) async {
    setState(() {
      _empId = id;
      _custId = null;
      _customers = [];
      _loadingCustomers = true;
    });

    if (id == null) {
      setState(() => _loadingCustomers = false);
      return;
    }

    try {
      final all = await ApiService.fetchCustomers(perPage: 500);
      if (!mounted) return;
      setState(() {
        _customers = all.where((c) => c.employeeId == id).toList();
        _loadingCustomers = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loadingCustomers = false);
    }
  }

  void _onSelectCustomer(Customer cust) {
    setState(() {
      _custId = cust.id;
      _selectedCustomer = cust;
      _phoneCtrl.text = cust.phone;
      _addrCtrl.text = cust.alamatDisplay;
    });
  }

  // ====== Foto ======
  Future<void> _pickFromGallery() async {
    final files = await _picker.pickMultiImage(imageQuality: 85);
    if (files.isNotEmpty) setState(() => _photos.addAll(files));
  }

  Future<void> _pickFromCamera() async {
    final file = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (file != null) setState(() => _photos.add(file));
  }

  void _removePhoto(int i) => setState(() => _photos.removeAt(i));

  void _addProduk() => setState(() => _items.add(_ProductItem()));
  void _removeProduk(int i) => setState(() => _items.removeAt(i));

  // ====== Submit ======
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (_deptId == null || _empId == null || _catId == null || _custId == null ||
        _phoneCtrl.text.isEmpty || _addrCtrl.text.isEmpty ||
        _amountCtrl.text.isEmpty || _reasonCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi field yang wajib *')),
      );
      return;
    }

    setState(() => _submitting = true);

    try {
      final ok = await ApiService.createReturn(
  companyId: 1, // contoh, ambil dari user login / fixed
  departmentId: _deptId!,
  employeeId: _empId!,
  customerId: _custId!,
  categoryId: _catId!,  // <-- ini akan masuk ke customer_categories_id
  phone: _phoneCtrl.text.trim(),
  address: AddressInput(
    provinsiCode: "",
    kotaKabCode: "",
    kecamatanCode: "",
    kelurahanCode: "",
    kodePos: "",
    detailAlamat: _addrCtrl.text.trim(),
  ),
  amount: int.tryParse(_amountCtrl.text.trim()) ?? 0,
  reason: _reasonCtrl.text.trim(),
  note: _noteCtrl.text.trim(),
  products: _items.map((e) => e.toMap()).toList(),
  photos: _photos,
);

      if (!mounted) return;
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Return berhasil dibuat'), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal membuat return'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  // ====== UI ======
  @override
  Widget build(BuildContext context) {
    final disabledAll = _loadingOptions || _submitting;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Return'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: const Color(0xFF0A1B2D),
      body: _loadingOptions
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isTablet = constraints.maxWidth >= 600;
              final fieldWidth = isTablet
                  ? (constraints.maxWidth - 60) / 2
                  : (constraints.maxWidth - 20) / 2;

              return AbsorbPointer(
                absorbing: disabledAll,
                child: Opacity(
                  opacity: disabledAll ? 0.6 : 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Data Return',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),

                      Wrap(
                        spacing: 20,
                        runSpacing: 16,
                        children: [
                          _dropdownInt('Departemen *',
                              width: fieldWidth,
                              value: _deptId,
                              items: _departments,
                              onChanged: (v) => _onSelectDepartment(v)),
                          _dropdownInt('Karyawan *',
                              width: fieldWidth,
                              value: _empId,
                              items: _employees,
                              onChanged: (v) => _onSelectEmployee(v),
                              loading: _loadingEmployees),
                          _dropdownInt('Kategori Customer *',
                              width: fieldWidth,
                              value: _catId,
                              items: _categories,
                              onChanged: (v) => setState(() => _catId = v)),
                          _dropdownCustomer('Customer *',
                              width: fieldWidth,
                              value: _custId,
                              items: _customers,
                              onChanged: (cust) => _onSelectCustomer(cust),
                              loading: _loadingCustomers),
                          _textField('Phone *', _phoneCtrl, fieldWidth),
                          _textField('Address', _addrCtrl, fieldWidth, maxLines: 2),
                          _textField('Nominal *', _amountCtrl, fieldWidth,
                              keyboard: TextInputType.number, prefix: 'Rp '),
                          _textField('Alasan Return *', _reasonCtrl, fieldWidth, maxLines: 2),
                          _textField('Catatan Tambahan', _noteCtrl, fieldWidth, maxLines: 2, hint: 'Opsional'),
                        ],
                      ),

                      const SizedBox(height: 30),
                      const Text('Gambar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      _buildPhotos(),

                      const SizedBox(height: 30),
                      const Text('Detail Produk', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),

                      Column(children: List.generate(_items.length, (i) => _productCard(i))),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: _addProduk,
                          icon: const Icon(Icons.add),
                          label: const Text('Tambah Produk'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        ),
                      ),

                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _formButton('Cancel', Colors.grey, () {
                            Navigator.pop(context, false);
                          }),
                          const SizedBox(width: 12),
                          _formButton('Create', Colors.blue, _submitting ? null : _submit,
                              showSpinner: _submitting),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ====== Helpers UI (sama gaya Customer) ======
  Widget _textField(String label, TextEditingController c, double width,
      {int maxLines = 1, TextInputType? keyboard, String? hint, String? prefix}) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 6),
          TextFormField(
            controller: c,
            maxLines: maxLines,
            keyboardType: keyboard,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              prefixText: prefix,
              filled: true,
              fillColor: const Color(0xFF22344C),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

 Widget _dropdownInt(String label,
    {required double width,
    required int? value,
    required List<OptionItem> items,
    required ValueChanged<int?> onChanged,
    bool loading = false}) {
  return SizedBox(
    width: width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        DropdownButtonFormField<int>(
          value: value,
          items: items
              .map((o) =>
                  DropdownMenuItem(value: o.id, child: Text(o.name)))
              .toList(),
          onChanged: loading ? null : onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF22344C),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          dropdownColor: Colors.grey[900],
          style: const TextStyle(color: Colors.white),
        ),
      ],
    ),
  );
}

Widget _dropdownCustomer(String label,
    {required double width,
    required int? value,
    required List<Customer> items,
    required ValueChanged<Customer> onChanged,
    bool loading = false}) {
  return SizedBox(
    width: width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        DropdownButtonFormField<int>(
          value: value,
          items: items
              .map((c) =>
                  DropdownMenuItem(value: c.id, child: Text(c.name)))
              .toList(),
          onChanged: loading
              ? null
              : (v) {
                  final cust = items.firstWhere((c) => c.id == v);
                  onChanged(cust);
                },
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF22344C),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          dropdownColor: Colors.grey[900],
          style: const TextStyle(color: Colors.white),
        ),
      ],
    ),
  );
}


  Widget _buildPhotos() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _photos.isEmpty
          ? Column(
              children: [
                const Text('Drag & Drop your files or Browse',
                    style: TextStyle(color: Colors.white54)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _pickFromGallery,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Pilih Foto'),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white),
                    ),
                    OutlinedButton.icon(
                      onPressed: _pickFromCamera,
                      icon: const Icon(Icons.photo_camera),
                      label: const Text('Kamera'),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white),
                    ),
                  ],
                )
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(_photos.length, (i) {
                    final photo = _photos[i];
                    return FutureBuilder<Widget>(
                      future: () async {
                        if (kIsWeb) {
                          final bytes = await photo.readAsBytes();
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              bytes,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          );
                        } else {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(photo.path),
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                      }(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox(
                            width: 90,
                            height: 90,
                            child: Center(
                                child: CircularProgressIndicator()),
                          );
                        }
                        return Stack(
                          children: [
                            snapshot.data!,
                            Positioned(
                              right: -6,
                              top: -6,
                              child: IconButton(
                                icon: const Icon(Icons.cancel,
                                    color: Colors.redAccent),
                                onPressed: () => _removePhoto(i),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: _pickFromGallery,
                      icon: const Icon(Icons.add_photo_alternate),
                      label: const Text('Tambah Foto'),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      onPressed: _pickFromCamera,
                      icon: const Icon(Icons.photo_camera),
                      label: const Text('Kamera'),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white),
                    ),
                  ],
                )
              ],
            ),
    );
  }


  Widget _productCard(int i) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2D44),
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF16283D),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Text('Produk ${i+1}', style: const TextStyle(color: Colors.white70)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () => _removeProduk(i),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                DropdownButtonFormField<int>(
  value: _items[i].brandId,
  items: _brands.map((b) =>
      DropdownMenuItem<int>(value: b.id, child: Text(b.name))).toList(),
  onChanged: (v) => setState(() => _items[i].brandId = v),
  decoration: InputDecoration(labelText: 'Brand *'),
),

DropdownButtonFormField<int>(
  value: _items[i].kategoriId,
  items: _productCategories.map((c) =>
      DropdownMenuItem<int>(value: c.id, child: Text(c.name))).toList(),
  onChanged: (v) => setState(() => _items[i].kategoriId = v),
  decoration: InputDecoration(labelText: 'Kategori *'),
),
               DropdownButtonFormField<int>(
  value: _items[i].produkId,
  items: _products.map((p) =>
      DropdownMenuItem<int>(value: p.id, child: Text(p.name))
  ).toList(),
  onChanged: (v) => setState(() => _items[i].produkId = v),
  decoration: InputDecoration(
    labelText: 'Produk *',
    filled: true,
    fillColor: const Color(0xFF22344C),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  ),
  dropdownColor: Colors.grey[900],
  style: const TextStyle(color: Colors.white),
),
                DropdownButtonFormField<int>(
  value: _items[i].warnaId,
  items: _colors
      .map((c) => DropdownMenuItem<int>(
            value: c.id,
            child: Text(c.name),
          ))
      .toList(),
  onChanged: (v) => setState(() => _items[i].warnaId = v),
  decoration: InputDecoration(
    labelText: 'Warna *',
    filled: true,
    fillColor: const Color(0xFF22344C),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  ),
  dropdownColor: Colors.grey[900],
  style: const TextStyle(color: Colors.white),
),



                _qtyField('Jumlah *', _items[i].qty?.toString() ?? '',
                        (txt) => setState(() => _items[i].qty = int.tryParse(txt))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _pillDropdown(String label, List<String> options, String? value, ValueChanged<String?> onChanged) {
    return SizedBox(
      width: 160,
      child: DropdownButtonFormField<String>(
        value: value,
        items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFF22344C),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        dropdownColor: Colors.grey[900],
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _qtyField(String label, String value, ValueChanged<String> onChanged) {
    return SizedBox(
      width: 160,
      child: TextFormField(
        initialValue: value,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFF22344C),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _formButton(String text, Color color, VoidCallback? onPressed, {bool showSpinner=false}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: color, foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14)),
      child: showSpinner
          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
          : Text(text),
    );
  }
}

class _ProductItem {
  int? produkId;
  int? warnaId;
  int? qty;
  int? brandId;
  int? kategoriId;

  _ProductItem({this.produkId, this.warnaId, this.qty, this.brandId, this.kategoriId});

  Map<String, dynamic> toMap() => {
        'produk_id': produkId,
        'warna_id': warnaId,
        'quantity': qty ?? 0,
        'brand_id': brandId,
        'kategori_id': kategoriId,
      };
}


