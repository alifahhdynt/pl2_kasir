import 'package:flutter/material.dart';
import 'package:pl2_kasir/home_page.dart';
// import 'package:pl2_kasir/pelanggan.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahPelanggan extends StatefulWidget {
  const TambahPelanggan({super.key});

  @override
  TambahPelangganState createState() => TambahPelangganState();
}

class TambahPelangganState extends State<TambahPelanggan> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaPelangganController =
      TextEditingController();
  final TextEditingController _alamatPelangganController =
      TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();

    List<Map<String, dynamic>> pelanggan = [];


  Future<void> addPelanggan() async {
    if (_formKey.currentState!.validate()) {
      final namaPelanggan = _namaPelangganController.text;
      final alamat = _alamatPelangganController.text;
      final nomorTelpon = int.tryParse(_noTelpController.text) ?? 0;

      try {
        final response =
            await Supabase.instance.client.from('pelanggan').insert(
          [
            {
              'namaPelanggan': namaPelanggan,
              'alamat': alamat,
              'nomorTelpon': nomorTelpon,
            },
          ],
        ).select();
        if (response.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data berhasil ditambahkan!'),
            ),
          );
          _namaPelangganController.clear();
          _alamatPelangganController.clear();
          _noTelpController.clear();

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
            content: Text('error: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _namaPelangganController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukkan nama pelanggan!';
                      }
                      return null;
                    },
                    obscureText: false,
                    textAlign: TextAlign.start,
                    maxLines: 1,
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
                      hintText: "Nama",
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
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      controller: _alamatPelangganController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Masukkan alamat pelanggan!";
                        }
                        return null;
                      },
                      obscureText: false,
                      textAlign: TextAlign.start,
                      maxLines: 1,
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
                        hintText: "Alamat",
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      controller: _noTelpController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Masukkan No. Telp pelanggan!";
                        }
                        if (num.tryParse(value) == null) {
                          return "Masukkan angka yg valid!";
                        }
                        return null;
                      },
                      obscureText: false,
                      textAlign: TextAlign.start,
                      maxLines: 1,
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
                        hintText: "No. Telp",
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: MaterialButton(
                      onPressed: addPelanggan,
                      color: const Color(0xff76a975),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                            color: Color(0xff808080), width: 0),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: const Text(
                        "SIMPAN",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      textColor: const Color(0xffffffff),
                      height: 40,
                      minWidth: 140,
                    ),
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
