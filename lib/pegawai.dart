import 'package:flutter/material.dart';
import 'package:pl2_kasir/TambahPegawai.dart';
import 'package:pl2_kasir/delete.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Pegawai extends StatefulWidget {
  const Pegawai({super.key});
  @override
  PegawaiState createState() => PegawaiState();
}

class PegawaiState extends State<Pegawai> {
  List<Map<String, dynamic>> pegawai = [];

  @override
  void initState() {
    super.initState();
    fetchPegawai();
  }

  Future<void> fetchPegawai() async {
    try {
      final response = await Supabase.instance.client.from('petugas').select();
      setState(() {
        pegawai = List<Map<String, dynamic>>.from(response);
      });
    } catch (error) {
      debugPrint("Error fetching produk: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff87c15e),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: const Text(
          "DAFTAR PEGAWAI",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 16,
            color: Color(0xffffffff),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: pegawai.length,
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(0),
                shrinkWrap: false,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = pegawai[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: ListTile(
                      tileColor: const Color(0xffffffff),
                      title: Text(
                        item['nama'] ?? '-',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                          fontSize: 16,
                          color: Color(0xff000000),
                        ),
                        textAlign: TextAlign.start,
                      ),
                      dense: false,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                      selected: false,
                      selectedTileColor: const Color(0x42000000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                            color: Color(0x4d9e9e9e), width: 1),
                      ),
                      trailing: SizedBox(
                        width: 100, 
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Color(0xff212435), size: 24),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Color.fromARGB(255, 255, 0, 0),
                                  size: 24),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Hapus Data'),
                                    content: const Text(
                                        'Anda yakin ingin menghapus data?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Kembali'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          if (item['petugasID'] != null) {
                                            await deletePegawai(
                                                item['petugasID']);
                                            fetchPegawai();
                                          }
                                        },
                                        child: const Text('Hapus'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            FloatingActionButton(
                backgroundColor: const Color(
                  0xff87c15e,
                ),
                elevation: 2,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Tambah Pegawai'),
                        content: ConstrainedBox(
                          constraints: const BoxConstraints(
                              maxWidth: 400, maxHeight: 300),
                          child: TambahPegawai(),
                        ),
                      );
                    },
                  );
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                )),
          ],
        ),
      ),
    );
  }
}
