import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> delete(int produkID) async {
  await Supabase.instance.client
      .from('produk')
      .delete()
      .eq('produkID', produkID);
}

// Future<void> deletePegawai(int petugasID, String accountId) async {
//   // Delete the petugas record
//   final response = await Supabase.instance.client
//       .from('petugas')
//       .delete()
//       .eq('petugasID', petugasID);

//   if (response.error == null) {
//     final authResponse =
//         await Supabase.instance.client.auth.admin.deleteUser(accountId);
//   }
// }

Future<void> deletePelanggan(int pelangganID) async {
  await Supabase.instance.client
      .from('pelanggan')
      .delete()
      .eq('pelangganID', pelangganID);
}
