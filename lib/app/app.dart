import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/theme/app_theme.dart';
import 'app_routes.dart';

/// Кореневий віджет застосунку «Поштовий трекер».
class PostalTrackerApp extends StatelessWidget {
  const PostalTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Поштовий трекер',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      // Українська мова для системних елементів (календар, підказки).
      locale: const Locale('uk'),
      supportedLocales: const [Locale('uk'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
