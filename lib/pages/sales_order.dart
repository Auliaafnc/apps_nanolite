import 'package:flutter/material.dart';
import 'create_sales_order.dart';
import 'home.dart';
import 'profile.dart';

class SalesOrderScreen extends StatelessWidget {
  final bool showCreatedSnack;
  const SalesOrderScreen({super.key, this.showCreatedSnack = false});

  @override
  Widget build(BuildContext context) {
    // Tampilkan snackbar sukses kalau datang dari create
    if (showCreatedSnack) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sales Order berhasil dibuat'),
            backgroundColor: Colors.green,
          ),
        );
      });
    }

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
              icon: const Icon(Icons.shopping_cart, color: Colors.black),
              label: const Text('Sales Order', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Sales Order List:',
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
                child: Row(
                  children: const [
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
                    headingRowColor: MaterialStateProperty.all<Color?>(Colors.grey[300]),
                    columns: const [
                      DataColumn(label: Text('Order Number')),
                      DataColumn(label: Text('Departmen')),
                      DataColumn(label: Text('Karyawan')),
                      DataColumn(label: Text('Customer')),
                      DataColumn(label: Text('Kategori Customer')),
                      DataColumn(label: Text('Telepon')),
                      DataColumn(label: Text('Alamat')),
                      DataColumn(label: Text('Detail Produk')),
                      DataColumn(label: Text('Total Awal')),
                      DataColumn(label: Text('Diskon')),
                      DataColumn(label: Text('Penjelasan Diskon')),
                      DataColumn(label: Text('Program Customer')),
                      DataColumn(label: Text('Program Point')),
                      DataColumn(label: Text('Reward Point')),
                      DataColumn(label: Text('Total Akhir')),
                      DataColumn(label: Text('Metode Pembayaran')),
                      DataColumn(label: Text('Status Pembayaran')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Download PDF')),
                      DataColumn(label: Text('Tanggal Dibuat')),
                      DataColumn(label: Text('Tanggal Diperbarui')),
                    ],
                    rows: const [
                      DataRow(cells: [
                        DataCell(Text('ORD-123456')),
                        DataCell(Text('Sales')),
                        DataCell(Text('Aulia')),
                        DataCell(Text('Nadia')),
                        DataCell(Text('Toko')),
                        DataCell(Text('08123456789')),
                        DataCell(Text('Balaraja')),
                        DataCell(Text('Nanolite-Bulb-Bulb A-3000K-Rp 15.000-Qty:2')),
                        DataCell(Text('Rp 30.000')),
                        DataCell(Text('-')),
                        DataCell(Text('-')),
                        DataCell(Text('Logam Mulia')),
                        DataCell(Text('8')),
                        DataCell(Text('10')),
                        DataCell(Text('Rp 30.000')),
                        DataCell(Text('Tempo')),
                        DataCell(Text('Belum Bayar')),
                        DataCell(Text('Disetujui')),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sales Order berhasil dibuat'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // TODO: refresh data kalau perlu
                }
              }),
              _navItem(context, Icons.person, 'Profile', onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfileScreen()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Versi _navItem yang sama seperti di Home (size responsive + warna)
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
