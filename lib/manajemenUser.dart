import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projek_skripsi/AddUser.dart';
import 'package:projek_skripsi/baca%20data/baca_user.dart';
import 'package:projek_skripsi/komponen/style.dart';

class ManageAcc extends StatefulWidget {
  const ManageAcc({super.key});

  @override
  State<ManageAcc> createState() => _ManageAccState();
}

class _ManageAccState extends State<ManageAcc> {

  List<String> docIDs = [];

  Future getDokumen() async{
    await FirebaseFirestore.instance.collection('User').get().then(
            (snapshot) => snapshot.docs.forEach((dokumen) {
              print(dokumen.reference);
              docIDs.add(dokumen.reference.id);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.green,
      appBar: AppBar(
        backgroundColor: const Color(0xFF61BF9D),
        title: const Text(
          'Manajemen User',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        elevation: 0,
        centerTitle: false,
      ),
      //badan crud
      body: Center(
        child: Container(
          width: 370,
          height: 580,
          decoration: BoxDecoration(
            color: Warna.white,
            borderRadius: BorderRadius.circular(20)
          ),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: getDokumen(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: docIDs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            elevation: 1,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                // Action when tapped
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    // Tambahkan foto profil di sini
                                    const CircleAvatar(
                                      backgroundImage: AssetImage('gambar/profiles.png'),
                                      radius: 25,
                                      backgroundColor: Warna.green,
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: BacaUser(dokumenUser: docIDs[index]),
                                    ),
                                    SizedBox(width: 10),

                                    IconButton(
                                        onPressed: (){},
                                        icon: const Icon(
                                          Icons.edit,
                                    color: Colors.lightBlue,)
                                    ),
                                    SizedBox(width: 5),

                                    IconButton(
                                        onPressed: (){},
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,)
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );

                  },
                )

              ],
            ),
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Container(
        height: 60,
        width: 60,
        margin: const EdgeInsets.only(bottom: 25, right: 10),
        child: FloatingActionButton(
          onPressed: () {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AddUser()),
          );
          },
          backgroundColor: Warna.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: const Icon(Icons.add,
              color: Warna.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
