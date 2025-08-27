// lib/pages/create_sales_order.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CreateSalesOrderScreen extends StatefulWidget {
  const CreateSalesOrderScreen({super.key});

  @override
  State<CreateSalesOrderScreen> createState() => _CreateSalesOrderScreenState();
}

class _CreateSalesOrderScreenState extends State<CreateSalesOrderScreen> {
  bool _rewardAktif = false;
  bool _programAktif = false;
  bool _diskonAktif = false;

  // Selected IDs
  int? _selectedDeptId;
  int? _selectedEmpId;
  int? _selectedCategoryId;
  int? _selectedCustomerId;
  int? _selectedProgramId;

  // Controller untuk auto-fill
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _programCtrl = TextEditingController();

  List<OptionItem> _customers = [];

  Future<void> _loadCustomers() async {
  if (_selectedDeptId == null || _selectedEmpId == null || _selectedCategoryId == null) {
    setState(() => _customers = []);
    return;
  }

  final list = await ApiService.fetchCustomersFiltered(
    departmentId: _selectedDeptId!,
    employeeId: _selectedEmpId!,
    categoryId: _selectedCategoryId!,
  );

  setState(() => _customers = list);
}

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

                  // ===== FORM UTAMA =====
                  Wrap(
                    spacing: 20,
                    runSpacing: 16,
                    children: [
                      // Department
                      _dropdownFuture(
                        label: 'Department *',
                        future: ApiService.fetchDepartments(),
                        value: _selectedDeptId,
                        width: fieldWidth,
                        onChanged: (v) {
                          setState(() {
                            _selectedDeptId = v;
                            _selectedEmpId = null;   // 🔥 reset employee biar nggak error
                          });
                          _loadCustomers();
                        },
                      ),

                      _dropdownFuture(
                      label: 'Karyawan *',
                      future: _selectedDeptId != null
                          ? ApiService.fetchEmployees(departmentId: _selectedDeptId!)
                          : Future.value([]),
                      value: _selectedEmpId,
                      width: fieldWidth,
                      onChanged: (v) {
                        setState(() {
                          _selectedEmpId = v;
                        });
                        _loadCustomers(); // ✅ aman, sudah di dalam block function
                      },
                    ),

                      _dropdownFuture(
                        label: 'Kategori Customer *',
                        future: ApiService.fetchCustomerCategories(),
                        value: _selectedCategoryId,
                        width: fieldWidth,
                        onChanged: (v) {
                          setState(() {
                            _selectedCategoryId = v;
                            _selectedCustomerId = null;   // 🔥 reset customer saat ganti kategori
                          });
                           _loadCustomers();
                        },
                      ),

                      // Ganti bagian _dropdownFuture Customer dengan ini
SizedBox(
  width: fieldWidth,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Customer *", style: TextStyle(color: Colors.white)),
      const SizedBox(height: 6),
      DropdownButtonFormField<int>(
        value: _selectedCustomerId,
        items: _customers
            .map((c) => DropdownMenuItem(
                  value: c.id,
                  child: Text(c.name),
                ))
            .toList(),
        onChanged: (v) {
          setState(() {
            _selectedCustomerId = v;
            final selected = _customers.firstWhere(
              (c) => c.id == v,
              orElse: () => OptionItem(
                id: 0,
                name: '-',
                phone: '',
                address: '-',
                programName: '-',
                programId: null,
                categoryId: null,
              ),
            );

            _phoneCtrl.text   = selected.phone ?? '';
            _addressCtrl.text = selected.address ?? '';
            _programCtrl.text = selected.programName ?? '-';
            _selectedProgramId = selected.programId;
          });
        },
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
),


                      _darkTextField('Phone *', fieldWidth, controller: _phoneCtrl),
                      _darkTextField('Address', fieldWidth, controller: _addressCtrl, maxLines: 2),

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

                      _darkTextField('Program Pelanggan', fieldWidth,
                        controller: _programCtrl, enabled: false),

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

                  // ===== DETAIL PRODUK =====
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
                      _formButton(context, 'Create', Colors.blue, () async {
                        final success = await ApiService.createOrder(
                          companyId: 1, // sesuaikan
                          departmentId: _selectedDeptId!,
                          employeeId: _selectedEmpId!,
                          customerId: _selectedCustomerId!,
                          categoryId: _selectedCategoryId!,
                          programId: _selectedProgramId,
                          phone: _phoneCtrl.text,
                          addressText: _addressCtrl.text,
                          programEnabled: _programAktif,
                          rewardEnabled: _rewardAktif,
                          products: _items.map((p) => {
                            'brand': p.brandId,
                            'category': p.kategoriId,
                            'product': p.produkId,
                            'color': p.warnaId,
                            'quantity': p.qty ?? 0,
                            'price': p.hargaPerProduk ?? 0,
                          }).toList(),
                          paymentMethod: "cash",
                          statusPembayaran: "unpaid",
                          status: "pending",
                        );

                        if (!mounted) return;

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Order berhasil dibuat")),
                          );
                          Navigator.pop(context, true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Gagal membuat order")),
                          );
                        }
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

          // Body
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
            child: LayoutBuilder(
              builder: (context, inner) {
                final double itemWidth = (inner.maxWidth - gap) / 2;
                return Wrap(
                  spacing: gap,
                  runSpacing: 16,
                  children: [
                    _dropdownFuture(
                      label: 'Brand *',
                      future: ApiService.fetchBrands(),
                      value: _items[i].brandId,
                      width: itemWidth,
                      onChanged: (v) => setState(() => _items[i].brandId = v),
                    ),
                    _dropdownFuture(
                      label: 'Kategori *',
                      future: ApiService.fetchProductCategories(),
                      value: _items[i].kategoriId,
                      width: itemWidth,
                      onChanged: (v) => setState(() => _items[i].kategoriId = v),
                    ),
                    _dropdownFuture(
  label: 'Produk *',
  future: ApiService.fetchProducts(),
  value: _items[i].produkId,
  width: itemWidth,
  onChanged: (v) async {
    setState(() {
      _items[i].produkId = v;
      _items[i].warnaId = null; // reset warna
      _items[i].availableColors = [];
    });

    if (v != null) {
      final cols = await ApiService.fetchColorsByProduct(v);
      setState(() => _items[i].availableColors = cols);
    }
  },
),

                    SizedBox(
  width: itemWidth,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Warna *", style: TextStyle(color: Colors.white)),
      const SizedBox(height: 6),
      DropdownButtonFormField<int>(
        value: _items[i].warnaId,
        items: (_items[i].availableColors)
            .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
            .toList(),
        onChanged: (v) => setState(() => _items[i].warnaId = v),
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
),

                    SizedBox(
                      width: itemWidth,
                      child: _moneyField(
                        label: 'Harga / Produk',
                        value: _items[i].hargaPerProduk,
                        onChanged: (txt) =>
                            setState(() => _items[i].hargaPerProduk = double.tryParse(txt.replaceAll('.', '').replaceAll(',', '.'))),
                      ),
                    ),
                    SizedBox(
                      width: itemWidth,
                      child: _qtyField(
                        label: 'Jumlah',
                        value: _items[i].qty?.toString(),
                        onChanged: (txt) => setState(() => _items[i].qty = int.tryParse(txt)),
                      ),
                    ),
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

  // ================== REUSABLE DROPDOWN FROM FUTURE ==================
  Widget _dropdownFuture({
    required String label,
    required Future<List<OptionItem>> future,
    required int? value,
    required double width,
    required ValueChanged<int?> onChanged,
    bool enabled = true,
    ValueChanged<List<OptionItem>>? onData,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 6),
          FutureBuilder<List<OptionItem>>(
            future: future,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox(height: 48, child: Center(child: CircularProgressIndicator()));
              }
              final items = snapshot.data!;
              if (onData != null) onData!(items);
              return DropdownButtonFormField<int>(
                value: value,
                items: items
                    .map((opt) => DropdownMenuItem(value: opt.id, child: Text(opt.name)))
                    .toList(),
                onChanged: enabled ? onChanged : null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF22344C),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                dropdownColor: Colors.grey[900],
                iconEnabledColor: Colors.white,
                style: const TextStyle(color: Colors.white),
              );
            },
          ),
        ],
      ),
    );
  }

  // ================== INPUT KOMONAN ==================
  Widget _darkTextField(String label, double width,
      {int maxLines = 1, bool enabled = true, String? hint, String? prefix,TextEditingController? controller,}) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
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
  int? brandId;
  int? kategoriId;
  int? produkId;
  int? warnaId;
  double? hargaPerProduk;
  int? qty;

  List<OptionItem> availableColors; // 🔥 tambahan

  _ProductItem({
    this.brandId,
    this.kategoriId,
    this.produkId,
    this.warnaId,
    this.hargaPerProduk,
    this.qty,
    this.availableColors = const [], // default kosong
  });
}
