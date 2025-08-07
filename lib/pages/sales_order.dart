import 'package:flutter/material.dart';

import 'create_sales_order.dart';
import 'home.dart'; // ✅ Tambahkan import HomeScreen
import 'profile.dart'; // ✅ Tambahkan import ProfileScreen

class SalesOrderScreen extends StatelessWidget {
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
              icon: Icon(Icons.receipt_long, color: Colors.black),
              label: Text('Sales Order', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Sales Order List:',
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
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Department')),
                      DataColumn(label: Text('Karyawan')),
                      DataColumn(label: Text('Kategori')),
                      DataColumn(label: Text('Customer')),
                      DataColumn(label: Text('Phone')),
                      DataColumn(label: Text('Address')),
                      DataColumn(label: Text('Reward Aktif')),
                      DataColumn(label: Text('Poin Reward')),
                      DataColumn(label: Text('Program Aktif')),
                      DataColumn(label: Text('Poin Program')),
                      DataColumn(label: Text('Program Pelanggan')),
                      DataColumn(label: Text('Diskon Aktif')),
                      DataColumn(label: Text('Diskon 1')),
                      DataColumn(label: Text('Ket Diskon 1')),
                      DataColumn(label: Text('Diskon 2')),
                      DataColumn(label: Text('Ket Diskon 2')),
                      DataColumn(label: Text('Metode Pembayaran')),
                      DataColumn(label: Text('Status Pembayaran')),
                      DataColumn(label: Text('Total Harga')),
                      DataColumn(label: Text('Total Harga Akhir')),
                      DataColumn(label: Text('Produk')),
                      DataColumn(label: Text('Harga/Produk')),
                      DataColumn(label: Text('Jumlah')),
                      DataColumn(label: Text('Subtotal')),
                      DataColumn(label: Text('Download PDF')),
                    ],
                    rows: const [
                      DataRow(cells: [
                        DataCell(Text('1')),
                        DataCell(Text('Sales')),
                        DataCell(Text('Aulia')),
                        DataCell(Text('Retail')),
                        DataCell(Text('Karina Store')),
                        DataCell(Text('08123456789')),
                        DataCell(Text('Jl. Sudirman')),
                        DataCell(Text('Aktif')),
                        DataCell(Text('100')),
                        DataCell(Text('Tidak Aktif')),
                        DataCell(Text('-')),
                        DataCell(Text('-')),
                        DataCell(Text('Aktif')),
                        DataCell(Text('5')),
                        DataCell(Text('Diskon Akhir Tahun')),
                        DataCell(Text('10')),
                        DataCell(Text('Diskon Loyalitas')),
                        DataCell(Text('Cash')),
                        DataCell(Text('Paid')),
                        DataCell(Text('Rp 2.000.000')),
                        DataCell(Text('Rp 1.700.000')),
                        DataCell(Text('Nano A')),
                        DataCell(Text('Rp 100.000')),
                        DataCell(Text('10')),
                        DataCell(Text('Rp 1.000.000')),
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
                      builder: (context) => CreateSalesOrderScreen(),
                    ),
                  );
                },
                icon: Icon(Icons.add_circle_outline),
                label: Text('Create Order'),
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

      // ✅ BottomNavigationBar dengan Navigasi Lengkap
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
