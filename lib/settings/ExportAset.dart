import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projek_skripsi/bacaExportAset/bacaCatatExportLaptop.dart';
import 'package:projek_skripsi/bacaExportAset/bacaCatatExportMobil.dart';
import 'package:projek_skripsi/bacaExportAset/bacaCatatExportMotor.dart';
import '../bacaExportAset/bacaCatatExportAC.dart';
import '../bacaExportAset/bacaCatatExportPC.dart';
import '../komponen/style.dart';
import '../textfield/textfields.dart';

class ExportAset extends StatefulWidget {
  const ExportAset({super.key});

  @override
  State<ExportAset> createState() => _ExportAsetState();
}

class _ExportAsetState extends State<ExportAset> {
  final List<String> kategoriAset = ['AC', 'PC', 'Laptop','Motor','Mobil','Semua'];
  List<String> kategoriTerpilih = [];
  late List<String> DokCatatanEX = [];

  Future<void> getAC() async {
    Query<Map<String, dynamic>> query =
    FirebaseFirestore.instance.collection('Aset');

    setState(() {
      DokCatatanEX = [];
    });

    final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();

    setState(() {
      DokCatatanEX = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  Future<void> getPC() async {
    Query<Map<String, dynamic>> query =
    FirebaseFirestore.instance.collection('PC');

    setState(() {
      DokCatatanEX = [];
    });

    final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();

    setState(() {
      DokCatatanEX = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  Future<void> getLaptop() async {
    Query<Map<String, dynamic>> query =
    FirebaseFirestore.instance.collection('Laptop');

    setState(() {
      DokCatatanEX = [];
    });

    final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();

    setState(() {
      DokCatatanEX = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  Future<void> getMotor() async {
    Query<Map<String, dynamic>> query =
    FirebaseFirestore.instance.collection('Motor');

    setState(() {
      DokCatatanEX = [];
    });

    final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();

    setState(() {
      DokCatatanEX = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  Future<void> getMobil() async {
    Query<Map<String, dynamic>> query =
    FirebaseFirestore.instance.collection('Mobil');

    setState(() {
      DokCatatanEX = [];
    });

    final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();

    setState(() {
      DokCatatanEX = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  Future<void> getCatatan(List<String> selectedCategories) async {
    if (selectedCategories.contains('AC')) {
      await getAC();
      return;
    }

    if (selectedCategories.contains('PC')) {
      await getPC();
      return;
    }

    if (selectedCategories.contains('Laptop')) {
      await getLaptop();
      return;
    }

    if (selectedCategories.contains('Motor')) {
      await getMotor();
      return;
    }

    if (selectedCategories.contains('Mobil')) {
      await getMobil();
      return;
    }

    if (selectedCategories.contains('Semua')) {
      await getAC();
      await getPC();
      await getLaptop();
      await getMotor();
      await getMobil();
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    getCatatan(kategoriTerpilih);
  }

  @override
  Widget build(BuildContext context) {
    final namaFile = TextEditingController();

    return Scaffold(
      backgroundColor: Warna.green,
      appBar: AppBar(
        backgroundColor: const Color(0xFF61BF9D),
        title: const Text(
          'Export Aset',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        elevation: 0,
        centerTitle: false,
      ),
      body: Center(
        child: Container(
          width: 370,
          height: 570,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(
                    kategoriAset.length,
                        (Aset) {
                      return FilterChip(
                        selected: kategoriTerpilih.contains(kategoriAset[Aset]),
                        showCheckmark: false,
                        label: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            kategoriAset[Aset],
                            style: TextStyle(
                              color: kategoriTerpilih.contains(
                                  kategoriAset[Aset])
                                  ? Warna.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        backgroundColor: kategoriTerpilih.contains(
                            kategoriAset[Aset])
                            ? Warna.lightgreen // Warna kalo dipilih
                            : Warna.white,
                        // Warna kalo tidak dipilih
                        selectedColor: Warna.lightgreen,
                        // Warna latar belakang
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              kategoriTerpilih.clear();
                              kategoriTerpilih.add(kategoriAset[Aset]);
                            } else {
                              kategoriTerpilih.remove(kategoriAset[Aset]);
                            }
                            getCatatan(kategoriTerpilih);
                          });
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 200,
                  width: 320,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Warna.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                        ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: DokCatatanEX.length,
                        itemBuilder: (BuildContext context, int indeks) {
                          switch (kategoriTerpilih.first) {
                            case 'AC':
                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: Material(
                                  borderRadius: BorderRadius.circular(10),
                                  elevation: 5,
                                  child: Container(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        BacaACExport(dokumenAsetAC: DokCatatanEX[indeks]),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            case 'PC':
                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: Material(
                                  borderRadius: BorderRadius.circular(10),
                                  elevation: 5,
                                  child: Container(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        BacaPCExport(dokumenAsetPC: DokCatatanEX[indeks]),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            case 'Laptop':
                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: Material(
                                  borderRadius: BorderRadius.circular(10),
                                  elevation: 5,
                                  child: Container(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        BacaLaptopExport(dokumenAsetLaptop: DokCatatanEX[indeks]),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            case 'Motor':
                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: Material(
                                  borderRadius: BorderRadius.circular(10),
                                  elevation: 5,
                                  child: Container(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        BacaMotorExport(dokumenAsetMotor: DokCatatanEX[indeks]),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            case 'Mobil':
                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: Material(
                                  borderRadius: BorderRadius.circular(10),
                                  elevation: 5,
                                  child: Container(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        BacaMobilExport(dokumenAsetMobil: DokCatatanEX[indeks]),
                                      ],
                                    ),
                                  ),
                                ),
                              );

                            case 'Semua':
                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: Material(
                                  borderRadius: BorderRadius.circular(10),
                                  elevation: 5,
                                  child: Container(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      children: [
                                        BacaACExport(dokumenAsetAC: DokCatatanEX[indeks]),
                                        BacaPCExport(dokumenAsetPC: DokCatatanEX[indeks]),
                                        BacaLaptopExport(dokumenAsetLaptop: DokCatatanEX[indeks]),
                                        BacaMotorExport(dokumenAsetMotor: DokCatatanEX[indeks]),
                                        BacaMobilExport(dokumenAsetMobil: DokCatatanEX[indeks]),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            default:
                              return Container(); // Return default widget jika tidak ada kategori yang dipilih
                          }
                        },
                      )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Nama File',
                          style: TextStyles.title.copyWith(fontSize: 17, color: Warna.darkgrey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    MyTextField(
                      textInputType: TextInputType.text,
                      hint: '',
                      textInputAction: TextInputAction.done,
                      controller: namaFile,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: (){

                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Warna.green,
                        minimumSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))
                    ),
                    child: SizedBox(
                      width: 200,
                      child: Center(
                        child: Text(
                          'Export',
                          style: TextStyles.title
                              .copyWith(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
