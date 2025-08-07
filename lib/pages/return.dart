import 'package:flutter/material.dart';

import 'create_return.dart'; // ✅ Import create_return.dart
import 'create_sales_order.dart'; // ✅ Import CreateSalesOrderScreen
import 'home.dart'; // ✅ Import HomeScreen
import 'profile.dart'; // ✅ Import ProfileScreen

class ReturnScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFF061F3D),
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
              icon: Icon(Icons.refresh, color: Colors.black),
              label: Text('Return', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Return List:',
              style: TextStyle(
                fontSize: isTablet ? 20 : 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),

            // Search Bar
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

            // Data Table
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
                      DataColumn(label: Text('No Order')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Sales')),
                      DataColumn(label: Text('Produk')),
                      DataColumn(label: Text('Custom')),
                      DataColumn(label: Text('Nominal')),
                      DataColumn(label: Text('Image')),
                      DataColumn(label: Text('Download PDF')),
                    ],
                    rows: const [
                      DataRow(cells: [
                        DataCell(Text('RT125')),
                        DataCell(Text('Toko Berkah')),
                        DataCell(Text('Aulia')),
                        DataCell(Text('Nanopiko Blue S War. Jumbo 6')),
                        DataCell(Text('Barang Tidak Laku')),
                        DataCell(Text('Rp 8000')),
                        DataCell(Icon(Icons.image)),
                        DataCell(Icon(Icons.download)),
                      ]),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 12),

            // ✅ Tombol Create Return
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateReturnScreen()),
                  );
                },
                icon: Icon(Icons.add_circle_outline),
                label: Text('Create Return'),
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

      // ✅ Bottom Navigation Bar dengan Navigasi Lengkap
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
