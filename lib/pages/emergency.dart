import 'package:flutter/material.dart';

import 'create_sales_order.dart';
import 'home.dart';
import 'profile.dart';

class EmergencyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 600;
        final double padding = isTablet ? 24 : 16;
        final double imageSize = isTablet ? 260 : 160;
        final double compareImageHeight = isTablet ? 200 : 180; // ✅ lebih besar di smartphone
        final double titleFontSize = isTablet ? 22 : 16;
        final double specFontSize = isTablet ? 16 : 12;

        return Scaffold(
          backgroundColor: const Color(0xFF0B2240),
          appBar: AppBar(
            backgroundColor: Colors.grey[200],
            elevation: 0,
            leading: const BackButton(color: Colors.black),
            title: const Text('nanopiko', style: TextStyle(color: Colors.black)),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.lightbulb_outline, color: Colors.white),
                  label: const Text('Nanolite'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black54,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Product Emergency',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Gambar & Spesifikasi Atas
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF162B4C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Image.asset('assets/images/emergency.jpg', height: imageSize),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: const Text('SPESIFIKASI', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 12),
                            _buildSpecBox([
                              'Baterai Tahan: Hingga 4 Jam',
                              'Hemat Energi: 90%',
                              'Tegangan: 100v–220v',
                              'Fitting: E27',
                            ], specFontSize),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Tabel Spesifikasi
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: _buildSpecTable(specFontSize, isTablet),
                ),

                const SizedBox(height: 30),

                // Gambar Perbandingan
                Text(
                  'Perbandingan:',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildCompareImage('assets/images/emerspek.jpg', 'NANOLITE', compareImageHeight),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildCompareImage('assets/images/emerkomp.jpg', 'PRODUK LAIN', compareImageHeight),
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
      },
    );
  }

  Widget _buildSpecBox(List<String> specs, double fontSize) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: specs.map((spec) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              '• $spec',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSpecTable(double fontSize, bool isTablet) {
    final rows = [
      ['10 Watt', 'AC 1000lm / DC 700lm', '70mm x 141mm', '80', '6500K', 'Cahaya Putih Kebiruan']
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Table(
        border: TableBorder.all(color: Colors.grey.shade300),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: isTablet
            ? {
                0: FixedColumnWidth(120),
                1: FixedColumnWidth(200),
                2: FixedColumnWidth(180),
                3: FixedColumnWidth(80),
                4: FixedColumnWidth(80),
                5: FixedColumnWidth(180),
              }
            : {
                0: FixedColumnWidth(100),
                1: FixedColumnWidth(160),
                2: FixedColumnWidth(150),
                3: FixedColumnWidth(60),
                4: FixedColumnWidth(70),
                5: FixedColumnWidth(160),
              },
        children: [
          _buildTableRow(
            ['Varian Watt', 'Lumen', 'Dimensi (Tinggi x Diameter)', 'Isi/Dus', 'Warna', 'Keterangan'],
            isHeader: true,
            fontSize: fontSize,
          ),
          for (var row in rows) _buildTableRow(row, isHeader: false, fontSize: fontSize),
        ],
      ),
    );
  }

  TableRow _buildTableRow(List<String> cells, {bool isHeader = false, required double fontSize}) {
    return TableRow(
      decoration: BoxDecoration(color: isHeader ? const Color(0xFF0B2240) : Colors.white),
      children: cells.map((text) {
        final isColor = text == '6500K';
        return Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.centerLeft,
          color: isColor ? Colors.lightBlueAccent : null,
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isHeader || isColor ? FontWeight.bold : FontWeight.normal,
              color: isHeader ? Colors.white : Colors.black87,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCompareImage(String imagePath, String title, double imageHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF162B4C),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(imagePath, height: imageHeight),
        ),
      ],
    );
  }

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
