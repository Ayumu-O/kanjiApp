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

class TestPage extends StatelessWidget {
  final User user;
  const TestPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(AppBar(), user),
        body: Center(
          child: ElevatedButton(
            child: Text('test'),
            onPressed: () {},
          ),
        ));
  }
}
