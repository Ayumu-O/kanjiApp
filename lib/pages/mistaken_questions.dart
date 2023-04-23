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
import 'package:sample/pages/questions.dart';

final db = FirebaseFirestore.instance;

class MistakenPage extends StatelessWidget {
  final User user;
  const MistakenPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(AppBar(), user), body: MistakenList(user: user));
  }
}

class MistakenList extends StatefulWidget {
  final User user;
  const MistakenList({
    super.key,
    required this.user,
  });

  @override
  State<MistakenList> createState() => _MistakenListState();
}

class _MistakenListState extends State<MistakenList> {
  Future<List<Question>> fetchQuestions(date) async {
    DocumentSnapshot docSnap = await db.doc('daily_questions/$date').get();
    List<Question> questions = await docSnap
        .get('questions')
        .map<Question>((q) => Question(q))
        .toList();
    return questions;
  }

  Future getDailyMistakenQuestions(date, numbers) async {
    final List<Question> questions = await fetchQuestions(date);
    final mistakenQuestions =
        numbers.map<Question>((i) => questions[i]).toList();
    // 非同期テスト用
    // sleep(Duration(seconds: 5));
    return {'date': date, 'mistakens': mistakenQuestions};
  }

  Future getMistakenQuestions(User user) async {
    final List mistakenQuestions = [];
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
      mistakenQuestions.add(r);
    });
    // 日付の降順にソート
    mistakenQuestions.sort((a, b) => b['date'].compareTo(a['date']));
    return mistakenQuestions;
  }

  bool _isLoading = false;
  List mistakenQuestions = [];
  @override
  void initState() {
    Future<void>.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      mistakenQuestions = await getMistakenQuestions(widget.user);
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator.adaptive())
        : ListView.builder(
            itemCount: mistakenQuestions.length,
            itemBuilder: (context, index) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 500,
                      padding: EdgeInsets.all(8),
                      color: colorWhite,
                      child: Text(
                        mistakenQuestions[index]['date'],
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    MistakenCard(
                      questions: mistakenQuestions[index]['mistakens'],
                    )
                  ]);
            },
          );
  }
}

class MistakenCard extends StatefulWidget {
  final List<Question> questions;
  const MistakenCard({
    super.key,
    required this.questions,
  });

  @override
  State<MistakenCard> createState() => _MistakenCardState();
}

class _MistakenCardState extends State<MistakenCard> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QuestionModel>(
      create: (_) => QuestionModel()..fromList(widget.questions),
      child: Consumer<QuestionModel>(builder: (context, model, child) {
        return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.questions.length,
            itemBuilder: (context, index) {
              final q = widget.questions[index];
              return QuestionCard(
                index: index,
                q: q,
                model: model,
                isTest: false,
              );
            });
      }),
    );
  }
}
