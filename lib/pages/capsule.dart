import 'package:flutter/material.dart';

import 'create_sales_order.dart';
import 'home.dart';
import 'profile.dart';

class CapsuleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final double padding = isTablet ? 30.0 : 16.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final double comparisonImageHeight = isTablet ? 220 : 180;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1E38),
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: const Text('nanopiko', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kategori Button
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.lightbulb, color: Colors.black),
                    SizedBox(width: 8),
                    Text("Nanolite", style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Text("Product Capsule", style: TextStyle(fontSize: 18, color: Colors.white)),
            const SizedBox(height: 16),

            // Top Product Display
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF16273F),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Expanded(
                    flex: 5,
                    child: Image.asset("assets/images/capsule.jpg", height: isTablet ? 220 : 180),
                  ),
                  const SizedBox(width: 16),
                  // Specs
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Text('Spesifikasi', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 12),
                        const Text("• Tahan Sampai: 25.000 Jam", style: TextStyle(color: Colors.white)),
                        const Text("• Fitting: E27", style: TextStyle(color: Colors.white)),
                        const Text("• Hemat Energi: 90%", style: TextStyle(color: Colors.white)),
                        const Text("• LED: Samsung", style: TextStyle(color: Colors.white)),
                        const Text("• Tegangan: 165–250V", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tabel Responsif
            LayoutBuilder(
              builder: (context, constraints) {
                final isTabletLayout = constraints.maxWidth >= 600;
                return isTabletLayout
                    ? _buildCapsuleTable(isTablet: true)
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _buildCapsuleTable(isTablet: false),
                      );
              },
            ),

            const SizedBox(height: 24),
            const Text("Perbandingan:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Image.asset(
                    "assets/images/nanocapspek.jpg",
                    height: comparisonImageHeight,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Image.asset(
                    "assets/images/kompcaps.jpg",
                    height: comparisonImageHeight,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
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

  Widget _buildCapsuleTable({required bool isTablet}) {
    List<List<String>> data = [
      ["30 Watt", "3600lm", "178mm x 100mm", "40", "6500K", "Cahaya Putih Kebiruan"],
      ["50 Watt", "6000lm", "211mm x 120mm", "24", "6500K", "Cahaya Putih Kebiruan"],
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Table(
        border: TableBorder.all(color: Colors.grey.shade300),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: isTablet
            ? {
                0: FlexColumnWidth(1.4),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1.7),
                3: FlexColumnWidth(0.8),
                4: FlexColumnWidth(0.9),
                5: FlexColumnWidth(2),
              }
            : {
                0: FixedColumnWidth(100),
                1: FixedColumnWidth(80),
                2: FixedColumnWidth(140),
                3: FixedColumnWidth(60),
                4: FixedColumnWidth(70),
                5: FixedColumnWidth(150),
              },
        children: [
          TableRow(
            decoration: const BoxDecoration(color: Color(0xFF0B1E38)),
            children: [
              _tableHeader("Varian Watt"),
              _tableHeader("Lumen"),
              _tableHeader("Dimensi (Tinggi x Diameter)"),
              _tableHeader("Isi/Dus"),
              _tableHeader("Warna"),
              _tableHeader("Keterangan"),
            ],
          ),
          for (var row in data)
            TableRow(
              children: [
                _tableCell(row[0]),
                _tableCell(row[1]),
                _tableCell(row[2]),
                _tableCell(row[3]),
                _tableCellColored(row[4]),
                _tableCell(row[5]),
              ],
            ),
        ],
      ),
    );
  }

  Widget _tableHeader(String text) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      );

  Widget _tableCell(String text) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text, textAlign: TextAlign.center),
      );

  Widget _tableCellColored(String text) => Container(
        color: Colors.lightBlueAccent,
        padding: const EdgeInsets.all(8.0),
        child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
      );

  Widget _navItem(IconData icon, String label, {VoidCallback? onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
