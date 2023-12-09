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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      content: SingleChildScrollView(
        child: Container(
          height: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tambah Kebutuhan baru...',
              style: TextStyles.body.copyWith(fontSize: 17, color: Warna.white),
              textAlign: TextAlign.left,),
              const SizedBox(height: 7),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              //tombol
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Tombol(
                      text: 'Add',
                      onPressed: onAdd,
                      backgroundColor: Colors.green.shade500,
                      textColor: Warna.white,),
                  const SizedBox(width: 15),
                  Tombol(
                      text: 'Cancel',
                      onPressed: onCancel,
                    backgroundColor: Warna.white,
                    textColor: Warna.darkgrey)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
