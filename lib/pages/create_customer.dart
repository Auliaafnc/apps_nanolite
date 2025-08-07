import 'package:flutter/material.dart';

import 'create_sales_order.dart';
import 'customer.dart';
import 'home.dart';
import 'profile.dart';

class CreateCustomerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Customer'),
        backgroundColor: Colors.grey[900],
      ),
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isTablet = constraints.maxWidth >= 600;
              double fieldWidth = isTablet ? (constraints.maxWidth - 60) / 2 : double.infinity;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  SizedBox(height: 20),
                  Text(
                    'Alamat',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 20,
                    runSpacing: 16,
                    children: [
                      _buildDropdown('Provinsi', ['Jawa Barat', 'Jawa Timur'], fieldWidth),
                      _buildDropdown('Kota/Kabupaten', ['Bandung', 'Bekasi'], fieldWidth),
                      _buildDropdown('Kecamatan', ['Cimahi', 'Cileunyi'], fieldWidth),
                      _buildDropdown('Kelurahan', ['Kel. A', 'Kel. B'], fieldWidth),
                      _buildTextField('Kode Pos', fieldWidth),
                      _buildTextField('Detail Alamat *', fieldWidth, maxLines: 3),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Gambar',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 150,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white54),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Drag & Drop your files or Browse',
                        style: TextStyle(color: Colors.white54),
                      ),
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
                          MaterialPageRoute(builder: (_) => CustomerScreen()),
                        );
                      }),
                    ],
                  )
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

  Widget _buildTextField(String label, double width, {int maxLines = 1}) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white)),
          SizedBox(height: 6),
          TextFormField(
            maxLines: maxLines,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[800],
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
