import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:scuba/constants.dart';
import 'package:scuba/screens/navigationScreen.dart';

/*
* Classe StartScreen
*
* Premier écran que l'utilisateur verra, sauf au premier demarrage
* Permet la navigation vers l'écran d'accueil
*
* */
class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {

  @override
  Widget build(BuildContext context) {

    return Container(
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
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
              ),
            ),
            const Spacer(
              flex: 3,
            ),
          ],
        ));
  }
}
