import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m3u/m3u.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:parser_flutter/PlayerScreen/VideoApp.dart';
import 'package:parser_flutter/customList/CustomListItem.dart';
import 'package:parser_flutter/helper/SQLHelper.dart';
import 'package:parser_flutter/model/channelmodel.dart';

class HomePager extends StatefulWidget {
  const HomePager({Key? key}) : super(key: key);

  @override
  _HomePagerState createState() => _HomePagerState();
}

class _HomePagerState extends State<HomePager> {
  List<ChannelModel> list = [];
  List<Map<String, dynamic>> _channelList = [];

  bool _isLoading = true;

  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _channelList = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readFile();
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Flutter",
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.w600),
              ),
              Text(
                "TV",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
              )
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: ListView.builder(
          itemCount: _channelList.length,
          itemBuilder: (context, index) {
            return CustomListItem(
              link: _channelList[index]['link'],
              title: _channelList[index]['title'],
              thumbnail: Container(
                child: _channelList[index]['logo'].toString().isNotEmpty
                    ? Image.network(_channelList[index]['logo'])
                    : Icon(Icons.tv),
              ),
              viewCount: 1222,
            );
          },
        ));
  }

  Future<void> readFile() async {
    /* final source = await File('tha.m3u').readAsString();
    final m3u = await M3uParser.parse(source);
    */
    final response = await http.get(Uri.parse(
        'https://firebasestorage.googleapis.com/v0/b/api-master-3fb49.appspot.com/o/ara%2Fin.m3u?alt=media&token=4a4fd1c0-d2ad-45cf-88d7-d34155796b8a'));
    final m3u = await M3uParser.parse(response.body);

    for (final entry in m3u) {
      //add data on db
      _addItem(entry.title, entry.link, entry.attributes["tvg-logo"]);
      // add data on listview
      list.add(new ChannelModel(
          entry.title, entry.attributes!["tvg-logo"], entry.link));
    }
    //show on console data
    for (int i = 0; i < list.length; i++) {
      print(list[i].logo);
    }
  }

// Insert a new journal to the database
  Future<void> _addItem(String _title, String _link, String? _logo) async {
    await SQLHelper.createItem(_title, _link, _logo);
    _refreshJournals();
  }
}
