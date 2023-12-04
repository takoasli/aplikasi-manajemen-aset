import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../komponen/style.dart';
import '../../textfield/imageField.dart';
import '../../textfield/textfields.dart';

class AddLaptop extends StatefulWidget {
  const AddLaptop({super.key});

  @override
  State<AddLaptop> createState() => _AddLaptopState();
}

class _AddLaptopState extends State<AddLaptop> {
  final merekLaptopController = TextEditingController();
  final IdLaptopController = TextEditingController();
  final lokasiRuanganController = TextEditingController();
  final CPUController = TextEditingController();
  final RamController = TextEditingController();
  final VGAController = TextEditingController();
  final ImglaptopController = TextEditingController();
  final StorageController = TextEditingController();
  final MonitorController = TextEditingController();
  final MasaServisLaptopController = TextEditingController();
  final ImagePicker _gambarLaptop = ImagePicker();
  final Sukses = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'SUCCESS',
      message: 'Data Laptop berhasil Ditambahkan!',
      contentType: ContentType.success,
    ),
  );

  void PilihGambarLaptop() async {
    final pilihLaptop =
        await _gambarLaptop.pickImage(source: ImageSource.gallery);
    if (pilihLaptop != null) {
      setState(() {
        ImglaptopController.text = pilihLaptop.path;
      });
    }
  }

  Future<String> unggahGambarLaptop(File gambarLaptop) async {
    try {
      if (!gambarLaptop.existsSync()) {
        print('File tidak ditemukan!');
        return '';
      }
      Reference penyimpanan = FirebaseStorage.instance
          .ref()
          .child('Laptop')
          .child(ImglaptopController.text.split('/').last);

      UploadTask uploadLaptop = penyimpanan.putFile(gambarLaptop);
      await uploadLaptop;
      String fotoLaptop = await penyimpanan.getDownloadURL();
      return fotoLaptop;
    } catch (e) {
      print('$e');
      return '';
    }
  }

  void SimpanLaptop() async {
    try {
      String lokasiGambarPC = ImglaptopController.text;
      String fotoLaptop = '';

      if (lokasiGambarPC.isNotEmpty) {
        File imgLaptop = File(lokasiGambarPC);
        fotoLaptop = await unggahGambarLaptop(imgLaptop);
      }

      await tambahLaptop(
        merekLaptopController.text.trim(),
        IdLaptopController.text.trim(),
        lokasiRuanganController.text.trim(),
        CPUController.text.trim(),
        int.parse(RamController.text.trim()),
        int.parse(StorageController.text.trim()),
        VGAController.text.trim(),
        MonitorController.text.trim(),
        int.parse(MasaServisLaptopController.text.trim()),
        fotoLaptop,
      );
      /*Navigator.pushReplacement(
          context, MaterialPageRoute(
          builder: (context)=> ManajemenLaptop())
      );*/
      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(Sukses);
    } catch (e) {
      print("Error : $e");
    }
  }

  Future tambahLaptop(
      String merek,
      String ID,
      String ruangan,
      String CPU,
      int ram,
      int storage,
      String vga,
      String monitor,
      int masaServis,
      String gambarLaptop) async {
    await FirebaseFirestore.instance.collection('Laptop').add({
      'Merek Laptop': merek,
      'ID Laptop': ID,
      'Lokasi Ruangan': ruangan,
      'CPU': CPU,
      'RAM': ram,
      'Kapasitas Penyimpanan': storage,
      'VGA': vga,
      'Ukuran Monitor': monitor,
      'Masa Servis': masaServis,
      'Gambar Laptop': gambarLaptop
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.green,
      appBar: AppBar(
        backgroundColor: const Color(0xFF61BF9D),
        title: const Text(
          'Tambah Data Laptop',
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
                    'Merek Laptop',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                SizedBox(height: 10),
                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: merekLaptopController),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'ID Laptop',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: IdLaptopController),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Ruangan',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                SizedBox(height: 10),
                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: lokasiRuanganController),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'CPU',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                SizedBox(height: 10),
                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: CPUController),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'RAM',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                SizedBox(height: 10),
                MyTextField(
                    textInputType: TextInputType.number,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: RamController),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Storage',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                SizedBox(height: 10),
                MyTextField(
                    textInputType: TextInputType.number,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: StorageController),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'VGA',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                SizedBox(height: 10),
                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: VGAController),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Ukuran Monitor',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                SizedBox(height: 10),
                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: MonitorController),
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
                  controller: MasaServisLaptopController,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Gambar Laptop',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                SizedBox(height: 10),
                FieldImage(
                    controller: ImglaptopController,
                    selectedImageName: ImglaptopController.text.isNotEmpty
                        ? ImglaptopController.text.split('/').last
                        : '',
                    onPressed: PilihGambarLaptop),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: SimpanLaptop,
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
