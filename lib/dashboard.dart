import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:projek_skripsi/Aset/AC/moreDetailAC.dart';
import 'package:projek_skripsi/Aset/Laptop/moreDetailLaptop.dart';
import 'package:projek_skripsi/Aset/Mobil/MoreDetailMobil.dart';
import 'package:projek_skripsi/Aset/Motor/MoreDetailMotor.dart';
import 'package:projek_skripsi/komponen/bottomNavigation.dart';
import 'package:projek_skripsi/komponen/box.dart';
import 'package:projek_skripsi/komponen/style.dart';
import 'package:projek_skripsi/manajemenUser.dart';

import 'Aset/PC/MoreDetailPC.dart';
import 'pilihInfoAset.dart';

void main() {
  runApp(Dashboard());
}

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  final pengguna = FirebaseAuth.instance.currentUser!;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late List<String> docPenggunas = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF61BF9D),
          title: const Text(
            'Asset Management',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: logout,
            ),
          ],
          centerTitle: false,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 17.0),
              child: Text(
                'Selamat Datang, ' + widget.pengguna.email!.split('@')[0],
                style: TextStyles.title.copyWith(
                  color: Warna.darkgrey,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Box(
                  text: 'Aset \nInfo',
                  gambar: 'gambar/aset_info.png',
                  warna: Warna.green,
                  halaman: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PilihInfoAset()),
                    );
                  },
                ),
                Box(
                  text: 'Catatan \nAset',
                  gambar: 'gambar/catatan.png',
                  warna: Warna.green,
                  halaman: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => Catatan()),
                    // );
                  },
                ),
                Box(
                  text: 'Manajemen\nUser',
                  gambar: 'gambar/users.png',
                  warna: Warna.green,
                  halaman: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ManageAcc()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
          width: 75,
          height: 75,
          child: FloatingActionButton(
            onPressed: () async {
              qrCodeScanner(context);
            },
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: const BorderSide(
                color: Colors.green,
                width: 6.0,
                style: BorderStyle.solid,
              ),
            ),
            child: Image.asset(
              "gambar/qr_code.png",
              height: 50,
              width: 50,
            ),
          ),
        ),
        bottomNavigationBar: BottomNav(),
      ),
    );
  }

  void logout() {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement;
    FirebaseAuth.instance.signOut();
  }

  // Fungsi ketika scan QR Code Aset
  void qrCodeScanner(BuildContext context) async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
      "#FF0000",
      "Cancel",
      true,
      ScanMode.QR,
    );

    Map<String, dynamic> data = {};
    final splits = barcode.split(',');
    var collection = splits[0];
    var id = splits[1];
    var fieldId = "ID $collection";
    if (collection == "Aset") {
      fieldId = "ID AC";
    }

    print("Field ID = $fieldId");
    CollectionReference reference =
        FirebaseFirestore.instance.collection(collection);
    reference
        .where(fieldId, isEqualTo: id)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size > 0) {
        data = querySnapshot.docs[0].data() as Map<String, dynamic>;
        print("Data : $data");
        if (data.isNotEmpty) {
          // Arahkan ke tiap2 detail untuk masing2 Asset
          if (collection == "Aset") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MoreDetailAC(data: data),
              ),
            );
          } else if (collection == "PC") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MoreDetail(data: data),
              ),
            );
          } else if (collection == "Leptop") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MoreDetailLaptop(data: data),
              ),
            );
          } else if (collection == "Mobil") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MoreDetailmobil(data: data),
              ),
            );
          } else if (collection == "Motor") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MoreDetailMotor(data: data),
              ),
            );
          }
        }
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.bottomSlide,
          title: 'Tidak ditemukan',
          desc: "Aset dengan id $barcode tidak ditemukan",
          btnOkOnPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            );
          },
          autoHide: Duration(seconds: 5),
        ).show();
      }
    });
  }
}
