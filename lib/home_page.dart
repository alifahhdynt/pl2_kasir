import 'package:flutter/material.dart';
// import 'package:pl2_kasir/tambah_produk.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'edit_produk.dart';
import 'delete.dart';

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
  String? namaPetugas; // Untuk menyimpan nama petugas
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaProdukController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();

  List<Map<String, dynamic>> produks = [];

  final List<FlutterVizBottomNavigationBarModel> _bottomNavBarItems = [
    FlutterVizBottomNavigationBarModel(icon: Icons.widgets, label: "Produk"),
    FlutterVizBottomNavigationBarModel(
        icon: Icons.add_shopping_cart, label: "Transaksi"),
  ];

  Future<void> _addProduk() async {
    if (_formKey.currentState!.validate()) {
      final nama = _namaProdukController.text;
      final harga = int.tryParse(_hargaController.text) ?? 0;
      final stok = int.tryParse(_stokController.text) ?? 0;

      if (!_formKey.currentState!.validate()) {
        return;
      }

      try {
        final response = await Supabase.instance.client.from('produk').insert([
          {
            'namaProduk': nama, // Sesuaikan dengan database
            'harga': harga,
            'stok': stok,
          },
        ]).select();
        if (response.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Produk berhasil ditambahkan!'),
            ),
          );

          _namaProdukController.clear();
          _hargaController.clear();
          _stokController.clear();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
          ),
        );
      }
    }
  }

  final List<Widget> _pages = [
    const Center(child: Text("Produk Page")),
    const Center(child: Text("Transaksi Page")),
  ];

  Future<void> fetchPetugas() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      throw Exception('User tidak ditemukan. Silakan login terlebih dahulu.');
    }

    try {
      final response = await Supabase.instance.client
          .from('petugas')
          .select('nama')
          .eq('account_id', user.id)
          .single();

      // Periksa apakah response valid
      setState(() {
        namaPetugas = response['nama'];
      });
    } catch (error) {
      throw Exception('Gagal mengambil data petugas: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPetugas();
    fetchProduks();
  }

  Future<void> fetchProduks() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return;
    }

    try {
      final response = await Supabase.instance.client.from('produk').select();
      // .eq('userID', user.id);

      if (response != null && response.isNotEmpty) {
        setState(() {
          produks = List<Map<String, dynamic>>.from(response);
        });
      } else {
        debugPrint("No produk found for user");
      }
    } catch (error) {
      debugPrint("Error fetching produk: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
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
            _currentIndex = index;
          });
        },
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.green[600],
                  border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.account_circle,
                            color: Colors.white,
                            size: 45,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            namaPetugas ?? "Memuat...",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon:
                                const Icon(Icons.refresh, color: Colors.white),
                            onPressed: () {
                              fetchProduks();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.login, color: Colors.white),
                            onPressed: () {
                              // Tambahkan aksi logout di sini
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Produk List
              Expanded(
                child: Column(
                  
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: produks.length,
                        padding: const EdgeInsets.all(15),
                        itemBuilder: (context, index) {
                          final produk = produks[index];
                          return Column(
                            children: [
                              ListTile(
                                tileColor: const Color(0xffffffff),
                                title: Text(
                                  produk['namaProduk'] ?? '-',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color(0xff000000),
                                  ),
                                ),
                                subtitle: Text(
                                  "Rp. ${produk['harga'] ?? '-'} - Stok: ${produk['stok'] ?? '-'}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color(0xff000000),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: const BorderSide(
                                    color: Color(0x4d9e9e9e),
                                    width: 1,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Color(0xff212435),
                                        size: 24,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditProduk(
                                              produk: produk,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 24,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Hapus Data'),
                                              content: const Text(
                                                  'Apakah Anda yakin untuk menghapus data?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Kembali'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await delete(
                                                        produk['produkID']);
                                                    Navigator.of(context).pop();
                                                    fetchProduks(); // Refresh data
                                                  },
                                                  child: const Text(
                                                    'Hapus',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Tambah Produk'),
                      content: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 400,
                            maxHeight: 300,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                TextFormField(
                                  controller: _namaProdukController,
                                  obscureText: false,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Masukkan nama produk!';
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14,
                                    color: Color(0xff000000),
                                  ),
                                  decoration: InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      borderSide: const BorderSide(
                                          color: Color(0xff000000), width: 1),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      borderSide: const BorderSide(
                                          color: Color(0xff000000), width: 1),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      borderSide: const BorderSide(
                                          color: Color(0xff000000), width: 1),
                                    ),
                                    hintText: "Nama Produk",
                                    hintStyle: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14,
                                      color: Color(0xff000000),
                                    ),
                                    filled: false,
                                    fillColor: const Color(0xfff2f2f3),
                                    isDense: false,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  child: TextFormField(
                                    controller: _hargaController,
                                    obscureText: false,
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Masukkan harga produk!';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14,
                                      color: Color(0xff000000),
                                    ),
                                    decoration: InputDecoration(
                                      disabledBorder: UnderlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xff000000), width: 1),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xff000000), width: 1),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xff000000), width: 1),
                                      ),
                                      hintText: "Harga",
                                      hintStyle: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        color: Color(0xff000000),
                                      ),
                                      filled: false,
                                      fillColor: const Color(0xfff2f2f3),
                                      isDense: false,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  child: TextFormField(
                                    controller: _stokController,
                                    obscureText: false,
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Masukkan stok produk!';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14,
                                      color: Color(0xff000000),
                                    ),
                                    decoration: InputDecoration(
                                      disabledBorder: UnderlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xff000000), width: 1),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xff000000), width: 1),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xff000000), width: 1),
                                      ),
                                      hintText: "Stok",
                                      hintStyle: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        color: Color(0xff000000),
                                      ),
                                      filled: false,
                                      fillColor: const Color(0xfff2f2f3),
                                      isDense: false,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: MaterialButton(
                                    onPressed: _addProduk,
                                    color: const Color(0xff76a975),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(
                                          color: Color(0xff808080), width: 0),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    textColor: const Color(0xffffffff),
                                    height: 40,
                                    minWidth: 140,
                                    child: const Text(
                                      "SIMPAN",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(14),
                backgroundColor: Colors.green[300],
              ),
              child: const Icon(
                Icons.add_rounded,
                size: 34,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
