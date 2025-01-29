// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'home_page.dart';
// class TambahProduk extends StatefulWidget {
//   const TambahProduk({super.key});

//   @override
//   State<TambahProduk> createState() => _TambahProdukState();
// }

// class _TambahProdukState extends State<TambahProduk> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _namaProdukController = TextEditingController();
//   final TextEditingController _hargaController = TextEditingController();
//   final TextEditingController _stokController = TextEditingController();

//   Future<void> _addProduk() async {
//     if (_formKey.currentState!.validate()) {
//       final nama = _namaProdukController.text;
//       final harga = int.tryParse(_hargaController.text) ?? 0;
//       final stok = int.tryParse(_stokController.text) ?? 0;

//       if (!_formKey.currentState!.validate()) {
//         return;
//       }

//       try {
//         final response = await Supabase.instance.client.from('produk').insert([
//           {
//             'namaProduk': nama, // Sesuaikan dengan database
//             'harga': harga,
//             'stok': stok,
//           },
//         ]).select();
//         if (response.isNotEmpty) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Produk berhasil ditambahkan!'),
//             ),
//           );

//           _namaProdukController.clear();
//           _hargaController.clear();
//           _stokController.clear();

//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const HomePage(),
//             ),
//           );
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error: $e'),
//           ),
//         );
//       }
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
//         backgroundColor:Colors.green[600],
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.zero,
//         ),
//         title: const Text(
//           "Tambah Produk",
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
//           }, // Kembali ke halaman sebelumnya
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.fromLTRB(10, 10, 10, 50),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               TextFormField(
//                 controller: _namaProdukController,
//                 obscureText: false,
//                 textAlign: TextAlign.start,
//                 maxLines: 1,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Masukkan nama produk!';
//                   }
//                   return null;
//                 },
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w400,
//                   fontStyle: FontStyle.normal,
//                   fontSize: 14,
//                   color: Color(0xff000000),
//                 ),
//                 decoration: InputDecoration(
//                   disabledBorder: UnderlineInputBorder(
//                     borderRadius: BorderRadius.circular(4.0),
//                     borderSide:
//                         const BorderSide(color: Color(0xff000000), width: 1),
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderRadius: BorderRadius.circular(4.0),
//                     borderSide:
//                         const BorderSide(color: Color(0xff000000), width: 1),
//                   ),
//                   enabledBorder: UnderlineInputBorder(
//                     borderRadius: BorderRadius.circular(4.0),
//                     borderSide:
//                         const BorderSide(color: Color(0xff000000), width: 1),
//                   ),
//                   hintText: "Nama Produk",
//                   hintStyle: const TextStyle(
//                     fontWeight: FontWeight.w400,
//                     fontStyle: FontStyle.normal,
//                     fontSize: 14,
//                     color: Color(0xff000000),
//                   ),
//                   filled: false,
//                   fillColor: const Color(0xfff2f2f3),
//                   isDense: false,
//                   contentPadding:
//                       const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
//                 child: TextFormField(
//                   controller: _hargaController,
//                   obscureText: false,
//                   textAlign: TextAlign.start,
//                   maxLines: 1,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Masukkan harga produk!';
//                     }
//                     return null;
//                   },
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w400,
//                     fontStyle: FontStyle.normal,
//                     fontSize: 14,
//                     color: Color(0xff000000),
//                   ),
//                   decoration: InputDecoration(
//                     disabledBorder: UnderlineInputBorder(
//                       borderRadius: BorderRadius.circular(4.0),
//                       borderSide:
//                           const BorderSide(color: Color(0xff000000), width: 1),
//                     ),
//                     focusedBorder: UnderlineInputBorder(
//                       borderRadius: BorderRadius.circular(4.0),
//                       borderSide:
//                           const BorderSide(color: Color(0xff000000), width: 1),
//                     ),
//                     enabledBorder: UnderlineInputBorder(
//                       borderRadius: BorderRadius.circular(4.0),
//                       borderSide:
//                           const BorderSide(color: Color(0xff000000), width: 1),
//                     ),
//                     hintText: "Harga",
//                     hintStyle: const TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontStyle: FontStyle.normal,
//                       fontSize: 14,
//                       color: Color(0xff000000),
//                     ),
//                     filled: false,
//                     fillColor: const Color(0xfff2f2f3),
//                     isDense: false,
//                     contentPadding:
//                         const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
//                 child: TextFormField(
//                   controller: _stokController,
//                   obscureText: false,
//                   textAlign: TextAlign.start,
//                   maxLines: 1,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Masukkan stok produk!';
//                     }
//                     return null;
//                   },
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w400,
//                     fontStyle: FontStyle.normal,
//                     fontSize: 14,
//                     color: Color(0xff000000),
//                   ),
//                   decoration: InputDecoration(
//                     disabledBorder: UnderlineInputBorder(
//                       borderRadius: BorderRadius.circular(4.0),
//                       borderSide:
//                           const BorderSide(color: Color(0xff000000), width: 1),
//                     ),
//                     focusedBorder: UnderlineInputBorder(
//                       borderRadius: BorderRadius.circular(4.0),
//                       borderSide:
//                           const BorderSide(color: Color(0xff000000), width: 1),
//                     ),
//                     enabledBorder: UnderlineInputBorder(
//                       borderRadius: BorderRadius.circular(4.0),
//                       borderSide:
//                           const BorderSide(color: Color(0xff000000), width: 1),
//                     ),
//                     hintText: "Stok",
//                     hintStyle: const TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontStyle: FontStyle.normal,
//                       fontSize: 14,
//                       color: Color(0xff000000),
//                     ),
//                     filled: false,
//                     fillColor: const Color(0xfff2f2f3),
//                     isDense: false,
//                     contentPadding:
//                         const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
//                 child: MaterialButton(
//                   onPressed: _addProduk,
//                   color: const Color(0xff76a975),
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                     side: const BorderSide(color: Color(0xff808080), width: 0),
//                   ),
//                   padding: const EdgeInsets.all(16),
//                   textColor: const Color(0xffffffff),
//                   height: 40,
//                   minWidth: 140,
//                   child: const Text(
//                     "SIMPAN",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w700,
//                       fontStyle: FontStyle.normal,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
