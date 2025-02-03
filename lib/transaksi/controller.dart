import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> addTransaction({
    required int totalHarga,
    required List<Map<String, dynamic>> cartItems,
    int? pelangganID,
  }) async {
    try {
      // 1. Insert ke tabel penjualan
      final penjualanResponse = await _supabase
          .from('penjualan')
          .insert({
            'tanggalPenjualan': DateTime.now().toIso8601String(),
            'totalHarga': totalHarga,
            'pelangganID': pelangganID,
          })
          .select('penjualanID')
          .single();

      final penjualanID = penjualanResponse['penjualanID'];

      // 2. Siapkan data detail penjualan
      final List<Map<String, dynamic>> detailPenjualan = cartItems.map((item) {
        return {
          'penjualanID': penjualanID,
          'produkID': item['produkID'],
          'jumlahProduk': item['total'],
          'subTotal': (item['harga'] as int) * (item['total'] as int),
        };
      }).toList();

      // 3. Insert ke tabel detailpenjualan
      await _supabase.from('detailPenjualan').insert(detailPenjualan);

      // 4. Update stok produk
      // Di dalam fungsi addTransaction
      for (final item in cartItems) {
        // Konversi ke int dan validasi tipe data
        final currentStok = int.parse(item['stok'].toString());
        final jumlahBeli = int.parse(item['total'].toString());

        await _supabase
            .from('produk')
            .update({'stok': currentStok - jumlahBeli}).eq(
                'produkID', item['produkID']);
      }
    } catch (e) {
      throw Exception('Gagal membuat transaksi: ${e.toString()}');
    }
  }
}
