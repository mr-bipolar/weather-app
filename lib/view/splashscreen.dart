import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/view/mainscreen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 6), () {
      Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()));
    });
    return Platform.isIOS
        //* ios
        ? CupertinoPageScaffold(
            child: SplashWidget(
            colors: const [
              CupertinoColors.systemOrange,
              CupertinoColors.systemIndigo,
              CupertinoColors.black
            ],
          ))
        //* Android
        : Scaffold(body: SplashWidget());
  }
}

//* splash background
// ignore: must_be_immutable
class SplashWidget extends StatelessWidget {
  SplashWidget({super.key, this.colors});

  List<Color>? colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: colors ??
                  [
                    const Color.fromARGB(255, 255, 162, 33),
                    const Color.fromARGB(221, 37, 38, 66),
                    Colors.black
                  ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
      child: Center(
        child: Image.asset(
          'assets/icons/Clear.png',
          height: 80,
        ),
      ),
    );
  }
}
