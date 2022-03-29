import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:scuba/model/dataClasses.dart';
import 'package:scuba/screens/startScreen.dart';
import 'package:scuba/screens/tutorialScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'navigationScreen.dart';

/*
* Screen : détection du premier chargement de l'application
*
* */
class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  Future checkFirst() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    //Navigation vers l'écran d'accueil si pas premier demarrage
    if (_seen) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const StartScreen(),
        ),
      );
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const FirstStartScreen(),
        ),
      );
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirst();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Loading...'),
      ),
    );
  }
}

/*
* Screen : écran de premier chargement de l'application
* Permet le chargement et l'initialisation de la BDD et des données
* */
class FirstStartScreen extends StatefulWidget {
  const FirstStartScreen({Key? key}) : super(key: key);

  @override
  State<FirstStartScreen> createState() => _FirstStartScreenState();
}

class _FirstStartScreenState extends State<FirstStartScreen> {

  //Initialisation de la bdd puis des données
  Future initDb() async {
    await DbBrain().init();
    await Future.delayed(const Duration(seconds: 5));
    await DbBrain().createDb();
    await DbBrain().insertDefault();

    pushNewScreen(
      context,
      screen: const TutorialScreen(),
    );

    return "Data";
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/imgStartScreen.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(
                flex: 2,
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Scuba Diving",
                        style: TextStyle(
                            fontSize: 45,
                            decoration: TextDecoration.none,
                            color: kDarkBlueTextColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Your application to dive anywhere",
                        style: TextStyle(
                            fontSize: 15,
                            decoration: TextDecoration.none,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(
                flex: 2, //3
              ),
              Expanded(
                flex: 1,
                child: FutureBuilder(
                  future: initDb(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return kStartButton;
                            },
                          ),
                        ),
                        onPressed: () => pushNewScreen(context,
                            screen: NavigationScreen(
                              menuScreenContext: context,
                            )),
                        child: const Padding(
                          padding: EdgeInsets.only(
                            bottom: 20,
                            right: 30,
                            left: 30,
                            top: 20,
                          ),
                          child: FittedBox(
                            child: Text(
                              'Tap Here to start',
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.all(30.0),
                        child: LinearProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    }
                  },
                ),
              ),
              const Spacer(
                flex: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
