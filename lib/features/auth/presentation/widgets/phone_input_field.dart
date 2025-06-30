import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final FocusNode? focusNode;

  const PhoneInputField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11), // Egyptian numbers are 11 digits
      ],
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText ?? '01012345678',
        prefixIcon: const Icon(Icons.phone_outlined),
        helperText: 'Format: 01XXXXXXXXX',
      ),
    );
  }
}

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final buffer = StringBuffer();

    // Format: 1-570-236-7033
    if (text.isNotEmpty) {
      buffer.write(text[0]);
      if (text.length > 1) {
        buffer.write('-');
        if (text.length >= 4) {
          buffer.write(text.substring(1, 4));
          if (text.length > 4) {
            buffer.write('-');
            if (text.length >= 7) {
              buffer.write(text.substring(4, 7));
              if (text.length > 7) {
                buffer.write('-');
                buffer.write(text.substring(7, text.length > 11 ? 11 : text.length));
              }
            } else {
              buffer.write(text.substring(4));
            }
          }
        } else {
          buffer.write(text.substring(1));
        }
      }
    }

    final formattedText = buffer.toString();

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

