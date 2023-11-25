import 'package:flutter/material.dart';
import 'package:projek_skripsi/komponen/style.dart';

class Tombol extends StatelessWidget {
  final String text;
  VoidCallback onPressed;

  Tombol({super.key,
    required this.text,
    required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: onPressed,
      color: Colors.green.shade500,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      child: Text(text,
      style: TextStyles.body.copyWith(
          color: Warna.white,
      fontSize: 15),
      ),
    );
  }
}
