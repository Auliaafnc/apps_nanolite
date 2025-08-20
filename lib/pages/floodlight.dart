// lib/pages/floodlight.dart
import 'package:flutter/material.dart';

import 'categories_nano.dart';
import 'create_sales_order.dart';
import 'home.dart';
import 'profile.dart';

class FloodLightPage extends StatelessWidget {
  const FloodLightPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ----- PALETTE -----
    const Color bgTop = Color(0xFF0B2741);
    const Color bgBottom = Color(0xFF0E3556);
    const Color card = Color(0xFF0F2D4B);
    const Color chip = Color(0xFF163E66);
    const Color pillLight = Color(0xFFE7EEF7);
    const Color pillText = Color(0xFF0F2D4B);
    const Color textPrimary = Colors.white;

    // Tabel accents
    const Color headerDark = Colors.white; // Header background putih
    const Color headerTextColor = Colors.black; // Header font hitam
    const Color borderColor = Colors.white; // Garis sekat putih
    const Color accentBlue = Color(0xFF03A9F4); // 6500K
    const Color accentYellow = Color(0xFFFFC107); // 3000K

    // ----- RESPONSIVE -----
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.width >= 600;
    final double hPad = isTablet ? 24 : 16;
    final double vPad = isTablet ? 18 : 12;
    final double heroH = isTablet ? 360 : 230; // gambar hero lebih besar di tablet
    final double? compH = isTablet ? 280 : null; // tinggi kartu perbandingan di tablet

