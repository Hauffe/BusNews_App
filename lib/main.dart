import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:bus_news/model/BusNews.dart';
import 'package:http/http.dart';

List<BusNews> list;
void main() => runApp(MyApp());

Future<List<BusNews>> getData() async {
  String link =
      'https://use o comando ipconfig e pegue o endereço ipv4/bus_news';
  var res = await get(Uri.parse(link));
  if (res.statusCode == 200) {
    var data = json.decode(res.body);
    var rest = data as List;
    list = rest.map<BusNews>((json) => BusNews.fromJson(json)).toList();
  }else{
    throw Exception("API error");
  }
  return list;
}

class MyApp extends StatelessWidget {
  final Future<BusNews> busNews;

  MyApp({Key key, this.busNews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boletim do transporte',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Boletim do transporte'),
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

  openURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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

  Widget listViewWidget(List<BusNews> news) {
    return Container(
      child: ListView.builder(
          itemCount: list.length,
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, position) {
            return Center(
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.directions_bus),
                        title: Text(
                          '${news[position].date.substring(0, 10)}'
                              '\n ${news[position].title}',
                        ),
                        subtitle: Text(
                            '${news[position].content.substring(0, 80)} [...]'
                        ),
                      ),
                      ButtonTheme.bar( // make buttons use the appropriate styles for cards
                        child: ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: const Text('Clique aqui'),
                              onPressed: () {
                                openURL(news[position].link);
                              },
                            ),
                            FlatButton(
                              child: const Text('Ver Detalhes'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => NewsDetails(busNews: news[position])),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                )
            );
          }),
    );
  }
}

class NewsDetails extends StatelessWidget{

  final BusNews busNews;

  NewsDetails({Key key, @required this.busNews}):super(key: key);

  @override
  Widget build(BuildContext context) {
      return Scaffold(appBar: AppBar(
        title: Text('${busNews.title}'),
      ),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(
                  child: busNews.imageURL == null
                      ? Image(image: null)
                      : Image.network(busNews.imageURL)
                ),
                Container(
                  child: Text('${busNews.content}'),
                )
              ],
            ),
          )
    );
  }
}
