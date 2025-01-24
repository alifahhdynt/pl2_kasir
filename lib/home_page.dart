import 'package:flutter/material.dart';
import 'package:pl2_kasir/pegawai.dart';
import 'package:pl2_kasir/login.dart';
import 'package:pl2_kasir/pelanggan.dart';
import 'package:pl2_kasir/transaksiv.dart';
// import 'package:pl2_kasir/tambah_produk.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'edit_produk.dart';
import 'produk.dart';

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

  List<Map<String, dynamic>> produks = [];
  final user = Supabase.instance.client.auth.currentUser;

  // Daftar item untuk Bottom Navigation Bar
  final List<FlutterVizBottomNavigationBarModel> _bottomNavBarItems = [
    FlutterVizBottomNavigationBarModel(icon: Icons.widgets, label: "Produk"),
    FlutterVizBottomNavigationBarModel(
        icon: Icons.add_shopping_cart, label: "Transaksi"),
        FlutterVizBottomNavigationBarModel(icon: Icons.perm_contact_calendar_sharp, label: "Petugas"),
    FlutterVizBottomNavigationBarModel(
        icon: Icons.people_alt_rounded, label: "Pelanggan"),
        FlutterVizBottomNavigationBarModel(icon: Icons.manage_accounts_rounded, label: "Profile"),
  ];

  // Halaman yang akan ditampilkan
  final List<Widget> _pages = [
    const Produk(), 
    const transaksiv(), 
    Pegawai(),
    Pelanggan(),

  ];

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
      });
    } catch (error) {
      throw Exception('Gagal mengambil data petugas: $error');
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
      bottomNavigationBar: BottomNavigationBar(
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
      ),
      body: _pages[_currentIndex],
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(55),
      //   child: Container(
      //     width: double.infinity,
      //     decoration: BoxDecoration(
      //       color: Colors.green[600],
      //       border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
      //     ),
      //     child: Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Row(
      //             children: [
      //               const Icon(
      //                 Icons.account_circle,
      //                 color: Colors.white,
      //                 size: 45,
      //               ),
      //               const SizedBox(width: 8),
      //               Text(
      //                 namaPetugas ?? "Memuat...",
      //                 style: const TextStyle(
      //                   fontWeight: FontWeight.w600,
      //                   fontSize: 18,
      //                   color: Colors.white,
      //                 ),
      //               ),
      //             ],
      //           ),
      //           Row(
      //             children: [
      //               IconButton(
      //                 icon: const Icon(Icons.login, color: Colors.white),
      //                 onPressed: () async {
      //                   await Supabase.instance.client.auth.signOut();
      //                   Navigator.pushReplacement(
      //                     context,
      //                     MaterialPageRoute(
      //                         builder: (context) => const Login()),
      //                   );
      //                 },
      //               ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
