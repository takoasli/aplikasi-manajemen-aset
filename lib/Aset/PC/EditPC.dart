import 'dart:io';
import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projek_skripsi/Aset/PC/ManajemenPC.dart';

import '../../komponen/kotakDialog.dart';
import '../../komponen/style.dart';
import '../../main.dart';
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

class KebutuhanModelUpdate {
  String namaKebutuhan;
  int masaKebutuhan;
  int randomID;

  KebutuhanModelUpdate(
      this.namaKebutuhan,
      this.masaKebutuhan,
      this.randomID);

  Map<String, dynamic> toMap() {
    return {
      'Kebutuhan PC': namaKebutuhan,
      'Masa Kebutuhan': masaKebutuhan,
      'ID' : randomID
    };
  }
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
  final MasaKebutuhanController = TextEditingController();
  String oldphotoPC = '';
  Map <String, dynamic> dataPC = {};
  final ImagePicker _gambarPC = ImagePicker();
  List Kebutuhan = [];

  void PilihGambarPC() async{
    final pilihPC = await _gambarPC.pickImage(source: ImageSource.gallery);
    if(pilihPC != null) {
      setState(() {
        ImgPCController.text = pilihPC.path;
      });
    }
  }

  int generateRandomId() {
    Random random = Random();
    return random.nextInt(400) + 1;
  }

  void SimpanKebutuhan_PC() async {
    String masaKebutuhanText = MasaKebutuhanController.text.trim();
    int randomId = generateRandomId();
    print('Random ID: $randomId');
    if (masaKebutuhanText.isNotEmpty) {
      try {
        int masaKebutuhan = int.parse(masaKebutuhanText);

        Kebutuhan.add({
          'Kebutuhan PC': isiKebutuhan.text,
          'Masa Kebutuhan': masaKebutuhan,
          'ID' : randomId,
        });

        isiKebutuhan.clear();
        MasaKebutuhanController.clear();

        setState(() {});
        await AndroidAlarmManager.oneShot(
          Duration(days: masaKebutuhan),
          randomId,
              () => myAlarmFunctionMotor(randomId),
          exact: true,
          wakeup: true,
        );

        print('Alarm berhasil diset');
        Navigator.of(context).pop();
      } catch (error) {
        print('Error saat mengatur alarm: $error');
      }
    } else {
      print('Input Masa Kebutuhan tidak boleh kosong');
      // Tindakan jika input kosong
    }
  }

  void myAlarmFunctionMotor(int id) {
    Notif.showTextNotif(
      judul: 'PT Dami Sariwana',
      body: 'Ada PC yang jatuh tempo!',
      fln: flutterLocalNotificationsPlugin,
      id: id,
    );
  }


  void tambahKebutuhan(){
    showDialog(
        context: context,
        builder: (context){
          return DialogBox(
            controller: isiKebutuhan,
            onAdd: SimpanKebutuhan_PC,
            onCancel: () => Navigator.of(context).pop(),
            TextJudul: 'Tambah Kebutuhan PC',
            JangkaKebutuhan: MasaKebutuhanController,
          );
        });
  }

  void ApusKebutuhan(int index) {
    setState(() {
      Kebutuhan.removeAt(index);
    });
  }

  void myAlarmFunction() {
    // Lakukan tugas yang diperlukan saat alarm terpicu
    print('Alarm terpicu untuk kebutuhan PC!');
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

  Future<void> UpdatePC(String dokPC, Map<String, dynamic> DataPC) async {
    try {
      String GambarPC;

      List<Map<String, dynamic>> listKebutuhan = Kebutuhan.map((kebutuhan) {
        var timeKebutuhan = contTimeService(int.parse(kebutuhan['Masa Kebutuhan'].toString()));
        return {
          'Kebutuhan PC': kebutuhan['Kebutuhan PC'],
          'Masa Kebutuhan': kebutuhan['Masa Kebutuhan'],
          'Waktu Kebutuhan PC': timeKebutuhan.millisecondsSinceEpoch,
          'Hari Kebutuhan PC': daysBetween(DateTime.now(), timeKebutuhan),
          'ID' : kebutuhan['ID'],
        };
      }).toList();

      if (ImgPCController.text.isNotEmpty) {
        File gambarPCBaru = File(ImgPCController.text);
        GambarPC = await unggahGambarPC(gambarPCBaru);
      } else {
        GambarPC = oldphotoPC;
      }

      // Menjalankan proses update untuk setiap item kebutuhan
      for (var item in listKebutuhan) {
        var waktuKebutuhan = contTimeService(int.parse(item['Masa Kebutuhan'].toString()));
        Map<String, dynamic> DataPCBaru = {
          'Merek PC': merekPCController.text,
          'ID PC': IdPCController.text,
          'Lokasi Ruangan': lokasiRuanganController.text,
          'CPU': CPUController.text,
          'RAM': RamController.text,
          'Kapasitas Penyimpanan': StorageController.text,
          'VGA': VGAController.text,
          'Kapasitas Power Supply': PSUController.text,
          'kebutuhan': listKebutuhan,
          'Gambar PC': GambarPC,
          'Jenis Aset' : 'PC',
          'Waktu Kebutuhan PC': waktuKebutuhan.millisecondsSinceEpoch,
          'Hari Kebutuhan PC': daysBetween(DateTime.now(), waktuKebutuhan)
        };

        // Update dokumen Firestore sesuai dengan dokPC
        await FirebaseFirestore.instance.collection('PC').doc(dokPC).update(DataPCBaru);
      }

      // Menampilkan dialog sukses setelah update berhasil
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'Berhasil!',
        desc: 'Data PC Berhasil Diupdate',
        btnOkOnPress: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ManajemenPC()),
          );
        },
        autoHide: Duration(seconds: 5),
      ).show();

      print('Data PC Berhasil Diupdate');
    } catch (e) {
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
        final UrlPC = data?['Gambar PC'] ?? '';
        oldphotoPC = UrlPC;
        Kebutuhan = List<Map<String, dynamic>>.from(data?['kebutuhan'] ?? []);
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
                    'RAM (GB)',
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
                    'Storage (GB)',
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
                    'Kapasitas PSU (watt)',
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
                      title: Text(Kebutuhan[index]['Kebutuhan PC']),
                      subtitle: Text('${Kebutuhan[index]['Masa Kebutuhan']} Bulan'),
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
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
