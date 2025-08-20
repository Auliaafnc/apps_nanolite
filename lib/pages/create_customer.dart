import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/api_service.dart';
import '../services/api_service.dart' show OptionItem, AddressInput;

class CreateCustomerScreen extends StatefulWidget {
  const CreateCustomerScreen({super.key});

  @override
  State<CreateCustomerScreen> createState() => _CreateCustomerScreenState();
}

class _CreateCustomerScreenState extends State<CreateCustomerScreen> {
  // ===== Image picker state (preview only) =====
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _photos = [];

  Future<void> _pickFromGallery() async {
    try {
      final files = await _picker.pickMultiImage(imageQuality: 85);
      if (!mounted) return;
      if (files.isNotEmpty) setState(() => _photos.addAll(files));
    } catch (_) {}
  }

  Future<void> _pickFromCamera() async {
    try {
      final file = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
      if (!mounted) return;
      if (file != null) setState(() => _photos.add(file));
    } catch (_) {}
  }

  void _removePhoto(int index) => setState(() => _photos.removeAt(index));

  // ===== Controllers =====
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _gmapsCtrl = TextEditingController();

  // Address (kode laravolt + detail)
  final _provCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _distCtrl = TextEditingController();
  final _villCtrl = TextEditingController();
  final _zipCtrl = TextEditingController();
  final _detailAddrCtrl = TextEditingController();

  // ===== Dropdown data from backend (sudah difilter di ApiService) =====
  List<OptionItem> _departments = [];
  List<OptionItem> _employees = [];
  List<OptionItem> _categories = [];
  List<OptionItem> _programs = [];

  // Selected IDs
  int? _deptId;
  int? _empId;
  int? _catId;
  int? _progId;

