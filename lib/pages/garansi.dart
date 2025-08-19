// lib/pages/garansi.dart
import 'package:flutter/material.dart';
import 'create_garansi.dart';
import 'create_sales_order.dart';
import 'home.dart';
import 'profile.dart';
import 'sales_order.dart'; // ⬅️ tambah ini

class GaransiScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;

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
              icon: const Icon(Icons.workspace_premium, color: Colors.black),
              label: const Text('Garansi', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            Text('Garansi List:',
                style: TextStyle(fontSize: isTablet ? 20 : 16, color: Colors.white)),
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
                      DataColumn(label: Text('Garansi Number')),
                      DataColumn(label: Text('Department')),
                      DataColumn(label: Text('Karyawan')),
                      DataColumn(label: Text('Kategori Customer')),
                      DataColumn(label: Text('Customer')),
                      DataColumn(label: Text('Phone')),
                      DataColumn(label: Text('Address')),
                      DataColumn(label: Text('Tanggal Pembelian')),
                      DataColumn(label: Text('Tanggal Klaim Garansi')),
                      DataColumn(label: Text('Alasan Pengajuan Garansi')),
                      DataColumn(label: Text('Catatan Tambahan')),
                      DataColumn(label: Text('Detail Produk')),
                      DataColumn(label: Text('Image')),
                      DataColumn(label: Text('Download PDF')),
                      DataColumn(label: Text('Tanggal Dibuat')),
                      DataColumn(label: Text('Tanggal Diperbarui')),
                    ],
                    rows: const [
                      DataRow(cells: [
                        DataCell(Text('GRN-0123456')),
                        DataCell(Text('Sales')),
                        DataCell(Text('Aulia')),
                        DataCell(Text('Toko')),
                        DataCell(Text('Nadia')),
                        DataCell(Text('0123456')),
                        DataCell(Text('Balaraja')),
                        DataCell(Text('16/8/2025')),
                        DataCell(Text('16/8/2025')),
                        DataCell(Text('Lampu Tidak Nyala')),
                        DataCell(Text('-')),
                        DataCell(Text('Nanolite - Bulb 9Watt - 3000K x 2')),
                        DataCell(Text('-')),
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

            // Create Garansi -> await hasil, tampilkan SnackBar
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final created = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(builder: (_) => const CreateGaransiScreen()),
                  );
                  if (created == true && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Garansi berhasil dibuat'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    // TODO: refresh data kalau perlu
                  }
                },
                icon: const Icon(Icons.workspace_premium),
                label: const Text('Create Garansi'),
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

      // ===== Bottom navigation: persis seperti Home =====
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

  // Ukuran ikon & font responsif (tablet/phone) + warna sama Home
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
