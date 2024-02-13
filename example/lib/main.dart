import 'package:flutter/material.dart';
// import 'tokens.dart';
import 'package:flutter_mapbox_autocomplete_plus/flutter_mapbox_autocomplete.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MapBox AutoComplete',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _startPointController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter MapBox AutoComplete example"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: CustomTextField(
          hintText: "Select starting point",
          textController: _startPointController,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MapBoxAutoCompleteWidget(
                  apiKey: TOKEN,
                  hint: "Select starting point",
                  onSelect: (place) {
                    _startPointController.text = place.placeName ?? "not found";
                  },
                  limit: 10,
                  language: 'en',
                  context: context,
                  loadingColor: Colors.black, backgroundColor: Colors.white70, textColor: Colors.blueAccent, iconColor: Colors.deepPurple,
                ),
              ),
            );
          },
          enabled: true,
        ),
      ),
    );
  }
}
