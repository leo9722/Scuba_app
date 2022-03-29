import 'package:flutter/material.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:scuba/components/crudButton.dart';
import 'package:scuba/components/headerC.dart';
import 'package:scuba/crud/azoteCrudMainScreen.dart';
import 'package:scuba/crud/deepCrudMainScreen.dart';
import 'package:scuba/crud/divingTableCrudMainScreen.dart';
import 'package:scuba/crud/groupesCrudMainScreen.dart';
import 'package:scuba/crud/intervalleCrudMainScreen.dart';
import 'package:scuba/crud/levelCrudMainScreen.dart';
import 'package:scuba/crud/majorationCrudMainScreen.dart';
import 'package:scuba/crud/timeCrudMainScreen.dart';

/*
* Screen : Administration des données (CRUD)
*
* Permet la navigation vers les CRUD pour gérer les différentes
* tables de la base de données
* */
class AdminMainScreen extends StatelessWidget {
  const AdminMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldGradientBackground(
      resizeToAvoidBottomInset: false,
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF32a5ff),
          Color(0xFF334ac9),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Flexible(
            child: HeaderC(
              text: "Paramètres",
            ),
            flex: 3,
          ),
          Flexible(
            flex: 17,
            child: Column(
              children: [
                const Spacer(flex: 1),
                Flexible(
                  flex: 3,
                  child: Row(
                    children: [
                      Flexible(
                        child: CrudButton(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TimeCrudMainScreen(),
                              ),
                            );
                          },
                          image: 'images/gestionnaire-de-temps-1.png',
                          text: 'Temps',
                        ),
                      ),
                      Flexible(
                        child: CrudButton(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DivingTableCrudMainScreen(),
                              ),
                            );
                          },
                          image: 'images/snorkeling.png',
                          text: 'Tables',
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 1),
                Flexible(
                  flex: 3,
                  child: Row(
                    children: [
                      Flexible(
                        child: CrudButton(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DeepCrudMainScreen(),
                              ),
                            );
                          },
                          image: 'images/profondeur.png',
                          text: 'Profondeurs',
                        ),
                      ),
                      Flexible(
                        child: CrudButton(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AzoteCrudMainScreen(),
                              ),
                            );
                          },
                          image: 'images/azote.png',
                          text: 'Azote',
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 1),
                Flexible(
                  flex: 3,
                  child: Row(
                    children: [
                      Flexible(
                        child: CrudButton(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GroupesCrudMainScreen(),
                              ),
                            );
                          },
                          image: 'images/abc-block.png',
                          text: 'Groupes',
                        ),
                      ),
                      Flexible(
                        child: CrudButton(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const IntervalleCrudMainScreen(),
                              ),
                            );
                          },
                          image: 'images/sablier.png',
                          text: 'Intervalles',
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 1),
                Flexible(
                  flex: 3,
                  child: Row(
                    children: [
                      Flexible(
                        child: CrudButton(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MajorationCrudMainScreen(),
                              ),
                            );
                          },
                          image: 'images/imgCalcul.png',
                          text: 'Majorations',
                        ),
                      ),
                      Flexible(
                        child: CrudButton(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LevelCrudMainScreen(),
                              ),
                            );
                          },
                          image: 'images/level-2.png',
                          text: 'Niveaux',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
