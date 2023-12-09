import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'komponen/style.dart';

class QR_View extends StatefulWidget {
  const QR_View({Key? key, required this.QR_ID,
    required this.namaAset,}) : super(key: key);

  final String QR_ID;
  final String namaAset;

  @override
  State<QR_View> createState() => _QR_ViewState();
}

class _QR_ViewState extends State<QR_View> {
  late String idAset;
  late String namaAset;
  final GlobalKey _gambarQRKey  = GlobalKey();

  @override
  void initState(){
    super.initState();
    idAset = '${widget.QR_ID}';
    namaAset = '${widget.namaAset}';
  }

  Future<void> SimpanGambarQR() async {
    try {
      RenderRepaintBoundary boundary = _gambarQRKey .currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      await ImageGallerySaver.saveImage(pngBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image downloaded successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print(e.toString());

      // Optionally, show a message if download fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to download image'),
          duration: Duration(seconds: 2),
        ),
      );
    }
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

              Container(
                height: 200,
                width: 200,
                child: RepaintBoundary(
                  key: _gambarQRKey,
                  child: QrImageView(
                    data: widget.QR_ID,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),

                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed:SimpanGambarQR,
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
                    style: TextStyles.title.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "1. Download Gambar QR Code",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "2. Print Gambar QR Code",
                      style: TextStyle(fontSize: 16)
                  ),
                  SizedBox(height: 5),
                  Text(
                    "3. Tempelkan Gambar QR Code ke \n     Unit Aset",
                      style: TextStyle(fontSize: 16)
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}

