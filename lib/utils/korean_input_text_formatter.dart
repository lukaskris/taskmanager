import 'package:flutter/services.dart';

class KoreanPhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digit characters
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    String formatted = '';
    int selectionIndex = newValue.selection.end;

    if (digits.length <= 3) {
      formatted = digits;
      selectionIndex = formatted.length;
    } else if (digits.length <= 7) {
      formatted = '${digits.substring(0, 3)}-${digits.substring(3)}';
      // Adjust cursor position
      if (selectionIndex > 3) {
        selectionIndex = selectionIndex + 1;
      }
    } else if (digits.length <= 11) {
      formatted =
          '${digits.substring(0, 3)}-${digits.substring(3, 7)}-${digits.substring(7)}';
      // Adjust cursor position carefully
      if (selectionIndex > 3 && selectionIndex <= 7) {
        selectionIndex = selectionIndex + 1;
      } else if (selectionIndex > 7) {
        selectionIndex = selectionIndex + 2;
      }
    } else {
      // Limit max 11 digits
      formatted =
          '${digits.substring(0, 3)}-${digits.substring(3, 7)}-${digits.substring(7, 11)}';
      if (selectionIndex > 3 && selectionIndex <= 7) {
        selectionIndex = selectionIndex + 1;
      } else if (selectionIndex > 7) {
        selectionIndex = selectionIndex + 2;
      }
    }

    // Make sure selectionIndex is within the valid range
    selectionIndex = selectionIndex.clamp(0, formatted.length);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
