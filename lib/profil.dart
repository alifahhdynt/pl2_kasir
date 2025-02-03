import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Nama Pengguna',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'email@domain.com',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF388E3C),
              ),
            ),
            const SizedBox(height: 32),

            // Tombol Kembali
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Kembali",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 16),
            // Tombol Logout
            ElevatedButton(
              onPressed: () {
                _showLogoutAlert(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFFFF0000), // Red color for logout
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Logout",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Keluar'),
              onPressed: () {
                // Lakukan aksi logout (misalnya membersihkan session atau token)
                Navigator.of(context).pop(); // Menutup dialog
                _performLogout();
              },
            ),
          ],
        );
      },
    );
  }

  void _performLogout() {
    // Tambahkan logika logout di sini, seperti menghapus session atau token
    print('User has logged out');
  }
}
