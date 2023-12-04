import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projek_skripsi/catatanAset.dart';
import 'package:projek_skripsi/komponen/TimeBar.dart';
import 'package:projek_skripsi/komponen/box.dart';
import 'package:projek_skripsi/komponen/style.dart';
import 'package:projek_skripsi/manajemenUser.dart';
import 'package:projek_skripsi/profile.dart';

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
                    fontWeight: FontWeight.bold),
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
                      MaterialPageRoute(builder: (context) => Catatan()),
                    );
                  },
                ),
                Box(
                  text: 'Manajemen \nAset',
                  gambar: 'gambar/manajemen.png',
                  warna: Warna.green,
                  halaman: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
            )
          ],
        ),

        backgroundColor: Colors.white,

        //bottom navbar
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          width: 75,
          height: 75,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => TimeBar()));
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
        bottomNavigationBar: Container(
          height: 65,
          decoration: const BoxDecoration(
            color: Color(0xFF61BF9D),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Dashboard()),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "gambar/home.png",
                          height: 40,
                          width: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 45.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "gambar/notifications.png",
                        height: 40,
                        width: 40,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 45.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "gambar/settings.png",
                        height: 40,
                        width: 40,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Profiles()),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "gambar/profiles.png",
                          height: 40,
                          width: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
