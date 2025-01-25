import 'package:flutter/material.dart';

class TambahPegawai extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            TextField(
              controller: TextEditingController(),
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
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: TextField(
                controller: TextEditingController(),
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
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: TextField(
                controller: TextEditingController(),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            ),
            MaterialButton(
              onPressed: () {},
              color: const Color(0xff76a975),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(color: Color(0xff808080), width: 0),
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
          ],
        ),
      ),
    );
  }
}
