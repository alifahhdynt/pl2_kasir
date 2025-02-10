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

  @override
  void dispose() {
    _produkController.dispose(); // Tambahkan dispose untuk controller
    super.dispose();
  }

  Future<void> fetchProduks() async {
    try {
      final response = await produkController.from('produk').select();
      if (response != null && mounted) {
        // Periksa mounted
        setState(() {
          listProduk = List<Map<String, dynamic>>.from(response);
          filteredProduk = List.from(response);
        });
      }
    } catch (e) {
      debugPrint('Eror mengambil produk: $e');
    }
  }

  Future<void> fetchPelanggans() async {
    try {
      final response = await produkController.from('pelanggan').select();
      if (response != null && mounted) {
        // Periksa mounted
        setState(() {
          listPelanggan = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      debugPrint('Eror mengambil pelanggan: $e');
    }
  }

  void addToCart(Map<String, dynamic> produk) {
    if (!mounted) return; // Tambahkan pengecekan mounted

    setState(() {
      final existingIndex = listPesanan
          .indexWhere((item) => item['produkID'] == produk['produkID']);

      if (existingIndex >= 0) {
        listPesanan[existingIndex]['total'] += 1;
      } else {
        listPesanan.add({
          'produkID': produk['produkID'],
          'namaProduk': produk['namaProduk'],
          'harga': produk['harga'],
          'stok': produk['stok'],
          'total': 1,
        });
      }
      _calculateTotal(); // Pindahkan kalkulasi total ke dalam setState
    });
  }

  void updateCartQuantity(int index, int delta) {
    if (!mounted) return; // Tambahkan pengecekan mounted

    setState(() {
      final produkID = listPesanan[index]['produkID'];
      final stokTersedia = listProduk.firstWhere(
        (p) => p['produkID'] == produkID,
        orElse: () => {'stok': 0},
      )['stok'];

      final currentQuantity = listPesanan[index]['total'];

      if (delta > 0 && currentQuantity < stokTersedia) {
        listPesanan[index]['total'] += delta;
      } else if (delta < 0 && currentQuantity > 1) {
        listPesanan[index]['total'] += delta;
      } else if (delta > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Stok tidak mencukupi!"),
          ),
        );
      }
      _calculateTotal(); // Pindahkan kalkulasi total ke dalam setState
    });
  }

  void removeFromCart(int index) {
    if (!mounted) return; // Tambahkan pengecekan mounted

    setState(() {
      listPesanan.removeAt(index);
      _calculateTotal();
    });
  }

  void _calculateTotal() {
    totalPesanan = listPesanan.fold(
      0,
      (sum, item) => sum + (item['harga'] as int) * (item['total'] as int),
    );
  }

  void filterProduk(String query) {
    if (!mounted) return; // Tambahkan pengecekan mounted

    setState(() {
      showDropdown = query.isNotEmpty;
      filteredProduk = query.isEmpty
          ? List.from(listProduk)
          : listProduk.where((produk) {
              return produk['namaProduk']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase());
            }).toList();
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
                  onChanged: filterProduk,
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
              _buildBottomPanel(),
            ],
          ),
          if (showDropdown) _buildProductDropdown(),
        ],
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0x4dffffff), width: 1),
      ),
      child: Column(
        children: [
          DropdownButton<Map<String, dynamic>>(
            value: selectedPelanggan,
            hint: const Text("Pilih Pelanggan"),
            onChanged: (newValue) {
              if (mounted) {
                setState(() => selectedPelanggan = newValue);
              }
            },
            items: listPelanggan
                .map((pelanggan) => DropdownMenuItem(
                      value: pelanggan,
                      child: Text(pelanggan['namaPelanggan']),
                    ))
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                onPressed: _handleTransaction,
                color: const Color(0xffaadb83),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "Lanjutkan",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductDropdown() {
    return Positioned(
      left: 10,
      right: 10,
      top: 70,
      child: Material(
        elevation: 4,
        child: Container(
          color: Colors.white,
          child: filteredProduk.isEmpty
              ? const ListTile(title: Text("Tidak ada produk yang ditemukan"))
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
                        if (mounted) {
                          setState(() {
                            addToCart(produk);
                            _produkController.clear();
                            showDropdown = false;
                          });
                        }
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }

  void _handleTransaction() {
    if (listPesanan.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Belum ada pesanan!")),
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
        onConfirm: () async {
          try {
            final transactionService = TransactionService();
            await transactionService.addTransaction(
              totalHarga: totalPesanan,
              cartItems: listPesanan,
              pelangganID: selectedPelanggan?['pelangganID'],
            );

            if (mounted) {
              // Tambahkan pengecekan mounted
              setState(() {
                listPesanan.clear();
                totalPesanan = 0;
                selectedPelanggan = null;
              });
            }

            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Transaksi berhasil!'),
                backgroundColor: Colors.green,
              ),
            );
          } catch (e) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${e.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }
}
