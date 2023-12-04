import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projek_skripsi/baca%20data/detail%20Baca%20Aset/DetailBacaLaptop.dart';

class DetailLaptop extends StatefulWidget {
  const DetailLaptop({super.key});

  @override
  State<DetailLaptop> createState() => _DetailLaptopState();
}

class _DetailLaptopState extends State<DetailLaptop> {
  late List<String> docDetailLaptop = [];

  Future<void> getDetailLaptop() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('Laptop').get();
    setState(() {
      docDetailLaptop = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  void performSearch(String value) {
  }

  @override
  void initState() {
    super.initState();
    getDetailLaptop();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF61BF9D),
        title: const Text(
          'Detail Laptop',
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
                hintText: 'Cari Laptop...',
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
                  itemCount: docDetailLaptop.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return DetailBacaLaptop(detailDokumenLaptop: docDetailLaptop[index]);
                    },
              )
              )
          )
        ],
        ),
      );
  }
}
