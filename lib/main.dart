import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';
import 'package:theater/prefs.dart';
import 'package:theater/providers/AppProvider.dart';
import 'package:theater/screens/Home.dart';
import 'package:theater/screens/Language.dart';
import 'package:theater/screens/Search.dart';
import 'package:theater/screens/Splash.dart';
import 'package:theater/screens/WatchList.dart';
import 'package:theater/utils/MyHttpOverrides.dart';
import 'screens/Main.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initPref();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  MediaKit.ensureInitialized();

  WidgetsApp.debugAllowBannerOverride = true;
  HttpOverrides.global = MyHttpOverrides();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AppProvider())],
      child: const MyApp(),
    ),
  );
  FlutterNativeSplash.remove();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent()
      },
      child: MaterialApp(
        title: 'Theater',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 26, 0, 26)),
          useMaterial3: true,
          highlightColor: const Color.fromARGB(255, 31, 1, 46),
          splashColor: const Color.fromARGB(255, 22, 0, 24),
          scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        routes: {
          "/search": (context) => const SearchScreen(),
          // "/play": (context) => const Play(),
          "/home": (context) => const HomeScreen(),
          "/watch": (context) => const WatchList(),
          "/language": (context) => const Language(),
          '/splash': (context) => const SplashScreen(),
          "/main": (context) => const Main()
        },
      ),
    );
  }
}
