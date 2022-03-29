import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:scuba/components/headerC.dart';
import 'package:scuba/model/DeepBrain.dart';
import 'package:scuba/model/DivingTableBrain.dart';
import 'package:scuba/model/TimeBrain.dart';
import 'package:scuba/model/calculator.dart';
import 'package:scuba/model/dataClasses.dart';

import '../constants.dart';

/*
* Classe ResultSimulationScreen
*
* Permet le calcul et la visualisation des résultats
* d'une simulation
*
* */
class ResultSimulationScreen extends StatefulWidget {
  const ResultSimulationScreen(
      {Key? key,
      required this.dTime,
      required this.deep,
      required this.chosenProfile,
      required this.table,
      required this.p3,
      required this.p6,
      required this.p9,
      required this.p12,
      required this.p15,
      required this.pressureLeft,
      required this.volumeLeft})
      : super(key: key);

  final int dTime;
  final int deep;
  final Profile chosenProfile;
  final String table;
  final int p3;
  final int p6;
  final int p9;
  final int p12;
  final int p15;
  final double pressureLeft;
  final double volumeLeft;

  @override
  State<ResultSimulationScreen> createState() => _ResultSimulationScreenState();
}

class _ResultSimulationScreenState extends State<ResultSimulationScreen> {

  //Initialisation des données par défaut
  String imagePath = "images/check-mark.png";
  String resultString = "Résultats incorrects";
  Color resultColor = const Color(0xffc82536);
  List<CheckObject> checkObjects = [];
  DivingTable table = DivingTable(name: "");

  Time time = Time(
    time: 0,
    p15: 0,
    p12: 0,
    p9: 0,
    p6: 0,
    p3: 0,
    azoteGroup: "0",
    deepId: 0,
  );
  double tempsTotal = 0;
  String groupe = '';

  late DivingResults divingResults;
  bool resChange = true;

  //Récupération de la table sélectionnée
  Future<void> getTable() async {

    table = await DivingTableBrain().listDivingTableByName(widget.table);

  }

  //Attente le temps que les données chargent
  final Future<String> _calculation3 =
      Future<String>.delayed(const Duration(seconds: 3), () async {
    return "Data loaded";
  });

  //Récupération d'une profondeur existante
  Future<Deep> getNextDeep(int iDeep, DivingTable divingTable) async {
    //print("Get next deep");
    getTable();
    //print("Diving table : " + divingTable.toMap().toString());

    List<Deep> deeps = await DeepBrain().listDeepByTable(table.id);

    //print("Deeps : " + deeps.length.toString());

    Deep fDeep = Deep(deep: 0, divingTableId: 0);

    for (Deep deep in deeps) {
      if (iDeep != deep.deep && iDeep < deep.deep) {
        fDeep = deep;
        //print("Deep found : " + deep.toMap().toString());
        return deep;
      }

      if (iDeep == deep.deep) {
        //print("Deep found : " + deep.toMap().toString());
        return deep;
      }
    }

    //print("Deep found : " + fDeep.toMap().toString());
    return fDeep;
  }

  //Récupération d'un temps existant
  Future<Time> getNextTime(int iTime, Deep deep) async {
    List<Time> times = await TimeBrain().listTimeByDeep(deep.id);
    Time fTime = Time(
      time: 0,
      p15: 0,
      p12: 0,
      p9: 0,
      p6: 0,
      p3: 0,
      azoteGroup: '0',
      deepId: 0,
    );

    for (Time time in times) {
      if (iTime != time.time && iTime < time.time) {
        fTime = time;
        //print("Time found : " + time.toMap().toString());
        return time;
      }

      if (iTime == time.time) {
        //print("Time found : " + time.toMap().toString());
        return time;
      }
    }
    //print("Time found : " + fTime.toMap().toString());
    return fTime;
  }

  //Récupération des données, et calculs
  Future<void> getData() async {
    DivingTable divingTable =
        await DivingTableBrain().listDivingTableByName(widget.table);
    Deep deep = await getNextDeep(widget.deep, divingTable);
    Time tTime = await getNextTime(widget.dTime, deep);

    groupe = tTime.azoteGroup;
    Calculator calculator = Calculator();

    divingResults =
        calculator.divingCalculator(deep.deep, tTime, widget.chosenProfile);

    setState(() {
      tempsTotal = divingResults.totalTime;
      time = tTime;
    });

    await analyseData();
  }

