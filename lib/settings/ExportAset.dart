import 'package:flutter/material.dart';

class ExportAset extends StatefulWidget {
  const ExportAset({super.key});

  @override
  State<ExportAset> createState() => _ExportAsetState();
}

class _ExportAsetState extends State<ExportAset> {
  final List<String> kategoriAset = ['AC', 'PC', 'Laptop','Motor','Mobil'];
  List<String> kategoriTerpilih = [];
  late List<String> DokCatatanEX = [];

  @override
  Widget build(BuildContext context) {
    final namaFile = TextEditingController();
    return Scaffold(

    );
  }
}
