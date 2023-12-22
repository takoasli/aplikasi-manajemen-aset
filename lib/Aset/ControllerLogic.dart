// Hitung hari antara 2 tangal
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projek_skripsi/main.dart';

// Hitung perbandingan tanggal berupa hari
int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

// Hitung waktu service
DateTime contTimeService(int month) {
  var timeNow = DateTime.now();
  return DateTime(timeNow.year, timeNow.month + month, timeNow.day);
}

// Convert epoch to time
DateTime epochTimeToData(int epochTime) {
  return DateTime.fromMillisecondsSinceEpoch(epochTime, isUtc: true);
}

Color getProgressColor(int waktu) {
  var timeProgress = epochTimeToData(waktu);
  Duration difference = timeProgress.difference(DateTime.now());
  var sisaHari = difference.inDays;
  print("Sisa Hari $sisaHari");

  if (sisaHari >= 20) {
    return Colors.green;
  } else if (sisaHari >= 15) {
    return Colors.yellow;
  } else {
    return Colors.red;
  }
}

String getRemainingTime(int epochTime) {
  var timeProgress = epochTimeToData(epochTime);
  Duration difference = timeProgress.difference(DateTime.now());
  int days = difference.inDays;
  int months = days ~/ 30;
  int remainingDays = days % 30;
  int hours = difference.inHours % 24;
  int minutes = difference.inMinutes % 60;
  int seconds = difference.inSeconds % 60;

  String timeRemaining = '';
  if (months > 0) {
    timeRemaining += '$months bulan ';
  }
  if (remainingDays > 0) {
    timeRemaining += '$remainingDays hari ';
  }
  if (hours > 0) {
    timeRemaining += '$hours jam ';
  }
  if (minutes > 0) {
    timeRemaining += '$minutes menit ';
  }
  if (seconds > 0) {
    timeRemaining += '$seconds detik';
  }
  if (timeRemaining.isEmpty) {
    timeRemaining = 'Waktu habis';
  }

  return timeRemaining;
}

double getValueIndicator(int totalHari, DateTime service) {
  int sisaHari = daysBetween(DateTime.now(), service);
  var sisa = sisaHari / totalHari * 100;
  var value = sisa / 100;
  return value.toDouble();
}

LinearProgressIndicator showIndicator(double value, Color color) {
  return LinearProgressIndicator(
      borderRadius: BorderRadius.circular(20.0),
      backgroundColor: Colors.grey[300],
      minHeight: 15,
      color: color,
      value: value);
}

String convertToRupiah(dynamic number) {
  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return currencyFormatter.format(number);
}

class CatatanBiaya {
  CatatanBiaya(this.nama, this.biaya);
  late String nama;
  late double biaya;
}

class Notif {
  //bikin instansi buat firebase notif
  final pesanNotif = FirebaseMessaging.instance;

  //simpen notif ke firestore
  Future<void> simpanNotifikasi(String judul, String isi) async {
    try {
      // Cek apakah notifikasi dengan judul dan isi yang sama sudah ada
      final querySnapshot = await FirebaseFirestore.instance
          .collection('List Notif')
          .where('judul', isEqualTo: judul)
          .where('isi', isEqualTo: isi)
          .get();

      // Jika tidak ada notifikasi yang sama, simpan notifikasi
      if (querySnapshot.docs.isEmpty) {
        await FirebaseFirestore.instance.collection('List Notif').add({
          'judul': judul,
          'isi': isi,
          'timestamp': FieldValue.serverTimestamp(), // Timestamp otomatis
        });
        print('Notifikasi disimpan di Firestore');
      } else {
        print('Notifikasi dengan judul dan isi yang sama sudah ada');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  //method inisialisasi notif
  Future<void> initNotif() async {
    //permission buat user
    await pesanNotif.requestPermission();
    //fetch data
    final TokenNotif = await pesanNotif.getToken();
    //print tokennya
    print('Token: $TokenNotif');
    initPushNotif();
  }

  void aturMessage(RemoteMessage? pesan) {
    if (pesan == null) return;

    // Menyimpan notifikasi ke Firestore saat pesan diterima
    simpanNotifikasi(pesan.notification?.title ?? 'Judul Kosong', pesan.notification?.body ?? 'Isi Kosong');

  }

  //function buat inisialisasi background settings
  Future initPushNotif() async{
    FirebaseMessaging.instance.getInitialMessage().then(aturMessage);

  //pake event listener
  FirebaseMessaging.onMessageOpenedApp.listen(aturMessage);
}
}

