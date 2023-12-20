import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:projek_skripsi/Aset/AC/moreDetailAC.dart';
import 'package:projek_skripsi/Aset/Laptop/moreDetailLaptop.dart';
import 'package:projek_skripsi/Aset/Mobil/MoreDetailMobil.dart';
import 'package:projek_skripsi/Aset/Motor/MoreDetailMotor.dart';
import 'package:projek_skripsi/Dashboard.dart';

import '../Aset/PC/MoreDetailPC.dart';

class ScanQR extends StatelessWidget {

  Future<Map<String, dynamic>?> fetchDataFromFirestore(String assetType, String assetId) async {
    CollectionReference collection =
    FirebaseFirestore.instance.collection(assetType);

    DocumentSnapshot documentSnapshot = await collection.doc(assetId).get();

    if (documentSnapshot.exists) {
      return documentSnapshot.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  String determineAssetCollection(String barcode) {
    if (barcode.toLowerCase().contains('ac')) {
      return 'AC';
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

  void navigateToSpecificAsset(BuildContext context, String assetCollection, Map<String, dynamic> data) {
    switch (assetCollection) {
      case 'AC':
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
            String assetCollection = determineAssetCollection(barcode);
            if (assetCollection.isNotEmpty) {
              Map<String, dynamic>? assetData = await fetchDataFromFirestore(assetCollection, barcode);
              if (assetData != null) {
                navigateToSpecificAsset(context, assetCollection, assetData);
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