    // ----- HELPERS -----
    Widget brandChip() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: chip, borderRadius: BorderRadius.circular(32)),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('Nanolite', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ],
          ),
        );

    Widget specPill() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: pillLight, borderRadius: BorderRadius.circular(20)),
          child: const Text(
            'SPESIFIKASI',
            style: TextStyle(color: pillText, fontWeight: FontWeight.w800, letterSpacing: .3),
          ),
        );

    Widget bullet(String text, {bool bold = false}) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.only(top: 6), child: Icon(Icons.circle, size: 6, color: Colors.white)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: textPrimary, fontWeight: bold ? FontWeight.w800 : FontWeight.w600),
                softWrap: true,
              ),
            ),
          ],
        );

    Widget productImage(String path, {double? height}) => Container(
          height: height,
          decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(18)),
          padding: const EdgeInsets.all(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              path,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Center(
                child: Icon(Icons.broken_image, color: Colors.white70, size: 48),
              ),
            ),
          ),
        );

    // Kartu spesifikasi (HANYA untuk hero / bagian atas)
    Widget specCard(List<String> points, {double? height}) => Container(
          height: height,
          decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(18)),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: specPill()),
              SizedBox(height: isTablet ? 16 : 12),
              for (int i = 0; i < points.length; i++) ...[
                bullet(points[i], bold: i == 0),
                const SizedBox(height: 8),
              ],
              if (height != null) const Spacer(),
            ],
          ),
        );

    // ====== TABEL VARIAN ======
    Widget th(String text) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          color: headerDark, // putih
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: headerTextColor, // hitam
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        );

    Widget tdText(String text) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        );

    Widget tdColor(String text, Color bg) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          alignment: Alignment.center,
          color: bg,
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
          ),
        );

    Widget specTable() {
      final rows = [
        {
          'watt': '20 Watt',
          'lumen': '2400lm',
          'ukuran': '104mm x 120,4mm x 22,8mm',
          'isi': '20',
          'warna1': tdColor('6500K', accentBlue),
          'ket1': 'Cahaya Putih Kebiruan',
          'warna2': tdColor('3000K', accentYellow),
          'ket2': 'Cahaya Putih Kekuningan',
        },
        {
          'watt': '50 Watt',
          'lumen': '6000lm',
          'ukuran': '164,2mm x 194,9mm x 31,7mm',
          'isi': '20',
          'warna1': tdColor('6500K', accentBlue),
          'ket1': 'Cahaya Putih Kebiruan',
          'warna2': tdColor('3000K', accentYellow),
          'ket2': 'Cahaya Putih Kekuningan',
        },
        {
          'watt': '100 Watt',
          'lumen': '12000lm',
          'ukuran': '198,6mm x 233,8mm x 33mm',
          'isi': '10',
          'warna1': tdColor('6500K', accentBlue),
          'ket1': 'Cahaya Putih Kebiruan',
          'warna2': tdColor('3000K', accentYellow),
          'ket2': 'Cahaya Putih Kekuningan',
        },
      ];

      final table = Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(color: borderColor, width: 1), // garis putih
        columnWidths: const {
          0: FixedColumnWidth(120),
          1: FixedColumnWidth(100),
          2: FixedColumnWidth(260),
          3: FixedColumnWidth(70),
          4: FixedColumnWidth(90),
          5: FixedColumnWidth(200),
          6: FixedColumnWidth(90),
          7: FixedColumnWidth(200),
        },
        children: [
          TableRow(children: [
            th('Varian Watt'),
            th('Lumen'),
            th('Ukuran'),
            th('Isi/Dus'),
            th('Warna'),
            th('Keterangan'),
            th('Warna'),
            th('Keterangan'),
          ]),
          for (final r in rows)
            TableRow(children: [
              tdText(r['watt'] as String),
              tdText(r['lumen'] as String),
              tdText(r['ukuran'] as String),
              tdText(r['isi'] as String),
              r['warna1'] as Widget,
              tdText(r['ket1'] as String),
              r['warna2'] as Widget,
              tdText(r['ket2'] as String),
            ]),
        ],
      );

      return Container(
        decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: table),
      );
    }

    // Kartu perbandingan
    Widget comparisonImageBlock({
      required String title,
      required String imagePath,
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: textPrimary, fontWeight: FontWeight.w800, fontSize: isTablet ? 18 : 16),
          ),
          SizedBox(height: vPad),
          productImage(imagePath, height: compH),
        ],
      );
    }

    // ----- PAGE -----
    return Scaffold(
      backgroundColor: bgBottom,
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const CategoriesNanoScreen()),
              );
            }
          },
        ),
        title: const Text('nanopiko', style: TextStyle(color: Colors.black)),
        centerTitle: false,
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [bgTop, bgBottom]),
        ),
        child: ListView(
          padding: EdgeInsets.fromLTRB(hPad, vPad, hPad, vPad + 16),
          children: [
            brandChip(),
            SizedBox(height: vPad),

            Text('Product Flood Light',
                style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700, fontSize: isTablet ? 18 : 16)),
            SizedBox(height: vPad),

            // HERO
            LayoutBuilder(builder: (context, c) {
              final row = isTablet && c.maxWidth >= 680;
              final img = productImage('assets/images/floodlightnano.jpg', height: row ? heroH : null);
              final spec = specCard(const [
                'Tahan Sampai: 30.000 Jam',
                'Power Faktor: >0.5',
                'Tegangan: 100-250V',
                'Jenis: Lampu Sorot',
                'CRI: >80',
                'IP: 65',
              ], height: row ? heroH : null);

              if (row) {
                return Row(children: [
                  Expanded(child: img),
                  const SizedBox(width: 12),
                  Expanded(child: spec),
                ]);
              }
              return Column(children: [img, SizedBox(height: vPad), spec]);
            }),

            SizedBox(height: vPad * 1.5),

            // TABEL VARIAN
            specTable(),

            SizedBox(height: vPad * 1.5),

            // PERBANDINGAN
            if (isTablet) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: comparisonImageBlock(
                      title: 'NANOLITE',
                      imagePath: 'assets/images/flnano.jpg',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: comparisonImageBlock(
                      title: 'PRODUK LAIN',
                      imagePath: 'assets/images/flkom.jpg',
                    ),
                  ),
                ],
              ),
            ] else ...[
              comparisonImageBlock(
                title: 'NANOLITE',
                imagePath: 'assets/images/flnano.jpg',
              ),
              SizedBox(height: vPad * 1.5),
              comparisonImageBlock(
                title: 'PRODUK LAIN',
                imagePath: 'assets/images/flkom.jpg',
              ),
            ],
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -2))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home, 'Home', onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
              }),
              _navItem(Icons.shopping_cart, 'Create Order', onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => CreateSalesOrderScreen()));
              }),
              _navItem(Icons.person, 'Profile', onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// Bottom nav item
Widget _navItem(IconData icon, String label, {required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.black87),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.black87, fontSize: 12)),
      ],
    ),
  );
}
