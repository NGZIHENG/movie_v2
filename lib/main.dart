import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(
        primarySwatch: Colors.yellow
      ),
      home: const MyWidget(title:'Movie'),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key, required this.title});
  final String title;

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final TextEditingController _searchController = TextEditingController();
  String title = "";
  String desc = "";
  String desc1 = "";
  var poster = 'https://color.adobe.com/media/theme/92471.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Movie App'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children:[
                  const Text('Welcome',style: TextStyle(fontSize:20)),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)
                      )
                    )
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed: (){
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Confirmation', style: TextStyle()),
                      content: const Text("Do you want to search this?", style: TextStyle()),
                      actions: <Widget> [
                        TextButton(
                          child: const Text ("Yes"),
                          onPressed: (){
                            Navigator.of(context).pop();
                            showMovie(_searchController.text);
                          }
                        ),
                        TextButton(
                          child: const Text("No"),
                          onPressed: (){
                            Navigator.of(context).pop();
                            _searchController.text = '';
                          }
                        )
                      ]
                    )
                  );
                },
                  child: const Text('SEARCH')
                ),
                    ElevatedButton(
                        onPressed: () {
                          _searchController.text = '';
                        },
                  child: const Text('CLEAR')
                    ),
                  ]
                ),
                Text(desc.toString(),style: const TextStyle(fontSize:20, fontWeight: FontWeight.bold)),
                Image.network(poster),
                Text(desc1.toString()),
              ],
            ),
          ),
        ),
      )
    );
  }

  showMovie(title) async {
    ProgressDialog progressDialog = ProgressDialog(context,
      message: const Text("Progress"), title: const Text("Searching...")
    );
    progressDialog.show();
    var url = Uri.parse('http://www.omdbapi.com/?t=$title&apikey=510fb1b4');
    var response = await http.get(url);
    var rescode = response.statusCode;
    if (rescode == 200 && _searchController.text != "") {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      Fluttertoast.showToast(
        msg: "Found",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
      setState(() {
        title = parsedJson['Title'];
        String released = parsedJson['Released'];
        String genre = parsedJson['Genre'];
        desc = "$title";
        desc1 = "Released: $released, Genre: $genre";
        poster = parsedJson['Poster'];
      });
    } else {
      setState(() {
        poster = 'https://service.hk/book/assets/images/no-result.png';
        desc = "";
        desc1 = "No Data";
      });
    }
    progressDialog.dismiss();
  }
}