  //Analyse des paliers
  //Quels paliers sont bons/mauvais
  Future<void> analysePaliers() async {
    widget.p3 == time.p3
        ? checkObjects
            .add(CheckObject(desc: "Palier 3", checked: true, short: "p3",userValue: widget.p3.toDouble(), realValue: time.p3.toDouble()))
        : checkObjects
            .add(CheckObject(desc: "Palier 3", checked: false, short: "p3",userValue: widget.p3.toDouble(), realValue: time.p3.toDouble()));
    widget.p6 == time.p6
        ? checkObjects
            .add(CheckObject(desc: "Palier 6", checked: true, short: "p6",userValue: widget.p6.toDouble(), realValue: time.p6.toDouble()))
        : checkObjects
            .add(CheckObject(desc: "Palier 6", checked: false, short: "p6",userValue: widget.p6.toDouble(), realValue: time.p6.toDouble()));
    widget.p9 == time.p9
        ? checkObjects
            .add(CheckObject(desc: "Palier 9", checked: true, short: "p9",userValue: widget.p9.toDouble(), realValue: time.p9.toDouble()))
        : checkObjects
            .add(CheckObject(desc: "Palier 9", checked: false, short: "p9",userValue: widget.p9.toDouble(), realValue: time.p9.toDouble()));
    widget.p12 == time.p12
        ? checkObjects
            .add(CheckObject(desc: "Palier 12", checked: true, short: "p12",userValue: widget.p12.toDouble(), realValue: time.p12.toDouble()))
        : checkObjects
            .add(CheckObject(desc: "Palier 12", checked: false, short: "p12",userValue: widget.p12.toDouble(), realValue: time.p12.toDouble()));
    widget.p15 == time.p15
        ? checkObjects
            .add(CheckObject(desc: "Palier 15", checked: true, short: "p15",userValue: widget.p15.toDouble(), realValue: time.p15.toDouble()))
        : checkObjects
            .add(CheckObject(desc: "Palier 15", checked: false, short: "p15",userValue: widget.p15.toDouble(), realValue: time.p15.toDouble()));
  }

  //Analyse de la pression et du volume
  Future<void> analyseVolumeAndPressure() async {
    widget.pressureLeft == divingResults.finalPressure
        ? checkObjects.add(
            CheckObject(desc: "Pression restante", checked: true, short: "p",userValue: widget.pressureLeft.toDouble(), realValue: divingResults.finalPressure.toDouble()))
        : checkObjects.add(
            CheckObject(desc: "Pression restante", checked: false, short: "p",userValue: widget.pressureLeft.toDouble(), realValue: divingResults.finalPressure.toDouble()));
    widget.volumeLeft == divingResults.finalVolume
        ? checkObjects
            .add(CheckObject(desc: "Volume restant", checked: true, short: "v",userValue: widget.volumeLeft.toDouble(), realValue: divingResults.finalVolume.toDouble()))
        : checkObjects.add(
            CheckObject(desc: "Volume restant", checked: false, short: "v",userValue: widget.volumeLeft.toDouble(), realValue: divingResults.finalVolume.toDouble()));
  }

  //Analyse des données
  Future<void> analyseData() async {
    //print("Analyse des données...");
    analysePaliers();
    analyseVolumeAndPressure();

    // print("Vol rest : " + divingResults.finalVolume.toString());
    // print("Press rest : " + divingResults.finalPressure.toString());

    for (CheckObject checkObject in checkObjects) {
      if(resChange == true && checkObject.checked) {
        checkObject.checked
            ? imagePath = "images/check-mark.png"
            : imagePath = "images/cancel.png";
        checkObject.checked
            ? resultString = "Résultats corrects"
            : resultString = "Résultats incorrects";
        checkObject.checked
            ? resultColor = const Color(0xFF8bff00)
            : resultColor = const Color(0xffc82536);
      } else {
        resChange = false;
        resultString = "Résultats incorrects";
        resultColor = const Color(0xffc82536);
        imagePath = "images/cancel.png";
      }

      //print(checkObject.toMap());
    }
  }

  //Récupération des items
  List<Widget> getPanelItems() {

    List<Widget> accordion = [];

    //Pour chaque item, affichage
    //avec mauvais et bon résultat
    for (CheckObject c in checkObjects) {
      if (c.checked == false) {
        accordion.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: ExpansionTile(
              collapsedBackgroundColor: const Color(0x44ffffff),
              backgroundColor: Colors.white,
              initiallyExpanded: false,
              textColor: kDarkBlueTextColor,
              collapsedIconColor: Colors.white,
              collapsedTextColor: Colors.white,
              title: Text(
                'Erreur sur ${c.desc}',
                style: const TextStyle(fontSize: 17),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            const TextSpan(
                              text: 'Valeur renseignée : ',
                              style: TextStyle(fontSize: 16),
                            ),
                            TextSpan(
                              text: '${c.userValue}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            const TextSpan(
                              text: 'Valeur correcte : ',
                              style: TextStyle(fontSize: 16),
                            ),
                            TextSpan(
                              text: '${c.realValue}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightGreenAccent),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    return accordion;
  }

  @override
  void initState() {
    super.initState();
    getData();
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
        body: FutureBuilder(
          future: _calculation3,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Flexible(
                    flex: 3,
                    child: HeaderC(text: "Résultats de la simulation"),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  Flexible(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            flex: 30,
                            child: Center(
                              child: Image.asset(imagePath),
                            ),
                          ),
                          const Spacer(
                            flex: 1,
                          ),
                          Flexible(
                            flex: 10,
                            child: Center(
                              child: Text(
                                resultString,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: resultColor,
                                    fontSize: 30),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  Flexible(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 25.0, left: 25.0),
                      child: ListView(
                        children: getPanelItems(),
                      ),
                    ),
                  ),
                  const Spacer(
                    flex: 1,
                  )
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
