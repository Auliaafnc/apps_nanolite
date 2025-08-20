// lib/pages/t8tubelight.dart
import 'package:flutter/material.dart';

import 'categories_nano.dart';
import 'create_sales_order.dart';
import 'home.dart';
import 'profile.dart';

class T8TubeLightPage extends StatelessWidget {
  const T8TubeLightPage({super.key});

  @override
  Widget build(BuildContext context) {
    // PALETTE
    const Color bgTop = Color(0xFF0B2741);
    const Color bgBottom = Color(0xFF0E3556);
    const Color card = Color(0xFF0F2D4B);
    const Color chip = Color(0xFF163E66);
    const Color pillLight = Color(0xFFE7EEF7);
    const Color pillText = Color(0xFF0F2D4B);
    const Color textPrimary = Colors.white;
    const Color textSecondary = Color(0xFFB8D1EA);

    // Table accents
    const Color headerBg = Colors.white; // putih
    const Color headerText = Colors.black; // hitam
    const Color accentBlue = Color(0xFF03A9F4); // 7000K biru penuh

    // RESPONSIVE
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.width >= 600;
    final double hPad = isTablet ? 24 : 16;
    final double vPad = isTablet ? 18 : 12;
    final double heroH = isTablet ? 360 : 220;       // hero image lebih besar di tablet
    final double? compImgH = isTablet ? 320 : null;  // tinggi image perbandingan di tablet

    // Helpers
    Widget brandChip() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: chip, borderRadius: BorderRadius.circular(32)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.lightbulb_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('Nanolite', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ],
          ),
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

    Widget specPill() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: pillLight, borderRadius: BorderRadius.circular(12)),
          child: const Text(
            'Spesifikasi',
            style: TextStyle(fontWeight: FontWeight.w800, color: pillText),
          ),
        );

    Widget bullet(String label, String value, {bool bold = false}) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.white, height: 1.3),
              children: [
                TextSpan(
                    text: '$label: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: bold ? Colors.white : textSecondary,
                    )),
                TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        );

    // Kartu spesifikasi untuk hero
    Widget heroSpecCard({double? height}) => Container(
          height: height,
          decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(18)),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: specPill()),
              SizedBox(height: isTablet ? 16 : 12),
              bullet('Tahan Sampai', '25.000 Jam', bold: true),
              bullet('LED', '60-2835'),
              bullet('Hemat Energi', '90%'),
              bullet('CRI', '>80'),
              if (height != null) const Spacer(),
            ],
          ),
        );

    // ===== TABEL VARIAN (sesuai gambar) =====
    Widget th(String text) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          color: headerBg,
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: headerText,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        );

    Widget tdText(String text) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          alignment: Alignment.center,
          child: Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
        );

    Widget tdColor(String text, Color bg) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          alignment: Alignment.center,
          color: bg, // full background
          child: Text(text,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
        );

    Widget specTable() {
      final table = Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(color: Colors.white, width: 1), // garis putih antar kolom
        columnWidths: const {
          0: FixedColumnWidth(120), // Varian Watt
          1: FixedColumnWidth(140), // Lumen
          2: FixedColumnWidth(200), // Ukuran
          3: FixedColumnWidth(110), // Warna
          4: FixedColumnWidth(240), // Keterangan
        },
        children: [
          TableRow(children: [
            th('Varian Watt'),
            th('Lumen'),
            th('Ukuran'),
            th('Warna'),
            th('Keterangan'),
          ]),
          TableRow(children: [
            tdText('18 Watt'),
            tdText('100lm/watt'),
            tdText('28mm x 1200mm'),
            tdColor('7000K', accentBlue),
            tdText('Cahaya Putih Kebiruan'),
          ]),
        ],
      );

      return Container(
        decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: table,
        ),
      );
    }

    // Baris perbandingan: kiri-kanan (tablet), stack (hp)
    Widget comparisonRow() => LayoutBuilder(
          builder: (context, c) {
            final row = isTablet && c.maxWidth >= 680;

            Widget leftCol = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NANOLITE',
                    style: TextStyle(
                        color: textPrimary, fontWeight: FontWeight.w800, fontSize: isTablet ? 18 : 16)),
                SizedBox(height: vPad),
                productImage('assets/images/t8nano.jpg', height: compImgH),
              ],
            );

            Widget rightCol = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PRODUK LAIN',
                    style: TextStyle(
                        color: textPrimary, fontWeight: FontWeight.w800, fontSize: isTablet ? 18 : 16)),
                SizedBox(height: vPad),
                productImage('assets/images/t8kom.jpg', height: compImgH),
              ],
            );

            if (row) {
              return Row(
                children: [
                  Expanded(child: leftCol),
                  const SizedBox(width: 12),
                  Expanded(child: rightCol),
                ],
              );
            }
            return Column(
              children: [
                leftCol,
                SizedBox(height: vPad * 1.5),
                rightCol,
              ],
            );
          },
        );

    // PAGE
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

            // Judul
            Text('Product T-8 Tube Light',
                style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700, fontSize: isTablet ? 18 : 16)),
            SizedBox(height: vPad),

            // HERO: gambar + spesifikasi di samping (tablet), stack (hp)
            LayoutBuilder(
              builder: (context, c) {
                final row = isTablet && c.maxWidth >= 680;
                final img = productImage('assets/images/t8nanolite.jpg', height: row ? heroH : null);
                final spec = heroSpecCard(height: row ? heroH : null);

                if (row) {
                  return Row(
                    children: [
                      Expanded(child: img),
                      const SizedBox(width: 12),
                      Expanded(child: spec),
                    ],
                  );
                }
                return Column(
                  children: [
                    img,
                    SizedBox(height: vPad),
                    spec,
                  ],
                );
              },
            ),

            SizedBox(height: vPad * 1.5),

            // ===== TABEL VARIAN DI TENGAH (di atas perbandingan) =====
            specTable(),

            SizedBox(height: vPad * 1.5),

            // PERBANDINGAN: kiri-kanan
            comparisonRow(),
          ],
        ),
      ),

      // Bottom nav
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

// Reusable nav item
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
