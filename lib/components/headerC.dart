import 'package:flutter/material.dart';

import '../constants.dart';

/*
* Component headerC
*
* Composant utilisé pour le header de chaque page
*
* */
class HeaderC extends StatelessWidget {
  const HeaderC({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {

  return  Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50.0),
          bottomRight: Radius.circular(50.0),
        ),
        color: Colors.white,
      ),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          const Spacer(
            flex: 5,
          ),
          Flexible(
            flex: 3,
            child: FittedBox(
              child: Text(
                text,
                style: const TextStyle(
                  color: kDarkBlueTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ),
          ),
          const Spacer(
            flex: 3,
          ),
        ],
      ),
    );
  }

}