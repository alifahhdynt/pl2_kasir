// import 'package:flutter/material.dart';
// import 'package:pl2_kasir/delete.dart';
// import 'package:pl2_kasir/edit_produk.dart';
// import 'package:pl2_kasir/tambah_produk.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class Produk extends StatefulWidget {
//   const Produk({super.key});

//   @override
//   State<Produk> createState() => _ProdukState();
// }

// class _ProdukState extends State<Produk> {
//   List<Map<String, dynamic>> produks = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchProduks();
//   }

//   Future<void> fetchProduks() async {
//     final user = Supabase.instance.client.auth.currentUser;
//     if (user == null) {
//       return;
//     }

//     try {
//       final response = await Supabase.instance.client.from('produk').select();
//       // .eq('userID', user.id);

//       if (response != null && response.isNotEmpty) {
//         setState(() {
//           produks = List<Map<String, dynamic>>.from(response);
//         });
//       } else {
//         debugPrint("No produk found for user");
//       }
//     } catch (error) {
//       debugPrint("Error fetching produk: $error");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffffffff),
//       appBar: AppBar(
//         elevation: 1,
//         centerTitle: false,
//         automaticallyImplyLeading: false,
//         backgroundColor: const Color(0xff9cb284),
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.zero,
//         ),
//         title: const Text(
//           "Produk",
//           style: TextStyle(
//             fontWeight: FontWeight.w700,
//             fontStyle: FontStyle.normal,
//             fontSize: 16,
//             color: Color(0xffffffff),
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Color(0xffffffff),
//             size: 24,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: fetchProduks, // tombol untuk refresh
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             Expanded(
//               flex: 1,
//               child: ListView.builder(
//                 itemCount: produks.length,
//                 itemBuilder: (context, index) {
//                   final produk = produks[index];
//                   return Column(
//                     children: [
//                       ListTile(
//                         tileColor: const Color(0xffffffff),
//                         title: Text(
//                           produk['namaProduk'] ?? '-',
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontStyle: FontStyle.normal,
//                             fontSize: 16,
//                             color: Color(0xff000000),
//                           ),
//                         ),
//                         subtitle: Text(
//                           "Harga: ${produk['harga'] ?? '-'} - Stok: ${produk['stok'] ?? '-'}",
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontStyle: FontStyle.normal,
//                             fontSize: 14,
//                             color: Color(0xff000000),
//                           ),
//                         ),
//                         dense: false,
//                         contentPadding: const EdgeInsets.symmetric(
//                             vertical: 0, horizontal: 16),
//                         selected: false,
//                         selectedTileColor: const Color(0x42000000),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           side: const BorderSide(
//                               color: Color(0x4d9e9e9e), width: 1),
//                         ),
//                         trailing: Row(
//                           mainAxisSize:
//                               MainAxisSize.min, // Mengatur ukuran sesuai isi
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.edit,
//                                   color: Color(0xff212435), size: 24),
//                               onPressed: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                             EditProduk(produk: produk)));
//                               },
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.delete,
//                                   color: Colors.red, size: 24),
//                               onPressed: () {
//                                 showDialog(
//                                   context: context,
//                                   builder: (BuildContext context) {
//                                     return AlertDialog(
//                                       title: const Text('Hapus Data'),
//                                       content: const Text(
//                                           'Apakah Anda yakin untuk menghapus data?'),
//                                       actions: [
//                                         TextButton(
//                                           onPressed: () {
//                                             Navigator.of(context)
//                                                 .pop(); // Tutup dialog
//                                           },
//                                           child: const Text('Kembali'),
//                                         ),
//                                         TextButton(
//                                           onPressed: () async {
//                                             await delete(produk[
//                                                 'produkID']); // Panggil fungsi hapus
//                                             Navigator.of(context)
//                                                 .pop(); // Tutup dialog setelah hapus
//                                             await fetchProduks(); // Refresh data
//                                           },
//                                           child: const Text('Hapus',
//                                               style:
//                                                   TextStyle(color: Colors.red)),
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Tambahkan jarak antar item
//                       const SizedBox(height: 10),
//                     ],
//                   );
//                 },
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Container(
//                   color: Colors.green[600],
//                   child: IconButton(
//                     icon: const Icon(Icons.add),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const TambahProduk(),
//                         ),
//                       );
//                     },
//                     color: const Color(0xff212435),
//                     iconSize: 40,
//                   ),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
