import 'package:flutter/material.dart';
import 'package:samplehttp/data.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<List<Data>> fetchPost() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/posts');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    List parseJson = json.decode(response.body);
    return (parseJson)
      .map((p) => Data.fromJson(p))
      .toList();
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
  Future<Data> post;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('List of Title from Post'),
        ),
        body: ListView(
          children: <Widget>[
            FutureBuilder<List<Data>>(
            future: fetchPost(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Data> posts = snapshot.data;
                      return Container(
                        child: Column(
                          children: posts.map((post) => Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.all(5),

                            child: Column(
                              children: <Widget>[
                              Text(post.id.toString()+") "+post.title),
                            ],
                            ),
                            
                          )).toList()
                      )
                      );
              } else if (snapshot.hasError) {
                return Text("Cant load Data due to Internet Connection\n ${snapshot.error}");
              }

              // By default, show a loading spinner.
              return Center(child: CircularProgressIndicator());
            },
          ),
          ],
        ),
      );
  }
}
