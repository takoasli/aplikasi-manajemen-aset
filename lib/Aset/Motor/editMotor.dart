import 'dart:io';
import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projek_skripsi/Aset/Motor/ManajemenMotor.dart';

import '../../komponen/kotakDialog.dart';
import '../../komponen/style.dart';
import '../../main.dart';
import '../../textfield/imageField.dart';
import '../../textfield/textfields.dart';
import '../ControllerLogic.dart';

class EditMotor extends StatefulWidget {
  const EditMotor({super.key,
    required this.dokumenMotor});

  final String dokumenMotor;

  @override
  State<EditMotor> createState() => _EditMotorState();
}

class KebutuhanModelUpdateMotor {
  String namaKebutuhanMotor;
  int masaKebutuhanMotor;
  int randomID;

  KebutuhanModelUpdateMotor(
      this.namaKebutuhanMotor,
      this.masaKebutuhanMotor,
      this.randomID);

  Map<String, dynamic> toMap() {
    return {
      'Nama Kebutuhan Motor': namaKebutuhanMotor,
      'Masa Kebutuhan Motor': masaKebutuhanMotor,
      'ID' : randomID
    };
  }
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
  final isiKebutuhan_Motor = TextEditingController();
  final MasaKebutuhanController = TextEditingController();
  final ImgMotorController = TextEditingController();
  String oldphotoMotor = '';
  Map <String, dynamic> datamotor = {};
  List Kebutuhan_Motor = [];
  final ImagePicker _gambarMotor = ImagePicker();

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

  int generateRandomId() {
    Random random = Random();
    return random.nextInt(400) + 1;
  }

  void SimpanKebutuhan_Motor() async {
    String masaKebutuhanText = MasaKebutuhanController.text.trim();
    int randomId = generateRandomId();
    print('Random ID: $randomId');
    if (masaKebutuhanText.isNotEmpty) {
      try {
        int masaKebutuhan = int.parse(masaKebutuhanText);

        Kebutuhan_Motor.add({
          'Nama Kebutuhan Motor': isiKebutuhan_Motor.text,
          'Masa Kebutuhan Motor': masaKebutuhan,
          'ID' : randomId,
        });

        isiKebutuhan_Motor.clear();
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
        // Lakukan penanganan kesalahan jika parsing gagal
      }
    } else {
      print('Input Masa Kebutuhan tidak boleh kosong');
      // Tindakan jika input kosong
    }
  }

  void myAlarmFunctionMotor(int id) {
    Notif.showTextNotif(
      judul: 'PT Dami Sariwana',
      body: 'Ada Motor yang jatuh tempo!',
      fln: flutterLocalNotificationsPlugin,
      id: id,
    );
  }

  void tambahKebutuhan_Motor(){
    showDialog(
        context: context,
        builder: (context){
          return DialogBox(
            controller: isiKebutuhan_Motor,
            onAdd: SimpanKebutuhan_Motor,
            onCancel: () => Navigator.of(context).pop(),
            TextJudul: 'Tambah Kebutuhan Motor',
            JangkaKebutuhan: MasaKebutuhanController,
          );
        });
  }

  void ApusKebutuhan_Motor(int index) {
    setState(() {
      Kebutuhan_Motor.removeAt(index);
    });
  }

  Future<void> UpdateMotor(String dokMotor, Map<String, dynamic> DataMotor) async{
    try{
      String GambarMotor;
      List<Map<String, dynamic>> ListKebutuhan_Motor = Kebutuhan_Motor.map((kebutuhan) {
        var timeKebutuhan = contTimeService(int.parse(kebutuhan['Masa Kebutuhan Motor'].toString()));
        return {
          'Nama Kebutuhan Motor': kebutuhan['Nama Kebutuhan Motor'],
          'Masa Kebutuhan Motor': kebutuhan['Masa Kebutuhan Motor'],
          'Waktu Kebutuhan Motor': timeKebutuhan.millisecondsSinceEpoch,
          'Hari Kebutuhan Motor': daysBetween(DateTime.now(), timeKebutuhan),
          'ID' : kebutuhan['ID'],
        };
      }).toList();

      if(ImgMotorController.text.isNotEmpty){
        File gambarMotorBaru = File(ImgMotorController.text);
        GambarMotor = await unggahGambarMotor(gambarMotorBaru);
      }else{
        GambarMotor = oldphotoMotor;
      }

      for(var item in ListKebutuhan_Motor){
        var waktuKebutuhanMotor = contTimeService(int.parse(item['Masa Kebutuhan Motor'].toString()));
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
          'Kebutuhan Motor' : ListKebutuhan_Motor,
          'Gambar Motor' : GambarMotor,
          'Jenis Aset' : 'Motor',
          'Waktu Service Motor': waktuKebutuhanMotor.millisecondsSinceEpoch,
          'Hari Service Motor': daysBetween(DateTime.now(), waktuKebutuhanMotor),
          'Lokasi' : 'Parkiran'
        };
        await FirebaseFirestore.instance.collection('Motor').doc(dokMotor).update(DataMotorBaru);
      }

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'Berhasil!',
        desc: 'Data Motor Berhasil Diupdate',
        btnOkOnPress: () {
          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ManajemenMotor()),
          );
        },
      ).show();
      print('Data Motor Berhasil Diupdate');

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
      final UrlMotor = data?['Gambar Motor'] ?? '';
      oldphotoMotor = UrlMotor;
      Kebutuhan_Motor = List<Map<String, dynamic>>.from(data?['Kebutuhan Motor'] ?? []);
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
                  itemCount: Kebutuhan_Motor.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(Kebutuhan_Motor[index]['Nama Kebutuhan Motor']),
                      subtitle: Text('${Kebutuhan_Motor[index]['Masa Kebutuhan Motor']} Bulan'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          ApusKebutuhan_Motor(index);
                        },
                        color: Colors.red,
                      ),
                    );
                  },
                ),

                InkWell(
                  onTap: tambahKebutuhan_Motor,
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
