import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase import
import 'firebase_options.dart'; // Firebase options import
import 'splash_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized(); // Initialize localization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Firebase initialization
  );

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('ml', 'IN')], // English & Malayalam
      path: 'assets/lang', // Path to translation files
      fallbackLocale: Locale('en', 'US'),
      saveLocale: true, // Saves selected language
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery App', // App title
      debugShowCheckedModeBanner: false,
      locale: context.locale, // Set locale dynamically
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      home: SplashScreen(), // Start with splash screen
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomePage(),
      },
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the device's locale is supported, otherwise use fallback
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return Locale('en', 'US'); // Default to English
      },
    );
  }
}
