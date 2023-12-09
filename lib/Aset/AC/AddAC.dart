import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projek_skripsi/Aset/helper.dart';
import 'package:projek_skripsi/textfield/textfields.dart';

import '../../komponen/style.dart';
import '../../textfield/imageField.dart';
import 'ManajemenAC.dart';

class AddAC extends StatefulWidget {
  const AddAC({super.key});

  @override
  State<AddAC> createState() => _AddACState();
}

class _AddACState extends State<AddAC> {
  final MerekACController = TextEditingController();
  final idACController = TextEditingController();
  final wattController = TextEditingController();
  final PKController = TextEditingController();
  final ruanganController = TextEditingController();
  final MasaServisACController = TextEditingController();
  final ImagePicker _gambarACIndoor = ImagePicker();
  final ImagePicker _gambarACOutdoor = ImagePicker();
  final gambarAcIndoorController = TextEditingController();
  final gambarAcOutdoorController = TextEditingController();
  final Sukses = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'SUCCESS',
      message: 'Data AC berhasil Ditambahkan!',
      contentType: ContentType.success,
    ),
  );

  void PilihIndoor() async {
    final pilihIndoor =
        await _gambarACIndoor.pickImage(source: ImageSource.gallery);
    if (pilihIndoor != null) {
      setState(() {
        gambarAcIndoorController.text = pilihIndoor.path;
      });
    }
  }

  void PilihOutdoor() async {
    final pilihOutdoor =
        await _gambarACOutdoor.pickImage(source: ImageSource.gallery);
    if (pilihOutdoor != null) {
      setState(() {
        gambarAcOutdoorController.text = pilihOutdoor.path;
      });
    }
  }

  Future<String> unggahACIndoor(File indoor) async {
    try {
      if (!indoor.existsSync()) {
        print('File tidak ditemukan.');
        return '';
      }

      Reference penyimpanan = FirebaseStorage.instance
          .ref()
          .child('AC')
          .child(gambarAcIndoorController.text.split('/').last);

      UploadTask uploadGambar = penyimpanan.putFile(indoor);
      await uploadGambar;
      String fotoIndoor = await penyimpanan.getDownloadURL();
      return fotoIndoor;
    } catch (e) {
      print('$e');
      return '';
    }
  }

  Future<String> unggahACOutdoor(File outdoor) async {
    try {
      if (!outdoor.existsSync()) {
        print('File tidak ditemukan.');
        return '';
      }

      Reference penyimpanan = FirebaseStorage.instance
          .ref()
          .child('AC')
          .child(gambarAcOutdoorController.text.split('/').last);

      UploadTask uploadGambar = penyimpanan.putFile(outdoor);
      await uploadGambar;
      String fotoOutdoor = await penyimpanan.getDownloadURL();
      return fotoOutdoor;
    } catch (e) {
      print('$e');
      return '';
    }
  }

  void SimpanAC() async {
    try {
      String lokasiGambarIndoor = gambarAcIndoorController.text;
      String fotoIndoor = '';
      String lokasiGambarOutdoor = gambarAcOutdoorController.text;
      String fotoOutdoor = '';

      if (lokasiGambarIndoor.isNotEmpty && lokasiGambarOutdoor.isNotEmpty ||
          lokasiGambarIndoor.isNotEmpty && lokasiGambarOutdoor.isEmpty) {
        File indoor = File(lokasiGambarIndoor);
        fotoIndoor = await unggahACIndoor(indoor);

        File outdoor = File(lokasiGambarOutdoor);
        fotoOutdoor = await unggahACOutdoor(outdoor);
      }

      await tambahAC(
        MerekACController.text.trim(),
        idACController.text.trim(),
        int.parse(wattController.text.trim()),
        int.parse(PKController.text.trim()),
        ruanganController.text.trim(),
        int.parse(MasaServisACController.text.trim()),
        fotoIndoor,
        fotoOutdoor,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ManajemenAC()),
      );

      ScaffoldMessenger.of(context).showSnackBar(Sukses);
      MerekACController.clear();
      idACController.clear();
      wattController.clear();
      PKController.clear();
      MasaServisACController.clear();
    } catch (e) {
      print("Error: $e");
    }
  }

  Future tambahAC(String merek, String ID, int watt, int pk, String ruangan,
      int masaServis, String UrlIndoor, String UrlOutdoor) async {
    var timeService = contTimeService(masaServis);
    await FirebaseFirestore.instance.collection('Aset').add({
      'Merek AC': merek,
      'ID AC': ID,
      'Kapasitas Watt': watt,
      'Kapasitas PK': pk,
      'Lokasi Ruangan': ruangan,
      'Masa Servis': masaServis,
      'Foto AC Indoor': UrlIndoor,
      'Foto AC Outdoor': UrlOutdoor,
      'waktu_service': timeService.millisecondsSinceEpoch,
      'hari_service': daysBetween(DateTime.now(), timeService)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.green,
      appBar: AppBar(
        backgroundColor: const Color(0xFF61BF9D),
        title: const Text(
          'Tambah Data AC',
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
                    'Merek AC',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                const SizedBox(height: 10),
                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: MerekACController),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'ID AC',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                const SizedBox(height: 10),
                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: idACController),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Kapasitas Watt',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                MyTextField(
                    textInputType: TextInputType.number,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: wattController),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(bottom: 3),
                  child: Text(
                    'kapasitas PK',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                MyTextField(
                    textInputType: TextInputType.number,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: PKController),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Ruangan',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: ruanganController),
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
                  controller: MasaServisACController,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Gambar AC Indoor',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                FieldImage(
                  controller: gambarAcIndoorController,
                  selectedImageName: gambarAcIndoorController.text.isNotEmpty
                      ? gambarAcIndoorController.text
                          .split('/')
                          .last // Display only the image name
                      : '',
                  onPressed:
                      PilihIndoor, // Pass the pickImage method to FieldImage
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Gambar AC Outdoor',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                FieldImage(
                    controller: gambarAcOutdoorController,
                    selectedImageName: gambarAcIndoorController.text.isNotEmpty
                        ? gambarAcOutdoorController.text.split('/').last
                        : '',
                    onPressed: PilihOutdoor),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: SimpanAC,
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
