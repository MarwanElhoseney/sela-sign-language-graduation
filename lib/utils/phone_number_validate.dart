import 'package:flutter/services.dart';

class ArabicToEnglishDigitsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final arabicToEnglish = newValue.text.replaceAllMapped(
      RegExp(r'[٠-٩]'),
          (match) => (match.group(0)!.codeUnitAt(0) - 0x0660).toString(),
    );

    return TextEditingValue(
      text: arabicToEnglish,
      selection: newValue.selection,
    );
  }
}
