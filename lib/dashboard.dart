import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:projek_skripsi/Catatan/ListCatatan.dart';
import 'package:projek_skripsi/komponen/bottomNavigation.dart';
import 'package:projek_skripsi/komponen/box.dart';
import 'package:projek_skripsi/komponen/style.dart';
import 'package:projek_skripsi/manajemenUser.dart';
import 'komponen/scanQR.dart';
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListCatatan()),
                    );
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
        floatingActionButton: ScanQR(),
        bottomNavigationBar: BottomNav(),
      ),
    );
  }

  void logout() {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement;
    FirebaseAuth.instance.signOut();
  }
}
