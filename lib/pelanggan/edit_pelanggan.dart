import 'package:flutter/material.dart';
// import 'package:pl2_kasir/home_page.dart';
// import 'package:pl2_kasir/pelanggan/pelanggan.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditPelanggan extends StatefulWidget {
  final Map<String, dynamic> pelanggan;

  const EditPelanggan({Key? key, required this.pelanggan}) : super(key: key);

  @override
  EditPelangganState createState() => EditPelangganState();
}

class EditPelangganState extends State<EditPelanggan> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaPelangganController;
  late TextEditingController _alamatPelangganController;
  late TextEditingController _noTelpController;

  @override
  void initState() {
    super.initState();
    print('Data pelanggan diterima dari: ${widget.pelanggan}');
    _namaPelangganController =
        TextEditingController(text: widget.pelanggan['namaPelanggan'] ?? '');
    _alamatPelangganController =
        TextEditingController(text: widget.pelanggan['alamat'] ?? '');
    _noTelpController = TextEditingController(
        text: widget.pelanggan['nomorTelpon']?.toString() ?? '0');
  }

  Future<void> updatePelanggan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final namaPelanggan = _namaPelangganController.text;
    final alamat = _alamatPelangganController.text;
    final nomorTelpon = int.tryParse(_noTelpController.text) ?? 0;

    final response = await Supabase.instance.client
        .from('pelanggan')
        .update(
          {
            'namaPelanggan': namaPelanggan,
            'alamat': alamat,
            'nomorTelpon': nomorTelpon,
          },
        )
        .eq('pelangganID', widget.pelanggan['pelangganID'])
        .select();
    if (response == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data gagal diperbarui!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil diperbarui!')),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      borderSide:
                          const BorderSide(color: Color(0xff000000), width: 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide:
                          const BorderSide(color: Color(0xff000000), width: 1),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide:
                          const BorderSide(color: Color(0xff000000), width: 1),
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
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                    onPressed: () async {
                      await updatePelanggan();
                      setState(() {});
                    },
                    color: const Color(0xff76a975),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side:
                          const BorderSide(color: Color(0xff808080), width: 0),
                    ),
                    padding: const EdgeInsets.all(16),
                    textColor: const Color(0xffffffff),
                    height: 40,
                    minWidth: 140,
                    child: const Text(
                      "SIMPAN",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
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
