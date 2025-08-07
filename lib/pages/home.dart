import 'package:flutter/material.dart';

import 'categories_nano.dart';
import 'categories_piko.dart';
import 'create_sales_order.dart';
import 'customer.dart';
import 'garansi.dart';
import 'profile.dart';
import 'return.dart';
import 'sales_order.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final double padding = isTablet ? 40.0 : 20.0;

    return Scaffold(
      backgroundColor: const Color(0xFF061F3D),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(backgroundColor: Colors.grey[200], elevation: 0),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Banner
              Container(
                width: double.infinity,
                child: AspectRatio(
                  aspectRatio: isTablet ? 16 / 5 : 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/banner.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Nanolite & Pikolite
              Wrap(
                spacing: 30,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  _buildCircleIcon(
                    Icons.lightbulb,
                    'Nanolite',
                    () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => CategoriesNanoScreen()));
                    },
                    isTablet,
                  ),
                  _buildCircleIcon(
                    Icons.lightbulb_outline,
                    'Pikolite',
                    () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => CategoriesPikoScreen()));
                    },
                    isTablet,
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Judul Operational
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Operational',
                  style: TextStyle(
                    fontSize: isTablet ? 28 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Grid 2 Kolom
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: isTablet ? 1.8 : 1.6,
                children: [
                  _buildBoxIcon(Icons.account_box, 'Customer', () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerScreen()));
                  }, isTablet),
                  _buildBoxIcon(Icons.shopping_cart, 'Sales Order', () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => SalesOrderScreen()));
                  }, isTablet),
                  _buildBoxIcon(Icons.history, 'Return', () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ReturnScreen()));
                  }, isTablet),
                  _buildBoxIcon(Icons.star, 'Garansi', () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => GaransiScreen()));
                  }, isTablet),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      // Bottom Nav
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

  // Kategori: Nanolite dan Pikolite
  Widget _buildCircleIcon(IconData icon, String label, VoidCallback onPressed, bool isTablet) {
    final double iconSize = isTablet ? 60 : 48;
    final double paddingSize = isTablet ? 28 : 20;
    final double fontSize = isTablet ? 18 : 14;

    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(paddingSize),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: iconSize, color: const Color(0xFF061F3D)),
          ),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: Colors.white, fontSize: fontSize)),
        ],
      ),
    );
  }

  // Menu kotak
  Widget _buildBoxIcon(IconData icon, String label, VoidCallback onPressed, bool isTablet) {
    final double iconSize = isTablet ? 40 : 28;
    final double fontSize = isTablet ? 16 : 13;
    final double boxWidth = isTablet ? 160 : 140;
    final double boxHeight = isTablet ? 100 : 85;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: boxWidth,
        height: boxHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 4,
              spreadRadius: 1,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize, color: const Color(0xFF061F3D)),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: const Color(0xFF061F3D), fontSize: fontSize)),
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
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
