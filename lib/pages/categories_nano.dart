import 'package:flutter/material.dart';

import 'bulb.dart';
import 'capsule.dart';
import 'create_sales_order.dart';
import 'emergency.dart';
import 'home.dart';
import 'profile.dart';

class CategoriesNanoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF061F3D),
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            Icon(Icons.shopping_basket, color: Colors.black),
            SizedBox(width: 8),
            Text('Categories', style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isTablet = constraints.maxWidth >= 600;
            int crossAxisCount = isTablet ? 3 : 2;

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.builder(
                      itemCount: 14,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) =>
                          _buildCategoryCard(context, index, isTablet),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),

      // ✅ Bottom Navigation Bar
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

  Widget _buildCategoryCard(BuildContext context, int index, bool isTablet) {
    List<String> categoryNames = [
      'Bulb', 'Capsule', 'Emergency', 'Multipack', 'Downlight Round', 'Downlight Square',
      'Power Supply', 'T8-Tube Light', 'Flood Light', 'Street Light 712', 'Street Light 711',
      'Light Strip 50M', 'Light Strip Indoor', 'Light Strip Outdoor'
    ];

    List<String> imagePaths = [
      'assets/images/bulb.png', 'assets/images/capsule.png', 'assets/images/emergency.png',
      'assets/images/MULTIPAK1.png', 'assets/images/round.png', 'assets/images/square.png',
      'assets/images/powersuplay1.png', 'assets/images/t81.png', 'assets/images/FloodLight00011.png',
      'assets/images/SL712.png', 'assets/images/SL711.png', 'assets/images/50m1.png',
      'assets/images/indoor1.png', 'assets/images/outdoor1.png'
    ];

    double imageSize = isTablet ? 100 : 70;

    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => BulbScreen()));
        } else if (index == 1) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => CapsuleScreen()));
        } else if (index == 2) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => EmergencyScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Halaman ${categoryNames[index]} belum tersedia')),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF12355C), // 🔵 Lebih muda dari background, tapi tetap gelap
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: imageSize,
              width: imageSize,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePaths[index]),
                  fit: (index == 3 || index == 7 || index == 10)
                      ? BoxFit.contain
                      : BoxFit.cover,
                  alignment: Alignment.center,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              categoryNames[index],
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? 16 : 14,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
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
