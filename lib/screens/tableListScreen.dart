import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:scuba/components/headerC.dart';
import 'package:scuba/components/listDivingTableC.dart';
import 'package:scuba/model/DeepBrain.dart';
import 'package:scuba/model/DivingTableBrain.dart';
import 'package:scuba/model/TimeBrain.dart';
import 'package:scuba/model/dataClasses.dart';

/*
* Classe TableListScreen
*
* Permet la visualisation des tables de plongées
*
* */
class TableListScreen extends StatefulWidget {
  const TableListScreen({
    Key? key,
  }) : super(key: key);

  @override
  _TableListScreen createState() => _TableListScreen();
}

class _TableListScreen extends State<TableListScreen> {

  //Initialisation de listes vides
  List<DeepTime> deepTimes = [];
  List<DivingTable> tables = [];

  DivingTable selectedTable = DivingTable(name: "MN90", id: 0);

  //Récupération des items pour le cupertino
  List<Widget> getItems() {
    List<Widget> pickerItems = [];

    for (DivingTable table in tables) {
      pickerItems.add(
        Align(
          child: Text(
            table.name,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          alignment: Alignment.center,
        ),
      );
    }

    return pickerItems;
  }

  //Récupération de chaque temps en fonction de chaque profondeurs
  //Si le nombre de temps est > à 12, on divise la table en deux, ou en trois
  Future<void> getDeepTimes() async {
    List<Deep> deeps = [];
    deepTimes = [];

    deeps = await DeepBrain().listDeepByTable(selectedTable.id);

    for (Deep deep in deeps) {
      List<Time> times = await TimeBrain().listTimeByDeep(deep.id);
      if (times.length > 12) {
        //Segmentation des tables en 3
        List<Time> t1 = [];
        List<Time> t2 = [];
        List<Time> t3 = [];

        for (int i = 0; i < times.length ~/ 3; i++) {
          t1.add(times[i]);
        }

        for (int i = times.length ~/ 3; i < times.length / 1.5; i++) {
          t2.add(times[i]);
        }

        for (int i = times.length ~/ 1.5; i < times.length; i++) {
          t3.add(times[i]);
        }

        deepTimes.add(DeepTime(deep: deep, times: t1));
        deepTimes.add(DeepTime(deep: deep, times: t2));
        deepTimes.add(DeepTime(deep: deep, times: t3));
      }
      //Segmentation des tables en 2
      else if (times.length > 7) {
        List<Time> t1 = [];
        List<Time> t2 = [];

        for (int i = 0; i < times.length ~/ 2; i++) {
          t1.add(times[i]);
        }

        for (int i = times.length ~/ 2; i < times.length; i++) {
          t2.add(times[i]);
        }

        deepTimes.add(DeepTime(deep: deep, times: t1));
        deepTimes.add(DeepTime(deep: deep, times: t2));
      } else {
        deepTimes.add(DeepTime(deep: deep, times: times));
      }
    }
    setState(() {
      deepTimes;
      print(deepTimes.length);
    });
  }

  //Récupération des tables
  void getTables() async {
    tables = await DivingTableBrain().listDivingTable();
    setState(() {
      tables;
    });
  }

  @override
  void initState() {
    super.initState();
    getTables();
    getDeepTimes();
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
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF32a5ff),
            Color(0xFF334ac9),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Flexible(
              flex: 3,
              child: HeaderC(text: "Tables de plongée"),
            ),
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, bottom: 5.0, left: 50.0, right: 50.0),
                child: CupertinoPicker(
                  itemExtent: 35.0,
                  looping: true,
                  onSelectedItemChanged: (selectedIndex) {
                    setState(() {
                      deepTimes = [];
                      selectedTable = tables[selectedIndex];
                      getDeepTimes();
                    });
                  },
                  children: getItems(),
                ),
              ),
            ),
            Expanded(
              flex: 12,
              child: deepTimes.isNotEmpty
                  ? ListDivingTableC(
                      deepTimes: deepTimes,
                    )
                  : const Center(
                      child: Text(
                        "Aucune donnée pour cette table",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
            const Spacer(
              flex: 3,
            )
          ],
        ),
      ),
    );
  }
}
