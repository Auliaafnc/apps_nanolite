import 'package:flutter/material.dart';

import 'create_return.dart';
import 'create_sales_order.dart';
import 'home.dart';
import 'profile.dart';
import 'sales_order.dart'; // <— tambahkan ini

class ReturnScreen extends StatelessWidget {
  const ReturnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFF0A1B2D),
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('nanopiko', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.history, color: Colors.black),
              label: const Text('Return', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Return List:',
              style: TextStyle(fontSize: isTablet ? 20 : 16, color: Colors.white),
            ),
            const SizedBox(height: 12),

            // Search
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: isTablet ? 300 : double.infinity,
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
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
            const SizedBox(height: 16),

            // Table
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(Colors.grey[300]),
                    columns: const [
                      DataColumn(label: Text('Return Number')),
                      DataColumn(label: Text('Departemen')),
                      DataColumn(label: Text('Karyawan')),
                      DataColumn(label: Text('Kategori Customer')),
                      DataColumn(label: Text('Customer')),
                      DataColumn(label: Text('Phone')),
                      DataColumn(label: Text('Address')),
                      DataColumn(label: Text('Nominal')),
                      DataColumn(label: Text('Alasan Return')),
                      DataColumn(label: Text('Catatan Tambahan')),
                      DataColumn(label: Text('Detail Produk')),
                      DataColumn(label: Text('Image')),
                      DataColumn(label: Text('Download PDF')),
                      DataColumn(label: Text('Tanggal Dibuat')),
                      DataColumn(label: Text('Tanggal Diperbarui')),
                    ],
                    rows: const [
                      DataRow(cells: [
                        DataCell(Text('RTN-0123456')),
                        DataCell(Text('Sales')),
                        DataCell(Text('Aulia')),
                        DataCell(Text('Toko')),
                        DataCell(Text('Nadia')),
                        DataCell(Text('0123456')),
                        DataCell(Text('Balaraja')),
                        DataCell(Text('Rp 8.000')),
                        DataCell(Text('Barang Tidak Laku')),
                        DataCell(Text('-')),
                        DataCell(Text('Nanolite-Bulb-A-3000K-Qty:1')),
                        DataCell(Text('image.jpg')),
                        DataCell(Icon(Icons.download)),
                        DataCell(Text('16/8/2025')),
                        DataCell(Text('16/8/2025')),
                      ]),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Create Return -> await result -> show snackbar here
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final created = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(builder: (_) => const CreateReturnScreen()),
                  );
                  if (created == true && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Return berhasil dibuat'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.history),
                label: const Text('Create Return'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),

      // ===== Bottom navigation: SAMA persis dgn Home =====
      bottomNavigationBar: Container(
        color: const Color(0xFF0A1B2D),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(context, Icons.home, 'Home', onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                );
              }),
              _navItem(context, Icons.shopping_cart, 'Create Order', onPressed: () async {
                final created = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (_) => CreateSalesOrderScreen()),
                );
                if (created == true) {
                  if (!context.mounted) return;
                  // sama seperti Home: pindah ke SalesOrderScreen dan tampilkan snackbar
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SalesOrderScreen(showCreatedSnack: true),
                    ),
                  );
                }
              }),
              _navItem(context, Icons.person, 'Profile', onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Versi _navItem sama seperti di Home (ukuran responsif & warna)
  static Widget _navItem(BuildContext context, IconData icon, String label,
      {VoidCallback? onPressed}) {
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final double iconSize = isTablet ? 32 : 28;
    final double fontSize = isTablet ? 14 : 12;

    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: const Color(0xFF0A1B2D)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: const Color(0xFF0A1B2D), fontSize: fontSize)),
        ],
      ),
    );
  }
}
