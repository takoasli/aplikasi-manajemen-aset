import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projek_skripsi/textfield/textfields.dart';

import '../Aset/ControllerLogic.dart';
import '../komponen/style.dart';

class ExportCatatan extends StatefulWidget {
  const ExportCatatan({Key? key}) : super(key: key);

  @override
  State<ExportCatatan> createState() => _ExportCatatanState();
}

class _ExportCatatanState extends State<ExportCatatan> {
  String selectedWaktu = "";
  List<String> kategoriTerpilih = [];
  late List<String> DokCatatanEX = [];
  final namaFile = TextEditingController();
  List<String> Waktu = [
    "Bulan ini",
    "Tahun ini",
    "Semua",
  ];

  Future<void> getCatatan(List<String> selectedCategories) async {
    if (selectedCategories.contains('Semua')) {
      await getAllCatatan();
      return;
    }

    if (selectedCategories.contains('Bulan ini')) {
      await getCatatanBulanIni();
      return;
    }

    if (selectedCategories.contains('Tahun ini')) {
      await getCatatanTahunIni();
      return;
    }
  }

  Future<void> getAllCatatan() async {
    Query<Map<String, dynamic>> query =
    FirebaseFirestore.instance.collection('Catatan Servis');

    setState(() {
      DokCatatanEX = [];
    });

    final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();

    setState(() {
      DokCatatanEX = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  Future<void> getCatatanBulanIni() async {
    DateTime now = DateTime.now();
    Timestamp startDate = Timestamp.fromDate(DateTime(now.year, now.month, 1));
    Timestamp endDate = Timestamp.fromDate(DateTime(now.year, now.month + 1, 0));

    await getCatatanByDateRange(startDate, endDate);
  }

  Future<void> getCatatanTahunIni() async {
    DateTime now = DateTime.now();
    Timestamp startDate = Timestamp.fromDate(DateTime(now.year, 1, 1));
    Timestamp endDate = Timestamp.fromDate(DateTime(now.year, 12, 31));

    await getCatatanByDateRange(startDate, endDate);
  }

  Future<void> getCatatanByDateRange(
      Timestamp startDate, Timestamp endDate) async {
    Query<Map<String, dynamic>> query =
    FirebaseFirestore.instance.collection('Catatan Servis');

    final QuerySnapshot<Map<String, dynamic>> snapshot = await query
        .where('Tanggal Dilakukan Servis', isGreaterThanOrEqualTo: startDate)
        .where('Tanggal Dilakukan Servis', isLessThanOrEqualTo: endDate)
        .get();

    setState(() {
      DokCatatanEX = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getCatatan(kategoriTerpilih);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.green,
      appBar: AppBar(
        backgroundColor: const Color(0xFF61BF9D),
        title: const Text(
          'Export Catatan',
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
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 55),
              child: Image.asset(
                'gambar/gambar file.png',
                fit: BoxFit.contain,
                width: 240,
                height: 240,
              ),
            ),
          ),

          // Taro containernya disini
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Container(
                decoration: BoxDecoration(
                  color: Warna.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30, right: 30),
                            child: Icon(
                              Icons.download_for_offline,
                              size: 55,
                              color: Warna.green,
                            ),
                          ),

                          // Ini dropdown menu
                          Container(
                            width: 263,
                            decoration: BoxDecoration(
                              color: Warna.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueGrey.shade500.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: Offset(0, 2), // changes position of shadow
                                ),
                              ],
                            ),
                            child: DropdownSearch<String>(
                              popupProps: PopupProps.menu(
                                showSelectedItems: true,
                              ),
                              items: Waktu,
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                    hintText: "Pilih...",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                    )
                                ),
                              ),
                              onChanged: (selectedValue){
                                print(selectedValue);
                                setState(() {
                                  selectedWaktu = selectedValue ?? "";
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),

                    // Column di sini
                    Column(
                      children: [
                        MyTextField(
                              textInputType: TextInputType.text,
                              hint: 'Nama File...',
                              textInputAction: TextInputAction.done,
                              controller: namaFile),

                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: (){

                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Warna.green,
                                  minimumSize: const Size(150, 40),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25))
                              ),
                              child: SizedBox(
                                width: 200,
                                child: Center(
                                  child: Text(
                                    'Export',
                                    style: TextStyles.title
                                        .copyWith(fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                          ],
                        ),
                      ],
                    ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
