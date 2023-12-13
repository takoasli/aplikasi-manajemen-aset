import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projek_skripsi/Aset/PC/ManajemenPC.dart';

import '../../komponen/kotakDialog.dart';
import '../../komponen/style.dart';
import '../../textfield/imageField.dart';
import '../../textfield/textfields.dart';
import '../ControllerLogic.dart';

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
  final isiKebutuhan = TextEditingController();
  final PSUController = TextEditingController();
  final MasaServisController = TextEditingController();
  String oldphotoPC = '';
  Map <String, dynamic> dataPC = {};
  final ImagePicker _gambarPC = ImagePicker();

  List Kebutuhan = [
  ];

  void PilihGambarPC() async{
    final pilihPC = await _gambarPC.pickImage(source: ImageSource.gallery);
    if(pilihPC != null) {
      setState(() {
        ImgPCController.text = pilihPC.path;
      });
    }
  }

  void SimpanKebutuhan(){
    setState(() {
      Kebutuhan.add({'Kebutuhan PC': isiKebutuhan.text});
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
      List <Map<String, dynamic>> ListKebutuhan = [];
      var timeService = contTimeService(int.parse(MasaServisController.text));
      for(var i = 0; i < Kebutuhan.length; i++){
        ListKebutuhan.add({'Kebutuhan PC': Kebutuhan[i]['Kebutuhan PC']});
      }

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
        'kebutuhan' : ListKebutuhan,
        'Gambar PC' : GambarPC,
        'Waktu Service PC': timeService.millisecondsSinceEpoch,
        'Hari Service PC': daysBetween(DateTime.now(), timeService)
      };

      await FirebaseFirestore.instance.collection('PC').doc(dokPC).update(DataPCBaru);

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'Berhasil!',
        desc: 'Data PC Berhasil Diupdate',
        btnOkOnPress: () {
          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const ManajemenPC()),
          );
        },
        autoHide: Duration(seconds: 5),
      ).show();
      print('Data PC Berhasil Diupdate');
    }catch (e){
      print(e);
    }
  }

  void initState(){
    super.initState();
    getData();
  }

  Future<void> getData() async{
    try{
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
        final List<dynamic> KebutuhanData = data?['kebutuhan'] ?? [];
        KebutuhanData.forEach((item) {
          Kebutuhan.add({'Kebutuhan PC' : item['Kebutuhan PC']});
        });

      });
    }catch(e){
      print('Terjadi kesalahan: $e');
    }

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
                const SizedBox(height: 10),

                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: merekPCController),
                const SizedBox(height: 10),

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
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Ruangan',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                const SizedBox(height: 10),

                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: lokasiRuanganController),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'CPU',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                const SizedBox(height: 10),

                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: CPUController),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'RAM',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                const SizedBox(height: 10),

                MyTextField(
                    textInputType: TextInputType.number,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: RamController),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Storage',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                const SizedBox(height: 10),

                MyTextField(
                    textInputType: TextInputType.number,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: StorageController),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'VGA',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                const SizedBox(height: 10),

                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: VGAController),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'PSU',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                const SizedBox(height: 10),

                MyTextField(
                    textInputType: TextInputType.number,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: PSUController),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Jangka Waktu Servis (Perbulan)',
                    style: TextStyles.title.copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                const SizedBox(height: 10),

                MyTextField(
                  textInputType: TextInputType.number,
                  hint: '',
                  textInputAction: TextInputAction.next,
                  controller: MasaServisController,
                ),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Gambar PC',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                const SizedBox(height: 10),

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
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: Kebutuhan.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(Kebutuhan[index]['Kebutuhan PC']), // Gunakan kunci yang benar
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
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
                    padding: const EdgeInsets.all(8),
                    child: const Row(
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
