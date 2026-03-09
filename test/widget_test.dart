import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app/core/theme/app_theme.dart';
import 'package:to_do_app/core/widgets/app_button.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('gradient button renders label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Center(
            child: GradientButton(
              label: 'Save',
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Save'), findsOneWidget);
  });
}
