import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:scuba/components/chatC.dart';
import 'package:scuba/components/headerC.dart';
import 'package:scuba/model/AzoteBrain.dart';
import 'package:scuba/model/DivingBrain.dart';
import 'package:scuba/model/DivingTableBrain.dart';
import 'package:scuba/model/GroupBrain.dart';
import 'package:scuba/model/IntervalleBrain.dart';
import 'package:scuba/model/SecondDeepBrain.dart';
import 'package:scuba/model/TimeBrain.dart';
import 'package:scuba/model/calculator.dart';
import 'package:scuba/model/dataClasses.dart';
import 'package:accordion/accordion.dart';
import '../constants.dart';
import 'calculScreen.dart';

/*
* Classe ResultSuccessiveScreen
*
* Permet le calcul et la visualisation des résultats
* après un calcul de plongée successive
*
* */

class ResultSuccessiveScreen extends StatefulWidget {
    const ResultSuccessiveScreen(
      {Key? key,
        required this.chosenProfile,
        required this.dTime,
        required this.deep,
        required this.group,
        required this.itTime,
        required this.table
      })
      : super(key: key);

  final Profile chosenProfile;
  final int dTime;
  final int deep;
  final String table;
  final String group;
  final int itTime;

  @override
  State<ResultSuccessiveScreen> createState() => _ResultSuccessiveScreenState();
}

class _ResultSuccessiveScreenState extends State<ResultSuccessiveScreen> {

  //Initialisation des données
  Time time = Time(time: 0, p15: 0, p12: 0, p9: 0, p6: 0, p3: 0, azoteGroup: "0", deepId: 0,);
  double tempsTotal = 0;
  DivingTable table = DivingTable(name: "");
  late DivingResults divingResults;
  bool enabled = true;
  List<AccordionSection> accordionList = [];
  Deep fDeep = Deep(deep: 0, divingTableId: 0);

  //Sauvegarde d'une plongée dans l'historique
  Future<void> saveDiving(SecondDeep deep) async {

    await _calculation;
    final divingDate = DateTime.now();
    double divingTime = divingResults.totalTime;
    double downTime = divingResults.infoDiving[1].time;
    double upTime = divingTime - divingResults.infoDiving[2].totalTime;
    int profileId = widget.chosenProfile.id;
    int deepId = deep.id;

    //print("Diving time : " + divingTime.toString() + " Down time : " + downTime.toString() + " Plongee : " + divingResults.infoDiving[2].totalTime.toString());
    Diving diving = Diving(divingDate: divingDate.toString(), divingTime: divingTime, downTime: downTime, upTime: upTime, profileId: profileId, deepId: deepId);

    await DivingBrain().insertDiving(diving);
    //print("Diving saved");

  }

  //Formatage des minutes en heure:minutes
  List<double> getHourFormat(double time) {
    return [(time / 60).floorToDouble(), time % 60];
  }

  //Récupération de la table sélectionnée
  Future<void> getTable() async {

    table = await DivingTableBrain().listDivingTableByName(widget.table);

  }

  //Récupération d'un azote existant
  Future<Azote> getNextAzote(double iAzote) async {

    //print("Get next azote");
    //print("Azote : " + iAzote.toString());

    List<Azote> azotes = await AzoteBrain().listAzote();

    Azote fAzote = Azote(azote: 0.0, id: 1);

    for(Azote azote in azotes){

      if(iAzote != azote.azote && iAzote < azote.azote){
        fAzote = azote;
        //print("Azote found : " + azote.toMap().toString());
        return azote;
      }

      if(iAzote == azote.azote){
        //print("Azote found : " + azote.toMap().toString());
        return azote;
      }

    }

    //print("Azote found : " + fAzote.toMap().toString());
    return fAzote;

  }

  //Récupération d'une profondeur existante
  Future<SecondDeep> getNextDeep(int iDeep, DivingTable divingTable) async {

    //print("Get next deep");
    getTable();
    //print("Diving table : " + divingTable.toMap().toString());

    List<SecondDeep> secondDeeps = await SecondDeepBrain().listSecondDeep();

    //print("Deeps : " + secondDeeps.length.toString());

    SecondDeep fDeep = SecondDeep(deep: 0, time: 0, azoteId: 0);

    for(SecondDeep deep in secondDeeps){

      if(iDeep != deep.deep && iDeep < deep.deep){
        fDeep = deep;
        //print("Deep found : " + deep.toMap().toString());
        return deep;
      }

      if(iDeep == deep.deep){
        //print("Deep found : " + deep.toMap().toString());
        return deep;
      }

    }

    //print("Deep found : " + fDeep.toMap().toString());
    return fDeep;

  }