  // UI state
  bool _loadingOptions = false;
  bool _loadingEmployees = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _gmapsCtrl.dispose();
    _provCtrl.dispose();
    _cityCtrl.dispose();
    _distCtrl.dispose();
    _villCtrl.dispose();
    _zipCtrl.dispose();
    _detailAddrCtrl.dispose();
    super.dispose();
  }

  // ====== LOAD OPTIONS (khusus Create) ======
  Future<void> _loadOptions() async {
    setState(() => _loadingOptions = true);
    try {
      // fungsi ini di ApiService sudah filter:
      // departments & categories & employees -> active
      // programs -> active + approved
      final depts = await ApiService.fetchDepartments();
      final cats  = await ApiService.fetchCustomerCategories();
      final progs = await ApiService.fetchCustomerPrograms();

      if (!mounted) return;
      setState(() {
        _departments = depts;
        _categories  = cats;
        _programs    = progs;
      });

      // opsional: pilih dept pertama & load employees-nya
      if (_departments.isNotEmpty) {
        await _onSelectDepartment(_departments.first.id);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat pilihan: $e')),
      );
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
    if (id == null) {
      setState(() => _loadingEmployees = false);
      return;
    }

    try {
      final emps = await ApiService.fetchEmployees(departmentId: id); // sudah active-only
      if (!mounted) return;
      setState(() => _employees = emps);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat karyawan: $e')),
      );
    } finally {
      if (mounted) setState(() => _loadingEmployees = false);
    }
  }

  // ====== SUBMIT ======
  Future<void> _submit() async {
    // Validasi minimum
    if (_deptId == null ||
        _empId == null ||
        _catId == null ||
        _nameCtrl.text.trim().isEmpty ||
        _phoneCtrl.text.trim().isEmpty ||
        _provCtrl.text.trim().isEmpty ||
        _cityCtrl.text.trim().isEmpty ||
        _distCtrl.text.trim().isEmpty ||
        _villCtrl.text.trim().isEmpty ||
        _detailAddrCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi field yang bertanda *')),
      );
      return;
    }

    setState(() => _submitting = true);

    // address: backend expect array -> kita kirim 1 item
    final addr = AddressInput(
      provinsiCode: _provCtrl.text.trim(),
      kotaKabCode: _cityCtrl.text.trim(),
      kecamatanCode: _distCtrl.text.trim(),
      kelurahanCode: _villCtrl.text.trim(),
      detailAlamat: _detailAddrCtrl.text.trim(),
      kodePos: _zipCtrl.text.trim().isEmpty ? null : _zipCtrl.text.trim(),
    );

    try {
      final ok = await ApiService.createCustomer(
        departmentId: _deptId!,
        employeeId: _empId!,
        name: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
        customerCategoryId: _catId!,
        customerProgramId: _progId, // boleh null
        gmapsLink: _gmapsCtrl.text.trim().isEmpty ? null : _gmapsCtrl.text.trim(),
        address: addr,
      );

      if (!mounted) return;

      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Customer berhasil dibuat'), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal membuat customer'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  // ====== AUTO ZIP BY VILLAGE ======
  Future<void> _onVillageChanged(String code) async {
    // kalau kamu punya endpoint postal code, aktifkan ini
    final v = code.trim();
    if (v.isEmpty) return;
    final maybeZip = await ApiService.fetchPostalCodeByVillage(v);
    if (!mounted) return;
    if (maybeZip != null && maybeZip.isNotEmpty) {
      _zipCtrl.text = maybeZip;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('nanopiko'),
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
                    final bool isTablet = constraints.maxWidth >= 600;
                    final double fieldWidth =
                        isTablet ? (constraints.maxWidth - 60) / 2 : (constraints.maxWidth - 20) / 2;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Create Customer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ========= FORM UTAMA =========
                        Wrap(
                          spacing: 20,
                          runSpacing: 16,
                          children: [
                            _dropdownInt(
                              'Department *',
                              width: fieldWidth,
                              value: _deptId,
                              items: _departments,
                              onChanged: _onSelectDepartment,
                            ),
                            _dropdownInt(
                              'Karyawan *',
                              width: fieldWidth,
                              value: _empId,
                              items: _employees,
                              onChanged: (v) => setState(() => _empId = v),
                              loading: _loadingEmployees,
                            ),
                            _textField('Nama Customer *', _nameCtrl, fieldWidth),
                            _textField('Telepon *', _phoneCtrl, fieldWidth, keyboard: TextInputType.phone),
                            _textField('Email', _emailCtrl, fieldWidth, keyboard: TextInputType.emailAddress),
                            _dropdownInt(
                              'Kategori Customer *',
                              width: fieldWidth,
                              value: _catId,
                              items: _categories,
                              onChanged: (v) => setState(() => _catId = v),
                            ),
                            _dropdownInt(
                              'Program Customer',
                              width: fieldWidth,
                              value: _progId,
                              items: _programs, // sudah hanya yang active+approved
                              onChanged: (v) => setState(() => _progId = v),
                            ),
                            _textField('Link Google Maps', _gmapsCtrl, fieldWidth),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // ========= ALAMAT =========
                        const Text('Alamat',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white30),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: LayoutBuilder(
                            builder: (context, inner) {
                              const double gap = 20;
                              final bool isTabletInside = inner.maxWidth >= 600;
                              final double innerFieldWidth =
                                  isTabletInside ? (inner.maxWidth - 60) / 2 : (inner.maxWidth - gap) / 2;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Alamat',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 16),
                                  Wrap(
                                    spacing: gap,
                                    runSpacing: 16,
                                    children: [
                                      _textField('Provinsi (code) *', _provCtrl, innerFieldWidth),
                                      _textField('Kota/Kab (code) *', _cityCtrl, innerFieldWidth),
                                      _textField('Kecamatan (code) *', _distCtrl, innerFieldWidth),
                                      _textField(
                                        'Kelurahan (code) *',
                                        _villCtrl,
                                        innerFieldWidth,
                                        onChanged: _onVillageChanged,
                                      ),
                                      _textField('Kode Pos', _zipCtrl, innerFieldWidth,
                                          keyboard: TextInputType.number),
                                      _textField('Detail Alamat *', _detailAddrCtrl, innerFieldWidth, maxLines: 3),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 30),

                        // ========= GAMBAR (preview only) =========
                        const Text(
                          'Gambar',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(minHeight: 150),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white54),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _photos.isEmpty
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Drag & Drop your files or Browse',
                                      style: TextStyle(color: Colors.white54),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    Wrap(
                                      spacing: 12,
                                      runSpacing: 12,
                                      alignment: WrapAlignment.center,
                                      children: [
                                        OutlinedButton.icon(
                                          onPressed: _pickFromGallery,
                                          icon: const Icon(Icons.photo_library),
                                          label: const Text('Pilih Foto'),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            side: const BorderSide(color: Colors.white38),
                                          ),
                                        ),
                                        OutlinedButton.icon(
                                          onPressed: _pickFromCamera,
                                          icon: const Icon(Icons.photo_camera),
                                          label: const Text('Kamera'),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            side: const BorderSide(color: Colors.white38),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: List.generate(_photos.length, (i) {
                                        final file = File(_photos[i].path);
                                        return Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Image.file(
                                                file,
                                                width: 90,
                                                height: 90,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                              right: -6,
                                              top: -6,
                                              child: IconButton(
                                                icon: const Icon(Icons.cancel, color: Colors.redAccent),
                                                onPressed: () => _removePhoto(i),
                                              ),
                                            ),
                                          ],
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
                                            foregroundColor: Colors.white,
                                            side: const BorderSide(color: Colors.white38),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        OutlinedButton.icon(
                                          onPressed: _pickFromCamera,
                                          icon: const Icon(Icons.photo_camera),
                                          label: const Text('Kamera'),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            side: const BorderSide(color: Colors.white38),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                        ),

                        const SizedBox(height: 30),

                        // ========= BUTTONS =========
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _formButton('Cancel', Colors.grey, () {
                              Navigator.pop(context, false);
                            }),
                            const SizedBox(width: 12),
                            _formButton(
                              'Create',
                              Colors.blue,
                              _submitting ? null : _submit,
                              showSpinner: _submitting,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
    );
  }

  // ===== UI helpers (dark style) =====
  Widget _textField(
    String label,
    TextEditingController c,
    double width, {
    int maxLines = 1,
    TextInputType? keyboard,
    ValueChanged<String>? onChanged,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 6),
          TextFormField(
            maxLines: maxLines,
            controller: c,
            onChanged: onChanged,
            keyboardType: keyboard,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
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

  Widget _dropdownInt(
    String label, {
    required double width,
    required int? value,
    required List<OptionItem> items,
    required ValueChanged<int?> onChanged,
    bool loading = false,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: const TextStyle(color: Colors.white)),
              if (loading) ...[
                const SizedBox(width: 8),
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<int>(
            value: value,
            items: items
                .map((o) => DropdownMenuItem<int>(
                      value: o.id,
                      child: Text(o.name),
                    ))
                .toList(),
            onChanged: loading ? null : onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF22344C),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            dropdownColor: Colors.grey[900],
            iconEnabledColor: Colors.white,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _formButton(String text, Color color, VoidCallback? onPressed, {bool showSpinner = false}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
      child: showSpinner
          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
          : Text(text),
    );
  }
}
