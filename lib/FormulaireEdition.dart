import 'package:flutter/material.dart';
import 'package:form/UtilisateurPage.dart';

import 'main.dart';

class FormulaireEdition extends StatefulWidget {
  final Utilisateur utilisateur;

  FormulaireEdition({required this.utilisateur});

  @override
  _FormulaireEditionState createState() => _FormulaireEditionState();
}

class _FormulaireEditionState extends State<FormulaireEdition> {
  final _formKey = GlobalKey<FormState>();
  String _nouveauNom = '';
  String _nouveauPrenom = '';
  String _nouvelleCivilite = '';
  List<String> _nouvellesSpecialites = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Édition de l\'utilisateur'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: widget.utilisateur.nom, // Affichez la valeur actuelle dans le champ de texte
                decoration: InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
                onSaved: (value) => _nouveauNom = value!,
              ),
              TextFormField(
                initialValue: widget.utilisateur.prenom, // Affichez la valeur actuelle dans le champ de texte
                decoration: InputDecoration(labelText: 'Prénom'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer votre prénom';
                  }
                  return null;
                },
                onSaved: (value) => _nouveauPrenom = value!,
              ),TextFormField(
                initialValue: widget.utilisateur.civilite,
                decoration: InputDecoration(labelText: 'Civilité'),
                onSaved: (value) => _nouvelleCivilite = value!,
              ),
              TextFormField(
                initialValue: widget.utilisateur.specialites.join(', '), // Convertissez la liste en chaîne de caractères
                decoration: InputDecoration(labelText: 'Spécialités (séparées par des virgules)'),
                onSaved: (value) {
                  _nouvellesSpecialites = value!.split(',').map((e) => e.trim()).toList();
                },
              ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState?.save();
                // Mettez à jour l'utilisateur avec les nouvelles valeurs et retournez-le à la page précédente
                Navigator.pop(context, Utilisateur(
                  nom: _nouveauNom,
                  prenom: _nouveauPrenom,
                  civilite: _nouvelleCivilite,
                  specialites: _nouvellesSpecialites,
                ));
              }
            },
            child: Text('Enregistrer'),
          ),

            ],
          ),
        ),
      ),
    );
  }
}
