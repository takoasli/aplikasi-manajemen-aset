import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projek_skripsi/Aset/Motor/ManajemenMotor.dart';

import '../../komponen/style.dart';
import '../../textfield/imageField.dart';
import '../../textfield/textfields.dart';

class EditMotor extends StatefulWidget {
  const EditMotor({super.key,
    required this.dokumenMotor});

  final String dokumenMotor;

  @override
  State<EditMotor> createState() => _EditMotorState();
}

class _EditMotorState extends State<EditMotor> {
  final merekMotorController = TextEditingController();
  final idMotorController = TextEditingController();
  final kapasitasMesinController = TextEditingController();
  final pendinginContorller = TextEditingController();
  final transmisiController = TextEditingController();
  final KapasitasBBController = TextEditingController();
  final KapasitasMinyakController = TextEditingController();
  final tipeAkiController = TextEditingController();
  final banDepanController = TextEditingController();
  final banBelakangController = TextEditingController();
  final MasaServisMotorController = TextEditingController();
  final ImgMotorController = TextEditingController();
  String oldphotoMotor = '';
  Map <String, dynamic> datamotor = {};
  final ImagePicker _gambarMotor = ImagePicker();
  final Sukses = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'SUCCESS',
      message: 'Data Motor berhasil Ditambahkan!',
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
      'Data Motor Gagal Dibuat',
      contentType: ContentType.success,
    ),
  );

  void PilihGambarMotor() async{
    final pilihMotor = await _gambarMotor.pickImage(source: ImageSource.gallery);
    if(pilihMotor != null) {
      setState(() {
        ImgMotorController.text = pilihMotor.path;
      });
    }
  }

  Future<String> unggahGambarMotor(File gambarMotor) async {
    try{
      if(!gambarMotor.existsSync()){
        print('File tidak ditemukan!');
        return '';
      }
      Reference penyimpanan = FirebaseStorage.instance
          .ref()
          .child('Motor')
          .child(ImgMotorController.text.split('/').last);

      UploadTask uploadMotor = penyimpanan.putFile(gambarMotor);
      await uploadMotor;
      String fotoMotor = await penyimpanan.getDownloadURL();
      return fotoMotor;
    }catch (e){
      print('$e');
      return '';
    }
  }

  Future<void> UpdateMotor(String dokMotor, Map<String, dynamic> DataMotor) async{
    try{
      String GambarMotor;

      if(ImgMotorController.text.isNotEmpty){
        File gambarMotorBaru = File(ImgMotorController.text);
        GambarMotor = await unggahGambarMotor(gambarMotorBaru);
      }else{
        GambarMotor = oldphotoMotor;
      }

      Map<String, dynamic> DataMotorBaru = {
        'Merek Motor' : merekMotorController.text,
        'ID Motor' : idMotorController.text,
        'Kapasitas Mesin' : kapasitasMesinController.text,
        'Sistem Pendingin' : pendinginContorller.text,
        'Tipe Transmisi' : transmisiController.text,
        'Kapasitas Bahan Bakar' : kapasitasMesinController.text,
        'Kapasitas Minyak' : KapasitasMinyakController.text,
        'Tipe Aki' : tipeAkiController.text,
        'Ban Depan' : banDepanController.text,
        'Ban Belakang' : banBelakangController.text,
        'Masa Servis' : MasaServisMotorController.text,
        'Gambar Motor' : GambarMotor
      };
      await FirebaseFirestore.instance.collection('Motor').doc(dokMotor).update(DataMotorBaru);

      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ManajemenMotor()),
      );
      ScaffoldMessenger.of(context).showSnackBar(Sukses);
    }catch (e){
      print(e);
    }
  }

  void initState(){
    super.initState();
    getMotor();
  }


  Future<void> getMotor() async{
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('Motor').doc(widget.dokumenMotor).get();
    final data = snapshot.data();

    setState(() {
      merekMotorController.text = data?['Merek Motor'] ?? '';
      idMotorController.text = data?['ID Motor'] ?? '';
      kapasitasMesinController.text = (data?['Kapasitas Mesin'] ?? '').toString();
      pendinginContorller.text = (data?['Sistem Pendingin'] ?? '').toString();
      transmisiController.text = data?['Tipe Transmisi' ?? ''];
      KapasitasBBController.text = (data?['Kapasitas Bahan Bakar' ?? '']).toString();
      KapasitasMinyakController.text = (data?['Kapasitas Minyak' ?? '']).toString();
      tipeAkiController.text = (data?['Tipe Aki' ?? '']).toString();
      banDepanController.text = data?['Ban Depan' ?? ''];
      banBelakangController.text = data?['Ban Belakang' ?? ''];
      MasaServisMotorController.text = (data?['Masa Servis' ?? '']).toString();
      final UrlMotor = data?['Gambar Motor'] ?? '';
      oldphotoMotor = UrlMotor;

    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.green,
      appBar: AppBar(
        backgroundColor: const Color(0xFF61BF9D),
        title: const Text(
          'Edit Data Motor',
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
                    'Merek Motor',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                const SizedBox(height: 10),

                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: merekMotorController),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'ID Motor',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),

                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: idMotorController),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Kapasitas Mesin',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                const SizedBox(height: 10),

                MyTextField(
                    textInputType: TextInputType.number,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: kapasitasMesinController),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Sistem Pendingin',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                const SizedBox(height: 10),

                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: pendinginContorller),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Tipe Transmisi',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                const SizedBox(height: 10),

                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: transmisiController),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Kapasitas Bahan Bakar',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                const SizedBox(height: 10),

                MyTextField(
                    textInputType: TextInputType.number,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: KapasitasBBController),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Kapasitas Minyak Pelumas',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                const SizedBox(height: 10),

                MyTextField(
                    textInputType: TextInputType.number,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: KapasitasMinyakController),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Tipe Aki',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                const SizedBox(height: 10),

                MyTextField(
                    textInputType: TextInputType.number,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: tipeAkiController),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Ukuran ban Depan',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),

                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: banDepanController),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Ukuran ban Belakang',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),

                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: banBelakangController),
                const SizedBox(height: 10),

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
                  controller: MasaServisMotorController,
                ),
                SizedBox(height: 10),


                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Gambar Motor',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                const SizedBox(height: 10),

                FieldImage(
                    controller: ImgMotorController,
                    selectedImageName: ImgMotorController.text.isNotEmpty
                        ? ImgMotorController.text.split('/').last
                        : '',
                    onPressed: PilihGambarMotor),
                const SizedBox(height: 30),

                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: (){
                      UpdateMotor(widget.dokumenMotor, datamotor);
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
