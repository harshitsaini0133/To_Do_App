import 'package:flutter/widgets.dart';
import 'package:to_do_app/app/app.dart';
import 'package:to_do_app/core/di/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  runApp(const ToDoApp());
}
