// lib/pages/create_sales_order.dart
import 'package:flutter/material.dart';

class CreateSalesOrderScreen extends StatefulWidget {
  const CreateSalesOrderScreen({super.key});

  @override
  State<CreateSalesOrderScreen> createState() => _CreateSalesOrderScreenState();
}

class _CreateSalesOrderScreenState extends State<CreateSalesOrderScreen> {
  bool _rewardAktif = false;
  bool _programAktif = false;
  bool _diskonAktif = false;

  // List produk sebagai kartu
  final _items = <_ProductItem>[ _ProductItem() ];

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
              // HP: 2 kolom rapat (gap 20), Tablet: lebih lega
              final double fieldWidth =
                  isTablet ? (constraints.maxWidth - 60) / 2 : (constraints.maxWidth - 20) / 2;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create Order',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // ===== FORM UTAMA (gaya CreateReturn/Garansi) =====
                  Wrap(
                    spacing: 20,
                    runSpacing: 16,
                    children: [
                      _darkDropdown('Department *', ['Sales', 'Marketing'], fieldWidth),
                      _darkDropdown('Karyawan *', ['Aulia', 'Karina'], fieldWidth),

                      _darkDropdown('Kategori Customer *', ['Retail', 'Wholesale'], fieldWidth),
                      _darkDropdown('Customer *', ['Customer A', 'Customer B'], fieldWidth),

                      _darkTextField('Phone *', fieldWidth),
                      _darkTextField('Address', fieldWidth, maxLines: 2),

                      // Reward
                      _darkTextField('Poin Reward', fieldWidth, enabled: _rewardAktif),
                      _switchTile(fieldWidth, 'Reward', _rewardAktif, (v) {
                        setState(() => _rewardAktif = v);
                      }),

                      // Program
                      _darkTextField('Poin Program', fieldWidth, enabled: _programAktif),
                      _switchTile(fieldWidth, 'Program', _programAktif, (v) {
                        setState(() => _programAktif = v);
                      }),

                      _darkDropdown('Program Pelanggan', ['Gold', 'Silver'], fieldWidth,
                          enabled: _programAktif),
                      _switchTile(fieldWidth, 'Diskon', _diskonAktif, (v) {
                        setState(() => _diskonAktif = v);
                      }),

                      // Diskon
                      _darkTextField('Diskon 1 (%)', fieldWidth, enabled: _diskonAktif, hint: '0'),
                      _darkTextField('Penjelasan Diskon 1', fieldWidth,
                          enabled: _diskonAktif, hint: 'Opsional'),
                      _darkTextField('Diskon 2 (%)', fieldWidth, enabled: _diskonAktif, hint: '0'),
                      _darkTextField('Penjelasan Diskon 2', fieldWidth,
                          enabled: _diskonAktif, hint: 'Opsional'),

                      // Pembayaran & total
                      _darkDropdown('Metode Pembayaran *', ['Cash', 'Transfer'], fieldWidth),
                      _darkTextField('Total Harga', fieldWidth, prefix: 'Rp '),
                      _darkDropdown('Status Pembayaran *', ['Paid', 'Unpaid'], fieldWidth),
                      _darkTextField('Total Harga Akhir', fieldWidth, prefix: 'Rp ', hint: '0'),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ===== DETAIL PRODUK (kartu, 2 kolom + hapus) =====
                  const Text('Detail Produk',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  Column(
                    children: List.generate(_items.length, (i) => _productCard(i)),
                  ),

                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () => setState(() => _items.add(_ProductItem())),
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Produk'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ===== ACTION BUTTONS =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _formButton(context, 'Cancel', Colors.grey, () {
                        Navigator.pop(context, false);
                      }),
                      const SizedBox(width: 12),
                      _formButton(context, 'Create', Colors.blue, () {
                        // TODO: kirim data _items + form ke API
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

  // ================== KARTU DETAIL PRODUK ==================
  Widget _productCard(int i) {
    const gap = 16.0;

    // Hitung subtotal (harga * qty)
    final double harga = _items[i].hargaPerProduk ?? 0;
    final int qty = _items[i].qty ?? 0;
    final double subtotal = harga * qty;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2D44),
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF16283D),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.swap_vert, color: Colors.white54, size: 18),
                const SizedBox(width: 8),
                Text('Produk ${i + 1}', style: const TextStyle(color: Colors.white70)),
                const Spacer(),
                IconButton(
                  tooltip: 'Hapus',
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () => setState(() => _items.removeAt(i)),
                ),
              ],
            ),
          ),

          // Body (selalu 2 kolom)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
            child: LayoutBuilder(
              builder: (context, inner) {
                final double itemWidth = (inner.maxWidth - gap) / 2;

                return Wrap(
                  spacing: gap,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                      width: itemWidth,
                      child: _pillDropdown(
                        label: 'Brand *',
                        options: const ['Brand A', 'Brand B'],
                        value: _items[i].brand,
                        onChanged: (v) => setState(() => _items[i].brand = v),
                      ),
                    ),
                    SizedBox(
                      width: itemWidth,
                      child: _pillDropdown(
                        label: 'Kategori *',
                        options: const ['Cat', 'Semen'],
                        value: _items[i].kategori,
                        onChanged: (v) => setState(() => _items[i].kategori = v),
                      ),
                    ),
                    SizedBox(
                      width: itemWidth,
                      child: _pillDropdown(
                        label: 'Produk *',
                        options: const ['Nano A', 'Piko B'],
                        value: _items[i].produk,
                        onChanged: (v) => setState(() => _items[i].produk = v),
                      ),
                    ),
                    SizedBox(
                      width: itemWidth,
                      child: _pillDropdown(
                        label: 'Warna *',
                        options: const ['Putih', 'Krem'],
                        value: _items[i].warna,
                        onChanged: (v) => setState(() => _items[i].warna = v),
                      ),
                    ),

                    // Harga / Produk
                    SizedBox(
                      width: itemWidth,
                      child: _moneyField(
                        label: 'Harga / Produk',
                        value: _items[i].hargaPerProduk,
                        onChanged: (txt) =>
                            setState(() => _items[i].hargaPerProduk = double.tryParse(txt.replaceAll('.', '').replaceAll(',', '.'))),
                      ),
                    ),

                    // Jumlah
                    SizedBox(
                      width: itemWidth,
                      child: _qtyField(
                        label: 'Jumlah',
                        value: _items[i].qty?.toString(),
                        onChanged: (txt) => setState(() => _items[i].qty = int.tryParse(txt)),
                      ),
                    ),

                    // Subtotal (read-only, tampil seperti pill)
                    SizedBox(
                      width: itemWidth,
                      child: _displayBox(
                        label: 'Subtotal',
                        value: _formatRupiah(subtotal),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================== INPUT KOMONAN (gaya gelap seragam) ==================
  Widget _darkTextField(String label, double width,
      {int maxLines = 1, bool enabled = true, String? hint, String? prefix}) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 6),
          TextFormField(
            maxLines: maxLines,
            enabled: enabled,
            style: TextStyle(color: enabled ? Colors.white : Colors.white54),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white38),
              prefixText: prefix,
              prefixStyle: const TextStyle(color: Colors.white),
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

  Widget _darkDropdown(String label, List<String> options, double width, {bool enabled = true}) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: null,
            items: options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
            onChanged: enabled ? (val) {} : null,
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

  Widget _switchTile(double width, String label, bool value, ValueChanged<bool> onChanged) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.only(top: 28),
        child: Row(
          children: [
            Switch.adaptive(value: value, onChanged: onChanged, activeColor: Colors.blue),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  // ===== Komponen dropdown bergaya "pill" (dipakai di kartu produk)
  Widget _pillDropdown({
    required String label,
    required List<String> options,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF22344C),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            suffixIcon: value == null
                ? null
                : IconButton(
                    tooltip: 'Clear',
                    icon: const Icon(Icons.close, size: 18, color: Colors.white70),
                    onPressed: () => onChanged(null),
                  ),
          ),
          dropdownColor: Colors.grey[900],
          iconEnabledColor: Colors.white,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _moneyField({
    required String label,
    double? value,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: value?.toString(),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          onChanged: onChanged,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixText: 'Rp ',
            prefixStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: const Color(0xFF22344C),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _qtyField({
    required String label,
    String? value,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: value,
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF22344C),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _displayBox({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF22344C),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white24),
          ),
          child: Text(value, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  String _formatRupiah(double n) {
    // Format sederhana: Rp 12,345.00 (tanpa paket intl)
    String s = n.toStringAsFixed(2);
    final parts = s.split('.');
    final head = parts.first;
    final tail = parts.last;
    final buf = StringBuffer();
    for (int i = 0; i < head.length; i++) {
      final idxFromEnd = head.length - i;
      buf.write(head[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) buf.write(',');
    }
    return 'Rp ${buf.toString()}.$tail';
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

// ===== Model data produk =====
class _ProductItem {
  String? brand;
  String? kategori;
  String? produk;
  String? warna;
  double? hargaPerProduk;
  int? qty;

  _ProductItem({
    this.brand,
    this.kategori,
    this.produk,
    this.warna,
    this.hargaPerProduk,
    this.qty,
  });
}
