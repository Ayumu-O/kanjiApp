import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sample/pages/common/header.dart';
import 'package:sample/pages/common/colors.dart';
import 'package:sample/models/question.dart';

final db = FirebaseFirestore.instance;

class MistakenPage extends StatelessWidget {
  final User user;
  const MistakenPage(this.user);

  @override
  Widget build(BuildContext context) {
    Future<List<Question>> getQuestions(date) async {
      DocumentSnapshot docSnap = await db.doc('daily_questions/$date').get();
      List<Question> questions = await docSnap
          .get('questions')
          .map<Question>((q) => Question(q))
          .toList();
      return questions;
    }

    Future getDailyMistakenQuestions(date, numbers) async {
      final List<Question> questions = await getQuestions(date);
      final mistakenQuestions =
          numbers.map<Question>((i) => questions[i]).toList();
      return {'date': date, 'mistakens': mistakenQuestions};
    }

    Future<void> getMistakenQuestions() async {
      final Map<String, List<Question>> mistakenQuestions = {};
      final DocumentSnapshot snap = await db.doc('user/${user.uid}').get();
      Map<String, dynamic> results = snap.get('results');

      final List<Future> futures = [];
      results.forEach((year, months) {
        months.forEach((month, days) {
          days.forEach((day, numbers) async {
            if (numbers.length > 0) {
              final String date = '$year/$month/$day';
              futures.add(getDailyMistakenQuestions(date, numbers));
            }
          });
        });
      });
      final futureAll = await Future.wait(futures);
      futureAll.forEach((r) {
        mistakenQuestions[r['date']] = r['mistakens'];
      });
      print(mistakenQuestions);
    }

    return Scaffold(
        appBar: Header(AppBar(), user),
        body: Center(
          child: ElevatedButton(
            child: Text('test'),
            onPressed: getMistakenQuestions,
          ),
        ));
  }
}
