import 'package:flutter/material.dart';

import 'create_sales_order.dart';
import 'home.dart';
import 'profile.dart';

class BulbScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFF061F3D),
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('nanopiko', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.lightbulb, color: Colors.black),
              label: Text('Nanolite', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Product Bulb',
              style: TextStyle(
                fontSize: isTablet ? 22 : 18,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            Center(
              child: Image.asset(
                'assets/images/spekbulb.png',
                width: isTablet ? 300 : 200,
              ),
            ),
            SizedBox(height: 24),
            _buildTable(),
            SizedBox(height: 30),
            Text(
              'Perbandingan:',
              style: TextStyle(
                fontSize: isTablet ? 20 : 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/nanobulbspek.png',
                      height: isTablet ? 220 : 160,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/productkomp.png',
                      height: isTablet ? 220 : 160,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
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

  Widget _buildTable() {
    final headerStyle = TextStyle(fontWeight: FontWeight.bold, color: Colors.black);
    final rows = [
      ['5 Watt', '840ml', '115mm', '60mm', '100', '3000K', '6500K', 'Rp 30.900'],
      ['7 Watt', '600ml', '105mm', '55mm', '100', '3000K', '6500K', 'Rp 23.900'],
      ['9 Watt', '1080ml', '110mm', '65mm', '100', '3000K', '6500K', 'Rp 35.900'],
      ['12 Watt', '1440ml', '125.5mm', '55mm', '100', '3000K', '6500K', 'Rp 42.900'],
      ['15 Watt', '1800ml', '137.5mm', '69.8mm', '100', '3000K', '6500K', 'Rp 50.900'],
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: {
            for (int i = 0; i < 8; i++) i: FixedColumnWidth(100),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey[300]),
              children: [
                for (var header in [
                  'Watt', 'Lumen', 'Tinggi', 'Diameter', 'Isi/Dus',
                  'Warm White', 'Cool Day', 'Harga'
                ])
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(child: Text(header, style: headerStyle)),
                  )
              ],
            ),
            ...rows.map((row) {
              return TableRow(
                decoration: BoxDecoration(color: Color(0xFF061F3D)),
                children: row.map((cell) {
                  final isColor = cell == '3000K' || cell == '6500K';
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        cell,
                        style: TextStyle(
                          color: isColor
                              ? (cell == '3000K' ? Colors.yellow[700] : Colors.blue[300])
                              : Colors.white,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }).toList(),
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
          SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
