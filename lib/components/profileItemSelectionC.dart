import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
* Component ProfileItemSelectionC
*
* Composant utilisé pour la sélection d'un champ lors
* de la création d'un profil
*
* */
class ProfileItemSelectionC extends StatefulWidget {
  const ProfileItemSelectionC(
      {Key? key,
      required this.pickerItems,
      required this.defaultItem,
      required this.itemName,
      required this.itemUnit,
      required this.onChange})
      : super(key: key);

  final double defaultItem;
  final String itemName;
  final String itemUnit;
  final List pickerItems;
  final Function onChange;

  @override
  _ProfileItemSelectionCState createState() => _ProfileItemSelectionCState();
}

class _ProfileItemSelectionCState extends State<ProfileItemSelectionC> {
  List<Widget> pickerItems = [];
  int selectedIndex = 0;

  //Récupération des valeurs pour le picker
  List<Widget> getItems() {
    List<Widget> pickerItems = [];

    for (int item in widget.pickerItems) {
      pickerItems.add(
        Align(
          child: Text(
            item.toString(),
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

  @override
  Widget build(BuildContext context) {

    double itemExtent = 50.0;
    double fontSize = 12.0;

    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    if(queryData.size.width <= 400){

      itemExtent = 25.0;
      fontSize = 9.0;

    }

    return Column(
      children: [
        Text(
          widget.itemName,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: fontSize,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(
              initialItem: widget.pickerItems.indexOf(widget.defaultItem),
            ),
            itemExtent: itemExtent,
            looping: true,
            onSelectedItemChanged: (selectedIndex) {
              widget.onChange(selectedIndex);
            },
            children: getItems(),
          ),
        ),
        Text(
          widget.itemUnit,
          style: TextStyle(
            color: Colors.white70,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}

