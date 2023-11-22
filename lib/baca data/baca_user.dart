import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projek_skripsi/komponen/style.dart';

class BacaUser extends StatelessWidget {
  BacaUser({required this.dokumenUser});

  final String dokumenUser;

  @override
  Widget build(BuildContext context) {
    CollectionReference User = FirebaseFirestore.instance.collection('User');

    return FutureBuilder<DocumentSnapshot>(
      future: User.doc(dokumenUser).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${data['Nama']}',
                style: TextStyles.title.copyWith(
                    fontSize: 17,
                    color: Warna.darkgrey,
                letterSpacing: 0.5),
              ),
              SizedBox(height: 8),
              Text(
                '${data['ID']}',
                style: TextStyles.body.copyWith(fontSize: 15, color: Warna.darkgrey),
              ),
            ],
          );
        }
        return Text('loading bang');
      },
    );
  }
}
