import 'package:flutter/material.dart';
import 'main.dart';
import 'FormulaireEdition.dart';

class UtilisateurPage extends StatefulWidget {
  final List<Utilisateur> utilisateurs;

  UtilisateurPage({required this.utilisateurs});

  @override
  _UtilisateurPageState createState() => _UtilisateurPageState();
}

class _UtilisateurPageState extends State<UtilisateurPage> {
  void _editerUtilisateur(BuildContext context, Utilisateur utilisateur, int index) async {
    Utilisateur utilisateurEdite = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormulaireEdition(utilisateur: utilisateur),
      ),
    );

    if (utilisateurEdite != null) {
      setState(() {
        widget.utilisateurs[index] = utilisateurEdite;
      });
    }
  }

  void _supprimerUtilisateur(int index) {
    setState(() {
      widget.utilisateurs.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Utilisateur supprimé'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Utilisateurs'),
      ),
      body: ListView.builder(
        itemCount: widget.utilisateurs.length,
        itemBuilder: (context, index) {
          Utilisateur utilisateur = widget.utilisateurs[index];
          return ListTile(
            title: Text('${utilisateur.nom} ${utilisateur.prenom}'),
            subtitle: Text('Civilité: ${utilisateur.civilite}, Spécialités: ${utilisateur.specialites.join(", ")}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editerUtilisateur(context, utilisateur, index);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _supprimerUtilisateur(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
