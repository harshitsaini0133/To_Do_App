import 'package:flutter/material.dart';

extension ResponsiveTextExtension on TextStyle {
  TextStyle responsive(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final scale = (width / 390).clamp(0.9, 1.18);
    return copyWith(fontSize: (fontSize ?? 14) * scale);
  }
}
