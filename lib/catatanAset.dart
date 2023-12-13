import 'package:flutter/material.dart';
import 'Aset/ControllerLogic.dart';
import 'komponen/checklists.dart';
import 'komponen/kotakBiaya.dart';
import 'komponen/kotakDialog.dart';
import 'komponen/style.dart';


class Catatan extends StatefulWidget {
  const Catatan({Key? key,
    required this.List_Kebutuhan,
    required this.ID_Aset,
    required this.Nama_Aset,}) : super(key: key);

  final List<dynamic> List_Kebutuhan;
  final String ID_Aset;
  final String Nama_Aset;

  @override
  State<Catatan> createState() => _CatatanState();
}

class _CatatanState extends State<Catatan> {

  final isiDialog = TextEditingController();
  final isiBiayaAC = TextEditingController();
  final hargaIsiBiayaAC = TextEditingController(text: '');
  late String idAC;
  late String merekAC;
  List<List<dynamic>> List_Kebutuhan = [];
  List<CatatanBiaya> biayaKebutuhans = [];


  void checkBoxberubah(bool? value, int index){
  setState(() {
    if(value != null){
      List_Kebutuhan[index][1] = value;
    }
  });
  }

  void SimpanTask(BuildContext context) {
    setState(() {
      List_Kebutuhan.add([isiDialog.text, false]);
      isiDialog.clear();
    });
    Navigator.of(context).pop();
  }

  void tambahTugas() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: isiDialog,
            onAdd: () => SimpanTask(context),
            onCancel: () => Navigator.of(context).pop(),
            TextJudul: 'Kebutuhan Tambahan',
          );
        });
  }


  void ApusTask(int index){
  setState(() {
    List_Kebutuhan.removeAt(index);
  });
  }

  void SimpanBiaya_AC(BuildContext context) {
    setState(() {
      // Pastikan isiBiayaAC dan hargaIsiBiayaAC tidak kosong
      if (isiBiayaAC.text.isNotEmpty && hargaIsiBiayaAC.text.isNotEmpty) {
        // Tambahkan nama biaya dan harga ke Biaya_Kebutuhan
        biayaKebutuhans.add(
            CatatanBiaya(isiBiayaAC.text, double.parse(hargaIsiBiayaAC.text)));
        isiBiayaAC.clear();
        hargaIsiBiayaAC.clear();
      } else {
        print('tolong tambahkan informasi yang diminta');
      }
    });
    Navigator.of(context).pop();
  }

  void tambahListBiaya() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBiaya(
            NamaBiayacontroller: isiBiayaAC,
            HargaBiayacontroller: hargaIsiBiayaAC,
            onAdd: () => SimpanBiaya_AC(context),
            onCancel: () => Navigator.of(context).pop(),
            TextJudul: 'Tambah Nama Biaya',
          );
        });
  }

  void ApusBiayaAC(int index) {
    setState(() {
      biayaKebutuhans.removeAt(index);
    });
  }

  double hitungTotalBiaya() {
    double totalBiaya = 0.0;
    for (int i = 0; i < biayaKebutuhans.length; i++) {
      totalBiaya += biayaKebutuhans[i].biaya;
    }
    return totalBiaya;
  }

  @override
  void initState(){
    super.initState();
    idAC = '${widget.ID_Aset}';
    merekAC = '${widget.Nama_Aset}';
    List_Kebutuhan = List<List<dynamic>>.from(widget.List_Kebutuhan.map((item) => [item, false]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.green,
      appBar: AppBar(
        backgroundColor: const Color(0xFF61BF9D),
        title: const Text(
          'Catatan Servis',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        elevation: 0,
        centerTitle: false,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Container(
        height: 60,
        width: 60,
        margin: const EdgeInsets.only(top: 70, right: 10),
        child: FloatingActionButton(
          onPressed: tambahTugas,
          backgroundColor: Warna.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: const Icon(
            Icons.add,
            color: Warna.black,
            size: 30,
          ),
        ),

      ),

      body: SingleChildScrollView(
        child: Center(
          child: Stack(
            children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text('Aset yang terpilih...',
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
                          const Padding(
                              padding: EdgeInsets.all(10),
                          child:
                          Icon(Icons.home_repair_service_outlined,
                          size: 40
                          ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(merekAC,
                              style: TextStyles.title.copyWith(fontSize: 20)
                              ),
                              Text(idAC,
                              style: TextStyles.body.copyWith(fontSize: 17),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text('List Kebutuhan',
                        style: TextStyles.title.copyWith(fontSize: 20, color: Warna.white),),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: 350,
                      height: 350,
                      decoration: BoxDecoration(
                        color: Warna.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                              child: ListView.builder(
                                itemCount: List_Kebutuhan.length,
                                itemBuilder: (context, index){
                                  return Checklist(
                                    namaTask: List_Kebutuhan[index][0],
                                    TaskKelar: List_Kebutuhan[index][1],
                                    onChanged: (value) =>checkBoxberubah(value, index),
                                    Hapus: (context) => ApusTask(index),
                                  );
                                },
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
                          style: TextStyles.title.copyWith(fontSize: 20, color: Warna.white),),
                      ),
                    ),
                    const SizedBox(height: 15),

                    Container(
                      width: 350,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Warna.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: biayaKebutuhans.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(biayaKebutuhans[index].nama),
                                  subtitle: Text(convertToRupiah(
                                      biayaKebutuhans[index].biaya)),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      ApusBiayaAC(index);
                                    },
                                    color: Colors.red,
                                  ),
                                );
                              },
                            ),
                          ),
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
                                  Text('Tambah Biaya Penyeluaran...'),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
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
                          onPressed: (){},
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
                                'Simpan Catatan',
                                style: TextStyles.title
                                    .copyWith(fontSize: 20, color: Warna.black),
                              ),
                            ),
                          ),
                        ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
