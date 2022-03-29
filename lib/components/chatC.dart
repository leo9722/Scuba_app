import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

/*
* Component chatC
*
* Composant utilisé pour l'affichage du graphique-résultats calculs
*
* */
class _LineChart extends StatelessWidget {
  const _LineChart({required this.isShowingMainData, required this.points, required this.deep});

  final List<FlSpot> points;
  final int deep;
  final bool isShowingMainData;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      isShowingMainData ? charData1 : charData1,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  //Structure du graphique, ordonnées / abscisses
  LineChartData get charData1 => LineChartData(
    lineTouchData: lineTouchData1,
    gridData: gridData,
    titlesData: titlesData1,
    borderData: borderData,
    lineBarsData: lineBarsData1,
    minX: 0,
    maxX: 50,
    maxY: 5,
    minY: -deep.toDouble() - 3,
  );

  //Propriétés du graphique
  LineTouchData get lineTouchData1 => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
    ),
  );

  //Données sur l'axe des ordonnées
  //Représente la profondeur
  FlTitlesData get titlesData1 => FlTitlesData(
    rightTitles: SideTitles(showTitles: false),
    topTitles: SideTitles(showTitles: false),
    bottomTitles: SideTitles(showTitles: false),
    leftTitles: leftTitles(
      getTitles: (value) {
        switch (value.toInt()) {
          case 0:
            return '0';
          case -3:
            return '3';
          case -6:
            return '6';
          case -9:
            return '9';
          case -12:
            return '12';
          case -15:
            return '15';
          case -40:
            return '40';
          case -50:
            return '50';
          case -60:
            return '60';
        }
        return '';
      },
    ),
  );

  List<LineChartBarData> get lineBarsData1 => [
    lineChartBarData2_3,
  ];

  //Style des données de l'ordonnée
  SideTitles leftTitles({required GetTitleFunction getTitles}) => SideTitles(
    getTitles: getTitles,
    showTitles: true,
    margin: 15,
    interval: 1,
    reservedSize: 40,
    getTextStyles: (context, value) => const TextStyle(
      color: kDarkBlueTextColor,
      fontSize: 14,
    ),
  );


  //Grille de fond et bordures
  FlGridData get gridData => FlGridData(show: true);
  FlBorderData get borderData => FlBorderData(
    show: true,
    border: const Border(
      bottom: BorderSide(color: Color(0xff4e4965), width: 4),
      left: BorderSide(color: Color(0xff4e4965), width: 3),
      right: BorderSide(color: Colors.transparent),
      top: BorderSide(color: Colors.transparent),
    ),
  );


  //Style de la courbe
  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
    colors: const [Color(0xAAFF0000)],
    barWidth: 3,
    isStrokeCapRound: true,
    dotData: FlDotData(show: true),
    belowBarData: BarAreaData(show: true),
    spots: points,
  );
  LineChartBarData get lineChartBarData2_3 => LineChartBarData(
    isCurved: false,
    curveSmoothness: 0,
    colors: const [Color(0xAAFF0000)],
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(show: true),
    spots: points,
  );
}

class ChartC extends StatefulWidget {
  const ChartC({Key? key, required this.points, required this.deep}) : super(key: key);

  final List<FlSpot> points;
  final int deep;

  @override
  State<StatefulWidget> createState() => ChartCState();
}

class ChartCState extends State<ChartC> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.15,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          gradient: LinearGradient(
            colors: [
              Color(0xffabf4ff),
              Color(0xff00a9ae),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: _LineChart(isShowingMainData: isShowingMainData, deep: widget.deep, points: widget.points,),
                  ),
                  const SizedBox(
                    height: 15,
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
