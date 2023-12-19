import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projek_skripsi/Catatan/ListEditCatatan.dart';
import 'package:projek_skripsi/Catatan/bacaCatatan.dart';
import '../komponen/style.dart';

class ListCatatan extends StatefulWidget {
  const ListCatatan({super.key});

  @override
  State<ListCatatan> createState() => _ListCatatanState();
}

class _ListCatatanState extends State<ListCatatan> {
  late List<String> DokCatatan = [];
  final berhasil = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'SUCCESS',
      message: 'Data Catatan Servis berhasil Dihapus!',
      contentType: ContentType.success,
    ),
  );
  Future<void> getCatatan() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('Catatan Servis').get();
    setState(() {
      DokCatatan = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  Future<void> hapusCatatan(String docServis) async {
    AwesomeDialog dialog = AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: 'Yakin ingin menghapus?',
      desc: 'Data yang dihapus tidak dapat dikembalikan.',
      btnOkOnPress: () async {
        await FirebaseFirestore.instance.collection('Catatan Servis').doc(docServis).delete();
        getCatatan();
        ScaffoldMessenger.of(context).showSnackBar(berhasil);
      },
      btnCancelOnPress: () {},
    );
    await dialog.show();
  }

  @override
  void initState(){
    super.initState();
    getCatatan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.green,
      appBar: AppBar(
        backgroundColor: const Color(0xFF61BF9D),
        title: const Text(
          'Manajemen Catatan',
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Warna.white,
                hintText: 'Cari Mobil...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide.none
                ),
              ),

              // onChanged: (value) {
              //   performSearch(value);
              // },
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Warna.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(20),
              child: ListView.builder(
                itemCount: DokCatatan.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      elevation: 5,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          // Action when tapped
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: BacaCatatan(
                                  dokumenCatatan: DokCatatan[index],

                                ),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ListEditcatatan(
                                          dokumenCatatan: DokCatatan[index])
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.lightBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
