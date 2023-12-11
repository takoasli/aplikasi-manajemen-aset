import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projek_skripsi/Aset/Mobil/manajemenMobil.dart';

import '../../komponen/kotakDialog.dart';
import '../../komponen/style.dart';
import '../../textfield/imageField.dart';
import '../../textfield/textfields.dart';
import '../Durability.dart';

class EditMobil extends StatefulWidget {
  const EditMobil({super.key,
    required this.dokumenMobil});
  final String dokumenMobil;

  @override
  State<EditMobil> createState() => _EditMobilState();
}

class _EditMobilState extends State<EditMobil> {
  final merekMobilController =TextEditingController();
  final idMobilCOntroller = TextEditingController();
  final tipemesinController = TextEditingController();
  final tipeBahanBakarController = TextEditingController();
  final pendinginController = TextEditingController();
  final transmisController =TextEditingController();
  final kapasitasBBController = TextEditingController();
  final isiKebutuhan_Mobil = TextEditingController();
  final ukuranBanController = TextEditingController();
  final akiController = TextEditingController();
  final MasaServisMobilController = TextEditingController();
  final imgMobilController = TextEditingController();
  final ImagePicker _gambarMobil = ImagePicker();
  String oldphotoMobil = '';
  Map <String, dynamic> datamobil = {};
  List Kebutuhan_Mobil = [];
  final Sukses = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'SUCCESS',
      message: 'Data Mobil berhasil Diupdate!',
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
      'Data Mobil Gagal Dibuat',
      contentType: ContentType.success,
    ),
  );

  void PilihGambarMobil() async{
    final pilihMobil = await _gambarMobil.pickImage(source: ImageSource.gallery);
    if(pilihMobil != null) {
      setState(() {
        imgMobilController.text = pilihMobil.path;
      });
    }
  }

  Future<String> unggahGambarMobil(File gambarMobil) async {
    try{
      if(!gambarMobil.existsSync()){
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
    }catch (e){
      print('$e');
      return '';
    }
  }

  void SimpanKebutuhan_Mobil(){
    setState(() {
      Kebutuhan_Mobil.add({'Nama Kebutuhan': isiKebutuhan_Mobil.text});
      isiKebutuhan_Mobil.clear();
    });
    Navigator.of(context).pop();
  }
  void tambahKebutuhan_Mobil(){
    showDialog(
        context: context,
        builder: (context){
          return DialogBox(
            controller: isiKebutuhan_Mobil,
            onAdd: SimpanKebutuhan_Mobil,
            onCancel: () => Navigator.of(context).pop(),
            TextJudul: 'Tambah Kebutuhan Mobil',
          );
        });
  }

  void ApusKebutuhan(int index) {
    setState(() {
      Kebutuhan_Mobil.removeAt(index);
    });
  }

  void initState(){
    super.initState();
    getMobil();
  }


  Future<void> getMobil() async{
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('Mobil').doc(widget.dokumenMobil).get();
    final data = snapshot.data();

    setState(() {
      merekMobilController.text = data?['Merek Mobil'] ?? '';
      idMobilCOntroller.text = data?['ID Mobil'] ?? '';
      tipemesinController.text = data?['Tipe Mesin'] ?? '';
      tipeBahanBakarController.text = data?['Jenis Bahan Bakar'] ?? '';
      pendinginController.text = data?['Sistem Pendingin Mesin'] ?? '';
      transmisController.text = data?['Tipe Transmisi'] ?? '';
      kapasitasBBController.text = (data?['Kapasitas Bahan Bakar' ?? '']).toString();
      ukuranBanController.text = data?['Ukuran Ban' ?? ''];
      akiController.text = data?['Aki' ?? ''];
      ukuranBanController.text = data?['Ukuran Ban' ?? ''];
      MasaServisMobilController.text = (data?['Masa Servis' ?? '']).toString();
      final UrlMobil = data?['Gambar Mobil'] ?? '';
      oldphotoMobil = UrlMobil;
      final List<dynamic> KebutuhanData = data?['Kebutuhan Mobil'] ?? [];
      KebutuhanData.forEach((item) {
        Kebutuhan_Mobil.add({'Nama Kebutuhan' : item['Nama Kebutuhan']});
      });

    });
  }

  Future<void> UpdateMobil(String dokMobil, Map<String, dynamic> DataMobil) async{
    try{
      String GambarMobil;

      List <Map<String, dynamic>> ListKebutuhan_Mobil = [];
      var timeService = contTimeService(int.parse(MasaServisMobilController.text));
      for(var i = 0; i < Kebutuhan_Mobil.length; i++){
        ListKebutuhan_Mobil.add({'Nama Kebutuhan': Kebutuhan_Mobil[i]['Nama Kebutuhan']});
      }

      if(imgMobilController.text.isNotEmpty){
        File gambarMobilBaru = File(imgMobilController.text);
        GambarMobil = await unggahGambarMobil(gambarMobilBaru);
      }else{
        GambarMobil = oldphotoMobil;
      }

      Map<String, dynamic> DataMobilBaru = {
        'Merek Mobil' : merekMobilController.text,
        'ID Mobil' : idMobilCOntroller.text,
        'Tipe Mesin' : tipemesinController.text,
        'Sistem Pendingin Mesin' : pendinginController.text,
        'Tipe Transmisi' : transmisController.text,
        'Jenis Bahan Bakar' : tipeBahanBakarController.text,
        'Kapasitas Bahan Bakar' : kapasitasBBController.text,
        'Ukuran Ban' : ukuranBanController.text,
        'Aki' : akiController.text,
        'Masa Servis' : MasaServisMobilController.text,
        'Kebutuhan Mobil' : ListKebutuhan_Mobil,
        'Gambar Mobil' : GambarMobil,
        'Waktu Service Mobil': timeService.millisecondsSinceEpoch,
        'Hari Service Mobil': daysBetween(DateTime.now(), timeService)
      };
      await FirebaseFirestore.instance.collection('Mobil').doc(dokMobil).update(DataMobilBaru);

      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ManajemenMobil()),
      );
      ScaffoldMessenger.of(context).showSnackBar(Sukses);
    }catch (e){
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.green,
      appBar: AppBar(
        backgroundColor: const Color(0xFF61BF9D),
        title: const Text(
          'Edit Data Mobil',
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
                    'Tipe Mesin',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                SizedBox(height: 10),

                MyTextField(
                    textInputType: TextInputType.text,
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
                    'Tipe Aki',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                SizedBox(height: 10),

                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: akiController),
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
                  itemCount: Kebutuhan_Mobil.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(Kebutuhan_Mobil[index]['Nama Kebutuhan']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          ApusKebutuhan(index);
                        },
                        color: Colors.red,
                      ),
                    );
                  },
                ),



                InkWell(
                  onTap: tambahKebutuhan_Mobil,
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
                      UpdateMobil(widget.dokumenMobil, datamobil);
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
