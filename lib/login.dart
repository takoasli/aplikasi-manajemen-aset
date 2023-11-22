import 'package:flutter/material.dart';
import 'package:projek_skripsi/komponen/style.dart';
import 'package:projek_skripsi/resetPassword.dart';
import 'package:projek_skripsi/textfield/textfields.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final passwordController = TextEditingController();
  final IdController = TextEditingController();
  bool isObscure = true;

  void showErrorDialog(BuildContext context, String errorMessage) {
    print('Dialog error call with message $errorMessage');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void>login(BuildContext context) async {
    /*showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );*/

    await Future.delayed(const Duration(seconds: 1));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: IdController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        showErrorDialog(context, 'The password or email is incorrect.');
      } else {
        showErrorDialog(context,'make sure you input email and password');
      }
     /* if (e.code == 'user-not-found') {
        showErrorDialog('The email is not found.');
      } else if (e.code == 'invalid-credential') {
        showErrorDialog('The password is incorrect.');
      } else {
        showErrorDialog('An error occurred: ${e.message}');
      }*/
    }

    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[400]!, Colors.green[700]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 69),
                Image.asset('gambar/logo2.png', height: 100, width: 100),
                const SizedBox(height: 30),
                Text(
                  'Login',
                  style: TextStyles.title.copyWith(fontSize: 30, color: Warna.white),
                ),
                const SizedBox(height: 40),

                // input id
                MyTextField(
                  textInputType: TextInputType.text,
                  hint: 'ID',
                  textInputAction: TextInputAction.next,
                  controller: IdController,
                ),

                // input password
                const SizedBox(height: 20),

                MyTextField(
                  controller: passwordController,
                  textInputType: TextInputType.visiblePassword,
                  hint: 'Password',
                  isObscure: isObscure,
                  hasSuffix: true,
                  onPress: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ResetPassword()),
                      );
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyles.body.copyWith(color: Warna.white, decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: (){
                    login(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Warna.green,
                    minimumSize: const Size(300, 50),
                  ),
                  child: Container(
                    width: 200,
                    child: Center(
                      child: Text(
                        'Login',
                        style: TextStyles.title.copyWith(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
