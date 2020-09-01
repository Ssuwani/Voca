import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

var url = 'http://10.0.2.2:5000/lv2_start_at';
var dontKnowUrl = 'http://10.0.2.2:5000/dontKnow';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> voca_data;
  bool loading = true;
  bool check = false;
  getVoca() async {
    print("VOCA실행");
    final response = await http.post(
      url,
      body: jsonEncode(
        {
          'cnt': 0,
        },
      ),
      headers: {'Content-Type': "application/json"},
    );
    // var response2 = await http.get(url);
    print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    final decodeData = utf8.decode(response.bodyBytes);
    final data = jsonDecode(decodeData);
    print(data.runtimeType);
    setState(() {
      voca_data = data;
      loading = false;
    });
  }

  dontKnow(english) async {
    final response = await http.post(
      dontKnowUrl,
      body: jsonEncode(
        {
          'word': english,
        },
      ),
      headers: {'Content-Type': "application/json"},
    );
    // var response2 = await http.get(url);
    print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    // final decodeData = utf8.decode(response.bodyBytes);
    // final data = jsonDecode(decodeData);
  }

  @override
  void initState() {
    getVoca();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController();
    final m_width = MediaQuery.of(context).size.width;
    final m_height = MediaQuery.of(context).size.height;
    print(voca_data);
    return Scaffold(
      appBar: AppBar(
        title: Text("단어연습"),
      ),
      body: loading
          ? SpinKitRotatingCircle(
              color: Colors.white,
              size: 50.0,
            )
          : PageView.builder(
              controller: controller,
              itemCount: voca_data.length,
              itemBuilder: (context, index) {
                final english = voca_data[index]["english"];
                final korean = voca_data[index]["korean"];
                return Container(
                  padding: EdgeInsets.only(top: 50, bottom: 50),
                  width: m_width,
                  height: m_height / 3,
                  color: Colors.red[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        english,
                        style: TextStyle(fontSize: 50),
                      ),
                      check
                          ? Column(
                              children: [
                                Text(
                                  korean,
                                  style: TextStyle(fontSize: 35),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        margin: EdgeInsets.all(15),
                                        width: m_width / 2,
                                        color: Colors.blue,
                                        child: FlatButton(
                                          onPressed: () {
                                            dontKnow(english);
                                            controller.jumpToPage(index + 1);
                                            setState(() {
                                              check = false;
                                            });
                                          },
                                          child: Text("몰라"),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        margin: EdgeInsets.all(9),
                                        width: m_width / 2,
                                        color: Colors.blue,
                                        child: FlatButton(
                                          onPressed: () {
                                            controller.jumpToPage(index + 1);
                                            setState(() {
                                              check = false;
                                            });
                                          },
                                          child: Text("알아"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Flexible(
                              child: Container(
                                margin: EdgeInsets.all(9),
                                width: m_width / 2,
                                color: Colors.blue,
                                child: FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      check = true;
                                    });
                                  },
                                  child: Text("확인하기"),
                                ),
                              ),
                            ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