  //Récupération d'un temps existant
  Future<Time> getNextTime(int iTime, SecondDeep deep) async {

    List<Time> times = await TimeBrain().listTimeByDeep(deep.id);
    Time fTime = Time(time: 0, p15: 0, p12: 0, p9: 0, p6: 0, p3: 0, azoteGroup: '0', deepId: 0,);

    for(Time time in times){

      if(iTime != time.time && iTime < time.time){
        fTime = time;
        //print("Time found : " + time.toMap().toString());
        return time;
      }

      if(iTime == time.time){
        //print("Time found : " + time.toMap().toString());
        return time;
      }

    }
    //print("Time found : " + fTime.toMap().toString());
    return fTime;

  }

  //Récupération des panels, avec les données de la plongée
  List<Widget> getPanelItems(){

    List<Widget> exp = [];

    // for(DivingInfo d in divingResults.infoDiving){
    //   print(d.toMap());
    // }

    /*
    * Pour chaque item, on va récupérer le temps (formaté), la pression et le volume
    * On va également changer, en fonction de la pression / détendeur, la couleur de l'en-tête
    *
    * */

    DivingInfo finalInfo = divingResults.infoDiving.last;
    //DivingInfo initialInfo = divingResults.infoDiving.first;
    DivingInfo down = divingResults.infoDiving[1];
    DivingInfo diving = divingResults.infoDiving[2];
    DivingInfo first = divingResults.infoDiving[3];

    List<double> hoursFormat = getHourFormat(finalInfo.totalTime);

    //print(finalInfo.toMap().toString());
    Color bgColor = const Color(0x44ffffff);

    finalInfo.breath ? bgColor = const Color(0x44ffffff) : bgColor = const Color(0xaaff0000);

    //Info globale plongée
    exp.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: ExpansionTile(
          collapsedBackgroundColor: bgColor,
          backgroundColor: Colors.white,
          initiallyExpanded: true,
          textColor: kDarkBlueTextColor,
          collapsedIconColor: Colors.white,
          collapsedTextColor: Colors.white,
          childrenPadding: const EdgeInsets.all(8.0),
          title: const Text(
            'Informations générales',
            style: TextStyle(fontSize: 17),
          ),
          children: <Widget> [
            Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Temps total : ',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextSpan(
                      text: '${hoursFormat[0].toInt()}h ${hoursFormat[1].toStringAsFixed(2)} min',
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
                      text: 'Volume restant : ',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextSpan(
                      text: '${finalInfo.volumeLeft.toStringAsFixed(2)} litres',
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
                      text: "Pression restante : ",
                      style: TextStyle(fontSize: 16),
                    ),
                    TextSpan(
                      text: '${finalInfo.pressureLeft.toStringAsFixed(2)} bars',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        ),
      ),
    );

    down.breath ? bgColor = const Color(0xaaffffff) : bgColor = const Color(0xaaff0000);
    //Descente
    hoursFormat = getHourFormat(down.time);
      exp.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: ExpansionTile(
          collapsedBackgroundColor: bgColor,
          backgroundColor: Colors.white,
          initiallyExpanded: false,
          textColor: kDarkBlueTextColor,
          collapsedIconColor: Colors.white,
          collapsedTextColor: Colors.white,
          childrenPadding: const EdgeInsets.all(8.0),
          title: Text(
            'Descente 0m -> ${down.currentDeep}m',
            style: const TextStyle(fontSize: 17),
          ),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'Temps de descente : ',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextSpan(
                        text: '${hoursFormat[0].toInt()}h ${hoursFormat[1].toStringAsFixed(2)} min',
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
                        text: 'Volume restant : ',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextSpan(
                        text: '${down.volumeLeft.toStringAsFixed(2)} litres',
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
                        text: "Pression restante : ",
                        style: TextStyle(fontSize: 16),
                      ),
                      TextSpan(
                        text: '${down.pressureLeft.toStringAsFixed(2)} bars',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
    ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );

    //Au fond
    diving.breath ? bgColor = const Color(0xaaffffff) : bgColor = const Color(0xaaff0000);

    hoursFormat = getHourFormat(diving.time);
    exp.add(
     Padding(
       padding: const EdgeInsets.only(bottom: 5.0),
       child: ExpansionTile(
         collapsedBackgroundColor: bgColor,
         backgroundColor: Colors.white,
         initiallyExpanded: false,
         textColor: kDarkBlueTextColor,
         collapsedIconColor: Colors.white,
         collapsedTextColor: Colors.white,
         childrenPadding: const EdgeInsets.all(8.0),
           title :Text(
             'Plongée à ${diving.currentDeep} m',
             style: const TextStyle(fontSize: 17),
           ),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'Temps de plongée : ',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextSpan(
                        text: '${hoursFormat[0].toInt()}h ${hoursFormat[1].toStringAsFixed(2)} min',
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
                        text: 'Volume restant : ',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextSpan(
                        text: '${diving.volumeLeft.toStringAsFixed(2)} litres',
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
                        text: "Pression restante : ",
                        style: TextStyle(fontSize: 16),
                      ),
                      TextSpan(
                        text: '${diving.pressureConso.toStringAsFixed(2)} bars',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
     ),
    );

    //Remontée 1er palier
    first.breath ? bgColor = const Color(0xaaffffff) : bgColor = const Color(0xaaff0000);

    hoursFormat = getHourFormat(first.time);
    exp.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: ExpansionTile(
          collapsedBackgroundColor: bgColor,
          backgroundColor: Colors.white,
          initiallyExpanded: false,
          textColor: kDarkBlueTextColor,
          collapsedIconColor: Colors.white,
          collapsedTextColor: Colors.white,
          childrenPadding: const EdgeInsets.all(8.0),
          title: const Text(
            "Remontée jusqu'au premier palier",
            style: TextStyle(fontSize: 17),
          ),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'Temps de remontée : ',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextSpan(
                        text: '${hoursFormat[0].toInt()}h ${hoursFormat[1].toStringAsFixed(2)} min',
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
                        text: 'Volume restant : ',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextSpan(
                        text: '${first.volumeLeft.toStringAsFixed(2)} litres',
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
                        text: "Pression restante : ",
                        style: TextStyle(fontSize: 16),
                      ),
                      TextSpan(
                        text: '${first.pressureLeft.toStringAsFixed(2)} bars',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    //Paliers
    for (int i = 0; i < divingResults.infoPaliers.length; i++) {
      if (i.isOdd && divingResults.infoPaliers[i].time != -1) {
        hoursFormat = getHourFormat(divingResults.infoPaliers[i].time);
        divingResults.infoPaliers[i].breath ? bgColor = const Color(0xaaffffff) : bgColor = const Color(0xaaff0000);

        exp.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: ExpansionTile(
              collapsedBackgroundColor: bgColor,
              backgroundColor: Colors.white,
              initiallyExpanded: false,
              textColor: kDarkBlueTextColor,
              collapsedIconColor: Colors.white,
              collapsedTextColor: Colors.white,
              childrenPadding: const EdgeInsets.all(8.0),
             title: Text(
               'Remontée ${divingResults.infoPaliers[i].currentDeep}m -> ${divingResults.infoPaliers[i + 1].currentDeep}m',
               style: const TextStyle(fontSize: 17),
             ),
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          const TextSpan(
                            text: 'Temps total : ',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextSpan(
                            text: '${hoursFormat[0].toInt()}h ${hoursFormat[1].toStringAsFixed(2)} min',
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
                            text: 'Volume restant : ',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextSpan(
                            text:
                            '${divingResults.infoPaliers[i].volumeLeft.toStringAsFixed(2)} litres',
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
                            text: "Pression restante : ",
                            style: TextStyle(fontSize: 16),
                          ),
                          TextSpan(
                            text:
                            '${divingResults.infoPaliers[i].pressureLeft.toStringAsFixed(2)} bars',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      } else if (divingResults.infoPaliers[i].time != -1) {
        hoursFormat = getHourFormat(divingResults.infoPaliers[i].time);
        divingResults.infoPaliers[i].breath ? bgColor = const Color(0xaaffffff) : bgColor = const Color(0xaaff0000);

        exp.add(
         Padding(
           padding: const EdgeInsets.only(bottom: 5.0),
           child: ExpansionTile(
             collapsedBackgroundColor: bgColor,
             backgroundColor: Colors.white,
             initiallyExpanded: false,
             textColor: kDarkBlueTextColor,
             collapsedIconColor: Colors.white,
             collapsedTextColor: Colors.white,
             childrenPadding: const EdgeInsets.all(8.0),
             title: Text(
             'Palier à ${divingResults.infoPaliers[i].currentDeep}m',
             style: const TextStyle(fontSize: 17),
           ),
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          const TextSpan(
                            text: 'Temps total : ',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextSpan(
                            text: '${hoursFormat[0].toInt()}h ${hoursFormat[1].toStringAsFixed(2)} min',
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
                            text: 'Volume restant : ',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextSpan(
                            text:
                            '${divingResults.infoPaliers[i].volumeLeft.toStringAsFixed(2)} litres',
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
                            text: "Pression restante : ",
                            style: TextStyle(fontSize: 16),
                          ),
                          TextSpan(
                            text:
                            '${divingResults.infoPaliers[i].pressureLeft.toStringAsFixed(2)} bars',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
         ),
        );
      }

      //print(divingResults.infoPaliers[i].toMap());
    }

    //print("Get accordion");

    return exp;

  }

  //Récupération des résultats des calculs
  Future<void> getData() async {

    DivingTable divingTable = await DivingTableBrain().listDivingTableByName(widget.table);
    SecondDeep deep = await getNextDeep(widget.deep, divingTable);
    Group group = await GroupBrain().listGroupByGroup(widget.group);
    Intervalle intervalle = await IntervalleBrain().listIntervalleByGroupAndTime(group.id, widget.itTime);
    Azote azote = await getNextAzote(intervalle.coefficient);
    SecondDeep secondDeep = await SecondDeepBrain().listSecondDeepByAzoteAndDeep(azote.id, deep.deep);

    // print("Intervalle : " + intervalle.toMap().toString());
    // print("Group : " + group.toMap().toString());
    // print("Second deep : " + secondDeep.toMap().toString());

    Calculator calculator = Calculator();

    int finalTime = widget.dTime + secondDeep.time;

    Time tTime = await getNextTime(finalTime, deep);

    divingResults = calculator.divingCalculator(deep.deep, tTime, widget.chosenProfile);

    getPoints(time, widget.deep.toDouble(), tempsTotal);
    //getAccordion(context);

    saveDiving(deep);

    setState(() {
      tempsTotal = divingResults.totalTime;
      time = tTime;
    });

  }

  //Récupération des points pour le graphique
  List<FlSpot> getPoints(Time time, double deep, double totalTime) {
    List<FlSpot> points = [];

    //X : 0 -> 50
    //Y : 0 -> deep

    //Profondeur
    points.add(const FlSpot(0, 0));
    points.add(FlSpot(2, -deep));
    points.add(FlSpot(time.time * 50 / totalTime, -deep));

    //Pour chaque palier, on calcul un coefficient proportionnel correspondant à l'abscisse d'un point

    //Palier 15
    if (time.p15 != 0) {
      points.add(
          FlSpot((time.time * 50 / totalTime) + (5 * 50 / totalTime), -15));
      points.add(FlSpot(
          (5 * 50 / totalTime) +
              (time.time * 50 / totalTime) +
              (time.p15 * 50 / totalTime),
          -15));
    }

    //Palier 12
    if (time.p12 != 0) {
      points.add(FlSpot(
          (time.time * 50 / totalTime) +
              (5 * 50 / totalTime) +
              (time.p15 * 50 / totalTime),
          -12));
      points.add(FlSpot(
          (5 * 50 / totalTime) +
              (time.time * 50 / totalTime) +
              (time.p12 * 50 / totalTime) +
              (time.p15 * 50 / totalTime),
          -12));
    }
    //
    //Palier 9
    if (time.p9 != 0) {
      points.add(FlSpot(
          (time.time * 50 / totalTime) +
              (5 * 50 / totalTime) +
              (time.p12 * 50 / totalTime) +
              (time.p15 * 50 / totalTime),
          -9));
      points.add(FlSpot(
          (5 * 50 / totalTime) +
              (time.time * 50 / totalTime) +
              (time.p9 * 50 / totalTime) +
              (time.p12 * 50 / totalTime) +
              (time.p15 * 50 / totalTime),
          -9));
    }

    //Palier 6
    if (time.p6 != 0) {
      points.add(FlSpot(
          (time.time * 50 / totalTime) +
              (5 * 50 / totalTime) +
              (time.p12 * 50 / totalTime) +
              (time.p15 * 50 / totalTime) +
              (time.p9 * 50 / totalTime),
          -6));
      points.add(FlSpot(
          (5 * 50 / totalTime) +
              (time.time * 50 / totalTime) +
              (time.p6 * 50 / totalTime) +
              (time.p12 * 50 / totalTime) +
              (time.p15 * 50 / totalTime) +
              (time.p9 * 50 / totalTime),
          -6));
    }

    //Palier 3
    if (time.p3 != 0) {
      points.add(FlSpot(
          (time.time * 50 / totalTime) +
              (5 * 50 / totalTime) +
              (time.p12 * 50 / totalTime) +
              (time.p15 * 50 / totalTime) +
              (time.p9 * 50 / totalTime) +
              (time.p6 * 50 / totalTime),
          -3));

      if ((5 * 50 / totalTime) +
          (time.time * 50 / totalTime) +
          (time.p3 * 50 / totalTime) +
          (time.p12 * 50 / totalTime) +
          (time.p15 * 50 / totalTime) +
          (time.p9 * 50 / totalTime) +
          (time.p6 * 50 / totalTime) >
          49) {
        if ((time.time * 50 / totalTime) +
            (5 * 50 / totalTime) +
            (time.p12 * 50 / totalTime) +
            (time.p15 * 50 / totalTime) +
            (time.p9 * 50 / totalTime) +
            (time.p6 * 50 / totalTime) >
            49) {
          points.add(FlSpot(
              (5 * 50 / totalTime) +
                  (time.time * 50 / totalTime) +
                  (time.p3 * 50 / totalTime) +
                  (time.p12 * 50 / totalTime) +
                  (time.p15 * 50 / totalTime) +
                  (time.p9 * 50 / totalTime) +
                  (time.p6 * 50 / totalTime) -
                  1,
              -3));
        } else {
          points.add(FlSpot(
              (5 * 50 / totalTime) +
                  (time.time * 50 / totalTime) +
                  (time.p3 * 50 / totalTime) +
                  (time.p12 * 50 / totalTime) +
                  (time.p15 * 50 / totalTime) +
                  (time.p9 * 50 / totalTime) +
                  (time.p6 * 50 / totalTime) -
                  3,
              -3));
        }
      } else {
        points.add(FlSpot(
            (5 * 50 / totalTime) +
                (time.time * 50 / totalTime) +
                (time.p3 * 50 / totalTime) +
                (time.p12 * 50 / totalTime) +
                (time.p15 * 50 / totalTime) +
                (time.p9 * 50 / totalTime) +
                (time.p6 * 50 / totalTime),
            -3));
      }
    }

    //Last point
    points.add(const FlSpot(50, 0));

    // print("Points : " + points.length.toString());
    // for (var point in points) {
    //   print("X : " + point.x.toString() + " Y : " + point.y.toString());
    // }

    return points;
  }

  //Fonction d'attente de 2 secondes, pour le chargement des données
  final Future<String> _calculation =
  Future<String>.delayed(const Duration(seconds: 2), () async {
    return "Data loaded";
  });

  //Initialisation de la page et récupération des résultats
  @override
  void initState() {
    super.initState();
    getData();
  }

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
      body: FutureBuilder(
        future: _calculation,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Flexible(
                  child: HeaderC(
                    text: "Résultats du calcul",
                  ),
                  flex: 3,
                ),
                Flexible(
                  flex: 7,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: ChartC(
                        points:
                        getPoints(time, widget.deep.toDouble(), tempsTotal),
                        deep: widget.deep,
                      )),
                ),
                const Spacer(
                  flex: 1,
                ),
                Flexible(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 25.0, left: 25.0),
                    child: ListView(
                      children: getPanelItems(),
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
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
                            return enabled
                                ? kLightPurpleButtonColor
                                : kLightGrayTextColor;
                          },
                        ),
                      ),
                      onPressed: () {
                        if (enabled) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CalculScreen(),
                            ),
                          );
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(
                          bottom: 20,
                          right: 25,
                          left: 25,
                          top: 20,
                        ),
                        child: Text(
                          "Refaire un calcul",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
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
    );
  }
}


