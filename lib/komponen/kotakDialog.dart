import 'package:flutter/material.dart';
import 'package:projek_skripsi/komponen/style.dart';
import 'package:projek_skripsi/komponen/tombol.dart';

class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onAdd;
  VoidCallback onCancel;

  DialogBox({super. key,
    required this.controller,
    required this.onAdd,
    required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Warna.green,
      content: SingleChildScrollView(
        child: Container(
          height: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tambah Task baru...',
              style: TextStyles.body.copyWith(fontSize: 17, color: Warna.white),
              textAlign: TextAlign.left,),
              const SizedBox(height: 7),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none// Radius sudut 20
                  ),
                  filled: true,
                  fillColor: Colors.white, // Warna latar belakang putih
                ),
              ),
              const SizedBox(height: 10),
              //tombol
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Tombol(
                      text: 'Add',
                      onPressed: onAdd),
                  const SizedBox(width: 15),
                  Tombol(
                      text: 'Cancel',
                      onPressed: onCancel)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
