import 'dart:convert';

import './button_widget.dart';
import 'package:flutter/material.dart';
import './quiz.dart';
import './result.dart';
import './navigation_drawer_widget.dart';
import 'package:http/http.dart' as http;

// void main() {
//   runApp(MyApp());
// }
// void main() => runApp(MyApp());
void main() => runApp(DataFromAPI());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _questions = [
    {
      'questionText': 'What\'s your favourite color?',
      'answers': [
        {'text': 'Black', 'score': 10},
        {'text': 'Blue', 'score': 5},
        {'text': 'Red', 'score': 9},
        {'text': 'Green', 'score': 6},
      ],
    },
    {
      'questionText': 'What\'s your favourite animal?',
      'answers': [
        {'text': 'Rabbit', 'score': 10},
        {'text': 'Dog', 'score': 5},
        {'text': 'Cat', 'score': 9},
        {'text': 'Horse', 'score': 6},
      ]
    },
    {
      'questionText': 'What\'s your favourite food?',
      'answers': [
        {'text': 'Sushi', 'score': 10},
        {'text': 'Beef bowl', 'score': 5},
        {'text': 'Ramen', 'score': 9},
        {'text': 'Sukiyaki', 'score': 6},
      ],
    },
  ];
  var _questionIndex = 0;
  var _totalScore = 0;
  var _currentIndex = 0;

  final tabs = [
    Center(
      child: Text('Home'),
    ),
    Center(
      child: Text('Search'),
    ),
    Center(
      child: Text('Camera'),
    ),
    Center(
      child: Text('Profile'),
    ),
  ];

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  void _answerQuestion(int score) {
    _totalScore += score;
    setState(() {
      _questionIndex = _questionIndex + 1;
    });
    print(_questionIndex);
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // endDrawer: NavigationDrawerWidget(),
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: Text('My First App'),
        ),
        body: Builder(
          builder: (context) => Column(
            children: <Widget>[
              tabs[_currentIndex],
              ButtonWidget(
                  icon: Icons.open_in_new,
                  text: 'Open Drawer',
                  onClicked: () {
                    Scaffold.of(context).openDrawer();
                    // Scaffold.of(context).openEndDrawer();
                  }),
            ],
          ),
        ),

        // _questionIndex < _questions.length
        //     ? Quiz(
        //         _questions,
        //         _questionIndex,
        //         _answerQuestion,
        //       )
        //     : Result(_totalScore, _resetQuiz),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.green,
          // selectedFontSize: 20,
          // unselectedFontSize: 15,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: 'Camera',
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Colors.yellowAccent,
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class DataFromAPI extends StatefulWidget {
  @override
  _DataFromAPIState createState() => _DataFromAPIState();
}

class _DataFromAPIState extends State<DataFromAPI> {
  Future getUserData() async {
    var responce =
        await http.get(Uri.https('jsonplaceholder.typicode.com', 'users'));
    var jsonData = jsonDecode(responce.body);
    List<User> users = [];
    for (var u in jsonData) {
      User user = User(u['name'], u['email'], u['username']);
      users.add(user);
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('User Data'),
        ),
        body: Container(
          child: Card(
            child: FutureBuilder(
              future: getUserData(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: Text('Loading...'),
                    ),
                  );
                } else {
                  return ListView.builder(
                      itemCount: (snapshot.data as List<User>).length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          title: Text((snapshot.data as List<User>)[i].name),
                          subtitle:
                              Text((snapshot.data as List<User>)[i].userName),
                          trailing:
                              Text((snapshot.data as List<User>)[i].email),
                        );
                      });
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class User {
  final String name, email, userName;
  User(this.name, this.email, this.userName);
}
