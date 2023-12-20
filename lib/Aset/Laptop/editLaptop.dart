import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projek_skripsi/Aset/Laptop/manajemenLaptop.dart';

import '../../komponen/kotakDialog.dart';
import '../../komponen/style.dart';
import '../../textfield/imageField.dart';
import '../../textfield/textfields.dart';
import '../ControllerLogic.dart';

class editLaptop extends StatefulWidget {
  const editLaptop({super.key,
    required this.dokumenLaptop});
  final String dokumenLaptop;

  @override
  State<editLaptop> createState() => _editLaptopState();
}

class KebutuhanModelUpdateLaptop {
  String namaKebutuhanLaptop;
  int masaKebutuhanLaptop;

  KebutuhanModelUpdateLaptop(this.namaKebutuhanLaptop, this.masaKebutuhanLaptop);

  Map<String, dynamic> toMap() {
    return {
      'Nama Kebutuhan Laptop': namaKebutuhanLaptop,
      'Masa Kebutuhan Laptop': masaKebutuhanLaptop,
    };
  }
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
  final MasaKebutuhanController = TextEditingController();
  final MasaServisLaptopController = TextEditingController();
  final isiKebutuhan_Laptop = TextEditingController();
  final ImagePicker _gambarLaptop = ImagePicker();
  String oldphotoLaptop = '';
  List Kebutuhan_Laptop = [
  ];
  Map <String, dynamic> dataLaptop = {};

  void SimpanKebutuhan_Laptop(){
    setState(() {
      KebutuhanModelUpdateLaptop kebutuhan = KebutuhanModelUpdateLaptop(
        isiKebutuhan_Laptop.text,
        int.parse(MasaKebutuhanController.text),
      );
      Kebutuhan_Laptop.add(kebutuhan.toMap());
      isiKebutuhan_Laptop.clear();
      MasaKebutuhanController.clear();
    });
    Navigator.of(context).pop();
  }

  void tambahKebutuhan_Laptop(){
    showDialog(
        context: context,
        builder: (context){
          return DialogBox(
            controller: isiKebutuhan_Laptop,
            onAdd: SimpanKebutuhan_Laptop,
            onCancel: () => Navigator.of(context).pop(),
            TextJudul: 'Tambah Kebutuhan Laptop',
            JangkaKebutuhan: MasaKebutuhanController,
          );
        });
  }

  void ApusKebutuhan_laptop(int index) {
    setState(() {
      Kebutuhan_Laptop.removeAt(index);
    });
  }

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

      List<Map<String, dynamic>> ListKebutuhan_Laptop = Kebutuhan_Laptop.map((kebutuhan) {
        var timeKebutuhan = contTimeService(int.parse(kebutuhan['Masa Kebutuhan Laptop'].toString()));
        return {
          'Nama Kebutuhan Laptop': kebutuhan['Nama Kebutuhan Laptop'],
          'Masa Kebutuhan Laptop': kebutuhan['Masa Kebutuhan Laptop'],
          'Waktu Kebutuhan Laptop': timeKebutuhan.millisecondsSinceEpoch,
          'Hari Kebutuhan Laptop': daysBetween(DateTime.now(), timeKebutuhan)
        };
      }).toList();

      if(ImglaptopController.text.isNotEmpty){
        File gambarLaptopBaru = File(ImglaptopController.text);
        GambarLaptop = await unggahGambarLaptop(gambarLaptopBaru);
      }else{
        GambarLaptop = oldphotoLaptop;
      }

      for(var item in ListKebutuhan_Laptop){
        var waktuKebutuhanLaptop = contTimeService(int.parse(item['Masa Kebutuhan Laptop'].toString()));
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
          'Kebutuhan Laptop' : ListKebutuhan_Laptop,
          'Gambar Laptop' : GambarLaptop,
          'Jenis Aset' : 'Laptop',
          'Waktu Service Laptop': waktuKebutuhanLaptop.millisecondsSinceEpoch,
          'Hari Service Laptop': daysBetween(DateTime.now(), waktuKebutuhanLaptop)
        };
        await FirebaseFirestore.instance.collection('Laptop').doc(dokLaptop).update(DataLaptopBaru);
      }

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'Berhasil!',
        desc: 'Data Laptop Berhasil Diupdate',
        btnOkOnPress: () {
          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ManajemenLaptop()),
          );
        },
        autoHide: Duration(seconds: 5),
      ).show();
      print('Data Laptop Berhasil Diupdate');

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
      final List<dynamic> KebutuhanData = data?['Kebutuhan Laptop'] ?? [];
      Kebutuhan_Laptop = KebutuhanData.map((item) {
        return {
          'Nama Kebutuhan Laptop': item['Nama Kebutuhan Laptop'],
          'Masa Kebutuhan Laptop': item['Masa Kebutuhan Laptop'],
        };
      }).toList();
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
                  itemCount: Kebutuhan_Laptop.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(Kebutuhan_Laptop[index]['Nama Kebutuhan Laptop']),
                      subtitle: Text('${Kebutuhan_Laptop[index]['Masa Kebutuhan Laptop']} Bulan'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          ApusKebutuhan_laptop(index);
                        },
                        color: Colors.red,
                      ),
                    );
                  },
                ),



                InkWell(
                  onTap: tambahKebutuhan_Laptop,
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
