import 'package:flutter/material.dart';

import 'home.dart';
import 'profile.dart';
import 'sales_order.dart';

class CreateSalesOrderScreen extends StatefulWidget {
  @override
  _CreateSalesOrderScreenState createState() => _CreateSalesOrderScreenState();
}

class _CreateSalesOrderScreenState extends State<CreateSalesOrderScreen> {
  bool _rewardAktif = false;
  bool _programAktif = false;
  bool _diskonAktif = false;

  List<int> _produkList = [0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Order'),
        backgroundColor: Colors.grey[900],
      ),
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bool isTablet = constraints.maxWidth >= 600;
              final double fieldWidth = isTablet ? (constraints.maxWidth - 60) / 2 : double.infinity;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 20,
                    runSpacing: 16,
                    children: [
                      _buildDropdown('Department *', ['Sales', 'Marketing'], fieldWidth),
                      _buildDropdown('Karyawan *', ['Aulia', 'Karina'], fieldWidth),
                      _buildDropdown('Kategori Customer *', ['Retail', 'Wholesale'], fieldWidth),
                      _buildDropdown('Customer *', ['Customer A', 'Customer B'], fieldWidth),
                      _buildTextField('Phone *', fieldWidth),
                      _buildTextField('Address', fieldWidth, maxLines: 2),
                    ],
                  ),
                  SizedBox(height: 16),

                  Row(
                    children: [
                      Switch(
                        value: _rewardAktif,
                        onChanged: (val) => setState(() => _rewardAktif = val),
                      ),
                      Text('Reward Aktif', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  _buildTextField('Poin Reward', fieldWidth, enabled: _rewardAktif),

                  Row(
                    children: [
                      Switch(
                        value: _programAktif,
                        onChanged: (val) => setState(() => _programAktif = val),
                      ),
                      Text('Program Aktif', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  _buildTextField('Poin Program', fieldWidth, enabled: _programAktif),
                  _buildTextField('Program Pelanggan', fieldWidth, enabled: _programAktif),

                  Row(
                    children: [
                      Switch(
                        value: _diskonAktif,
                        onChanged: (val) => setState(() => _diskonAktif = val),
                      ),
                      Text('Diskon Aktif', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Wrap(
                    spacing: 20,
                    runSpacing: 16,
                    children: [
                      _buildTextField('Diskon 1 (%)', fieldWidth, enabled: _diskonAktif),
                      _buildTextField('Penjelasan Diskon 1', fieldWidth, enabled: _diskonAktif),
                      _buildTextField('Diskon 2 (%)', fieldWidth, enabled: _diskonAktif),
                      _buildTextField('Penjelasan Diskon 2', fieldWidth, enabled: _diskonAktif),
                      _buildDropdown('Metode Pembayaran *', ['Cash', 'Transfer'], fieldWidth),
                      _buildDropdown('Status Pembayaran *', ['Paid', 'Unpaid'], fieldWidth),
                      _buildTextField('Total Harga', fieldWidth),
                      _buildTextField('Total Harga Akhir', fieldWidth),
                    ],
                  ),

                  SizedBox(height: 20),
                  Text('Detail Produk', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),

                  Column(
                    children: _produkList.map((index) => _buildProdukField(fieldWidth)).toList(),
                  ),

                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _addProdukField,
                      child: Text('Tambah Produk'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    ),
                  ),

                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _formButton(context, 'Cancel', Colors.grey, () => Navigator.pop(context)),
                      SizedBox(width: 12),
                      _formButton(context, 'Create', Colors.blue, () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => SalesOrderScreen()),
                        );
                      }),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),

      // ✅ Bottom Navigation Bar
      bottomNavigationBar: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home, 'Home', onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
            }),
            _navItem(Icons.shopping_cart, 'Create Order', onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => CreateSalesOrderScreen()));
            }),
            _navItem(Icons.person, 'Profile', onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
            }),
          ],
        ),
      ),
    );
  }

  void _addProdukField() {
    setState(() {
      _produkList.add(_produkList.length);
    });
  }

  Widget _buildTextField(String label, double width, {int maxLines = 1, bool enabled = true}) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white)),
          SizedBox(height: 6),
          TextFormField(
            maxLines: maxLines,
            enabled: enabled,
            style: TextStyle(color: enabled ? Colors.white : Colors.white54),
            decoration: InputDecoration(
              filled: true,
              fillColor: enabled ? Colors.grey[800] : Colors.grey[700],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
          Text(label, style: TextStyle(color: Colors.white)),
          SizedBox(height: 6),
          DropdownButtonFormField<String>(
            items: options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
            onChanged: (val) {},
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            dropdownColor: Colors.grey[900],
            iconEnabledColor: Colors.white,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildProdukField(double width) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white54),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 16,
        children: [
          _buildDropdown('Brand *', ['Brand A', 'Brand B'], width),
          _buildDropdown('Kategori *', ['Cat', 'Semen'], width),
          _buildDropdown('Produk *', ['Nano A', 'Piko B'], width),
          _buildDropdown('Warna *', ['Putih', 'Krem'], width),
          _buildTextField('Harga / Produk', width),
          _buildTextField('Jumlah', width),
          _buildTextField('Subtotal', width),
        ],
      ),
    );
  }

  Widget _formButton(BuildContext context, String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, {VoidCallback? onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
