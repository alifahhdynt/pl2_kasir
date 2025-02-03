import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailTransaksi extends StatelessWidget {
  List<Map<String, dynamic>> detailTransaksi = [];

  Future<void> detailtransaksi(int penjuaalanID) async {
    try {
      await Supabase.instance.client
          .from('detailPenjualan')
          .select('jumlahProduk, subTotal, produk(namaProduk)')
          .eq('penjualanID', penjuaalanID);
    } catch (e) {
      print('Eror loading detail transaksi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F5F5), // Light grey background for modern feel
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFF4CAF50), // Green color for the app bar
        title: const Text(
          "Detail Transaksi",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the entire body
        child: ListView(
          children: [
            // Customer Name Search
            TextField(
              controller: TextEditingController(),
              obscureText: false,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color(0xFF000000),
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF2F2F3),
                hintText: "Nama Pelanggan...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
            ),
            const SizedBox(height: 16),

            // Product List
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x20000000), spreadRadius: 2, blurRadius: 6),
                ],
              ),
              child: ListTile(
                title: const Text("Nama Produk",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                subtitle: const Text("Rp. x jumlah produk",
                    style: TextStyle(fontSize: 14)),
                trailing: const Icon(Icons.add, color: Color(0xFF4CAF50)),
              ),
            ),
            const SizedBox(height: 16),

            // Payment Details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x20000000), spreadRadius: 2, blurRadius: 6),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Rincian Pembayaran",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Nama Pelanggan",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      Text("Agus Suprapto",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF388E3C))),
                    ],
                  ),
                  const Divider(thickness: 1, height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Harga (x barang)",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      Text("Rp. 1.999.999",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF388E3C))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Total Payment and Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x20000000), spreadRadius: 2, blurRadius: 6),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total Pembayaran",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  Row(
                    children: [
                      const Text("Rp. 1.999.999",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF4CAF50))),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF0000),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Bayar",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
