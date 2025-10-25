import 'package:flutter/material.dart';
import 'core/routes/app_router.dart';
import 'core/theme/light_theme.dart';
import 'core/theme/dark_theme.dart';

void main() {
  runApp(const IASApp());
}

class IASApp extends StatelessWidget {
  const IASApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'IAS Test Series',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: AppRouter.router,
    );
  }
}
