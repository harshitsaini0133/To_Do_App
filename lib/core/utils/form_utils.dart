import 'package:flutter/material.dart';

export 'package:to_do_app/core/utils/validation_logic.dart';

abstract final class FormUtils {
  static void unfocus(BuildContext context) {
    final focusScope = FocusScope.of(context);
    if (!focusScope.hasPrimaryFocus) {
      focusScope.unfocus();
    }
  }
}
