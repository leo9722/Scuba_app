import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:scuba/components/headerC.dart';
import 'package:intl/intl.dart';
import 'package:scuba/model/DeepBrain.dart';
import 'package:scuba/model/DivingBrain.dart';
import 'package:scuba/model/dataClasses.dart';

/*
* Classe ProfileHistory
*
* Permet la visualisation d'un historique
*
* */

class ProfileHistoryScreen extends StatefulWidget {
  const ProfileHistoryScreen({Key? key, required this.selectedProfile})
      : super(key: key);

  final Profile selectedProfile;

  @override
  State<ProfileHistoryScreen> createState() => _ProfileHistoryScreenState();
}

class _ProfileHistoryScreenState extends State<ProfileHistoryScreen> {

  //Initialisation des données, vides
  List<Diving> divings = [];
  List<Deep> deeps = [];
  Profile selectedProfile = Profile(
      speed: 0,
      consommation: 0,
      nbBottle: 0,
      name: "",
      vRap: 0,
      vRep: 0,
      volume: 0,
      pressure: 0,
      detendor: 0,
      selected: 0,
      levelId: 0);

  //Récupération de toutes les plongées pour un profil sélectionné
  Future<void> getDivings() async {
    List<Diving> dvgs =
        await DivingBrain().listDivingByProfile(selectedProfile.id);
    setState(() {
      divings = dvgs;
    });

    print(dvgs.length);

    for (Diving d in divings) {
      print(d.toMap());
    }
  }

  //Récupération des profondeurs
  Future<void> getDeeps() async {
    List<Deep> dps = await DeepBrain().listDeep();
    setState(() {
      deeps = dps;
    });
  }

  //Récupération des items (liste historique)
  List<Padding> getListViewItems() {
    //Liste de Widgets (ici, des paddings)
    List<Padding> items = [];

    //Pour chaque données, on va créer un widget et l'ajouter à la liste
    for (Diving d in divings) {
      Deep deep = deeps.firstWhere((element) => d.deepId == element.id);
      DateFormat dateDMY = DateFormat('dd-MM-yyyy');
      DateFormat dateHM = DateFormat('Hm');

      items.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          //GestureDetector qui prend en charge tout le widget
          child: GestureDetector(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Flexible(
                      flex: 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              "Plongée à ${deep.deep} mètres",
                              style: const TextStyle(
                                  color: Colors.blue, fontSize: 21),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                child: Text(
                                  "Date de plongée : ${dateDMY.format(DateTime.parse(d.divingDate))} à ${dateHM.format(DateTime.parse(d.divingDate))}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                child: Text(
                                  "Temps de plongée : ${d.divingTime.toStringAsFixed(2)} minutes",
                                  style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              FittedBox(
                                child: Text(
                                  "Descente : ${d.downTime.toStringAsFixed(2)} minutes | Remontée : ${d.upTime.toStringAsFixed(2)} minutes",
                                  style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const Spacer(),
                    Flexible(
                      child: GestureDetector(
                        child: const Icon(
                          Icons.delete,
                          size: 30,
                          color: Colors.red,
                        ),
                        onTap: () {
                          deleteDiving(d);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return items;
  }

  //Suppression d'une plongée
  Future<void> deleteDiving(Diving diving) async {
    await DivingBrain().deleteDiving(diving.id);
    getDivings();
  }

  //Initialisation de la page
  @override
  void initState() {
    super.initState();
    getDeeps();
    selectedProfile = widget.selectedProfile;
    getDivings();
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Flexible(
              flex: 3,
              child: HeaderC(text: "Historique profil"),
            ),
            const Flexible(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                child: Center(
                  child: Text(
                    "Historique de mes plongées",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 13,
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                child: Center(
                  child: divings.isEmpty
                      ? const Text(
                          "Aucun calcul n'a été réalisé pour ce profil",
                          style: TextStyle(color: Colors.white),
                        )
                      : ListView(
                          children: getListViewItems(),
                        ),
                ),
              ),
            ),
            const Spacer(
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}
