import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:projek_skripsi/auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

Future<FirebaseApp> _inizializedFirebase() async {
  FirebaseApp firebaseApp = await Firebase.initializeApp();
  return firebaseApp;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _inizializedFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AnimatedSplashScreen(
                splash: Image.asset(
                  'gambar/full_gambar.png',
                  height: 650,
                  width: 650,
                ),
                duration: 3500,
                splashTransition: SplashTransition.fadeTransition,
                pageTransitionType: PageTransitionType.leftToRightWithFade,
                animationDuration: const Duration(milliseconds: 2000),
                nextScreen: const Auth());
          } else if (snapshot.hasError) {
            return Center(
                child: Image.asset(
              'gambar/full_gambar.png',
              height: 650,
              width: 650,
            ));
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
