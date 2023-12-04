import 'dart:async';

import 'package:flutter/material.dart';

import '../../komponen/style.dart';

class MoreDetailAC extends StatefulWidget {
  const MoreDetailAC({super.key,
    required this.data});
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
              targetDate.difference(DateTime(targetDate.year, targetDate.month, 0)).inSeconds;
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

    Color _getProgressColor(double progressValue) {
      if (progressValue >= 0.5) {
        return Colors.green;
      } else if (progressValue >= 0.2) {
        return Colors.yellow;
      } else {
        return Colors.red;
      }
    }

    String _getRemainingTime() {
      Duration difference = targetDate.difference(DateTime.now());
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF61BF9D),
        title: Text(
            '${widget.data['ID AC']}',
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
                      child: PageView.builder(
                        controller: _pageController,
                          itemCount: imageUrls.length,
                          onPageChanged: (int page){
                          setState(() {
                            _currentPage = page;
                          }
                          );
                          },
                          itemBuilder: (context, index){
                          return Image.network(
                            imageUrls[index],
                            fit: BoxFit.contain,
                          );
                          },
                          ),
                    ),
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
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: 10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.grey[300],
                                ),
                                child: Stack(
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(seconds: 1),
                                      width: MediaQuery.of(context).size.width * progressValue * 0.8,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.0),
                                        color: _getProgressColor(progressValue),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _getProgressColor(progressValue),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    _getRemainingTime(),
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                  'Merek AC',
                                  style: TextStyles.title.copyWith(
                                      fontSize: 18,
                                      color: Warna.darkgrey,
                                      fontWeight: FontWeight.w500
                                  )
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${widget.data['Merek AC']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 10),

                              Text(
                                  'ID AC',
                                  style: TextStyles.title.copyWith(
                                      fontSize: 18,
                                      color: Warna.darkgrey,
                                      fontWeight: FontWeight.w500
                                  )
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${widget.data['ID AC']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 10),

                              Text(
                                  'Lokasi Ruangan',
                                  style: TextStyles.title.copyWith(
                                      fontSize: 18,
                                      color: Warna.darkgrey,
                                      fontWeight: FontWeight.w500
                                  )
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${widget.data['Lokasi Ruangan']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 10),

                              Text(
                                  'Kapasitas Watt',
                                  style: TextStyles.title.copyWith(
                                      fontSize: 18,
                                      color: Warna.darkgrey,
                                      fontWeight: FontWeight.w500
                                  )
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${widget.data['Kapasitas Watt']} watt',
                                style: const TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 10),

                              Text(
                                  'Kapasitas PK',
                                  style: TextStyles.title.copyWith(
                                      fontSize: 18,
                                      color: Warna.darkgrey,
                                      fontWeight: FontWeight.w500
                                  )
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${widget.data['Kapasitas PK']}',
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
