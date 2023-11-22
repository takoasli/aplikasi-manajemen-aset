import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projek_skripsi/textfield/textfields.dart';
import 'komponen/style.dart';
import 'manajemenUser.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {

  final nomorController = TextEditingController();
  final emailController = TextEditingController();
  final alamatController = TextEditingController();
  final namaController = TextEditingController();
  final IdController = TextEditingController();
  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();
  bool isPassword = true;
  bool confirmisPassword = true;

  final Sukses = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'SUCCESS',
      message:
      'Data user berhasil Ditambahkan',
      contentType: ContentType.success,
    ),
  );

  Future SimpanAkun() async {
    if (PasswordConfirmed()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        await tambahUserInfo(
          namaController.text.trim(),
          IdController.text.trim(),
          int.parse(nomorController.text.trim()),
          emailController.text.trim(),
          alamatController.text.trim(),
        );

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder:(context) => ManageAcc())
        );

        ScaffoldMessenger.of(context).showSnackBar(Sukses);
        namaController.clear();
        IdController.clear();
        nomorController.clear();
        emailController.clear();
        alamatController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
      } catch (e) {
        print("error: $e");
      }
    }
  }

  Future tambahUserInfo(
      String Nama, String ID, int Nomor, String Email, String Alamat) async {
    await FirebaseFirestore.instance.collection('User').add({
      'Nama': Nama,
      'ID': ID,
      'Nomor HP': Nomor,
      'Email': Email,
      'Alamat Rumah': Alamat,
    });
  }


  bool PasswordConfirmed() {
      if (passwordController.text.trim() ==
          confirmPasswordController.text.trim()) {
        return true;
      } else {
        return false;
      }
    }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Warna.green,
        appBar: AppBar(
          backgroundColor: const Color(0xFF61BF9D),
          title: const Text(
            'Tambah User',
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
                      'Nama',
                      style: TextStyles.title.copyWith(
                          fontSize: 15, color: Warna.darkgrey),
                    ),
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                      textInputType: TextInputType.text,
                      hint: "Nama",
                      textInputAction: TextInputAction.next,
                      controller: namaController),
                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      'ID',
                      style: TextStyles.title.copyWith(
                          fontSize: 15, color: Warna.darkgrey),
                    ),
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                      textInputType: TextInputType.text,
                      hint: 'ID',
                      textInputAction: TextInputAction.next,
                      controller: IdController),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      'Nomor HP',
                      style: TextStyles.title.copyWith(
                          fontSize: 15, color: Warna.darkgrey),
                    ),
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                      textInputType: TextInputType.number,
                      hint: "Nomor HP",
                      textInputAction: TextInputAction.next,
                      controller: nomorController),
                  const SizedBox(height: 10),


                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      'Email',
                      style: TextStyles.title.copyWith(
                          fontSize: 15, color: Warna.darkgrey),
                    ),
                  ),
                  MyTextField(
                      textInputType: TextInputType.emailAddress,
                      hint: "Email",
                      textInputAction: TextInputAction.next,
                      controller: emailController),
                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      'Alamat Rumah',
                      style: TextStyles.title.copyWith(
                          fontSize: 15, color: Warna.darkgrey),
                    ),
                  ),

                  MyTextField(
                      textInputType: TextInputType.streetAddress,
                      hint: "Alamat Rumah",
                      textInputAction: TextInputAction.done,
                      controller: alamatController),
                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      'Password',
                      style: TextStyles.title.copyWith(
                          fontSize: 15, color: Warna.darkgrey),
                    ),
                  ),

                  MyTextField(
                      textInputType: TextInputType.visiblePassword,
                      hint: 'password',
                      textInputAction: TextInputAction.done,
                      isObscure: isPassword,
                      hasSuffix: true,
                      onPress: () {
                        setState(() {
                          isPassword = !isPassword;
                        });
                      },
                      controller: passwordController),
                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      're-Password',
                      style: TextStyles.title.copyWith(
                          fontSize: 15, color: Warna.darkgrey),
                    ),
                  ),

                  MyTextField(
                      textInputType: TextInputType.visiblePassword,
                      hint: 're-Password',
                      isObscure: confirmisPassword,
                      hasSuffix: true,
                      onPress: () {
                        setState(() {
                          confirmisPassword = !confirmisPassword;
                        });
                      },
                      textInputAction: TextInputAction.done,
                      controller: confirmPasswordController),
                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      'Gambar Profil',
                      style: TextStyles.title.copyWith(
                          fontSize: 15, color: Warna.darkgrey),
                    ),
                  ),
                  ElevatedButton(
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
                        'Choose...',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),



                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: SimpanAkun,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Warna.green,
                          minimumSize: const Size(300, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)
                          )
                      ),
                      child: Container(
                        width: 200,
                        child: Center(
                          child: Text(
                            'Save',
                            style: TextStyles.title.copyWith(
                                fontSize: 20, color: Colors.white),
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
