import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bus_news/model/BusNews.dart';
import 'package:http/http.dart' as http;

List<BusNews> list;
void main() => runApp(MyApp());

Future<List<BusNews>> getData() async {
  String link =
      "http://busnewsservice-env.us-east-2.elasticbeanstalk.com/bus_news";
  var res = await http.get(link);
  if (res.statusCode == 200) {
    var data = json.decode(res.body);
    var rest = data as List;
    list = rest.map<BusNews>((json) => BusNews.fromJson(json)).toList();
  }
  print("List Size: ${list.length}");
  return list;
}

class MyApp extends StatelessWidget {

  final Future<BusNews> busNews;

  MyApp({Key key, this.busNews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            return snapshot.data != null
                ? listViewWidget(snapshot.data)
                : Center(child: CircularProgressIndicator());
          }),

    );
  }

  Widget listViewWidget(List<BusNews> article) {
    return Container(
      child: ListView.builder(
          itemCount: list.length,
          padding: const EdgeInsets.all(2.0),
          itemBuilder: (context, position) {
            return Card(
              child: ListTile(
                title: Text(
                  '${article[position].title}',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: article[position].imageURL == null
                        ? Image()
                        : Image.network('${article[position].imageURL}'),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
