import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:sample/pages/questions.dart';

// firestoreのドキュメントを扱うクラスBookを作る。
class Question {
  // ドキュメントを扱うDocumentSnapshotを引数にしたコンストラクタを作る
  Question(Map doc) {
    question = doc['question'];
    prefix = doc['prefix'];
    suffix = doc['suffix'];
    answer = doc['answer'];
    isCorrect = false;
    answerIsVisible = false;
  }

  String question = '';
  String prefix = '';
  String suffix = '';
  String answer = '';
  bool isCorrect = false;
  bool answerIsVisible = false;
}

class QuestionModel extends ChangeNotifier {
  // ListView.builderで使うためのListを用意しておく。
  List<Question> questions = [];

  // Firestore から問題と解答を取得
  Future<void> fetchQuestions(String date) async {
    // Firestoreからドキュメントを取得
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.doc('daily_questions/$date').get();

    // map(): Listの各要素をQuestionに変換
    // toList(): Map()から返ってきたIterable→Listに変換する
    // TODO: is_correct の初期化
    List<Question> questions =
        snap.get('questions').map<Question>((q) => Question(q)).toList();
    this.questions = questions;
    notifyListeners();
  }

  // 正解している問題数の取得
  int getCorrectedQuestions() {
    return this.questions.where((q) => q.isCorrect).length;
  }
}
