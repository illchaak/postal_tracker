import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'data/services/crash_reporting_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Потрібно перед викликом нативного коду (Firebase) до runApp().
  WidgetsFlutterBinding.ensureInitialized();

  // Підключення до проєкту Firebase (налаштування згенеровано flutterfire configure).
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Надсилання необроблених помилок у Firebase Crashlytics.
  CrashReportingService.instance.setupErrorHandlers();

  runApp(const PostalTrackerApp());
}
