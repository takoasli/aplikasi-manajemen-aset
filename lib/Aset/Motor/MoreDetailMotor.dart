import 'dart:async';

import 'package:flutter/material.dart';

import '../../catatanAset.dart';
import '../../komponen/style.dart';
import '../../qrView.dart';
import '../ControllerLogic.dart';

class MoreDetailMotor extends StatefulWidget {
  const MoreDetailMotor({super.key,
    required this.data});
  final Map<String, dynamic> data;

  @override
  State<MoreDetailMotor> createState() => _MoreDetailMotorState();
}

class _MoreDetailMotorState extends State<MoreDetailMotor> {
  late DateTime targetDate = DateTime(2024, 2, 1);
  late Timer timer;
  double progressValue = 1.0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (DateTime.now().isBefore(targetDate)) {
        setState(() {
          progressValue = targetDate.difference(DateTime.now()).inSeconds /
              targetDate.difference(DateTime(targetDate.year, targetDate.month, 0)).inSeconds;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = widget.data['Gambar Motor'] ?? '';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF61BF9D),
        title: Text(
            '${widget.data['ID Motor']}',
            style: TextStyles.title.copyWith(
                fontSize: 20,
                color: Warna.white
            )
        ),
        elevation: 0,
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 370,
              height: 570,
              decoration: BoxDecoration(
                color: Warna.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                      )
                          : Image.asset(
                        'gambar/motor.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                      top: 30,
                      right: 30,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Warna.white,
                        ),
                        child: IconButton(
                          onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => QR_View(QR_ID: widget.data['ID Motor'], namaAset: widget.data['Merek Motor'],),
                                )
                            );
                          },
                          icon: Icon(Icons.qr_code_2,
                              size: 33),
                        ),
                      )
                  ),
                  Positioned(
                      top: 100,
                      right: 30,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Warna.white,
                        ),
                        child: IconButton(
                          onPressed: (){
                            List<dynamic> kebutuhanMobil = widget.data['Kebutuhan Motor'];

                            List<String> namaKebutuhan = [];
                            for (var kebutuhan in kebutuhanMobil) {
                              if (kebutuhan is Map<String, dynamic> && kebutuhan.containsKey('Nama Kebutuhan')) {
                                namaKebutuhan.add(kebutuhan['Nama Kebutuhan']);
                              }
                            }

                            Navigator.push(context, MaterialPageRoute(builder: (context) => Catatan(
                              List_Kebutuhan: namaKebutuhan,
                              ID_Aset: widget.data['ID Motor'],
                              Nama_Aset: widget.data['Merek Motor'],)));
                          },
                          icon: Icon(Icons.border_color_outlined,
                              size: 33),
                        ),
                      )
                  ),
                  Positioned(
                    top: 170,
                    child: Container(
                      width: 320,
                      height: 380,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Sisa waktu Maintenance',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 10),
                              showIndicator(
                                  getValueIndicator(
                                      widget.data['Hari Service Motor'],
                                      epochTimeToData(
                                          widget.data['Waktu Service Motor'])),
                                  getProgressColor(
                                      widget.data['Waktu Service Motor'])),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    getRemainingTime(
                                        widget.data['Waktu Service Motor']),
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 20),

                              Text(
                                  'Kebutuhan Servis',
                                  style: TextStyles.title.copyWith(
                                      fontSize: 18,
                                      color: Warna.darkgrey,
                                      fontWeight: FontWeight.w500
                                  )
                              ),
                              const SizedBox(height: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: widget.data['Kebutuhan Motor'].length,
                                    itemBuilder: (context, index) {
                                      final kebutuhan = widget.data['Kebutuhan Motor'][index]['Nama Kebutuhan'];
                                      final part = kebutuhan.split(': ');
                                      final hasSplit = part.length > 1 ? part[1] : kebutuhan;
                                      return Text(
                                        '- $hasSplit',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          letterSpacing: 1,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                  'Merek Motor',
                                  style: TextStyles.title.copyWith(
                                      fontSize: 18,
                                      color: Warna.darkgrey,
                                      fontWeight: FontWeight.w500
                                  )
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${widget.data['Merek Motor']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 15),

                              Text(
                                  'ID Motor',
                                  style: TextStyles.title.copyWith(
                                      fontSize: 18,
                                      color: Warna.darkgrey,
                                      fontWeight: FontWeight.w500
                                  )
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${widget.data['ID Motor']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 15),

                              Text(
                                  'Kapasitas Mesin',
                                  style: TextStyles.title.copyWith(
                                      fontSize: 18,
                                      color: Warna.darkgrey,
                                      fontWeight: FontWeight.w500
                                  )
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${widget.data['Kapasitas Mesin']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 15),

                              Text(
                                  'Sistem Pendingin',
                                  style: TextStyles.title.copyWith(
                                      fontSize: 18,
                                      color: Warna.darkgrey,
                                      fontWeight: FontWeight.w500
                                  )
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${widget.data['Sistem Pendingin']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 15),

                              Text(
                                  'Tipe Transmisi',
                                  style: TextStyles.title.copyWith(
                                      fontSize: 18,
                                      color: Warna.darkgrey,
                                      fontWeight: FontWeight.w500
                                  )
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${widget.data['Tipe Transmisi']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 15),

                              Text(
                                  'Kapasitas Bahan Bakar',
                                  style: TextStyles.title.copyWith(
                                      fontSize: 18,
                                      color: Warna.darkgrey,
                                      fontWeight: FontWeight.w500
                                  )
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${widget.data['Kapasitas Bahan Bakar']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 15),

                              Text(
                                  'Kapasitas Minyak Rem',
                                  style: TextStyles.title.copyWith(
                                      fontSize: 18,
                                      color: Warna.darkgrey,
                                      fontWeight: FontWeight.w500
                                  )
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${widget.data['Kapasitas Minyak']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 15),

                              Text(
                                  'Tipe Aki',
                                  style: TextStyles.title.copyWith(
                                      fontSize: 18,
                                      color: Warna.darkgrey,
                                      fontWeight: FontWeight.w500
                                  )
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${widget.data['Tipe Aki']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 15),

                              Text(
                                  'Ukuran Ban Depan',
                                  style: TextStyles.title.copyWith(
                                      fontSize: 18,
                                      color: Warna.darkgrey,
                                      fontWeight: FontWeight.w500
                                  )
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${widget.data['Ban Depan']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 15),

                              Text(
                                  'Ukuran Ban Belakang',
                                  style: TextStyles.title.copyWith(
                                      fontSize: 18,
                                      color: Warna.darkgrey,
                                      fontWeight: FontWeight.w500
                                  )
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${widget.data['Ban Belakang']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 10),

                              Text(
                                  'Tempo Maintenance',
                                  style: TextStyles.title.copyWith(
                                      fontSize: 18,
                                      color: Warna.darkgrey,
                                      fontWeight: FontWeight.w500
                                  )
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${widget.data['Masa Servis']} Bulan',
                                style: const TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 10),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
