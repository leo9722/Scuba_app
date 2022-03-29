import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:im_stepper/stepper.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:scuba/components/headerC.dart';
import 'package:scuba/constants.dart';
import 'package:scuba/screens/startScreen.dart';

/*
* Classe TutorialScreen
*
* Permet l'affichage de l'écran de tutoriel
* pour le premier démarrage de l'application
* et avec possibilité de revenir
*
* */
class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  _TutorialScreen createState() => _TutorialScreen();
}

class _TutorialScreen extends State<TutorialScreen> {

  //Première étape // Nb étapes
  int activeStep = 0;
  int upperBound = 6;

  //Liste vide pour stocker nos pages de tutoriel
  List<Widget> steps = [];

  //Récupération des pages de tutoriel
  void getWidgets() {

    //Responsive, changement de
    //taille de police si taille écran
    //plus petit que 400 pixels
    double fontSize = 23.0;
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    if(queryData.size.width < 400){
      fontSize = 15.0;
    }

    //Liste des pages, incluant les textes
    List<Widget> stepWidgets = [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "\n\nCette application consiste principalement à réaliser des calculs de plongée.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: fontSize,
              ),
            ),
            const Text("\n\n"),
            Text(
              "Vous pourrez gérer des profils de plongée, effectuer des calculs avec deux modes différents, visualiser les tables de plongée, et administrer les données.\n\n",
              style: TextStyle(
                color: Colors.white70,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "\n\nL'application dispose d'un profil par défaut. Vous pouvez administrer de manière complète les profils.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: fontSize,
              ),
            ),
            const Text("\n\n"),
            Text(
              " Les profils serviront à effectuer les calculs. Il y aura toujours au moins un profil de disponible.\n\n",
              style: TextStyle(
                color: Colors.white70,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "\n\nLe mode calcul simple permet de réaliser des calculs de plongée en fonction d'un temps, d'une profondeur et d'un profil.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: fontSize,
              ),
            ),
            const Text("\n\n"),
            Text(
              "Après résultats, vous aurez la possibilité de faire une plongée successive. Tous les calculs sont enregistrés dans la partie historique pour un profil.\n\n",
              style: TextStyle(
                color: Colors.white70,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "\n\nLe mode simulation permet la vérification de résultats calculés par un utilisateur.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: fontSize,
              ),
            ),
            const Text("\n\n"),
            Text(
              "L'application indiquera les champs là où les données entrées sont fausses.\n\n",
              style: TextStyle(
                color: Colors.white70,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "\n\nL'application permet la visualisation des tables de plongées. Par défaut, ce sont les tables de plongée MN90 qui sont affichées.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: fontSize,
              ),
            ),
            const Text("\n\n\n\n"),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "\n\nScuba Diving propose également une interface de gestion des données.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: fontSize,
              ),
            ),
            const Text("\n\n"),
            Text(
              "Vous avez la possibilité de créer, modifier, et supprimer des données.\n\n",
              style: TextStyle(
                color: Colors.white70,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "\n\nVous pourrez revenir à tout moment vers ce tutoriel depuis la page d'accueil, grâce à l'icone information situé à droite du titre.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: fontSize,
              ),
            ),
            const Text("\n\n\n\n"),

          ],
        ),
      ),
    ];

    setState(() {
      steps = stepWidgets;
    });

  }

  //Initialisation de la page et récupération des textes
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      getWidgets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.white,
      ),
      child: ScaffoldGradientBackground(
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
          children: [
            const Flexible(
              flex: 3,
              child: HeaderC(text: "Tutoriel"),
            ),
            Flexible(
              flex: 17,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 20.0, right: 20.0, bottom: 8.0),
                child: Column(
                  children: [
                    IconStepper(
                      nextButtonIcon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 30,
                      ),
                      previousButtonIcon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 30,
                      ),
                      activeStepColor: Colors.white,
                      icons: const [
                        Icon(Icons.supervised_user_circle),
                        Icon(Icons.flag),
                        Icon(Icons.access_alarm),
                        Icon(Icons.supervised_user_circle),
                        Icon(Icons.access_alarm),
                        Icon(Icons.supervised_user_circle),
                        Icon(Icons.supervised_user_circle),
                      ],
                      // activeStep property set to activeStep variable defined above.
                      activeStep: activeStep,
                      // This ensures step-tapping updates the activeStep.
                      onStepReached: (index) {
                        setState(() {
                          activeStep = index;
                        });
                      },
                    ),
                    header(),
                    steps[activeStep],
                    skipButton(activeStep),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Bouton skip
  Widget skipButton(int activeStep) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: kDarkBlueTextColor,
        padding: const EdgeInsets.all(15.0),
        textStyle: const TextStyle(fontSize: 20),
      ),
      onPressed: () {
        // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const StartScreen(),
          ),
        );
      },
      child: Text(activeStep < 6 ? 'Passer le tutoriel' : 'Poursuivre'),
    );
  }

  //Header, informations sur l'étape actuelle
  Widget header() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                headerText(),
                style: const TextStyle(
                    color: kDarkBlueTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Texte header sur l'étape actuelle
  String headerText() {
    switch (activeStep) {
      case 0:
        return 'Introduction';

      case 1:
        return 'Profil';

      case 2:
        return 'Mode calcul';

      case 3:
        return 'Mode simulation';

      case 4:
        return 'Tables';

      case 5:
        return 'Administration';

      case 6:
        return 'Ready to dive';

      default:
        return 'Introduction';
    }
  }
}
