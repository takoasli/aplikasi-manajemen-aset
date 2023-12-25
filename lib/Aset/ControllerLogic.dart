// Hitung hari antara 2 tangal
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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

class Notif{
  static Future initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async{
    var androidInitialize = new AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationsSettings = new InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  }

  static Future showTextNotif({required int id, required String judul, required String body, var payload, required FlutterLocalNotificationsPlugin fln}) async{
    AndroidNotificationDetails androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'Channel ID',
        'Nama Channel',
        playSound: true,
      importance: Importance.high
    );

    var noti = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(
        0, judul, body, noti);
  }
}

// class ExcellCatatan{
//   Future <void> exportExcel(require) async{
//     Excel eksel = Excel.createExcel();
//     print('Tombol Export Ditekan!');
//     eksel.rename(eksel.getDefaultSheet()!, 'Catatan Servis');
//     Sheet sheet = eksel['Catatan Servis'];
//     sheet.setColumnWidth(4, 100); // Mengubah lebar kolom ke-5 menjadi 100
//     sheet.setColumnAutoFit(2); // Mengaktifkan autofit pada kolom ke-3 (index 2)
//
//
//     //isi tiap judul excell
//     //judulnya
//     var cellD1 = sheet.cell(CellIndex.indexByString("D1"));
//     cellD1.value = TextCellValue('Catatan Servis');
//     sheet.merge(CellIndex.indexByString("D1"), CellIndex.indexByString("H2"));
//     cellD1.cellStyle = CellStyle(backgroundColorHex: "#C6E0B4", fontSize: 20,
//         verticalAlign: VerticalAlign.Center, horizontalAlign: HorizontalAlign.Center);
//
//     //nomor
//     var cellA4 = sheet.cell(CellIndex.indexByString("A4"));
//     cellA4.value = TextCellValue('No');
//     sheet.merge(CellIndex.indexByString("A4"), CellIndex.indexByString("A5"));
//     cellA4.cellStyle = CellStyle(backgroundColorHex: "#B4C3E8",fontSize: 20,
//         verticalAlign: VerticalAlign.Center, horizontalAlign: HorizontalAlign.Center);
//
//     //tanggal
//     var cellB4 = sheet.cell(CellIndex.indexByString("B4"));
//     cellB4.value = TextCellValue('Tanggal Dibuat');
//     sheet.merge(CellIndex.indexByString("B4"), CellIndex.indexByString("B5"));
//     cellB4.cellStyle = CellStyle(backgroundColorHex: "#B4C3E8",fontSize: 20,
//         verticalAlign: VerticalAlign.Center, horizontalAlign: HorizontalAlign.Center);
//
//     //nama aset
//     var cellC4 = sheet.cell(CellIndex.indexByString("C4"));
//     cellC4.value = TextCellValue('Nama Aset');
//     sheet.merge(CellIndex.indexByString("C4"), CellIndex.indexByString("C5"));
//     cellC4.cellStyle = CellStyle(backgroundColorHex: "#B4C3E8",fontSize: 20,
//         verticalAlign: VerticalAlign.Center, horizontalAlign: HorizontalAlign.Center);
//
//     //ID Aset
//     var cellD4 = sheet.cell(CellIndex.indexByString("D4"));
//     cellD4.value = TextCellValue('ID Aset');
//     sheet.merge(CellIndex.indexByString("D4"), CellIndex.indexByString("D5"));
//     cellD4.cellStyle = CellStyle(backgroundColorHex: "#B4C3E8",fontSize: 20,
//         verticalAlign: VerticalAlign.Center, horizontalAlign: HorizontalAlign.Center);
//
//     //jenis aset
//     var cellE4 = sheet.cell(CellIndex.indexByString("E4"));
//     cellE4.value = TextCellValue('Jenis Aset');
//     sheet.merge(CellIndex.indexByString("E4"), CellIndex.indexByString("E5"));
//     cellE4.cellStyle = CellStyle(backgroundColorHex: "#B4C3E8",fontSize: 20,
//         verticalAlign: VerticalAlign.Center, horizontalAlign: HorizontalAlign.Center);
//
//     //lokasi
//     var cellF4 = sheet.cell(CellIndex.indexByString("F4"));
//     cellF4.value = TextCellValue('Lokasi Aset');
//     sheet.merge(CellIndex.indexByString("F4"), CellIndex.indexByString("F5"));
//     cellF4.cellStyle = CellStyle(backgroundColorHex: "#B4C3E8",fontSize: 20,
//         verticalAlign: VerticalAlign.Center, horizontalAlign: HorizontalAlign.Center);
//
//     //keterangan
//     var cellG4 = sheet.cell(CellIndex.indexByString("G4"));
//     cellG4.value = TextCellValue('Keterangan');
//     sheet.merge(CellIndex.indexByString("G4"), CellIndex.indexByString("G5"));
//     cellG4.cellStyle = CellStyle(backgroundColorHex: "#B4C3E8",fontSize: 20,
//         verticalAlign: VerticalAlign.Center, horizontalAlign: HorizontalAlign.Center);
//
//     //kebutuhan
//     var cellH4 = sheet.cell(CellIndex.indexByString("H4"));
//     cellH4.value = TextCellValue('Kebutuhan');
//     sheet.merge(CellIndex.indexByString("H4"), CellIndex.indexByString("I4"));
//     cellH4.cellStyle = CellStyle(backgroundColorHex: "#B4C3E8", fontSize: 20,
//         horizontalAlign: HorizontalAlign.Center);
//
//     var cellH5 = sheet.cell(CellIndex.indexByString("H5"));
//     cellH5.value = TextCellValue('Nama Kebutuhan');
//     cellH5.cellStyle = CellStyle(backgroundColorHex: "#B4C3E8",fontSize: 20,
//         horizontalAlign: HorizontalAlign.Center);
//
//     var cellI5 = sheet.cell(CellIndex.indexByString("I5"));
//     cellI5.value = TextCellValue('Status');
//     cellI5.cellStyle = CellStyle(backgroundColorHex: "#B4C3E8",fontSize: 20,
//         horizontalAlign: HorizontalAlign.Center);
//
//     //Catatan biaya
//     var cellJ4 = sheet.cell(CellIndex.indexByString("J4"));
//     cellJ4.value = TextCellValue('Catatan Biaya');
//     sheet.merge(CellIndex.indexByString("J4"), CellIndex.indexByString("K4"));
//     cellJ4.cellStyle = CellStyle(backgroundColorHex: "#B4C3E8",fontSize: 20,
//         horizontalAlign: HorizontalAlign.Center);
//
//     var cellJ5 = sheet.cell(CellIndex.indexByString("J5"));
//     cellJ5.value = TextCellValue('Nama Biaya');
//     cellJ5.cellStyle = CellStyle(backgroundColorHex: "#B4C3E8",fontSize: 20,
//         horizontalAlign: HorizontalAlign.Center);
//
//     var cellK5 = sheet.cell(CellIndex.indexByString("K5"));
//     cellK5.value = TextCellValue('Harga');
//     cellK5.cellStyle = CellStyle(backgroundColorHex: "#B4C3E8",fontSize: 20,
//         horizontalAlign: HorizontalAlign.Center);
//
//     Directory? downloadsDirectory = await getDownloadsDirectory();
//     if (downloadsDirectory != null) {
//       String filePath = '${downloadsDirectory.path}/${namaFile.text}.xlsx';
//
//       final File file = File(filePath);
//       if (await file.exists()) {
//         await file.delete();
//       }
//
//       await file.writeAsBytes(eksel.encode()!);
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Export berhasil. File disimpan di $filePath'),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error mengakses direktori unduhan.'),
//         ),
//       );
//     }
//   }
// }

