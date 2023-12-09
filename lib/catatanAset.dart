import 'package:flutter/material.dart';
import 'komponen/checklists.dart';
import 'komponen/kotakDialog.dart';
import 'komponen/style.dart';

class Catatan extends StatefulWidget {
  const Catatan({Key? key}) : super(key: key);

  @override
  State<Catatan> createState() => _CatatanState();
}

class _CatatanState extends State<Catatan> {

  final isiDialog = TextEditingController();

  List ToDo = [
    ["Tes", false],
    ["Tes 2", false],
  ];

  void checkBoxberubah(bool? value, int index){
  setState(() {
    ToDo[index][1] = !ToDo[index][1];
  });
  }

  void SimpanTask(){
    setState(() {
      ToDo.add([isiDialog.text, false]);
      isiDialog.clear();
    });
    Navigator.of(context).pop();
  }

  void tambahTugas(){
    showDialog(
        context: context,
        builder: (context){
          return DialogBox(
            controller: isiDialog,
            onAdd: SimpanTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  void ApusTask(int index){
  setState(() {
    ToDo.removeAt(index);
  });
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Container(
        height: 60,
        width: 60,
        margin: const EdgeInsets.only(bottom: 25, right: 10),
        child: FloatingActionButton(
          onPressed: tambahTugas,
          backgroundColor: Warna.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: const Icon(
            Icons.add,
            color: Warna.white,
            size: 30,
          ),
        ),

      ),

      body: Center(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Aset yang terpilih...',
                    style: TextStyles.body.copyWith(fontSize: 18, color: Warna.white),
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
                        Icon(Icons.adb_outlined,
                        size: 40
                        ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nama Aset',
                            style: TextStyles.title.copyWith(fontSize: 20)
                            ),
                            Text('ID Aset',
                            style: TextStyles.body.copyWith(fontSize: 17),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 370,
                    height: 420,
                    decoration: BoxDecoration(
                      color: Warna.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.builder(
                      itemCount: ToDo.length,
                      itemBuilder: (context, index){
                        return Checklist(
                            namaTask: ToDo[index][0],
                            TaskKelar: ToDo[index][1],
                            onChanged: (value) =>checkBoxberubah(value, index),
                          Hapus: (context) => ApusTask(index),
                        );
                      },


                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
