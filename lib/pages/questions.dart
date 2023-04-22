import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sample/models/question.dart';

const colorMain = Color(0xFFee827c);
const colorTriad1 = Color(0xFF7bafed);
const colorTriad2 = Color(0xFF7ebd81);
const colorLetter = Color(0xFF331c1b);
const colorWhite = Color(0xFFf1f1f1);

class QuestionPage extends StatefulWidget {
  QuestionPage(this.user);
  final User user;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  bool isVisibleAll = false;

  @override
  Widget build(BuildContext buildContext) {
    return ChangeNotifierProvider<QuestionModel>(
        create: (_) => QuestionModel()..fetchQuestions('2023/04/16'),
        child:
            Consumer<QuestionModel>(builder: (consumerContext, model, child) {
          final questions = model.questions;
          final List<bool> isVisibles = List.filled(questions.length, false);
          void toggleIsVisibleAll() {
            setState(() {
              isVisibleAll = !isVisibleAll;
            });
            questions.forEach((q) {
              q.answerIsVisible = isVisibleAll;
            });
            model.notifyListeners();
          }

          final int score = model.getCorrectedQuestions();
          return Scaffold(
              // Header
              appBar: AppBar(
                title: Row(
                  children: [
                    Text(
                      '今日の漢字',
                      style:
                          GoogleFonts.yujiMai(color: colorWhite, fontSize: 32),
                    ),
                    // Image(
                    //     image: NetworkImage(
                    //         'https://kyounokanji.com/img/kanji_logo3.gif')),
                    // Text(user.email.toString(),
                    //     style: TextStyle(color: Colors.black)),
                  ],
                ),
                backgroundColor: colorTriad1,
              ),
              // Body
              body: ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (consumerContext, index) {
                    final q = questions[index];
                    return QuestionCard(
                      index: index + 1,
                      q: q,
                      model: model,
                    );
                  }),
              // Footer
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: ScoreBoard(score: score),
              bottomNavigationBar: Footer(isVisibleAll, toggleIsVisibleAll));
        }));
  }
}

// 各問題
class QuestionCard extends StatefulWidget {
  QuestionCard({
    Key? key,
    required this.index,
    required this.q,
    required this.model,
  }) : super(key: key);
  final int index;
  final Question q;
  final QuestionModel model;

  @override
  State<QuestionCard> createState() => _QuestionState();
}

class _QuestionState extends State<QuestionCard> {
  void toggleAnswerVisiblity() {
    widget.q.answerIsVisible = !widget.q.answerIsVisible;
    widget.model.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorWhite,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(color: Colors.grey),
          )),
          child: Row(children: [
            // 問題番号
            Container(
              width: 28,
              child: Text(
                '(' + widget.index.toString() + ')',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: colorLetter),
              ),
            ),
            SizedBox(width: 8),
            // 問題文
            Flexible(
              child: Container(
                width: 200,
                child: RichText(
                    text: TextSpan(
                  style: TextStyle(color: colorLetter, fontFamily: 'Verdana'),
                  children: [
                    TextSpan(text: widget.q.prefix + " ("),
                    // 漢字を答えるカタカナの部分だけ太字
                    TextSpan(
                        text: widget.q.question,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ") " + widget.q.suffix)
                  ],
                )),
              ),
            ),
            SizedBox(width: 12),
            // 解答
            Visibility(
                visible: widget.q.answerIsVisible,
                maintainAnimation: true,
                maintainState: true,
                maintainSize: true,
                child: Container(
                    width: 50,
                    child: Text(widget.q.answer,
                        style: GoogleFonts.yujiMai(
                            color: colorLetter, fontSize: 24)))),
            SizedBox(width: 12),
            // 解答表示ボタン
            Container(
              child: SizedBox(
                width: 46,
                child: ElevatedButton(
                  onPressed: toggleAnswerVisiblity,
                  child: Text(
                    '答',
                    style: TextStyle(fontSize: 18, color: colorWhite),
                  ),
                  // child: Text(isVisible ? widget.q.answer : '解答'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: colorTriad1, padding: EdgeInsets.all(0)),
                ),
              ),
            ),
            SizedBox(width: 12),
            // 正答ボタン
            Container(
                child: SizedBox(
              width: 48,
              child: ElevatedButton(
                child: Icon(
                  Icons.circle_outlined,
                  color: colorWhite,
                ),
                onPressed: () {
                  widget.q.isCorrect = !widget.q.isCorrect;
                  widget.model.notifyListeners();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.q.isCorrect ? colorMain : Colors.grey,
                  padding: EdgeInsets.all(0),
                ),
              ),
            )),
          ]),
        ),
      ),
    );
  }
}

// Footer
class ScoreBoard extends StatelessWidget {
  const ScoreBoard({
    super.key,
    required this.score,
  });

  final int score;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: colorTriad1,
        onPressed: () {},
        child: Container(
          // （背景）正解した問題数に応じて色で埋まっていく
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [colorTriad1, colorTriad1, colorWhite],
                  stops: [0, score / 20, score / 20])),
          padding: EdgeInsets.all(10),
          // 正解数の表示
          child: SizedBox(
            width: 50,
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Text(
                '${score.toString()}',
                style: TextStyle(
                  // 14 で完全に文字が色に隠れるので、見やすいように
                  color: score > 13 ? colorWhite : colorLetter,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ));
  }
}

class Footer extends StatelessWidget {
  Footer(this.isVisibleAll, this.onPressedIsVisibleAll);
  final bool isVisibleAll;
  final Function() onPressedIsVisibleAll;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        color: colorTriad1,
        notchMargin: 6.0,
        shape: AutomaticNotchedShape(
          RoundedRectangleBorder(),
          StadiumBorder(
            side: BorderSide(),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // Footer の中身
            children: <Widget>[
              TextButton(
                child: Row(children: [
                  Text(
                    '全解答',
                    style: TextStyle(
                        color: colorWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Verdana'),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    isVisibleAll ? Icons.visibility_off : Icons.remove_red_eye,
                    color: colorWhite,
                  )
                ]),
                onPressed: onPressedIsVisibleAll,
              ),
              TextButton(
                child: Row(children: [
                  Text(
                    '登録',
                    style: TextStyle(
                        color: colorWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Verdana'),
                  ),
                ]),
                onPressed: () {},
              ),
            ],
          ),
          // BottomNavigationBar(items: [
          //   BottomNavigationBarItem(
          //       icon: Icon(Icons.home),
          //       label: model.getCorrectedQuestions().toString()),
          //   BottomNavigationBarItem(icon: Icon(Icons.search), label: 'test')
          // ]
        ));
  }
}