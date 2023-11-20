import 'package:flutter/material.dart';
import 'komponen/box.dart';
import 'komponen/style.dart';

class Aset extends StatefulWidget {
  const Aset({Key? key}) : super(key: key);

  @override
  State<Aset> createState() => _AsetState();
}

class _AsetState extends State<Aset> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF61BF9D),
          title: const Text(
            'Asset Info',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          centerTitle: false,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(17.0),
              child: Text(
                'Pilih Kategori Aset',
                style: TextStyles.title.copyWith(
                  color: Warna.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 5),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Box(
                  text: 'AC',
                  gambar: 'gambar/ac.png',
                  halaman: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Aset()),
                    );
                  },
                ),
                Box(
                  text: 'PC / Laptop',
                  gambar: 'gambar/pc.png',
                  halaman: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Aset()),
                    );
                  },
                ),
                Box(
                  text: 'Motor',
                  gambar: 'gambar/motor.png',
                  halaman: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Aset()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Box(
                      text: 'Mobil',
                      gambar: 'gambar/mobil.png',
                      halaman: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Aset()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
          color: const Color(0xFF61BF9D),
          height: 75,
          child: const Center(
            child: Text(
              'Your Footer Content Goes Here',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
