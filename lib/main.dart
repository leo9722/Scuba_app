/*
* APPLICATION SCUBA
* PROJET M1 LEOPOLD PRALAIN & KILLIAN CHEVRIER
*
* CETTE APPLICATION APPARTIENT A LEOPOLD PRALAIN & KILLIAN CHEVRIER
* CE CODE APPARTIENT A LEOPOLD PRALAIN & KILLIAN CHEVRIER
*
* PROPRIETE INTELLECTUELLE DE LEOPOLD PRALAIN & KILLIAN CHEVRIER
* PROPRIETE DE LEOPOLD PRALAIN & KILLIAN CHEVRIER
*
* COPYRIGHT LEOPOLD PRALAIN & KILLIAN CHEVRIER
*
* */

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:scuba/constants.dart';
import 'package:scuba/screens/firstStartScreen.dart';
import 'package:scuba/screens/navigationScreen.dart';

//Fonction main, gestionnaire de l'application
Future<void> main() async {

  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_){

  //A50 : 411.4 * 843.4
  //Emulateur Pixel 3a XL : 432.0 * 816.0
  //A5 : 360 * 640

  runApp(const MyApp());
  //});
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Image.asset("images/imgDiver.png"),
        nextScreen: const Splash(),
        backgroundColor: kDarkBlueTextColor,
        splashTransition: SplashTransition.scaleTransition,

      ),
      initialRoute: '/',
      routes: {
        '/nav': (context) => NavigationScreen(
              menuScreenContext: context,
        ),
      },
    );
  }
}
