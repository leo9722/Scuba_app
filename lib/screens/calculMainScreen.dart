import 'package:flutter/material.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:scuba/components/calcModeButtonC.dart';
import 'package:scuba/components/headerC.dart';
import 'package:scuba/screens/simulationScreen.dart';
import 'calculScreen.dart';

/*
* Screen : Mode de calcul
*
* Permet de choisir le mode de calcul entre calcul simple ou navigation
* */
class CalculMainScreen extends StatefulWidget {
  const CalculMainScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CalculMainScreen createState() => _CalculMainScreen();
}

class _CalculMainScreen extends State<CalculMainScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldGradientBackground(
      resizeToAvoidBottomInset: false,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xFF32a5ff),
          Color(0xFF334ac9),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Flexible(
            flex: 3,
            child: HeaderC(
              text: "Calcul",
            ),
          ),
          const Spacer(
            flex: 2,
          ),
          Flexible(
            flex: 5,
            child: Image.asset("images/imgMainCalc.png"),
          ),
          const Spacer(
            flex: 2,
          ),
          Flexible(
            flex: 4,
            child: Row(
              children: [
                Flexible(
                  flex: 15,
                  child: CalcModeButton(
                    text: "Calcul",
                    image: "images/imgCalcul.png",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const CalculScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
                Flexible(
                  flex: 15,
                  child: CalcModeButton(
                    text: "Simulation",
                    image: "images/imgSimulate.png",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const SimulationScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Spacer(
            flex: 4,
          ),
        ],
      ),
    );
  }
}
