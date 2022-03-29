import 'package:flutter/material.dart';

/*
* Component ProfileDisplayFieldC
*
* Composant utilisé pour afficher les données d'un profil
*
* */
class ProfileDisplayFieldC extends StatelessWidget {
  const ProfileDisplayFieldC({
    Key? key,
    required this.fieldName, required this.fieldValue, required this.fieldUnit,
  }) : super(key: key);

  final String fieldName;
  final int fieldValue;
  final String fieldUnit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            fieldName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ),
        TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            fillColor: Colors.white30,
            filled: true,
            disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white70,
              ),
            ),
            enabled: false,
            label: Text(
              "${fieldValue.toString()}\n$fieldUnit",
              style: const TextStyle(
                fontSize: 13.0
              ),
            ),
          ),
        ),
      ],
    );
  }
}