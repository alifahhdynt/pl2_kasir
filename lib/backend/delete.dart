import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> delete(int produkID) async {
  await Supabase.instance.client
      .from('produk')
      .delete()
      .eq('produkID', produkID);
}

Future<void> deletePegawai(int petugasID) async {
  await Supabase.instance.client
      .from('petugas')
      .delete()
      .eq('petugasID', petugasID);
}
