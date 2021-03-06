import 'package:flutter/material.dart';
import 'package:simple_quiz_app/model/api_adapter.dart';
import 'package:simple_quiz_app/model/model_quiz.dart';
import 'package:simple_quiz_app/screen/screen_quiz.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 화면 전환시 로딩 화면
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Quiz> quizes = [];
  bool isloading = false; // 데이터 로딩 상태에 대한 정보

  _fetchQuizes() async {
    setState(() {
      isloading = true;
    });
    final response = await http.get(Uri.parse("https://drf-simple-quiz-app.herokuapp.com/quiz/3/"));
    if (response.statusCode == 200) {
      setState(() {
        quizes = parseQuizes(utf8.decode(response.bodyBytes));
        isloading = false;
      });
    } else {
      throw Exception('failed to load data');
    }
  }

  // List<Quiz> quizes = [
  //   Quiz.fromMap({
  //     'title': 'test',
  //     'candidates': ['a','b','c', 'd'],
  //     'answer': 0
  //   }),
  //   Quiz.fromMap({
  //     'title': 'test',
  //     'candidates': ['a','b','c', 'd'],
  //     'answer': 0
  //   }),
  //   Quiz.fromMap({
  //     'title': 'test',
  //     'candidates': ['a','b','c', 'd'],
  //     'answer': 0
  //   }),
  // ];

  @override
  Widget build(BuildContext context) {
    // media query 활용: 화면의 사이즈, 화면 로테이션 정보
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey, // 로딩 화면 
        appBar: AppBar(
          title: Text('My Quiz App'),
          backgroundColor: Colors.deepPurple,
          leading: Container(),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image.asset(
                'images/quiz.jpeg', width: width*0.8,
                ),
              ),
              Padding(padding: EdgeInsets.all(width * 0.024),
              ),
              Text(
                '플러터 퀴즈 앱', 
                style: TextStyle(
                  fontSize: width * 0.065,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '퀴즈를 풀기 전 안내 사항입니다. \n꼼꼼히 읽고 퀴즈 풀기를 눌러주세요.',
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.048),
                ),
                _buildStep(width, '1. 랜덤으로 나오는 퀴즈 3개를 풀어보세요.'),
                _buildStep(width, '2. 문제를 잘 읽고 정답을 고른 뒤, \n다음 문제 버튼을 눌러주세요.'),
                _buildStep(width, '만접을 향해 도전해 보세요!'),
                Padding(
                  padding: EdgeInsets.all(width * 0.048),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: width * 0.036),
                    child: Center(
                      child: ButtonTheme(
                        minWidth: width * 0.8,
                        height: height * 0.05,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // child: RaisedButton(
                        //   child: Text(
                        //     '지금 퀴즈 풀기',
                        //     style: TextStyle(color: Colors.white),
                        //   ),
                        //   color: Colors.deepPurple,
                        //   onPressed: () {},

                        //   ),
                        child: ElevatedButton (
                          child: Text(
                            '지금 퀴즈 풀기',
                            style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurple
                            ),
                            onPressed: () {
                              _scaffoldKey.currentState?.showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: <Widget>[
                                      CircularProgressIndicator(),
                                      Padding(padding: EdgeInsets.only(left: width * 0.036),
                                      ),
                                    ],
                                  ),
                                  ),
                                );
                              _fetchQuizes().whenComplete(() {
                                return Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => QuizScreen(
                                    quizes: quizes,
                                  ),
                                ),
                              );
                              });
                            },
                            ),
                      ),
                    ),
                  )
            ],
          ),
        ), 
      );
  }

  Widget _buildStep(double width, String title) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        width * 0.048,
        width * 0.024,
        width * 0.048,
        width * 0.024,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.check_box,
            size: width * 0.04,
          ),
          Padding(
            padding: EdgeInsets.only(right: width * 0.024),
          ),
          Text(title),
        ],
      ),
    );
  }

}

