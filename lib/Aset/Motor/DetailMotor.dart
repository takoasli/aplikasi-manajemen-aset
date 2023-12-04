import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projek_skripsi/baca%20data/detail%20Baca%20Aset/DetailBacaMotor.dart';

class DetailMotor extends StatefulWidget {
  const DetailMotor({super.key});

  @override
  State<DetailMotor> createState() => _DetailMotorState();
}

class _DetailMotorState extends State<DetailMotor> {
  late List<String> docDetailMotor = [];

  Future<void> getDetailMotor() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('Motor').get();
    setState(() {
      docDetailMotor = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  void performSearch(String value) {
  }

  @override
  void initState() {
    super.initState();
    getDetailMotor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF61BF9D),
        title: const Text(
          'Detail Motor',
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
                hintText: 'Cari Motor...',
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
                  itemCount: docDetailMotor.length,
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return DetailBacaMotor(detailDokumenMotor: docDetailMotor[index]);
                  },
                ),
              )
          )
        ],
      ),
    );
  }
}
