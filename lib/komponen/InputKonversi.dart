import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    int value = int.parse(newValue.text.replaceAll('.', ''));
    final formatter = NumberFormat('#,###');
    String newText = formatter.format(value);

    return newValue.copyWith(
      text: newText.replaceAll(',', '.'), // ganti koma dengan titik
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
