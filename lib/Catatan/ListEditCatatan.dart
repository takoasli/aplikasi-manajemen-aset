import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projek_skripsi/Catatan/ListCatatan.dart';
import 'package:projek_skripsi/komponen/kotakDialogKedua.dart';
import '../Aset/ControllerLogic.dart';
import '../komponen/checklists.dart';
import '../komponen/kotakBiaya.dart';
import '../komponen/style.dart';

class ListEditcatatan extends StatefulWidget {
  const ListEditcatatan({super.key,
    required this.dokumenCatatan});
  final String dokumenCatatan;


  @override
  State<ListEditcatatan> createState() => _ListEditcatatanState();
}

class _ListEditcatatanState extends State<ListEditcatatan> {
  final merekAsetCatatan = TextEditingController();
  final idAsetCatatan = TextEditingController();
  final isiKebutuhan = TextEditingController();
  final isiBiaya = TextEditingController();
  final isiHarga = TextEditingController();
  final CatatanLengkapController = TextEditingController();
  Map <String, dynamic> dataCatatans = {};
  List DokKebutuhan = [];
  List DokBiaya = [];

  void checkBoxberubah(bool? value, int index) {
    setState(() {
      if (value != null) {
        DokKebutuhan[index]['status'] = value ? 'Done' : 'unDone'; // Perbaiki cara ini
      }
    });
  }


  void SimpanTask(BuildContext context) {
    setState(() {
      DokKebutuhan.add({
        'Nama Kebutuhan': isiKebutuhan.text,
        'status': false,
      });
      isiKebutuhan.clear();
    });
    Navigator.of(context).pop();
  }


  void tambahTugas() {
    showDialog(
        context: context,
        builder: (context) {
          return KotakKedua(
              controller: isiKebutuhan,
              TextJudul: 'Tambah Kebutuhan',
              onAdd: () => SimpanTask(context),
          onCancel: () => Navigator.of(context).pop()
          );
        });
  }

  void SimpanBiaya(BuildContext context) {
    setState(() {
      if (isiBiaya.text.isNotEmpty && isiHarga.text.isNotEmpty) {
        DokBiaya.add([
          isiBiaya.text,
          double.parse(isiHarga.text.replaceAll(".", "")),
        ]);
        isiBiaya.clear();
        isiHarga.clear();
      } else {
        print('Tolong tambahkan informasi yang diminta');
      }
    });
    Navigator.of(context).pop();
  }


