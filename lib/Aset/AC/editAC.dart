import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projek_skripsi/Aset/AC/ManajemenAC.dart';

import '../../komponen/kotakDialog.dart';
import '../../komponen/style.dart';
import '../../textfield/imageField.dart';
import '../../textfield/textfields.dart';
import '../ControllerLogic.dart';

class UpdateAC extends StatefulWidget {
  const UpdateAC({super.key, required this.dokumenAC});
  final String dokumenAC;

  @override
  State<UpdateAC> createState() => _UpdateACState();
}

class KebutuhanModelUpdateAC {
  String namaKebutuhanAC;
  int masaKebutuhanAC;

  KebutuhanModelUpdateAC(this.namaKebutuhanAC, this.masaKebutuhanAC);

  Map<String, dynamic> toMap() {
    return {
      'Kebutuhan AC': namaKebutuhanAC,
      'Masa Kebutuhan AC': masaKebutuhanAC,
    };
  }
}

class _UpdateACState extends State<UpdateAC> {
  final MerekACController = TextEditingController();
  final idACController = TextEditingController();
  final wattController = TextEditingController();
  final PKController = TextEditingController();
  final ruanganController = TextEditingController();
  final MasaKebutuhanController = TextEditingController();
  final MasaServisACController = TextEditingController();
  final isiKebutuhan_AC = TextEditingController();
  final ImagePicker _gambarACIndoor = ImagePicker();
  final ImagePicker _gambarACOutdoor = ImagePicker();
  final gambarAcIndoorController = TextEditingController();
  final gambarAcOutdoorController = TextEditingController();
  List Kebutuhan_AC = [];
  String oldphotoIndoor = '';
  String oldphotoOutdoor = '';
  Map <String, dynamic> dataAC = {};
  final Sukses = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'SUCCESS',
      message:
      'Data AC berhasil Diupdate!',
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
      'Data AC Gagal Dibuat',
      contentType: ContentType.success,
    ),
  );

  void SimpanKebutuhan_AC(){
    setState(() {
      KebutuhanModelUpdateAC kebutuhan = KebutuhanModelUpdateAC(
        isiKebutuhan_AC.text,
        int.parse(MasaKebutuhanController.text),
      );
      Kebutuhan_AC.add(kebutuhan.toMap());
      isiKebutuhan_AC.clear();
      MasaKebutuhanController.clear();
    });
    Navigator.of(context).pop();
  }
  void tambahKebutuhan_AC(){
    showDialog(
        context: context,
        builder: (context){
          return DialogBox(
            controller: isiKebutuhan_AC,
            onAdd: SimpanKebutuhan_AC,
            onCancel: () => Navigator.of(context).pop(),
            TextJudul: 'Tambah Kebutuhan AC',
            JangkaKebutuhan: MasaKebutuhanController,
          );
        });
  }

  void ApusKebutuhan_AC(int index) {
    setState(() {
      Kebutuhan_AC.removeAt(index);
    });
  }


  void PilihUpdateIndoor() async {
    final pilihIndoor = await _gambarACIndoor.pickImage(source: ImageSource.gallery);
    if (pilihIndoor != null) {
      setState(() {
        gambarAcIndoorController.text = pilihIndoor.path;
      });
    }
  }

  void PilihUpdateOutdoor() async {
    final pilihOutdoor = await _gambarACOutdoor.pickImage(source: ImageSource.gallery);
    if (pilihOutdoor != null) {
      setState(() {
        gambarAcOutdoorController.text = pilihOutdoor.path;
      });
    }
  }


  Future<String> unggahACIndoor(File indoor) async {
    try {
      if (!indoor.existsSync()) {
        print('File tidak ditemukan.');
        return '';
      }

      Reference penyimpanan = FirebaseStorage.instance
          .ref()
          .child('AC')
          .child(gambarAcIndoorController.text.split('/').last);

      UploadTask uploadGambar = penyimpanan.putFile(indoor);
      await uploadGambar;
      String fotoIndoor = await penyimpanan.getDownloadURL();
      return fotoIndoor;
    } catch (e) {
      print('$e');
      return '';
    }
  }

  Future<String> unggahACOutdoor(File outdoor) async {
    try {
      if (!outdoor.existsSync()) {
        print('File tidak ditemukan.');
        return '';
      }

      Reference penyimpanan = FirebaseStorage.instance
          .ref()
          .child('AC')
          .child(gambarAcOutdoorController.text.split('/').last);

      UploadTask uploadGambar = penyimpanan.putFile(outdoor);
      await uploadGambar;
      String fotoOutdoor = await penyimpanan.getDownloadURL();
      return fotoOutdoor;
    } catch (e) {
      print('$e');
      return '';
    }
  }

  Future<void> UpdateAC(String dokAC, Map<String, dynamic> DataAC) async{
    try{
      String GambarACIndoor;
      String GambarACOutdoor;
      var timeService = contTimeService(int.parse(MasaServisACController.text));

      List<Map<String, dynamic>> ListKebutuhan_AC = Kebutuhan_AC.map((kebutuhan) {
        var timeKebutuhan = contTimeService(int.parse(kebutuhan['Masa Kebutuhan AC'].toString()));
        return {
          'Kebutuhan AC': kebutuhan['Kebutuhan AC'],
          'Masa Kebutuhan AC': kebutuhan['Masa Kebutuhan AC'],
          'Waktu Kebutuhan AC': timeKebutuhan.millisecondsSinceEpoch,
          'Hari Kebutuhan AC': daysBetween(DateTime.now(), timeKebutuhan)
        };
      }).toList();

      if(gambarAcIndoorController.text.isNotEmpty&&gambarAcOutdoorController.text.isNotEmpty
      ||gambarAcIndoorController.text.isNotEmpty&&gambarAcOutdoorController.text.isEmpty){
        File gambarIndoorBaru = File(gambarAcIndoorController.text);
        GambarACIndoor = await unggahACIndoor(gambarIndoorBaru);
        File gambarOutdoorBaru = File(gambarAcOutdoorController.text);
        GambarACOutdoor = await unggahACOutdoor(gambarOutdoorBaru);
      }else{
        GambarACIndoor = oldphotoIndoor;
        GambarACOutdoor = oldphotoOutdoor;
      }

      for(var item in ListKebutuhan_AC){
        var waktuKebutuhanAC = contTimeService(int.parse(item['Masa Kebutuhan AC'].toString()));
        Map<String, dynamic> DataACBaru = {
          'Merek AC': MerekACController.text,
          'ID AC': idACController.text,
          'Kapasitas Watt': wattController.text,
          'Kapasitas PK': PKController.text,
          'Lokasi Ruangan' : ruanganController.text,
          'Masa Servis' : MasaServisACController.text,
          'Kebutuhan AC' : ListKebutuhan_AC,
          'Foto AC Indoor': GambarACIndoor,
          'Foto AC Outdoor': GambarACOutdoor,
          'waktu_service': timeService.millisecondsSinceEpoch,
          'hari_service': daysBetween(DateTime.now(), timeService),
          'Waktu Kebutuhan AC' : waktuKebutuhanAC.millisecondsSinceEpoch,
          'Hari Kebutuhan AC' : daysBetween(DateTime.now(), waktuKebutuhanAC)
        };
        await FirebaseFirestore.instance.collection('Aset').doc(dokAC).update(DataACBaru);
      }

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'Berhasil!',
        desc: 'Data AC Berhasil Diupdate',
        btnOkOnPress: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ManajemenAC()),
          );
        },
        autoHide: Duration(seconds: 5),
      ).show();

      print('Data AC Berhasil Diupdate');
    }catch (e){
      print(e);
    }
  }

  void initState(){
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('Aset').doc(widget.dokumenAC).get();
      final data = snapshot.data();

      setState(() {
        MerekACController.text = data?['Merek AC'] ?? '';
        idACController.text = data?['ID AC'] ?? '';
        wattController.text = (data?['Kapasitas Watt'] ?? '').toString();
        PKController.text = (data?['Kapasitas PK'] ?? '').toString();
        ruanganController.text = data?['Lokasi Ruangan'] ?? '';
        MasaServisACController.text = (data?['Masa Servis'] ?? '').toString();
        final UrlIndoor = data?['Foto AC Indoor'] ?? '';
        oldphotoIndoor = UrlIndoor;
        final UrlOutdoor = data?['Foto AC Outdoor'] ?? '';
        oldphotoOutdoor = UrlOutdoor;
        final List<dynamic> kebutuhanData = data?['Kebutuhan AC'] ?? [];
        Kebutuhan_AC = kebutuhanData.map((item) {
          return {
            'Kebutuhan AC': item['Kebutuhan AC'],
            'Masa Kebutuhan AC': item['Masa Kebutuhan AC'],
          };
        }).toList();
      });
    } catch (e) {
      print('Terjadi Kesalahan: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.green,
      appBar: AppBar(
        backgroundColor: const Color(0xFF61BF9D),
        title: const Text(
          'Edit Data AC',
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
                    'Merek AC',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                const SizedBox(height: 10),
                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: MerekACController),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'ID AC',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),
                const SizedBox(height: 10),
                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: idACController),

                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Kapasitas Watt',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),

                MyTextField(
                    textInputType: TextInputType.number,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: wattController),

                SizedBox(height: 10),

                Padding(
                  padding: EdgeInsets.only(bottom: 3),
                  child: Text('kapasitas PK',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),

                MyTextField(
                    textInputType: TextInputType.number,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: PKController),

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
                  controller: MasaServisACController,
                ),
                SizedBox(height: 10),

                Padding(
                  padding: EdgeInsets.only(bottom: 3),
                  child: Text('Ruangan',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey)
                    ,)
                  ),

                MyTextField(
                    textInputType: TextInputType.text,
                    hint: '',
                    textInputAction: TextInputAction.next,
                    controller: ruanganController),

                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Gambar AC Indoor',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),

                FieldImage(
                  controller: gambarAcIndoorController,
                  selectedImageName: gambarAcIndoorController.text.isNotEmpty
                      ? gambarAcIndoorController.text.split('/').last // Display only the image name
                      : '',
                  onPressed: PilihUpdateIndoor, // Pass the pickImage method to FieldImage
                ),

                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    'Gambar AC Outdoor',
                    style: TextStyles.title
                        .copyWith(fontSize: 15, color: Warna.darkgrey),
                  ),
                ),

                FieldImage(
                    controller: gambarAcOutdoorController,
                    selectedImageName: gambarAcIndoorController.text.isNotEmpty
                        ? gambarAcOutdoorController.text.split('/').last // Display only the image name
                        : '',
                    onPressed: PilihUpdateOutdoor),
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
                  itemCount: Kebutuhan_AC.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(Kebutuhan_AC[index]['Kebutuhan AC']),
                      subtitle: Text('${Kebutuhan_AC[index]['Masa Kebutuhan AC']} Bulan'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          ApusKebutuhan_AC(index);
                        },
                        color: Colors.red,
                      ),
                    );
                  },
                ),



                InkWell(
                  onTap: tambahKebutuhan_AC,
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
                      UpdateAC(widget.dokumenAC, dataAC);
                    },
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
