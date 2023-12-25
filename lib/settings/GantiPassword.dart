import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projek_skripsi/komponen/style.dart';

import '../textfield/textfields.dart';

class GantiPass extends StatefulWidget {
  GantiPass({Key? key});

  final pengguna = FirebaseAuth.instance.currentUser;
  @override
  State<GantiPass> createState() => _GantiPassState();
}

class _GantiPassState extends State<GantiPass> {
  final newPasswordController = TextEditingController();
  final reenterPasswordController = TextEditingController();
  final passwordSekarang = TextEditingController();
  User? pengguna; // Tambahkan variabel untuk menyimpan data pengguna

  @override
  void initState() {
    super.initState();
    // Ambil informasi pengguna saat widget diinisialisasi
    pengguna = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF61BF9D),
        title: const Text(
          'Ganti Password',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        elevation: 0,
        centerTitle: false,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Akun yang sedang aktif',
                style: TextStyles.title.copyWith(color: Warna.darkgrey.withOpacity(0.7), fontSize: 17),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(17.0),
                child: Text(
                  pengguna?.email ?? 'No user logged in',
                  style: TextStyles.title.copyWith(
                    color: Warna.darkgrey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'New Password',
                style: TextStyles.title.copyWith(color: Warna.darkgrey.withOpacity(0.7), fontSize: 17),
              ),
              const SizedBox(height: 10),
              MyTextField(
                textInputType: TextInputType.emailAddress,
                hint: '',
                textInputAction: TextInputAction.next,
                controller: newPasswordController,
              ),
              const SizedBox(height: 30),
              Text(
                'Re-enter New Password',
                style: TextStyles.title.copyWith(color: Warna.darkgrey.withOpacity(0.7), fontSize: 17),
              ),
              const SizedBox(height: 10),
              MyTextField(
                textInputType: TextInputType.emailAddress,
                hint: '',
                textInputAction: TextInputAction.done,
                controller: reenterPasswordController,
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // execSendEmail(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF80C5AD),
                    minimumSize: const Size(150, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Container(
                    width: 200,
                    child: Center(
                      child: Text(
                        'Reset Password',
                        style: TextStyles.title.copyWith(fontSize: 20, color: Colors.white),
                      ),
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
