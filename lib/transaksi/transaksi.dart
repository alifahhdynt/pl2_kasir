import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  int totalProduk = 0;
  int totalPesanan = 0;

  Future<void> fetchProduks() async {
    try {
      final response = await produkController.from('produk').select();
      if (response != null) {
        setState(() {
          listProduk = List<Map<String, dynamic>>.from(response);
          filteredProduk = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      debugPrint('Eror mengambil produk: $e');
    }
  }

  Future<void> tambahTransaksi({
    required int pelangganID,
    required int totalHarga,
    required List<Map<String, dynamic>> listPesanan,
  }) async {
    try {
      await produkController.from('penjualan').insert({
        'tglPenjualan': DateTime.now().toIso8601String(),
        'totalHarga': totalHarga,
      });
    } catch (e) {
      debugPrint('Eror tambah transaksi: $e');
    }
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

  void addToCart(Map<String, dynamic> produk) {
    setState(() {
      var existingProduct =
          listPesanan.indexWhere((item) => item['id'] == produk['id']);
      if (existingProduct >= 0) {
        listPesanan[existingProduct]['total'] += 1;
      } else {
        listPesanan.add({
          'id': produk['id'],
          'nama': produk['nama'],
          'harga': produk['harga'],
          'total': 1,
        });
      }
      totalProduk += 1;
    });
    kalkulatorTotalPesanan();
  }

  void onAdd(int index) {
    setState(() {
      listPesanan[index]['total'] += 1;
      totalProduk += 1;
    });
    kalkulatorTotalPesanan();
  }

  void removeAdd(int index) {
    setState(() {
      if (listPesanan[index]['total'] > 1) {
        listPesanan[index]['total'] -= 1;
        totalProduk -= 1;
      } else {
        listPesanan.removeAt(index);
        totalProduk -= 1;
      }
    });
    kalkulatorTotalPesanan();
  }

  void filterProduk(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProduk = List<Map<String, dynamic>>.from(listProduk);
      } else {
        filteredProduk = listProduk
            .where((produk) => produk['namaProduk']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProduks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        automaticallyImplyLeading: false,
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: TextField(
              controller: _produkController,
              onChanged: (value) {
                filterProduk(value);
              },
              decoration: InputDecoration(
                hintText: "Cari Produk...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                filled: true,
                fillColor: const Color(0xfff2f2f3),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProduk.length,
              itemBuilder: (context, index) {
                final produk = filteredProduk[index];
                return ListTile(
                  title: Text(produk['namaProduk']),
                  subtitle: Text('Harga: ${produk['harga']}'),
                  onTap: () {
                    addToCart(produk);
                  },
                );
              },
            ),
          ),
          // List Produk
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: listProduk.length,
          //     itemBuilder: (context, index) {
          //       final produk = listProduk[index];
          //       return ListTile(
          //         title: Text(produk['namaProduk']),
          //         subtitle: Text("Rp. ${produk['harga']}"),
          //         trailing: IconButton(
          //           icon: const Icon(Icons.add),
          //           onPressed: () => addToCart(produk),
          //         ),
          //       );
          //     },
          //   ),
          // ),

          // Total Pesanan
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0x4dffffff), width: 1),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  onPressed: () {
                    tambahTransaksi(
                      pelangganID: 1, // contoh ID pelanggan statis
                      totalHarga: totalPesanan,
                      listPesanan: listPesanan,
                    );
                  },
                  color: const Color(0xffaadb83),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.all(16),
                  textColor: const Color(0xffffffff),
                  child: const Text(
                    "Lanjutkan",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
