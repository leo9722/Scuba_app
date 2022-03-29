import 'package:flutter/material.dart';

/*
* Component ErrorAlertDialog
*
* Composant utilisé pour les messages d'erreur du CRUD
*
* */

class ErrorAlertDialog  {

  void alertDialog(BuildContext context, String errorMessage){
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Erreur'),
        content: Text(errorMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Ok'),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }


}