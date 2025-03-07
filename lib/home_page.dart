import 'package:flutter/material.dart';
import 'package:pl2_kasir/pegawai/pegawai.dart';
import 'package:pl2_kasir/pelanggan/pelanggan.dart';
import 'package:pl2_kasir/profil.dart';
import 'package:pl2_kasir/transaksi/transaksi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pl2_kasir/produk/produk.dart';

class FlutterVizBottomNavigationBarModel {
  final IconData icon;
  final String label;

  FlutterVizBottomNavigationBarModel({
    required this.icon,
    required this.label,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String? namaPetugas;
  String? role;

  // Daftar item untuk Bottom Navigation Bar
  List<FlutterVizBottomNavigationBarModel> _bottomNavBarItems = [];

  // Halaman yang akan ditampilkan
  List<Widget> _pages = [];

  // Fungsi untuk mengambil data petugas
  Future<void> fetchPetugas() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      throw Exception('User tidak ditemukan. Silakan login terlebih dahulu.');
    }

    try {
      final response = await Supabase.instance.client
          .from('petugas')
          .select()
          .eq('account_id', user.id)
          .single();

      setState(() {
        namaPetugas = response['nama'];
        role = response['role'];
        configureNavigationBar();
      });
    } catch (error) {
      throw Exception('Gagal mengambil data petugas: $error');
    }
  }

  void configureNavigationBar() {
    if (role == 'admin') {
      _bottomNavBarItems = [
        FlutterVizBottomNavigationBarModel(
            icon: Icons.widgets, label: "Produk"),
        FlutterVizBottomNavigationBarModel(
            icon: Icons.perm_contact_calendar_sharp, label: "Pegawai"),
        FlutterVizBottomNavigationBarModel(
            icon: Icons.people_alt_rounded, label: "Pelanggan"),
        FlutterVizBottomNavigationBarModel(
            icon: Icons.manage_accounts_rounded, label: "Profile"),
      ];
      _pages = [
        const Produk(),
        const Pegawai(),
        const Pelanggan(),
        const ProfilPage()
      ];
    } else if (role == 'petugas') {
      _bottomNavBarItems = [
        FlutterVizBottomNavigationBarModel(
            icon: Icons.widgets, label: "Produk"),
        FlutterVizBottomNavigationBarModel(
            icon: Icons.add_shopping_cart, label: "Transaksi"),
        FlutterVizBottomNavigationBarModel(
            icon: Icons.manage_accounts_rounded, label: "Profile"),
      ];

      _pages = [const Produk(), const Transaksi(), const ProfilPage()];
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPetugas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      // Bottom Navigation Bar
      bottomNavigationBar: _bottomNavBarItems.isNotEmpty
          ? BottomNavigationBar(
              items: _bottomNavBarItems.map((item) {
                return BottomNavigationBarItem(
                  icon: Icon(item.icon),
                  label: item.label,
                );
              }).toList(),
              backgroundColor: const Color(0xffffffff),
              currentIndex: _currentIndex,
              elevation: 8,
              iconSize: 24,
              selectedItemColor: const Color(0xff608463),
              unselectedItemColor: const Color(0xff9e9e9e),
              selectedFontSize: 14,
              unselectedFontSize: 14,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              onTap: (index) {
                setState(() {
                  _currentIndex = index; // Menetapkan halaman yang aktif
                });
              },
            )
          : null,
      body: _pages.isNotEmpty
          ? _pages[_currentIndex]
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
