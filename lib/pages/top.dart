import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sample/pages/common/header.dart';
import 'package:sample/pages/common/colors.dart';
import 'package:sample/pages/mistaken_questions.dart';
import 'package:sample/pages/test.dart';
import 'package:sample/pages/questions.dart';

class TopPage extends StatelessWidget {
  const TopPage(this.user);
  final user;

  @override
  Widget build(BuildContext context) {
    String date = DateFormat('yyyy/MM/dd').format(DateTime.now());
    date = '2023/04/18';
    return Scaffold(
        appBar: Header(AppBar(), user),
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              width: 150,
              child: ElevatedButton(
                  child: Text('今日の問題'),
                  style: ElevatedButton.styleFrom(backgroundColor: colorTriad1),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuestionPage(user, date)));
                  }),
            ),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                child: Text('間違えた問題'),
                style: ElevatedButton.styleFrom(backgroundColor: colorMain),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MistakenPage(user)));
                },
              ),
            ),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                child: Text('テスト'),
                style: ElevatedButton.styleFrom(backgroundColor: colorTriad2),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TestPage(user)));
                },
              ),
            ),
          ]),
        ));
  }
}
