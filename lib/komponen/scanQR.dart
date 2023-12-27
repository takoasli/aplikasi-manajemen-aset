import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:projek_skripsi/Aset/AC/moreDetailAC.dart';
import 'package:projek_skripsi/Aset/Laptop/moreDetailLaptop.dart';
import 'package:projek_skripsi/Aset/Mobil/MoreDetailMobil.dart';
import 'package:projek_skripsi/Aset/Motor/MoreDetailMotor.dart';
import 'package:projek_skripsi/dashboard.dart';

import '../Aset/PC/MoreDetailPC.dart';

class ScanQR extends StatelessWidget {

  Future<Map<String, dynamic>?> fetchDataFromFirestore(String assetCollection, String assetId) async {
    CollectionReference collection = FirebaseFirestore.instance.collection(assetCollection);
    QuerySnapshot querySnapshot;

    switch (assetCollection) {
      case 'Aset':
        querySnapshot = await collection.where('ID AC', isEqualTo: assetId).get();
        break;
      case 'PC':
        querySnapshot = await collection.where('ID PC', isEqualTo: assetId).get();
        break;
      case 'Laptop':
        querySnapshot = await collection.where('ID Laptop', isEqualTo: assetId).get();
        break;
      case 'Motor':
        querySnapshot = await collection.where('ID Motor', isEqualTo: assetId).get();
        break;
      case 'Mobil':
        querySnapshot = await collection.where('ID Mobil', isEqualTo: assetId).get();
        break;
      default:
        return null;
    }

    if (querySnapshot.docs.isNotEmpty) {
      // Jika data ditemukan, mengembalikan data pertama yang cocok
      return querySnapshot.docs.first.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  String determineAssetType(String barcode) {
    if (barcode.toLowerCase().contains('ac')) {
      return 'Aset';
    } else if (barcode.toLowerCase().contains('pc')) {
      return 'PC';
    } else if (barcode.toLowerCase().contains('laptop')) {
      return 'Laptop';
    } else if (barcode.toLowerCase().contains('motor')) {
      return 'Motor';
    } else if (barcode.toLowerCase().contains('mobil')) {
      return 'Mobil';
    } else {
      return '';
    }
  }

  String extractAssetId(String barcode) {
    List<String> parts = barcode.split(',');
    if (parts.length == 2) {
      return parts[1]; // Mengembalikan bagian kedua sebagai ID
    } else {
      return ''; // Mengembalikan string kosong jika format tidak sesuai
    }
  }


  void navigateToSpecificAsset(BuildContext context, String assetCollection, Map<String, dynamic> data) {
    switch (assetCollection) {
      case 'Aset':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MoreDetailAC(data: data)),
        );
        break;
      case 'PC':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MoreDetail(data: data)),
        );
        break;
      case 'Laptop':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MoreDetailLaptop(data: data)),
        );
        break;
      case 'Motor':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MoreDetailMotor(data: data)),
        );
        break;
      case 'Mobil':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MoreDetailmobil(data: data)),
        );
        break;
      default:
        showNotFoundDialog(context, 'QR Tidak Ditemukan!');
        break;
    }
  }



  void showNotFoundDialog(BuildContext context, String barcode) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
      title: 'Gagal!',
      desc: 'Aset dengan ID: $barcode tidak ditemukan.',
      btnOkOnPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 75,
      height: 75,
      child: FloatingActionButton(
        onPressed: () async {
          String barcode = await FlutterBarcodeScanner.scanBarcode(
            "#FF0000",
            "Cancel",
            true,
            ScanMode.QR,
          );
          if (barcode != '-1') {
            String assetType = determineAssetType(barcode);
            String assetId = extractAssetId(barcode);
            if (assetType.isNotEmpty && assetId.isNotEmpty) {
              Map<String, dynamic>? assetData = await fetchDataFromFirestore(assetType, assetId);
              if (assetData != null) {
                navigateToSpecificAsset(context, assetType, assetData);
              } else {
                showNotFoundDialog(context, barcode);
              }
            } else {
              showNotFoundDialog(context, barcode);
            }
          }
          print(barcode);
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
    );
  }
}
