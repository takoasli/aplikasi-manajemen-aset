import 'dart:async';

import 'package:flutter/material.dart';

class TimeBar extends StatefulWidget {
  const TimeBar({Key? key}) : super(key: key);

  @override
  _TimeBarState createState() => _TimeBarState();
}

class _TimeBarState extends State<TimeBar> {
  late DateTime targetDate;
  double progressValue = 1.0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    targetDate = DateTime(2024, 1, 1);

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
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

    // Mengubah teks berdasarkan kondisi bulan, hari, jam, menit, dan detik
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

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color progressColor = _getProgressColor(progressValue);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF61BF9D),
        title: const Text(
          'tes bar',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.grey[300],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  width: MediaQuery.of(context).size.width * progressValue * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: progressColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              _getRemainingTime(),
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
