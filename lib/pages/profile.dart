import 'package:flutter/material.dart';
import 'package:apps_nanolite/pages/home.dart';

import 'login.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFF061F3D), // Warna latar belakang disamakan
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.grey[200], // Warna AppBar disamakan
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Avatar
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: isTablet ? 80 : 60,
                  backgroundImage: const AssetImage('assets/images/avatar.jpg'),
                ),
              ),
              const SizedBox(height: 20),

              // Name and Title
              Text(
                'SALES',
                style: TextStyle(
                  fontSize: isTablet ? 26 : 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Karina Indah Puspa',
                style: TextStyle(
                  fontSize: isTablet ? 22 : 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Statistik
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildStatCard('Pengajuan', '0', isTablet),
                  _buildStatCard('Disetujui', '0', isTablet),
                  _buildStatCard('Ditolak', '0', isTablet),
                ],
              ),
              const SizedBox(height: 20),

              // Informasi user
              Container(
                padding: EdgeInsets.all(isTablet ? 20 : 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildUserInfo('Branch', 'Cengkareng', isTablet),
                    _buildUserInfo('Email', 'karina@gmail.com', isTablet),
                    _buildUserInfo('Phone', '0123456', isTablet),
                    _buildUserInfo('Department', 'Sales', isTablet),
                    _buildUserInfo('Status', 'Active', isTablet),
                    _buildUserInfo('Address', 'Jl. Raya Sudirman, RT 01 / RW 01, 1678', isTablet),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Tombol Logout
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 120 : 100,
                    vertical: isTablet ? 18 : 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: isTablet ? 20 : 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Kartu statistik
  Widget _buildStatCard(String label, String value, bool isTablet) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(isTablet ? 14 : 10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: isTablet ? 20 : 16,
                color: const Color(0xFF061F3D), // warna biru tua
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  // Info pengguna
  Widget _buildUserInfo(String title, String value, bool isTablet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF061F3D), // biru gelap
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
