import 'package:flutter/material.dart';
import 'package:scuba/components/divingTableC.dart';
import 'package:scuba/model/dataClasses.dart';

/*
* Component ListDivingTableC
*
* Composant utilisé pour l'affichage des tables de plongées
* Utilise le composant affichant une table, et liste les données
*
* */
class ListDivingTableC extends StatelessWidget {
  const ListDivingTableC({Key? key, required this.deepTimes}) : super(key: key);

  final List<DeepTime> deepTimes;

  /*
  * Récupération des tables de plongées
  * et insertion de ces tables dans une liste qui
  * sera affichée à l'écran
  */
  List<Widget> getTables() {
    List<Widget> tables = [];

    for (var deepTime in deepTimes) {
      tables.add(
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0.0, bottom: 15.0, right: 10.0, top: 15.0),
              child: DivingTableC(times: deepTime.times, deep: deepTime.deep.deep),
            ),
          ],
        ),
      );
    }

    return tables;
  }

  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Scrollbar(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: getTables(),
          )
        ),
    );
  }
}
