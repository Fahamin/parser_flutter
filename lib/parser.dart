import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m3u/m3u.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:parser_flutter/VideoApp.dart';
import 'package:parser_flutter/channelmodel.dart';

class HomePager extends StatefulWidget {
  const HomePager({Key? key}) : super(key: key);

  @override
  _HomePagerState createState() => _HomePagerState();
}

class _HomePagerState extends State<HomePager> {
  List<ChannelModel> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hELLO"),
      ),
      body: Column(
        children: [
          ElevatedButton(
            child: Text("hLLO"),
            onPressed: readFile,
          ),
          ElevatedButton(
              child: Text("videoplay"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VideoApp()),
                );
              })
        ],
      ),
    );
  }

  Future<void> readFile() async {
    /* final source = await File('tha.m3u').readAsString();
    final m3u = await M3uParser.parse(source);
    */
    final response = await http.get(Uri.parse(
        'https://firebasestorage.googleapis.com/v0/b/api-master-3fb49.appspot.com/o/ara%2Fin.m3u?alt=media&token=4a4fd1c0-d2ad-45cf-88d7-d34155796b8a'));
    final m3u = await M3uParser.parse(response.body);

    for (final entry in m3u) {
      list.add(new ChannelModel(
          entry.title, entry.attributes!["tvg-logo"], entry.link));
      //  print("${entry.link}");
      //  print(' ${entry.attributes['tvg-logo']}');

    }
    for (int i = 0; i < list.length; i++) {
      print(list[i].link.toString());
    }
  }
}
