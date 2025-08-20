// lib/pages/sl711.dart
import 'package:flutter/material.dart';

import 'categories_nano.dart';
import 'create_sales_order.dart';
import 'home.dart';
import 'profile.dart';

class StreetLight711Page extends StatelessWidget {
  const StreetLight711Page({super.key});

  @override
  Widget build(BuildContext context) {
    // ---- PALETTE ----
    const Color bgTop = Color(0xFF0B2741);
    const Color bgBottom = Color(0xFF0E3556);
    const Color card = Color(0xFF0F2D4B);
    const Color chip = Color(0xFF163E66);
    const Color pillLight = Color(0xFFE7EEF7);
    const Color pillText = Color(0xFF0F2D4B);
    const Color textPrimary = Colors.white;

    // Tabel
    const Color headerDark = Color(0xFF0B2741);
    const Color accentBlue = Color(0xFF1EA7FF); // biru muda untuk 6500K

    // ---- RESPONSIVE ----
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.width >= 600;
    final double hPad = isTablet ? 24 : 16;
    final double vPad = isTablet ? 18 : 12;
    final double heroH = isTablet ? 380 : 240;
    final double? compH = isTablet ? 300 : null;

    // ---- HELPERS ----
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
              errorBuilder: (_, __, ___) =>
                  const Center(child: Icon(Icons.broken_image, color: Colors.white70, size: 48)),
            ),
          ),
        );

    // Spesifikasi HANYA untuk hero (atas)
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

    // ===== TABEL VARIAN =====
    Widget th(String text) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      color: Colors.white, // ubah background header jadi putih
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black, // teks hitam
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );

    Widget td(String text, {bool highlight = false}) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          alignment: Alignment.center,
          decoration: highlight ? BoxDecoration(color: accentBlue) : const BoxDecoration(),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
              fontSize: 12,
            ),
          ),
        );

    Widget specTable() {
      final rows = [
        ['150 Watt', '19500lm/watt', '542mm x 214mm x 76mm', '10', '6500K', 'Cahaya Putih Kebiruan'],
      ];

      final table = Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(color: Colors.white, width: 1), // border antar sel putih
      columnWidths: const {
        0: FixedColumnWidth(110),
        1: FixedColumnWidth(130),
        2: FixedColumnWidth(200),
        3: FixedColumnWidth(80),
        4: FixedColumnWidth(100),
        5: FixedColumnWidth(180),
      },
      children: [
        TableRow(children: [
          th('Varian Watt'),
          th('Lumen'),
          th('Ukuran'),
          th('Isi/Dus'),
          th('Warna'),
          th('Keterangan'),
        ]),
        for (final r in rows)
          TableRow(children: [
            td(r[0]),
            td(r[1]),
            td(r[2]),
            td(r[3]),
            td(r[4], highlight: true),
            td(r[5]),
          ]),
      ],
    );


      return Container(
        decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: table),
      );
    }

    // Perbandingan: hanya judul + gambar (tanpa spesifikasi)
    Widget comparisonImageBlock({required String title, required String imagePath}) => Column(
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

    // ---- PAGE ----
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

            Text('Product Street Light 711',
                style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700, fontSize: isTablet ? 18 : 16)),
            SizedBox(height: vPad),

            // HERO
            LayoutBuilder(builder: (context, c) {
              final row = isTablet && c.maxWidth >= 680;
              final img = productImage('assets/images/streetlightnano.jpg', height: row ? heroH : null);
              final spec = specCard(const [
                'Tahan Sampai: 50.000 Jam',
                'Power Faktor: >0.5',
                'Tegangan: 100–300V (50/60Hz)',
                'Jenis: Lampu Jalan',
                'CRI: >85',
                'IP: 65',
                'Ukuran Lubang Tiang: 60mm',
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

            SizedBox(height: vPad),
            specTable(),

            SizedBox(height: vPad * 1.5),

            // ===== PERBANDINGAN: NANOLITE kiri, PRODUK LAIN kanan =====
            if (isTablet) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: comparisonImageBlock(
                      title: 'NANOLITE',
                      imagePath: 'assets/images/slnano.jpg',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: comparisonImageBlock(
                      title: 'PRODUK LAIN',
                      imagePath: 'assets/images/slkom.jpg',
                    ),
                  ),
                ],
              ),
            ] else ...[
              comparisonImageBlock(title: 'NANOLITE', imagePath: 'assets/images/slnano.jpg'),
              SizedBox(height: vPad * 1.5),
              comparisonImageBlock(title: 'PRODUK LAIN', imagePath: 'assets/images/slkom.jpg'),
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

// Bottom nav item (reusable)
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
