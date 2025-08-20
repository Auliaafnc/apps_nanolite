import 'package:flutter/material.dart';
import 'package:mobile_nano/pages/categories_nano.dart';

import 'create_sales_order.dart';
import 'home.dart';
import 'profile.dart';

class PowerSupplyPage extends StatelessWidget {
  const PowerSupplyPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ---- PALETTE ----
    const Color bgTop = Color(0xFF0B2741);
    const Color bgBottom = Color(0xFF0E3556);
    const Color card = Color(0xFF0F2D4B);
    const Color chip = Color(0xFF163E66);
    const Color textPrimary = Colors.white;
    const Color whiteColor = Colors.white;
    const Color blackColor = Colors.black;

    // Warna khusus isi tabel (dari gambar kamu)
    const Color tableCellBg = Color(0xFF0B2741);

    // ---- RESPONSIVE ----
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.width >= 600;
    final double hPad = isTablet ? 24 : 16;
    final double vPad = isTablet ? 18 : 12;

    // Gambar lebih besar di tablet
    final double productCardH = isTablet ? 380 : 220;

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

    Widget productImage(String path) => Container(
          height: productCardH,
          decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(18)),
          padding: const EdgeInsets.all(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              path, // contoh: assets/images/psupply.jpg
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Center(child: Icon(Icons.broken_image, color: Colors.white70, size: 48)),
            ),
          ),
        );

    // -------- TABLE UTILS --------
    Widget th(String text) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          color: whiteColor, // header putih
          alignment: Alignment.center,
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

    Widget tdColor(String text, Color bg, {bool dark = false}) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          alignment: Alignment.center,
          color: bg,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: dark ? blackColor : whiteColor,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        );

    Widget specTable() {
      final table = Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(color: Colors.white24, width: 1),
        columnWidths: const {
          0: FixedColumnWidth(220), // Input
          1: FixedColumnWidth(260), // Output
          2: FixedColumnWidth(260), // Lumen
        },
        children: [
          TableRow(children: [
            th('Input'),
            th('Output'),
            th('Lumen'),
          ]),
          TableRow(children: [
            tdColor('100-240Vac', tableCellBg), // Input
            tdColor('+12V=5A 60W Max', tableCellBg), // Output
            tdColor('114mm x 28mm x 47mm', tableCellBg), // Lumen
          ]),
        ],
      );

      return Container(
        decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: table),
      );
    }

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

            Text('Product Power Supply',
                style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700, fontSize: isTablet ? 18 : 16)),
            SizedBox(height: vPad),

            // Hanya gambar
            productImage('assets/images/psupply.jpg'),

            SizedBox(height: vPad),

            // Hanya tabel
            specTable(),
          ],
        ),
      ),

      // Bottom Navigation (kapsul)
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
