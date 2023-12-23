import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:projek_skripsi/Aset/ControllerLogic.dart';
import 'package:projek_skripsi/Notif/Notification.dart';

import '../dashboard.dart';
import '../profile.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/halaman_notif');
                },
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
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 45.0),
              child: GestureDetector(
                onTap: (){
                  // Notif.showTextNotif(judul: 'tes aja', body: 'tes juga coy', fln: flutterLocalNotificationsPlugin);
                },
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
    );
  }
}