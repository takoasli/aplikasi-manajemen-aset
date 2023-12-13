// Hitung hari antara 2 tangal
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    decimalDigits: 2,
  );
  return currencyFormatter.format(number);
}

class CatatanBiaya {
  CatatanBiaya(this.nama, this.biaya);
  late String nama;
  late double biaya;
}
