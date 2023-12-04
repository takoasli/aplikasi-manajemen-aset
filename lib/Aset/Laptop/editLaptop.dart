import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projek_skripsi/Aset/Laptop/manajemenLaptop.dart';

import '../../komponen/style.dart';
import '../../textfield/imageField.dart';
import '../../textfield/textfields.dart';

class editLaptop extends StatefulWidget {
  const editLaptop({super.key,
    required this.dokumenLaptop});
  final String dokumenLaptop;

  @override
  State<editLaptop> createState() => _editLaptopState();
}

class _editLaptopState extends State<editLaptop> {
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
  String oldphotoLaptop = '';
  Map <String, dynamic> dataLaptop = {};

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

  final gagal = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'FAILED',
      message:
      'Data Laptop Gagal Dibuat',
      contentType: ContentType.success,
    ),
  );

  void PilihGambarLaptop() async{
    final pilihLaptop = await _gambarLaptop.pickImage(source: ImageSource.gallery);
    if(pilihLaptop != null) {
      setState(() {
        ImglaptopController.text = pilihLaptop.path;
      });
    }
  }

  Future<String> unggahGambarLaptop(File gambarLaptop) async {
    try{
      if(!gambarLaptop.existsSync()){
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
    }catch (e){
      print('$e');
      return '';
    }
  }

  Future<void> UpdateLaptop(String dokLaptop, Map<String, dynamic> DataLaptop) async{
    try{
      String GambarLaptop;

      if(ImglaptopController.text.isNotEmpty){
        File gambarLaptopBaru = File(ImglaptopController.text);
        GambarLaptop = await unggahGambarLaptop(gambarLaptopBaru);
      }else{
        GambarLaptop = oldphotoLaptop;
      }

      Map<String, dynamic> DataLaptopBaru = {
        'Merek Laptop' : merekLaptopController.text,
        'ID Laptop' : IdLaptopController.text,
        'Lokasi Ruangan' : lokasiRuanganController.text,
        'CPU' : CPUController.text,
        'RAM' : RamController.text,
        'Kapasitas Penyimpanan' : StorageController.text,
        'VGA' : VGAController.text,
        'Ukuran Monitor' : MonitorController.text,
        'Masa Servis' : MasaServisLaptopController.text,
        'Gambar Laptop' : GambarLaptop
      };

      await FirebaseFirestore.instance.collection('Laptop').doc(dokLaptop).update(DataLaptopBaru);

      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ManajemenLaptop()),
      );
      ScaffoldMessenger.of(context).showSnackBar(Sukses);
    }catch (e){
      print(e);
    }
  }

  void initState(){
    super.initState();
    getLaptop();
  }

  Future<void> getLaptop() async{
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('Laptop').doc(widget.dokumenLaptop).get();
    final data = snapshot.data();

    setState(() {
      merekLaptopController.text = data?['Merek Laptop'] ?? '';
      IdLaptopController.text = data?['ID Laptop'] ?? '';
      lokasiRuanganController.text = data?['Lokasi Ruangan'] ?? '';
      CPUController.text = data?['CPU'] ?? '';
      RamController.text = (data?['RAM'] ?? '').toString();
      StorageController.text = (data?['Kapasitas Penyimpanan'] ?? '').toString();
      VGAController.text = data?['VGA'] ?? '';
      MonitorController.text = data?['Ukuran Monitor'] ?? '';
      MasaServisLaptopController.text = (data?['Masa Servis'] ?? '').toString();
      final Urllaptop = data?['Gambar Laptop'] ?? '';
      oldphotoLaptop = Urllaptop;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.green,
      appBar: AppBar(
        backgroundColor: const Color(0xFF61BF9D),
        title: const Text(
          'Edit Data Laptop',
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
                    style: TextStyles.title.copyWith(fontSize: 15, color: Warna.darkgrey),
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
                    onPressed: (){
                      UpdateLaptop(widget.dokumenLaptop, dataLaptop);
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
