import 'package:flutter/material.dart';
import 'Afficher.dart';
import 'UtilisateurPage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulaire',
      theme: ThemeData(primarySwatch: Colors.lightGreen),
      home: MyForm(),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class Utilisateur {
  String nom;
  String prenom;
  String civilite;
  List<String> specialites;

  Utilisateur({
    required this.nom,
    required this.prenom,
    required this.civilite,
    required this.specialites,
  });

  // Ajoutez une méthode pour convertir l'objet Utilisateur en JSON
  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'civilite': civilite,
      'specialites': specialites,
    };
  }
  // Méthode pour créer un objet Utilisateur à partir de JSON
  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      nom: json['nom'],
      prenom: json['prenom'],
      civilite: json['civilite'],
      specialites: List<String>.from(json['specialites']),
    );
  }
}

class Storage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.json');
  }

  Future<List<Utilisateur>> readUsers() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      List<dynamic> usersJson = json.decode(contents);
      List<Utilisateur> users = usersJson.map((userJson) => Utilisateur.fromJson(userJson)).toList();
      return users;
    } catch (e) {
      return [];
    }
  }

  Future<void> writeUsers(List<Utilisateur> users) async {
    try {
      final file = await _localFile;
      String usersJson = json.encode(users.map((user) => user.toJson()).toList());
      await file.writeAsString(usersJson);
    } catch (e) {
      print('Erreur lors de l\'écriture dans le fichier : $e');
    }
  }
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  String _nom = '';
  String _prenom = '';
  String _civilite = '';
  List<String> _specialites = [];
  List<Utilisateur> utilisateurs = [];
  final storage = Storage();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  _loadUsers() async {
    List<Utilisateur> users = await storage.readUsers();
    setState(() {
      utilisateurs = users;
    });
  }

  _saveUsers() {
    storage.writeUsers(utilisateurs);
  }

  void _afficherPrompt() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Afficher(
            nom: _nom,
            prenom: _prenom,
            civilite: _civilite,
            specialites: _specialites,
          ),
        ),
      );
    }
  }

  void _enregistrerUtilisateur() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      Utilisateur nouvelUtilisateur = Utilisateur(
        nom: _nom,
        prenom: _prenom,
        civilite: _civilite,
        specialites: List.from(_specialites),
      );

      setState(() {
        utilisateurs.add(nouvelUtilisateur);
      });

      // Réinitialiser le formulaire
      _formKey.currentState?.reset();

      // Enregistrer la liste des utilisateurs dans le fichier JSON
      _saveUsers();

      // Naviguer vers la page de la liste des utilisateurs
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UtilisateurPage(utilisateurs: utilisateurs),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulaire Flutter'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
                onSaved: (value) => _nom = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Prénom'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer votre prénom';
                  }
                  return null;
                },
                onSaved: (value) => _prenom = value!,
              ),
              DropdownButtonFormField(
                items: ['Monsieur', 'Madame'].map((String civilite) {
                  return DropdownMenuItem(
                    value: civilite,
                    child: Text(civilite),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _civilite = value!;
                  });
                },
                hint: Text('Sélectionnez la civilité'),
              ),
              SizedBox(height: 20),
              Text('Sélectionnez les spécialités:'),
              Column(
                children: ['Java', 'Math', 'Laravel'].map((String specialite) {
                  return CheckboxListTile(
                    title: Text(specialite),
                    value: _specialites.contains(specialite),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value!) {
                          _specialites.add(specialite);
                        } else {
                          _specialites.remove(specialite);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _afficherPrompt,
                child: Text('Afficher'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _enregistrerUtilisateur,
                child: Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
