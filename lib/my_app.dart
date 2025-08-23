import 'package:flutter/material.dart';

import 'core/constants/app_colors.dart';
import 'presentation/pages/splashScreen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auto Parts App',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bgColor,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
