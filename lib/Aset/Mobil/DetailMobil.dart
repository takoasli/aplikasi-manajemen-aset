import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projek_skripsi/baca%20data/detail%20Baca%20Aset/DetailBacaMobil.dart';

class DetailMobil extends StatefulWidget {
  const DetailMobil({super.key});

  @override
  State<DetailMobil> createState() => _DetailMobilState();
}

class _DetailMobilState extends State<DetailMobil> {
  late List<String> docDetailMobil = [];

  Future<void> getDetailMobil() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('Mobil').get();
    setState(() {
      docDetailMobil = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  void performSearch(String value) {
  }

  @override
  void initState() {
    super.initState();
    getDetailMobil();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF61BF9D),
        title: const Text(
          'Detail Mobil',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Cari Mobil...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              onChanged: (value) {

                performSearch(value);
              },
            ),
          ),
          Expanded(
              child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 30),
                child: GridView.builder(
                itemCount: docDetailMobil.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return DetailBacaMobil(detailDokumenMobil: docDetailMobil[index]);
                },
              )
            )
          )
        ],

        ),
      );
  }
}
