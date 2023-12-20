import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projek_skripsi/Aset/Mobil/manajemenMobil.dart';

import '../../komponen/kotakDialog.dart';
import '../../komponen/style.dart';
import '../../textfield/imageField.dart';
import '../../textfield/textfields.dart';
import '../ControllerLogic.dart';

class AddMobil extends StatefulWidget {
  const AddMobil({super.key});

  @override
  State<AddMobil> createState() => _AddMobilState();
}

class KebutuhanModelMobil {
  String namaKebutuhanMobil;
  int masaKebutuhanMobil;

  KebutuhanModelMobil(
      this.namaKebutuhanMobil,
      this.masaKebutuhanMobil,
      );
}

class _AddMobilState extends State<AddMobil> {
  final merekMobilController = TextEditingController();
  final idMobilCOntroller = TextEditingController();
  final tipemesinController = TextEditingController();
  final tipeBahanBakarController = TextEditingController();
  final pendinginController = TextEditingController();
  final transmisController = TextEditingController();
  final kapasitasBBController = TextEditingController();
  final ukuranBanController = TextEditingController();
  final akiController = TextEditingController();
  final MasaKebutuhanController = TextEditingController();
  final MasaServisMobilController = TextEditingController();
  final isiKebutuhan_Mobil = TextEditingController();
  final imgMobilController = TextEditingController();
  final ImagePicker _gambarMobil = ImagePicker();
  List Kebutuhan_Mobil = [
  ];

  void PilihGambarMobil() async {
    final pilihMobil =
        await _gambarMobil.pickImage(source: ImageSource.gallery);
    if (pilihMobil != null) {
      setState(() {
        imgMobilController.text = pilihMobil.path;
      });
    }
  }

  Future<String> unggahGambarMobil(File gambarMobil) async {
    try {
      if (!gambarMobil.existsSync()) {
        print('File tidak ditemukan!');
        return '';
      }
      Reference penyimpanan = FirebaseStorage.instance
          .ref()
          .child('Mobil')
          .child(imgMobilController.text.split('/').last);

      UploadTask uploadMobil = penyimpanan.putFile(gambarMobil);
      await uploadMobil;
      String fotoMobil = await penyimpanan.getDownloadURL();
      return fotoMobil;
    } catch (e) {
      print('$e');
      return '';
    }
  }

  void SimpanKebutuhan_Mobil(){
    setState(() {
      Kebutuhan_Mobil.add(KebutuhanModelMobil(isiKebutuhan_Mobil.text,
          int.parse(MasaKebutuhanController.text)
      ));
      isiKebutuhan_Mobil.clear();
      MasaKebutuhanController.clear();
    });
    Navigator.of(context).pop();
  }

  void tambahKebutuhan(){
    showDialog(
        context: context,
        builder: (context){
          return DialogBox(
            controller: isiKebutuhan_Mobil,
            onAdd: SimpanKebutuhan_Mobil,
            onCancel: () => Navigator.of(context).pop(),
            TextJudul: 'Tambah Kebutuhan Mobil',
            JangkaKebutuhan: MasaKebutuhanController,
          );
        });
  }

  void ApusKebutuhan(int index) {
    setState(() {
      Kebutuhan_Mobil.removeAt(index);
    });
  }


