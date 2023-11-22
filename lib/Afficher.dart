import 'package:flutter/material.dart';

class Afficher extends StatelessWidget {
  final String nom;
  final String prenom;
  final String civilite;
  final List<String> specialites;

  Afficher({
    required this.nom,
    required this.prenom,
    required this.civilite,
    required this.specialites,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informations du Formulaire'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Nom: $nom'),
            Text('Prénom: $prenom'),
            Text('Civilité: $civilite'),
            Text('Spécialités: ${specialites.join(", ")}'),
          ],
        ),
      ),
    );
  }

}
