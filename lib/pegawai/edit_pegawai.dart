import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditPegawai extends StatefulWidget {
  final Map<String, dynamic> pegawai;

  const EditPegawai({Key? key, required this.pegawai}) : super(key: key);

  @override
  EditPegawaiState createState() => EditPegawaiState();
}

class EditPegawaiState extends State<EditPegawai> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaPegawaiController;
  late TextEditingController _emailPegawaiController;
  late TextEditingController _passwordPegawaiController;

  @override
  void initState() {
    super.initState();
    _namaPegawaiController =
        TextEditingController(text: widget.pegawai['nama']);
    _emailPegawaiController =
        TextEditingController(text: widget.pegawai['email']);
    _passwordPegawaiController =
        TextEditingController(); // Kosong untuk password
  }

  @override
  void dispose() {
    _namaPegawaiController.dispose();
    _emailPegawaiController.dispose();
    _passwordPegawaiController.dispose();
    super.dispose();
  }

  Future<void> updatePegawai() async {
    if (_formKey.currentState!.validate()) {
      final namaPegawai = _namaPegawaiController.text;
      final emailPegawai = _emailPegawaiController.text;
      final passwordPegawai = _passwordPegawaiController.text;

      try {
        final accountId = widget.pegawai['account_id'];

        // Update nama di tabel petugas
        await Supabase.instance.client.from('petugas').update({
          'nama': namaPegawai,
        }).eq('account_id', accountId);

        // Jika email diubah dan pengguna sedang login
        if (emailPegawai.isNotEmpty &&
            emailPegawai != widget.pegawai['email']) {
          final currentUser = Supabase.instance.client.auth.currentUser;
          if (currentUser != null && currentUser.id == accountId) {
            final response = await Supabase.instance.client.auth.updateUser(
              UserAttributes(email: emailPegawai),
            );

            if (response != null) {
              throw Exception('Gagal memperbarui email');
            }
          }
        }

        // Jika password diisi, update password pengguna yang sedang login
        if (passwordPegawai.isNotEmpty) {
          final currentUser = Supabase.instance.client.auth.currentUser;
          if (currentUser != null && currentUser.id == accountId) {
            final response = await Supabase.instance.client.auth.updateUser(
              UserAttributes(password: passwordPegawai),
            );

            if (response != null) {
              throw Exception('Gagal memperbarui password');
            }
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Petugas berhasil diperbarui')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              TextFormField(
                controller: _namaPegawaiController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama harus diisi';
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
                  hintText: "Nama ",
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
                  controller: _emailPegawaiController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email harus diisi';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Format email tidak valid';
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
                    hintText: "Email",
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
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextFormField(
                  controller: _passwordPegawaiController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password harus diisi';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
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
                    hintText: "Password",
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
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              ),
              MaterialButton(
                onPressed: () async {
                  await updatePegawai();
                  setState(() {});
                },
                color: const Color(0xff76a975),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: Color(0xff808080), width: 0),
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
            ],
          ),
        ),
      ),
    );
  }
}
