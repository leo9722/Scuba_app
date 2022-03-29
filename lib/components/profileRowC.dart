import 'package:flutter/material.dart';
import 'package:scuba/constants.dart';

/*
* Component ProfileRowC
*
* Composant utilisé afficher une information
* pour un profile
*
* */

// ignore: must_be_immutable
class ProfileRowC extends StatefulWidget {
  ProfileRowC({Key? key, required this.tooltipText, required this.infoText, required this.value, required this.unit}) : super(key: key);

  late String tooltipText;
  late String infoText;
  late String unit;
  late String value;

  @override
  State<ProfileRowC> createState() => _ProfileRowCState();
}

class _ProfileRowCState extends State<ProfileRowC> {
  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          flex: 5,
          child: Text(
            "${widget.infoText} : ${widget.value} ${widget.unit}",
            style: const TextStyle(
                color: kLightGrayTextColor,
                fontSize: 15,
                fontWeight: FontWeight.w300),
          ),
        ),
        Flexible(
          flex: 1,
          child: Tooltip(
            message: widget.tooltipText,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: const LinearGradient(
                  colors: <Color>[Colors.white, Colors.white]),
            ),
            height: 50,
            padding: const EdgeInsets.all(8.0),
            preferBelow: false,
            textStyle: const TextStyle(
              fontSize: 15,
            ),
            showDuration: const Duration(seconds: 2),
            waitDuration: const Duration(seconds: 1),
            child: const Icon(
              Icons.info,
              color: Colors.white38,
              size: 25,
            ),
          ),
        ),
      ],
    );
  }
}