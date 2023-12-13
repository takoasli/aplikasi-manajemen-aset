import 'dart:io';
import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:projek_skripsi/textfield/textfields.dart';
import '../../komponen/kotakDialog.dart';
import '../../komponen/style.dart';
import '../../textfield/imageField.dart';
import '../ControllerLogic.dart';
import 'ManajemenPC.dart';

class AddPC extends StatefulWidget {
  const AddPC({super.key,});

  @override
  State<AddPC> createState() => _AddPCState();
}

class _AddPCState extends State<AddPC> {
  final merekPCController = TextEditingController();
  final IdPCController = TextEditingController();
  final lokasiRuanganController = TextEditingController();
  final CPUController = TextEditingController();
  final RamController = TextEditingController();
  final VGAController = TextEditingController();
  final isiKebutuhan = TextEditingController();
  final ImgPCController = TextEditingController();
  final StorageController = TextEditingController();
  final MasaServisController = TextEditingController();
  final PSUController = TextEditingController();
  final ImagePicker _gambarPC = ImagePicker();

  List Kebutuhan = [
  ];


  void PilihGambarPC() async{
    final pilihPC = await _gambarPC.pickImage(source: ImageSource.gallery);
    if (pilihPC != null) {
      setState(() {
        ImgPCController.text = pilihPC.path;
      });
    }
  }

  void SimpanKebutuhan(){
    setState(() {
      Kebutuhan.add([isiKebutuhan.text, false]);
      isiKebutuhan.clear();
    });
    Navigator.of(context).pop();
  }

  void tambahKebutuhan(){
    showDialog(
        context: context,
        builder: (context){
          return DialogBox(
            controller: isiKebutuhan,
            onAdd: SimpanKebutuhan,
            onCancel: () => Navigator.of(context).pop(),
            TextJudul: 'Tambah Kebutuhan PC',
          );
        });
  }

  void ApusKebutuhan(int index) {
    setState(() {
      Kebutuhan.removeAt(index);
    });
  }




  Future<String> unggahGambarPC(File gambarPC) async {
    try {
      if (!gambarPC.existsSync()) {
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
    } catch (e) {
      print('$e');
      return '';
    }
  }

  void SimpanPC() async {
    try {
      String lokasiGambarPC = ImgPCController.text;
      String fotoPC = '';
      List <Map<String, dynamic>> ListKebutuhan = [];
      for(var i = 0; i < Kebutuhan.length; i++){
        ListKebutuhan.add({
          'Kebutuhan PC': Kebutuhan[i][0]
        });
      }


      // kalo lokasiGambarPC tidak kosong, unggah gambar PC
      if (lokasiGambarPC.isNotEmpty) {
        File imgPC = File(lokasiGambarPC);
        fotoPC = await unggahGambarPC(imgPC);
      }

        // Tambahkan data PC ke Firestore
        await tambahPC(
          merekPCController.text.trim(),
          IdPCController.text.trim(),
          lokasiRuanganController.text.trim(),
          CPUController.text.trim(),
          int.parse(RamController.text.trim()),
          int.parse(StorageController.text.trim()),
          VGAController.text.trim(),
          int.parse(PSUController.text.trim()),
          int.parse(MasaServisController.text.trim()),
          ListKebutuhan,
          fotoPC,
        );

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'Berhasil!',
        desc: 'Data PC Berhasil Ditambahkan',
        btnOkOnPress: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ManajemenPC()),
          );
        },
        autoHide: Duration(seconds: 5),
      ).show();
      print('Data PC Berhasil Ditambahkan');

    } catch (e) {
      print("Error : $e");
    }
  }

  Future tambahPC (String merek, String ID, String ruangan,
      String CPU, int ram, int storage, String vga, int psu, int masaServis,List<Map<String, dynamic>> kebutuhan,  String gambarPC) async{
    var timeService = contTimeService(masaServis);
    await FirebaseFirestore.instance.collection('PC').add({
      'Merek PC' : merek,
      'ID PC' : ID,
      'Lokasi Ruangan' : ruangan,
      'CPU' : CPU,
      'RAM' : ram,
      'Kapasitas Penyimpanan' : storage,
      'VGA' : vga,
      'Kapasitas Power Supply' : psu,
      'Masa Servis' : masaServis,
      'kebutuhan' : kebutuhan,
      'Gambar PC' : gambarPC,
      'Waktu Service PC': timeService.millisecondsSinceEpoch,
      'Hari Service PC': daysBetween(DateTime.now(), timeService)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.green,
      appBar: AppBar(
        backgroundColor: const Color(0xFF61BF9D),
        title: const Text(
          'Tambah Data PC',
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
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
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
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Kebutuhan',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),

                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: Kebutuhan.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(Kebutuhan[index][0]), // Menampilkan teks kebutuhan
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          ApusKebutuhan(index); // Fungsi untuk menghapus kebutuhan
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

                SizedBox(height: 30),

                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: SimpanPC,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
