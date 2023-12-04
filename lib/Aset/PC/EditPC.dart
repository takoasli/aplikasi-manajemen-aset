import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projek_skripsi/Aset/PC/ManajemenPC.dart';

import '../../komponen/style.dart';
import '../../textfield/imageField.dart';
import '../../textfield/textfields.dart';

class EditPC extends StatefulWidget {
  const EditPC({super.key,
    required this.dokumenPC});
  final String dokumenPC;

  @override
  State<EditPC> createState() => _EditPCState();
}

class _EditPCState extends State<EditPC> {
  final merekPCController = TextEditingController();
  final IdPCController = TextEditingController();
  final lokasiRuanganController = TextEditingController();
  final CPUController = TextEditingController();
  final RamController = TextEditingController();
  final VGAController = TextEditingController();
  final ImgPCController = TextEditingController();
  final StorageController = TextEditingController();
  final PSUController = TextEditingController();
  final MasaServisController = TextEditingController();
  String oldphotoPC = '';
  Map <String, dynamic> dataPC = {};
  final ImagePicker _gambarPC = ImagePicker();
  final Sukses = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'SUCCESS',
      message: 'Data PC berhasil Ditambahkan!',
      contentType: ContentType.success,
    ),
  );

  final gagal = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'FAILED',
      message:
      'Data PC Gagal Diubah',
      contentType: ContentType.success,
    ),
  );

  void PilihGambarPC() async{
    final pilihPC = await _gambarPC.pickImage(source: ImageSource.gallery);
    if(pilihPC != null) {
      setState(() {
        ImgPCController.text = pilihPC.path;
      });
    }
  }

  Future<String> unggahGambarPC(File gambarPC) async {
    try{
      if(!gambarPC.existsSync()){
        print('File tidak ditemukan!');
        return '';
      }
      Reference penyimpanan = FirebaseStorage.instance
          .ref()
          .child('Personal Conputer')
          .child(ImgPCController.text.split('/').last);

      UploadTask uploadPC = penyimpanan.putFile(gambarPC);
      await uploadPC;
      String fotoPC = await penyimpanan.getDownloadURL();
      return fotoPC;
    }catch (e){
      print('$e');
      return '';
    }
  }

  Future<void> UpdatePC(String dokPC, Map<String, dynamic> DataPC) async{
    try{
      String GambarPC;

      if(ImgPCController.text.isNotEmpty){
        File gambarPCBaru = File(ImgPCController.text);
        GambarPC = await unggahGambarPC(gambarPCBaru);
      }else{
        GambarPC = oldphotoPC;
      }

      Map<String, dynamic> DataPCBaru = {
        'Merek PC' : merekPCController.text,
        'ID PC' : IdPCController.text,
        'Lokasi Ruangan' : lokasiRuanganController.text,
        'CPU' : CPUController.text,
        'RAM' : RamController.text,
        'Kapasitas Penyimpanan' : StorageController.text,
        'VGA' : VGAController.text,
        'Kapasitas Power Supply' : PSUController.text,
        'Masa Servis' : MasaServisController.text,
        'Gambar PC' : GambarPC
      };

      await FirebaseFirestore.instance.collection('PC').doc(dokPC).update(DataPCBaru);

      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ManajemenPC()),
      );
    }catch (e){
      print(e);
    }
  }

  void initState(){
    super.initState();
    getData();
  }

  Future<void> getData() async{
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('PC').doc(widget.dokumenPC).get();
    final data = snapshot.data();

    setState(() {
      merekPCController.text = data?['Merek PC'] ?? '';
      IdPCController.text = data?['ID PC'] ?? '';
      lokasiRuanganController.text = data?['Lokasi Ruangan'] ?? '';
      CPUController.text = data?['CPU'] ?? '';
      RamController.text = (data?['RAM'] ?? '').toString();
      StorageController.text = (data?['Kapasitas Penyimpanan'] ?? '').toString();
      VGAController.text = data?['VGA'] ?? '';
      PSUController.text = (data?['Kapasitas Power Supply'] ?? '').toString();
      MasaServisController.text = (data?['Masa Servis'] ?? '').toString();
      final UrlPC = data?['Gambar PC'] ?? '';
      oldphotoPC = UrlPC;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.green,
      appBar: AppBar(
        backgroundColor: const Color(0xFF61BF9D),
        title: const Text(
          'Edit Data PC',
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
                    'Merek PC',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                SizedBox(height: 10),

                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: merekPCController),
                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'ID PC',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),

                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: IdPCController),
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
                    'PSU',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                SizedBox(height: 10),

                MyTextField(
                    textInputType: TextInputType.number,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: PSUController),
                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Jangka Waktu Servis (Perbulan)',
                    style: TextStyles.title.copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                SizedBox(height: 10),

                MyTextField(
                  textInputType: TextInputType.number,
                  hint: '',
                  textInputAction: TextInputAction.next,
                  controller: MasaServisController,
                ),
                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Gambar PC',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                SizedBox(height: 10),

                FieldImage(
                    controller: ImgPCController,
                    selectedImageName: ImgPCController.text.isNotEmpty
                        ? ImgPCController.text.split('/').last
                        : '',
                    onPressed: PilihGambarPC),
                const SizedBox(height: 30),

                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: (){
                      UpdatePC(widget.dokumenPC, dataPC);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Warna.green,
                        minimumSize: const Size(300, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))
                    ),
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
