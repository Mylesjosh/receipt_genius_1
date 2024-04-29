import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:receipt_genius/pages/landing_page.dart';
import 'theme/theme_provider.dart';
// Import the generated file
import 'firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// Conditionally import 'dart:js' only when running on web
//import 'dart:js' as js if (kIsWeb) 'dart:html';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const MyApp()
      ),
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
    // Use builder only if you need to use library outside ScreenUtilInit context
    builder: (_ , child) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: Provider.of<ThemeProvider>(context).themeData,
            home: child,
          );
        },
        child: const LandingPage(),
    );
  }
}

