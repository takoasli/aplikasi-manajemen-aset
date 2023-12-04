import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'komponen/style.dart';

class Profiles extends StatefulWidget {
  Profiles({Key? key}) : super(key: key);

  final pengguna = FirebaseAuth.instance.currentUser!;

  @override
  State<Profiles> createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {
  final double tiggiBackground = 200;
  final double tinggiProfile = 60;

  void logout() {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement;
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF61BF9D),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('User')
            .doc(widget.pengguna.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.data() == null) {
            return Center(child: Text('Tidak Ada Data'));
          } else {
            final dataUser = snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
              children: <Widget>[
                buildTop(dataUser),
                SizedBox(height: 65),
                buildNama(dataUser),
                buildKonten(),
                SizedBox(height: 40),
                buildLogout(),
                SizedBox(height: 40),
              ],
            );
          }
        },
      ),
    );
  }


  Widget buildLogout() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: logout,
          style: ElevatedButton.styleFrom(
            backgroundColor: Warna.green,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
            ),
            minimumSize: Size(200, 50),
          ),
          child: Container(
            width: 200,
            child: Center(
              child: Text(
                'Logout',
                style: TextStyles.title.copyWith(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget buildNama(Map<String, dynamic> dataUser) {
    return Positioned(
      top: tiggiBackground - (tinggiProfile / 2),
      child: Column(
        children: [
          Text(
            dataUser['Nama'] ?? 'No Name',
            style: TextStyles.title.copyWith(fontSize: 30, color: Warna.black),
          ),
          SizedBox(height: 6),
          Text(
            dataUser['ID'] ?? 'No ID',
            style: TextStyles.body.copyWith(fontSize: 15, color: Colors.black38),
          ),
        ],
      ),
    );
  }

  Widget buildKonten() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildInfoText('HP', '087958473824'),
          SizedBox(height: 20),
          buildInfoText('email', widget.pengguna.email!),
          SizedBox(height: 20),
          buildInfoText('alamat', 'rumah makan satpam'),
        ],
      ),
    );
  }

  Widget buildInfoText(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            title.toUpperCase(),
            style: TextStyles.body.copyWith(color: Warna.black, fontSize: 17)
        ),
        SizedBox(height: 6),
        Text(
            content,
            style: TextStyles.body.copyWith(color: Colors.black38, fontSize: 15)
        ),
      ],
    );
  }


  Widget buildTop(Map<String, dynamic> dataUser) {
    final atas = tiggiBackground - tinggiProfile;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        gambarBackground(),
        Positioned(
          top: atas,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  gambarProfile(),
                  Positioned(
                    bottom: 5,
                    right: -120,
                    child: ElevatedButton(
                      onPressed: () {
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Warna.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Text(
                          'Edit',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget gambarBackground() => Container(
    color: Colors.green, // Mengganti Warna.green dengan Colors.green
    child: Image.asset(
      'gambar/background_profile.jpg',
      width: double.infinity,
      height: tiggiBackground,
      fit: BoxFit.cover,
    ),
  );

  Widget gambarProfile() => CircleAvatar(
    radius: tinggiProfile,
    backgroundColor: Colors.white,
    child: Image.asset('gambar/profil.png'),
  );
}