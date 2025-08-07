import 'package:flutter/material.dart';

import 'create_customer.dart';
import 'create_sales_order.dart';
import 'home.dart';
import 'profile.dart';

class CustomerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: Colors.indigo[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('nanopiko', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.apartment, color: Colors.black),
              label: Text('Customer', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Customers List:',
              style: TextStyle(
                fontSize: isTablet ? 20 : 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: isTablet ? 300 : double.infinity,
                height: 42,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.black54),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(Colors.grey[300]),
                    columns: const [
                      DataColumn(label: Text('Department')),
                      DataColumn(label: Text('Karyawan')),
                      DataColumn(label: Text('Nama Customer')),
                      DataColumn(label: Text('Telepon')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Kategori Customer')),
                      DataColumn(label: Text('Program Customer')),
                      DataColumn(label: Text('Link Maps')),
                      DataColumn(label: Text('Provinsi')),
                      DataColumn(label: Text('Kota/Kabupaten')),
                      DataColumn(label: Text('Kecamatan')),
                      DataColumn(label: Text('Kelurahan')),
                      DataColumn(label: Text('Kode Pos')),
                      DataColumn(label: Text('Detail Alamat')),
                      DataColumn(label: Text('Gambar')),
                      DataColumn(label: Text('Download PDF')),
                    ],
                    rows: const [
                      DataRow(cells: [
                        DataCell(Text('Sales')),
                        DataCell(Text('Aulia')),
                        DataCell(Text('Karina Indah Puspa')),
                        DataCell(Text('08123456789')),
                        DataCell(Text('karina@gmail.com')),
                        DataCell(Text('Retail')),
                        DataCell(Text('Program A')),
                        DataCell(Text('https://maps.google.com/...')),
                        DataCell(Text('DKI Jakarta')),
                        DataCell(Text('Jakarta Barat')),
                        DataCell(Text('Cengkareng')),
                        DataCell(Text('Cengkareng Barat')),
                        DataCell(Text('11730')),
                        DataCell(Text('Jl. Raya Sudirman No. 123')),
                        DataCell(Text('image.jpg')),
                        DataCell(Icon(Icons.download)),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateCustomerScreen(),
                    ),
                  );
                },
                icon: Icon(Icons.person_add_alt_1),
                label: Text('Create Customer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),

      // ✅ BOTTOM NAVIGATION BAR YANG BENAR
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