  void SimpanMobil() async{
    try{
      String lokasiGambarMobil = imgMobilController.text;
      String fotoMobil = '';
      List<Map<String, dynamic>> ListKebutuhan_Mobil = Kebutuhan_Mobil.map((kebutuhan) {
        var timeKebutuhan = contTimeService(kebutuhan.masaKebutuhanMobil);
        return {
          'Nama Kebutuhan Mobil': kebutuhan.namaKebutuhanMobil,
          'Masa Kebutuhan Mobil': kebutuhan.masaKebutuhanMobil,
          'Waktu Kebutuhan Mobil': timeKebutuhan.millisecondsSinceEpoch,
          'Hari Kebutuhan Mobil': daysBetween(DateTime.now(), timeKebutuhan)
        };
      }).toList();

      if (lokasiGambarMobil.isNotEmpty) {
        File imgMobil = File(lokasiGambarMobil);
        fotoMobil = await unggahGambarMobil(imgMobil);
      }

      await tambahMobil(
        merekMobilController.text.trim(),
        idMobilCOntroller.text.trim(),
        int.parse(tipemesinController.text.trim()),
        tipeBahanBakarController.text.trim(),
        pendinginController.text.trim(),
        transmisController.text.trim(),
        int.parse(kapasitasBBController.text.trim()),
        ukuranBanController.text.trim(),
        int.parse(akiController.text.trim()),
        int.parse(MasaServisMobilController.text.trim()),
        ListKebutuhan_Mobil,
        fotoMobil,
      );

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'Berhasil!',
        desc: 'Data Mobil Berhasil Ditambahkan',
        btnOkOnPress: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ManajemenMobil()),
          );
        },
      ).show();
      print('Data Mobil Berhasil Ditambahkan');

    } catch (e) {
      print("Error : $e");
    }
  }

  Future tambahMobil (String merek, String ID, int tipemesin,
      String tipeBB, String pendingin, String transmisi, int kapasitasBB, String ban, int Aki, int masaServis,List<Map<String, dynamic>> kebutuhan, String GambarMobil) async{
    var timeService = contTimeService(masaServis);
    await FirebaseFirestore.instance.collection('Mobil').add({
      'Merek Mobil' : merek,
      'ID Mobil' : ID,
      'Tipe Mesin' : tipemesin,
      'Jenis Bahan Bakar' : tipeBB,
      'Sistem Pendingin Mesin' : pendingin,
      'Tipe Transmisi' : transmisi,
      'Kapasitas Bahan Bakar' : kapasitasBB,
      'Ukuran Ban' : ban,
      'Aki' : Aki,
      'Masa Servis' : masaServis,
      'Kebutuhan Mobil' : kebutuhan,
      'Gambar Mobil' : GambarMobil,
      'Jenis Aset' : 'Mobil',
      'Waktu Service Mobil': timeService.millisecondsSinceEpoch,
      'Hari Service Mobil': daysBetween(DateTime.now(), timeService)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.green,
      appBar: AppBar(
        backgroundColor: const Color(0xFF61BF9D),
        title: const Text(
          'Tambah Data Mobil',
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
          height: 580,
          decoration: BoxDecoration(
            color: Warna.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Merek Mobil',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                SizedBox(height: 10),
                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: merekMobilController),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'ID Mobil',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                SizedBox(height: 10),
                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: idMobilCOntroller),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Kapasitas Mesin',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                SizedBox(height: 10),
                MyTextField(
                    textInputType: TextInputType.number,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: tipemesinController),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Jenis Bahan Bakar',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                SizedBox(height: 10),
                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: tipeBahanBakarController),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Sistem Pendingin',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                SizedBox(height: 10),
                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: pendinginController),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Tipe Transmisi',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                SizedBox(height: 10),
                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: transmisController),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Kapasitas Bahan Bakar',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                SizedBox(height: 10),
                MyTextField(
                    textInputType: TextInputType.number,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: kapasitasBBController),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Ukuran Ban',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                SizedBox(height: 10),
                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: ukuranBanController),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Kapasitas Aki',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                SizedBox(height: 10),
                MyTextField(
                    textInputType: TextInputType.number,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: akiController),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Jangka Waktu Servis (Perbulan)',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                SizedBox(height: 10),
                MyTextField(
                  textInputType: TextInputType.number,
                  hint: '',
                  textInputAction: TextInputAction.next,
                  controller: MasaServisMobilController,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Gambar Mobil',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                SizedBox(height: 10),
                FieldImage(
                    controller: imgMobilController,
                    selectedImageName: imgMobilController.text.isNotEmpty
                        ? imgMobilController.text.split('/').last
                        : '',
                    onPressed: PilihGambarMobil),

                SizedBox(height: 10),

                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: Kebutuhan_Mobil.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(Kebutuhan_Mobil[index].namaKebutuhanMobil),
                      subtitle: Text('${Kebutuhan_Mobil[index].masaKebutuhanMobil} Bulan'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          ApusKebutuhan(index);
                        },
                        color: Colors.red,
                      ),
                    );
                  },
                ),

                InkWell(
                  onTap: tambahKebutuhan,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [Icon(Icons.add),
                        SizedBox(width: 5),
                        Text('Tambah Kebutuhan...')],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: SimpanMobil,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Warna.green,
                        minimumSize: const Size(300, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    child: Container(
                      width: 200,
                      child: Center(
                        child: Text(
                          'Save',
                          style: TextStyles.title
                              .copyWith(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