  void tambahListBiaya() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBiaya(
            NamaBiayacontroller: isiBiaya,
            HargaBiayacontroller: isiHarga,
            onAdd: () => SimpanBiaya(context),
            onCancel: () => Navigator.of(context).pop(),
            TextJudul: 'Tambah Nama Biaya',
          );
        });
  }

  void ApusTask(int index){
    setState(() {
      DokKebutuhan.removeAt(index);
    });
  }

  double hitungTotalBiaya() {
    double totalBiaya = 0.0;
    for (int i = 0; i < DokBiaya.length; i++) {
      totalBiaya += DokBiaya[i][1];
    }
    return totalBiaya;
  }

  void ApusBiaya(int index) {
    setState(() {
      DokBiaya.removeAt(index);
    });
  }


  void initState(){
    super.initState();
    getCatatan();
  }

  Future<void> getCatatan() async{
    final DocumentSnapshot<Map<String, dynamic>> snapshot=
        await FirebaseFirestore.instance.collection('Catatan Servis').doc(
          widget.dokumenCatatan).get();
    final dataCatat = snapshot.data();

    setState(() {
      merekAsetCatatan.text = dataCatat?['Nama Aset'] ?? 'not found';
      idAsetCatatan.text = dataCatat?['ID Aset'] ?? 'not found';
      CatatanLengkapController.text = dataCatat?['Catatan Tambahan'] ?? 'Not found';
      final List<dynamic> KebutuhanData = dataCatat?['List Kebutuhan'] ?? [];
      DokKebutuhan = KebutuhanData.map((item) {
        return {
          'Nama Kebutuhan': item['Nama Kebutuhan'],
          'status': item['status'] == 'Done',
        };
      }).toList();
      final List<dynamic> BiayaData = dataCatat?['Catatan Biaya'] ?? [];
      DokBiaya = BiayaData.map((item) {
        return [item['Nama Biaya'], item['Harga Biaya']];
      }).toList();
    });
  }

  Future<void> UpdateCatatan(String dokCatatan, Map<String, dynamic> DataCatatan) async {
    try {
      List<Map<String, dynamic>> DataKebutuhan = [];

      for (int i = 0; i < DokKebutuhan.length; i++) {
        Map<String, dynamic> kebutuhan = {
          'Nama Kebutuhan': DokKebutuhan[i][0],
          'status': DokKebutuhan[i][1] ? 'Done' : 'unDone',
        };

        DataKebutuhan.add(Map.from(kebutuhan));
      }
      for (int i = 0; i < DataKebutuhan.length; i++) {
        DataKebutuhan[i].update('status', (value) => value == 'Done' ? 'Updated' : value);
      }
      for (int i = 0; i < DataKebutuhan.length; i++) {
        print(DataKebutuhan[i]);
      }


      List<Map<String, dynamic>> CatatanBiaya = [];

      for (int i = 0; i < DokBiaya.length; i++) {
        CatatanBiaya.add({
          'Nama Biaya': DokBiaya[i].nama,
          'Harga Biaya': DokBiaya[i].biaya,
        });
      }

      // Mengisi DataCatatan dengan data yang telah Anda susun
      DataCatatan['List Kebutuhan'] = DataKebutuhan;
      DataCatatan['Catatan Biaya'] = CatatanBiaya;

      // Lakukan pembaruan pada dokumen Firestore yang diinginkan
      await FirebaseFirestore.instance
          .collection('Catatan Servis')
          .doc(dokCatatan)
          .update(DataCatatan);

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
            MaterialPageRoute(builder: (context) => const ListCatatan()),
          );
        },
        autoHide: Duration(seconds: 5),
      ).show();

      print('Data Catatan Berhasil Diupdate');
    } catch (e) {
      print(e);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.green,
      appBar: AppBar(
        backgroundColor: const Color(0xFF80C5AD),
        title: const Text(
          'Edit Catatan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text('Catatan yang akan diupdate...',
                        style: TextStyles.title.copyWith(fontSize: 20, color: Warna.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 370,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Warna.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 15),
                        Padding(
                            padding: EdgeInsets.all(10),
                          child: Icon(Icons.home_repair_service_outlined,
                          size: 40),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(merekAsetCatatan.text,
                                style: TextStyles.title.copyWith(fontSize: 20)),
                            Text(idAsetCatatan.text,
                                style: TextStyles.body.copyWith(fontSize: 17))
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text('List Kebutuhan',
                          style: TextStyles.title.copyWith(fontSize: 20, color: Warna.white)
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: 350,
                    decoration: BoxDecoration(
                      color: Warna.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: DokKebutuhan.length,
                          itemBuilder: (context, index) {
                            final bool isDone = DokKebutuhan[index]['status'] == 'Done';
                            return Checklist(
                              namaTask: DokKebutuhan[index]['Nama Kebutuhan'],
                              TaskKelar: isDone,
                              onChanged: (value) {
                                checkBoxberubah(value, index);
                              },
                              Hapus: (context) => ApusTask(index),
                            );
                          },
                        ),
                        SizedBox(height: 15),
                        InkWell(
                          onTap: tambahTugas,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Row(
                              children: [
                                Icon(Icons.add),
                                SizedBox(width: 5),
                                Text('Tambah Kebutuhan Lainnya...'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text('Catatan Biaya',
                          style: TextStyles.title.copyWith(fontSize: 20, color: Warna.white)
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  Container(
                    width: 350,
                    decoration: BoxDecoration(
                      color: Warna.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: DokBiaya.length,
                            itemBuilder: (context, index){
                              return ListTile(
                                title: Text(DokBiaya[index][0]), // Nama Biaya
                                subtitle: Text('${convertToRupiah(DokBiaya[index][1])}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    ApusBiaya(index);
                                  },
                                  color: Colors.red,
                                ),
                              );
                            }
                            ),
                        SizedBox(height: 15),
                        InkWell(
                          onTap: tambahListBiaya,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Row(
                              children: [
                                Icon(Icons.add),
                                SizedBox(width: 5),
                                Text('Tambah Kebutuhan Lainnya...'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                  ),
                  const SizedBox(height: 15),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text('Catatan Lengkap',
                        style: TextStyles.title.copyWith(fontSize: 20, color: Warna.white),),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    width: 350,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Warna.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: TextField(
                        controller: CatatanLengkapController,
                        maxLines: null, // Untuk mengizinkan multiple baris teks
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Masukkan catatan tambahan...',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    width: 350,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Warna.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Total:',
                            style: TextStyles.title.copyWith(
                              fontSize: 18,
                              color: Warna.darkgrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                convertToRupiah(hitungTotalBiaya()),
                                style: TextStyles.title.copyWith(
                                  fontSize: 18,
                                  color: Warna.darkgrey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed:(){
                        UpdateCatatan(widget.dokumenCatatan, dataCatatans);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Warna.white,
                          minimumSize: const Size(200, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: const BorderSide(color: Warna.lightgreen, width: 5),
                          )),
                      child: Container(
                        width: 200,
                        child: Center(
                          child: Text(
                            'Edit Catatan',
                            style: TextStyles.title
                                .copyWith(fontSize: 20, color: Warna.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              )
            ],
          ),
        ),

      ),
    );
  }
}
