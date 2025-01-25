import 'package:flutter/material.dart';
import 'package:pl2_kasir/tambahPegawai.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Pelanggan extends StatefulWidget {
  const Pelanggan({super.key});

  @override
  _PelangganState createState() => _PelangganState();
}

class _PelangganState extends State<Pelanggan> {
  List<Map<String, dynamic>> pelanggans = [];

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
  }

  Future<void> fetchPelanggan() async {
    try {
      final response =
          await Supabase.instance.client.from('pelanggan').select();
      if (response != null) {
        setState(() {
          pelanggans = response;
        });
      }
    } catch (e) {
      debugPrint("Eror fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff87c15e),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: const Text(
          "DAFTAR PELANGGAN",
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
                scrollDirection: Axis.vertical,
                shrinkWrap: false,
                physics: const ScrollPhysics(),
                itemCount: pelanggans.length,
                itemBuilder: (context, index) {
                  final pelanggan = pelanggans[index];
                  return Column(
                    children: [
                      Card(
                        color: const Color(0xffa3dd81),
                        shadowColor: const Color(0xff000000),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: const BorderSide(
                              color: Color(0x4d9e9e9e), width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${pelanggan['pelangganID']?.toString() ?? '-'}. ${pelanggan['namaPelanggan'] ?? '-'}',
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          debugPrint(
                                              'Edit pressed for ${pelanggan['pelangganID']}');
                                        },
                                        color: const Color(0xff212435),
                                        iconSize: 20,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          debugPrint(
                                              'Delete pressed for ${pelanggan['pelangganID']}');
                                        },
                                        color: const Color(0xffff0000),
                                        iconSize: 20,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  pelanggan['nomorTelpon'] ?? '-',
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14,
                                    color: Color(0xff555555),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Tambah Pelanggan'),
                content: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxHeight: 300, maxWidth: 400),
                  child: TambahPegawai(
                  ),
                ),
              );
            },
          );
        },
        backgroundColor: const Color(0xff87c15e),
        elevation: 2,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
