import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'struk.dart';
import 'controller.dart';

class Transaksi extends StatefulWidget {
  const Transaksi({super.key});

  @override
  TransaksiState createState() => TransaksiState();
}

class TransaksiState extends State<Transaksi> {
  final TextEditingController _produkController = TextEditingController();
  final produkController = Supabase.instance.client;
  List<Map<String, dynamic>> listProduk = [];
  List<Map<String, dynamic>> listPesanan = [];
  List<Map<String, dynamic>> filteredProduk = [];
  List<Map<String, dynamic>> listPelanggan = [];
  Map<String, dynamic>? selectedPelanggan;
  bool showDropdown = false;
  int totalPesanan = 0;

  @override
  void initState() {
    super.initState();
    fetchProduks();
    fetchPelanggans();
  }

  Future<void> fetchProduks() async {
    try {
      final response = await produkController.from('produk').select();
      if (response != null) {
        setState(() {
          listProduk = List<Map<String, dynamic>>.from(response);
          filteredProduk = List<Map<String, dynamic>>.from(response);
        });
      } else {
        debugPrint("Produk kosong atau response null.");
      }
    } catch (e) {
      debugPrint('Eror mengambil produk: $e');
    }
  }

  Future<void> fetchPelanggans() async {
    try {
      final response = await produkController.from('pelanggan').select();
      if (response != null) {
        setState(() {
          listPelanggan = List<Map<String, dynamic>>.from(response);
        });
      } else {
        debugPrint("Pelanggan kosong atau response null.");
      }
    } catch (e) {
      debugPrint('Eror mengambil pelanggan: $e');
    }
  }

  void addToCart(Map<String, dynamic> produk) {
    setState(() {
      var existingProduct = listPesanan
          .indexWhere((item) => item['produkID'] == produk['produkID']);
      if (existingProduct >= 0) {
        listPesanan[existingProduct]['total'] += 1;
      } else {
        listPesanan.add({
          'produkID': produk['produkID'],
          'namaProduk': produk['namaProduk'],
          'harga': produk['harga'],
          'stok': produk['stok'],
          'total': 1,
        });
      }
    });
    kalkulatorTotalPesanan();
  }

  void updateCartQuantity(int index, int delta) {
    setState(() {
      int stokTersedia = listProduk.firstWhere(
        (produk) => produk['produkID'] == listPesanan[index]['produkID'],
        orElse: () => {'stok': 0},
      )['stok'];

      int currentQuantity = listPesanan[index]['total'];

      // Tambahkan delta jika tidak melebihi stok
      if (delta > 0 && currentQuantity < stokTersedia) {
        listPesanan[index]['total'] += delta;
      } else if (delta < 0 && currentQuantity > 1) {
        listPesanan[index]['total'] += delta;
      } else if (delta > 0 && currentQuantity >= stokTersedia) {
        // Keterangan jika melebihi stok tersedia
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Tidak bisa menambah lebih dari stok tersedia!.",
            ),
          ),
        );
      }
    });

    kalkulatorTotalPesanan();
  }

  void removeFromCart(int index) {
    setState(() {
      listPesanan.removeAt(index);
    });
    kalkulatorTotalPesanan();
  }

  void kalkulatorTotalPesanan() {
    setState(() {
      totalPesanan = listPesanan.fold(
        0,
        (previousValue, item) =>
            previousValue + (item['harga'] as int) * (item['total'] as int),
      );
    });
  }

  void filterProduk(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProduk = List<Map<String, dynamic>>.from(listProduk);
      } else {
        filteredProduk = listProduk.where((produk) {
          return produk['namaProduk']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        backgroundColor: const Color(0xffa7db7b),
        title: const Text(
          "TAMBAH TRANSAKSI",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xffffffff),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: _produkController,
                  onChanged: (value) {
                    filterProduk(value);
                    setState(() {
                      showDropdown = value.isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Cari Produk...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xfff2f2f3),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: listPesanan.length,
                  itemBuilder: (context, index) {
                    final pesanan = listPesanan[index];
                    return ListTile(
                      title: Text(pesanan['namaProduk']),
                      subtitle: Text(
                          "Rp. ${pesanan['harga']} x ${pesanan['total']} = Rp. ${pesanan['harga'] * pesanan['total']}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => updateCartQuantity(index, -1),
                            icon: const Icon(Icons.remove, color: Colors.red),
                          ),
                          Text('${pesanan['total']}'),
                          IconButton(
                            onPressed: () => updateCartQuantity(index, 1),
                            icon: const Icon(Icons.add, color: Colors.green),
                          ),
                          IconButton(
                            onPressed: () => removeFromCart(index),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0x4dffffff), width: 1),
                ),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DropdownButton<Map<String, dynamic>>(
                            value: selectedPelanggan,
                            hint: const Text("Pilih Pelanggan"),
                            onChanged: (Map<String, dynamic>? newValue) {
                              setState(() {
                                selectedPelanggan = newValue;
                              });
                            },
                            items: listPelanggan
                                .map<DropdownMenuItem<Map<String, dynamic>>>(
                                    (Map<String, dynamic> pelanggan) {
                              return DropdownMenuItem<Map<String, dynamic>>(
                                value: pelanggan,
                                child: Text(pelanggan['namaPelanggan']),
                              );
                            }).toList(),
                          ),
                        ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Total Pesanan",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Rp. $totalPesanan",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        MaterialButton(
                          elevation: 2,
                          onPressed: () {
                            if (listPesanan.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Belum ada pesanan!"),
                                ),
                              );
                              return;
                            }

                            showDialog(
                              context: context,
                              builder: (context) => StrukDialog(
                                selectedPelanggan: selectedPelanggan,
                                listPesanan: listPesanan,
                                totalPesanan: totalPesanan,
                                onCancel: () => Navigator.pop(context),
                                // Di bagian onConfirm dalam Transaksi.dart
                                onConfirm: () async {
                                  try {
                                    final transactionService =
                                        TransactionService();

                                    await transactionService.addTransaction(
                                      totalHarga: totalPesanan,
                                      cartItems: listPesanan,
                                      pelangganID:
                                          selectedPelanggan?['pelangganID'],
                                    );

                                    // Reset state setelah transaksi berhasil
                                    setState(() {
                                      listPesanan.clear();
                                      totalPesanan = 0;
                                      selectedPelanggan = null;
                                    });

                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Transaksi berhasil dicatat!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  } catch (e) {
                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(e.toString()),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                          color: const Color(0xffaadb83),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.all(12),
                          textColor: const Color(0xffffffff),
                          minWidth: 140,
                          height: 40,
                          child: const Text(
                            "Lanjutkan",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (showDropdown)
            Positioned(
              left: 10,
              right: 10,
              top: 70,
              child: Material(
                elevation: 4,
                child: Container(
                  color: Colors.white,
                  child: filteredProduk.isEmpty
                      ? const ListTile(
                          title: Text("Tidak ada produk yang ditemukan"),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredProduk.length,
                          itemBuilder: (context, index) {
                            final produk = filteredProduk[index];
                            return ListTile(
                              title: Text(produk['namaProduk']),
                              subtitle: Text(
                                  'Rp. ${produk['harga']} - Stok ${produk['stok']}'),
                              onTap: () {
                                addToCart(produk);
                                _produkController.text = produk['namaProduk'];
                                setState(() {
                                  showDropdown = false;
                                });
                              },
                            );
                          },
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
