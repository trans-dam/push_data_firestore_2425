import 'package:dto/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:push_data_firestore/data/teams.dart';
import 'package:push_data_firestore/styles/spacings.dart';

import '../data/transactions.dart';
import '../data/users.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> _description = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
        child: Center(
          child: SizedBox(
            height: 300,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _description.map((e) => Text(e)).toList(),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton.extended(
              onPressed: deleteCollections,
              label: const Row(
                children: [
                  Icon(Icons.delete_forever),
                  SizedBox(width: kHorizontalPaddingS),
                  Text("Supprimer les données"),
                ],
              ),
            ),
            FloatingActionButton.extended(
              onPressed: () async {
                await authenticate();
                await addUsers();
                await addTeams();
              },
              label: const Row(
                children: [
                  Icon(Icons.published_with_changes),
                  SizedBox(width: kHorizontalPaddingS),
                  Text("Générer les données"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void deleteCollections() async {
    await usersRef.get().then((snapshot) {
      for (UsersQueryDocumentSnapshot user in snapshot.docs) {
        setState(() {
          _description.insert(0, "Suppression de l'utilisateur${user.id}");
        });
        user.reference.delete();
      }
    });

    await teamsRef.get().then((snapshot) {
      for (TeamsQueryDocumentSnapshot team in snapshot.docs) {
        team.reference.transactions.get().then((snapshot) {
          for (TransactionsQueryDocumentSnapshot myTransaction
              in snapshot.docs) {
            setState(() {
              _description.insert(
                  0, "Suppression de la transaction${myTransaction.id}");
            });
            myTransaction.reference.delete();
          }
        });
        setState(() {
          _description.insert(0, "Suppression de l'équipe${team.id}");
        });
        team.reference.delete();
      }
    });
  }

  Future<void> authenticate() async {
    for (var user in users) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: user.email, password: "123456789");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          setState(() {
            _description.insert(0, "L'utilisateur ${user.email} existe déjà");
          });
        }
      }
    }
  }

  Future<void> addUsers() async {
    for (var user in users) {
      usersRef.add(user).then((user) {
        setState(() {
          _description.insert(0, "Ajout de l'utilisateur${user.id}");
        });
      });
    }
  }

  Future<void> addTeams() async {
    for (Team team in teams) {
      teamsRef.add(team).then((team) {
        for (MyTransaction transaction in transactions) {
          teamsRef
              .doc(team.id)
              .transactions
              .add(transaction)
              .then((transaction) {
            for (var user in users) {
              transaction.concerns.add(user);
              setState(() {
                _description.insert(
                    0, "Ajout de l'utilisateur concerné ${user.email}");
              });
            }
            setState(() {
              _description.insert(
                  0, "Ajout de la transaction ${transaction.id}");
            });
          });
        }
        setState(() {
          _description.insert(0, "Ajout de l'équipe${team.id}");
        });
      });
    }
  }
}
