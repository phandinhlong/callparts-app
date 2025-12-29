import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:callparts/presentation/providers/cart_provider.dart';
import 'package:callparts/presentation/providers/favorite_provider.dart';

import 'core/constants/app_colors.dart';
import 'presentation/pages/splashScreen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final cartProvider = CartProvider();
            cartProvider.loadFromPreferences();
            return cartProvider;
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            final favoriteProvider = FavoriteProvider();
            favoriteProvider.loadFromPreferences();
            return favoriteProvider;
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Auto Parts App',
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.bgColor,
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
