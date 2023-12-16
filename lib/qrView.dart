import 'dart:typed_data';
import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'komponen/style.dart';

class QRView extends StatefulWidget {
  const QRView({
    Key? key,
    required this.assetCollection,
    required this.assetId,
    required this.assetName,
  }) : super(key: key);

  final String assetCollection;
  final String assetId;
  final String assetName;

  @override
  State<QRView> createState() => _QRViewState();
}

class _QRViewState extends State<QRView> {
  late String idAset;
  late String namaAset;
  final GlobalKey _qrImageGlobalKey = GlobalKey();
  Uint8List? _imageData;

  Future<void> PermissionAja() async {
    if (_imageData != null) {
      final PermissionStatus status = await Permission.storage.request();
      if (status.isGranted) {
        final result = await ImageGallerySaver.saveImage(_imageData!);
        if (result['isSuccess']) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            title: 'Berhasil!',
            desc: 'QR Code berhasil Diunduh',
            btnOkOnPress: () {
              Navigator.of(context).pop();
            },
            autoHide: Duration(seconds: 5),
          ).show();
          print('QR Code berhasil Diunduh');
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.bottomSlide,
            title: 'Gagal!',
            desc: 'QR Code Gagal Diunduh',
            btnOkOnPress: () {
              Navigator.of(context).pop();
            },
            autoHide: Duration(seconds: 5),
          ).show();
          print('QR Code Gagal Diunduh: ${result['error']}');
        }
      } else {
        print('Permission denied');
      }
    }
  }

  Future<void> AmbilGambar() async {
    try {
      if (_qrImageGlobalKey.currentContext != null) {
        RenderRepaintBoundary boundary = _qrImageGlobalKey.currentContext!
            .findRenderObject() as RenderRepaintBoundary;
        if (boundary != null) {
          var image = await boundary.toImage(pixelRatio: 3.0);
          ByteData? byteData =
              await image.toByteData(format: ImageByteFormat.png);
          if (byteData != null) {
            setState(() {
              _imageData = byteData.buffer.asUint8List();
            });
          } else {
            print('ByteData is null');
          }
        } else {
          print('RenderRepaintBoundary is null');
        }
      } else {
        print('RepaintBoundary context is null');
      }
    } catch (e) {
      print('Error while capturing QR Code image: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    idAset = '${widget.assetId}';
    namaAset = '${widget.assetName}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.green,
      appBar: AppBar(
        backgroundColor: const Color(0xFF61BF9D),
        title: const Text(
          'QR Code',
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
          height: 585,
          decoration: BoxDecoration(
            color: Warna.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Text(
                idAset,
                style: TextStyles.title.copyWith(
                  fontSize: 25,
                  color: Warna.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                namaAset,
                style: TextStyles.body.copyWith(
                  fontSize: 20,
                  color: Warna.darkgrey,
                ),
              ),
              const SizedBox(height: 10),
              RepaintBoundary(
                key: _qrImageGlobalKey,
                child: Container(
                  height: 200,
                  width: 200,
                  child: QrImageView(
                    data: '${widget.assetCollection},${widget.assetId}',
                    version: QrVersions.auto,
                    size: 200.0,
                    backgroundColor: Warna.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await AmbilGambar();
                  await PermissionAja();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Warna.green,
                  minimumSize: const Size(170, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Download',
                  style: TextStyles.body.copyWith(fontSize: 20),
                ),
              ),
              SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Cara Mengaplikasikan\n QR Code ke Aset",
                    style: TextStyles.title
                        .copyWith(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "1. Download Gambar QR Code",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text("2. Print Gambar QR Code",
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 5),
                  Text("3. Tempelkan Gambar QR Code ke \n     Unit Aset",
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
