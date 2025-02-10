import 'package:flutter/material.dart';
import 'package:ukk_2025/account/controller.dart';
import 'login.dart';

class ReadUser extends StatefulWidget {
  const ReadUser({super.key});

  @override
  State<ReadUser> createState() => _ReadUserState();
}

class _ReadUserState extends State<ReadUser> {
  // Menggunakan singleton Controller
  final Controller controller = Controller();
  final TextEditingController searchController = TextEditingController();

  // Data user yang ditampilkan (sudah difilter jika ada pencarian)
  List<Map<String, dynamic>> displayedUsers = [];

  @override
  void initState() {
    super.initState();
    // Pastikan data sudah ada (misalnya setelah login)
    displayedUsers = controller.userData;
  }

  // Fungsi untuk memfilter data user berdasarkan nama
  void filterUser(String query) {
    setState(() {
      if (query.isEmpty) {
        displayedUsers = controller.userData;
      } else {
        displayedUsers = controller.userData.where((user) {
          final namaUser = user['namaUser']?.toString().toLowerCase() ?? '';
          return namaUser.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  // Fungsi untuk melakukan logout
  Future<void> handleLogout() async {
    await controller.logout();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        backgroundColor: const Color(0xff79b356),
        title: const Text(
          "ACCOUNT",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xffffffff),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Color(0xffffffff)),
            onPressed: () {
              // Aksi jika tombol account ditekan (jika diperlukan)
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xffffffff)),
            onPressed: handleLogout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Field pencarian user
            TextField(
              controller: searchController,
              onChanged: filterUser,
              decoration: InputDecoration(
                hintText: "Cari User...",
                prefixIcon: const Icon(Icons.search, size: 24),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
            ),
            const SizedBox(height: 10),
            // ListView untuk menampilkan data user
            Expanded(
              child: ListView.builder(
                itemCount: displayedUsers.length,
                itemBuilder: (context, index) {
                  final user = displayedUsers[index];
                  return Card(
                    margin: const EdgeInsets.only(top: 10),
                    child: ListTile(
                      title: Text(
                        user['namaUser'] ?? '-',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email: ${user['email'] ?? '-'}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "Password: ${user['passwordUser'] ?? '-'}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
