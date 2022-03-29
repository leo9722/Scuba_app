import 'package:flutter/material.dart';
import 'package:scuba/constants.dart';
import 'package:scuba/model/dataClasses.dart';

/*
* Component DivingTableC
*
* Composant utilisé pour l'affichage d'une table de plongée
*
* */
class DivingTableC extends StatefulWidget {
  const DivingTableC({Key? key, this.deep = 0, required this.times})
      : super(key: key);

  final int deep;
  final List<Time> times;

  @override
  State<DivingTableC> createState() => _DivingTableCState();
}

class _DivingTableCState extends State<DivingTableC> {

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.black),
            top: BorderSide(width: 1, color: Colors.black),
            left: BorderSide(width: 1, color: Colors.black),
            right: BorderSide(width: 1, color: Colors.black),
          ),
          color: kDivingTableHeader),
      child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Profondeur : ${widget.deep} mètres",
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        DataTable(
          headingRowColor: MaterialStateProperty.resolveWith(
              (states) => kDivingTableRowHeader),
          columnSpacing: 10,
          border: const TableBorder(
            top: BorderSide(width: 1, color: Colors.black),
          ),
          dividerThickness: 1,
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Temps',
              ),
            ),
            DataColumn(
                label: VerticalDivider(
              color: Colors.black,
            )),
            DataColumn(
              label: Text(
                'P.15',
              ),
            ),
            DataColumn(
                label: VerticalDivider(
              color: Colors.black,
            )),
            DataColumn(
              label: Text(
                'P.12',
              ),
            ),
            DataColumn(
                label: VerticalDivider(
              color: Colors.black,
            )),
            DataColumn(
              label: Text(
                'P.9',
              ),
            ),
            DataColumn(
                label: VerticalDivider(
              color: Colors.black,
            )),
            DataColumn(
              label: Text(
                'P.6',
              ),
            ),
            DataColumn(
                label: VerticalDivider(
              color: Colors.black,
            )),
            DataColumn(
              label: Text(
                'P.3',
              ),
            ),
          ],
          rows: getRows(),
        ),
      ]),
    );
  }

  /*
  * Méthode pour récupérer les lignes
  * d'une table
  *
  * */
  List<DataRow> getRows() {
    List<DataRow> rows = [];

    for (var time in widget.times) {
      rows.add(DataRow(
          cells: <DataCell>[
            DataCell(
              Align(
                child: Text(time.time.toString()),
                alignment: Alignment.center,
              ),
            ),
            const DataCell(VerticalDivider(
              color: Colors.black,
            )),
            DataCell(
              Align(
                child: Text(time.p15.toString()),
                alignment: Alignment.center,
              ),
            ),
            const DataCell(VerticalDivider(
              color: Colors.black,
            )),
            DataCell(
              Align(
                child: Text(time.p12.toString()),
                alignment: Alignment.center,
              ),
            ),
            const DataCell(VerticalDivider(
              color: Colors.black,
            )),
            DataCell(
              Align(
                child: Text(time.p9.toString()),
                alignment: Alignment.center,
              ),
            ),
            const DataCell(VerticalDivider(
              color: Colors.black,
            )),
            DataCell(
              Align(
                child: Text(time.p6.toString()),
                alignment: Alignment.center,
              ),
            ),
            const DataCell(VerticalDivider(
              color: Colors.black,
            )),
            DataCell(
              Align(
                child: Text(time.p3.toString()),
                alignment: Alignment.center,
              ),
            ),
          ],
          color:
              MaterialStateProperty.resolveWith((states) => kDivingTableRow)));
    }

    return rows;
  }
}
