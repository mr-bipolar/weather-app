import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/view/splashscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(Platform.isIOS
      ? const CupertinoApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        )
      : const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        ));
}
