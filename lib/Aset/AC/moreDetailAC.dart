import 'dart:async';

import 'package:flutter/material.dart';

import '../../catatanAset.dart';
import '../../komponen/style.dart';
import '../../qrView.dart';
import '../ControllerLogic.dart';

class MoreDetailAC extends StatefulWidget {
  const MoreDetailAC({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<MoreDetailAC> createState() => _MoreDetailACState();
}

class _MoreDetailACState extends State<MoreDetailAC> {
  late DateTime targetDate = DateTime(2024, 2, 1);
  late Timer timer;
  double progressValue = 1.0;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (DateTime.now().isBefore(targetDate)) {
        setState(() {
          progressValue = targetDate.difference(DateTime.now()).inSeconds /
              targetDate
                  .difference(DateTime(targetDate.year, targetDate.month, 0))
                  .inSeconds;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> imageUrls = [
      widget.data['Foto AC Indoor'] ?? '',
      widget.data['Foto AC Outdoor'] ?? '',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF61BF9D),
        title: Text('${widget.data['ID AC']}',
            style: TextStyles.title.copyWith(fontSize: 20, color: Warna.white)),
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
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: imageUrls.length,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Image.network(
                            imageUrls[index],
                            fit: BoxFit.contain,
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                      top: 30,
                      right: 30,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Warna.white,
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QRView(
                                    assetCollection: "Aset",
                                    assetId: widget.data['ID AC'],
                                    assetName: widget.data['Merek AC'],
                                  ),
                                ));
                          },
                          icon: Icon(Icons.qr_code_2, size: 33),
                        ),
                      )),
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
                          onPressed: () {
                            List<dynamic> kebutuhanAC =
                                widget.data['Kebutuhan AC'];

                            List<String> namaKebutuhan = [];
                            for (var kebutuhan in kebutuhanAC) {
                              if (kebutuhan is Map<String, dynamic> &&
                                  kebutuhan.containsKey('Nama Kebutuhan')) {
                                namaKebutuhan.add(kebutuhan['Nama Kebutuhan']);
                              }
                            }

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Catatan(
                                          List_Kebutuhan: namaKebutuhan,
                                          ID_Aset: widget.data['ID AC'],
                                          Nama_Aset: widget.data['Merek AC'],
                                        )));
                          },
                          icon: Icon(Icons.border_color_outlined, size: 33),
                        ),
                      )),
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
                              SizedBox(height: 5),
                              showIndicator(
                                  getValueIndicator(
                                      widget.data['hari_service'],
                                      epochTimeToData(
                                          widget.data['waktu_service'])),
                                  getProgressColor(
                                      widget.data['waktu_service'])),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    getRemainingTime(
                                        widget.data['waktu_service']),
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text('Kebutuhan Servis',
                                  style: TextStyles.title.copyWith(
                                      fontSize: 18,
                                      color: Warna.darkgrey,
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(height: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        widget.data['Kebutuhan AC'].length,
                                    itemBuilder: (context, index) {
                                      final kebutuhan =
                                          widget.data['Kebutuhan AC'][index]
                                              ['Nama Kebutuhan'];
                                      final part = kebutuhan.split(': ');
                                      final hasSplit =
                                          part.length > 1 ? part[1] : kebutuhan;
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
                              const SizedBox(height: 10),
                              Text('Merek AC',
                                  style: TextStyles.title.copyWith(
                                      fontSize: 18,
                                      color: Warna.darkgrey,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 5),
                              Text(
                                '${widget.data['Merek AC']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text('ID AC',
                                  style: TextStyles.title.copyWith(
                                      fontSize: 18,
                                      color: Warna.darkgrey,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 5),
                              Text(
                                '${widget.data['ID AC']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text('Lokasi Ruangan',
                                  style: TextStyles.title.copyWith(
                                      fontSize: 18,
                                      color: Warna.darkgrey,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 5),
                              Text(
                                '${widget.data['Lokasi Ruangan']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text('Kapasitas Watt',
                                  style: TextStyles.title.copyWith(
                                      fontSize: 18,
                                      color: Warna.darkgrey,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 5),
                              Text(
                                '${widget.data['Kapasitas Watt']} watt',
                                style: const TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text('Kapasitas PK',
                                  style: TextStyles.title.copyWith(
                                      fontSize: 18,
                                      color: Warna.darkgrey,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 5),
                              Text(
                                '${widget.data['Kapasitas PK']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text('Tempo Maintenance',
                                  style: TextStyles.title.copyWith(
                                      fontSize: 18,
                                      color: Warna.darkgrey,
                                      fontWeight: FontWeight.w500)),
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
