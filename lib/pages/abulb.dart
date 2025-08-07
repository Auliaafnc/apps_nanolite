import 'package:flutter/material.dart';

import 'create_sales_order.dart';
import 'home.dart';
import 'profile.dart';

class ABulbScreen extends StatelessWidget {
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
              icon: Icon(Icons.lightbulb_outline, color: Colors.black),
              label: Text('Pikolite', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Product A-Bulb',
              style: TextStyle(
                fontSize: isTablet ? 22 : 18,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),

            // Gambar + Spesifikasi
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Image.asset(
                    'assets/images/spekabulb1.png',
                    height: isTablet ? 200 : 150,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SPESIFIKASI',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800])),
                        SizedBox(height: 8),
                        _buildSpecLine('Tahan Sampai:', '15.000 Jam'),
                        _buildSpecLine('Fitting:', 'E27'),
                        _buildSpecLine('Hemat Energi:', '90%'),
                        _buildSpecLine('Lumen:', '100lm/Watt'),
                        _buildSpecLine('Tegangan:', '110~240V'),
                        _buildSpecLine('CRI:', '>80Ra'),
                      ],
                    ),
                  ),
                )
              ],
            ),

            SizedBox(height: 30),
            _buildTable(),

            SizedBox(height: 30),
            Text(
              'Perbandingan:',
              style: TextStyle(
                fontSize: isTablet ? 20 : 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Image.asset('assets/images/nanobulbspek.png'),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Image.asset('assets/images/productkomp.png'),
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

  Widget _buildSpecLine(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(title, style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildTable() {
    final headerStyle = TextStyle(fontWeight: FontWeight.bold, color: Colors.black);
    final rows = [
      ['3 Watt', '115mm', '60mm', '3000K', '6500K', 'Rp 12.900'],
      ['5 Watt', '115mm', '60mm', '3000K', '6500K', 'Rp 14.900'],
      ['7 Watt', '115mm', '55mm', '3000K', '6500K', 'Rp 16.900'],
      ['9 Watt', '125.5mm', '65mm', '3000K', '6500K', 'Rp 18.900'],
      ['12 Watt', '125.5mm', '65mm', '3000K', '6500K', 'Rp 19.900'],
      ['15 Watt', '137.5mm', '69.8mm', '3000K', '6500K', 'Rp 25.900'],
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: {
          for (int i = 0; i < 6; i++) i: FlexColumnWidth(),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(color: Colors.grey[300]),
            children: [
              for (var header in [
                'Watt', 'Tinggi', 'Diameter', 'Warm White', 'Cool Day Wight', 'Harga'
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
