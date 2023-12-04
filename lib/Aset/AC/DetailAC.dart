import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projek_skripsi/baca%20data/detail%20Baca%20Aset/DetailBacaAC.dart';

class DetailAC extends StatefulWidget {
  const DetailAC({Key? key}) : super(key: key);

  @override
  State<DetailAC> createState() => _DetailACState();
}

class _DetailACState extends State<DetailAC> {
  late List<String> docDetailAC = [];

  Future<void> getDetailAC() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('Aset').get();
    setState(() {
      docDetailAC = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  void performSearch(String value) {
  }

  @override
  void initState() {
    super.initState();
    getDetailAC();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF61BF9D),
        title: const Text(
          'Detail AC',
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
                hintText: 'Cari AC...',
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
                itemCount: docDetailAC.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return DetailBacaAC(detailDokumenAC: docDetailAC[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
