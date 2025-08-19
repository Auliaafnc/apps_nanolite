// lib/pages/create_customer.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateCustomerScreen extends StatefulWidget {
  const CreateCustomerScreen({super.key});

  @override
  State<CreateCustomerScreen> createState() => _CreateCustomerScreenState();
}

class _CreateCustomerScreenState extends State<CreateCustomerScreen> {
  // ===== Image picker state =====
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _photos = [];

  Future<void> _pickFromGallery() async {
    try {
      final files = await _picker.pickMultiImage(imageQuality: 85);
      if (files.isNotEmpty) {
        setState(() => _photos.addAll(files));
      }
    } catch (_) {}
  }

  Future<void> _pickFromCamera() async {
    try {
      final file = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
      if (file != null) {
        setState(() => _photos.add(file));
      }
    } catch (_) {}
  }

  void _removePhoto(int index) => setState(() => _photos.removeAt(index));

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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bool isTablet = constraints.maxWidth >= 600;
              // HP: 2 kolom (gap 20), Tablet: lebih lega
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
                      _buildDropdown('Department *', ['Sales', 'Marketing'], fieldWidth),
                      _buildDropdown('Karyawan *', ['Aulia', 'Karina'], fieldWidth),
                      _buildTextField('Nama Customer *', fieldWidth),
                      _buildTextField('Telepon *', fieldWidth),
                      _buildTextField('Email', fieldWidth),
                      _buildDropdown('Kategori Customer *', ['Retail', 'Wholesale'], fieldWidth),
                      _buildDropdown('Program Customer', ['Gold', 'Silver'], fieldWidth),
                      _buildTextField('Link Google Maps', fieldWidth),
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
                                _buildDropdown('Provinsi *', ['Jawa Barat', 'Jawa Timur'], innerFieldWidth),
                                _buildDropdown('Kota/Kabupaten *', ['Bandung', 'Bekasi'], innerFieldWidth),
                                _buildDropdown('Kecamatan *', ['Cimahi', 'Cileunyi'], innerFieldWidth),
                                _buildDropdown('Kelurahan *', ['Kel. A', 'Kel. B'], innerFieldWidth),
                                _buildTextField('Kode Pos', innerFieldWidth),
                                _buildTextField('Detail Alamat *', innerFieldWidth, maxLines: 3),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ========= GAMBAR (UPLOAD + PREVIEW) =========
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
                      _formButton(context, 'Cancel', Colors.grey, () {
                        Navigator.pop(context, false);
                      }),
                      const SizedBox(width: 12),
                      _formButton(context, 'Create', Colors.blue, () {
                        // TODO: kirim _photos + data form ke API
                        Navigator.pop(context, true);
                      }),
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

  // ===== Helpers (styling seragam gelap) =====
  Widget _buildTextField(String label, double width, {int maxLines = 1}) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 6),
          TextFormField(
            maxLines: maxLines,
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

  Widget _buildDropdown(String label, List<String> options, double width) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            items: options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
            onChanged: (_) {},
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

  Widget _formButton(BuildContext context, String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
      child: Text(text),
    );
  }
}
