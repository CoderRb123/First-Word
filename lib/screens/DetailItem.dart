import 'dart:convert';

import 'package:first_word/utils/allPackages.dart';
import 'package:http/http.dart' as http;

class DetailItem extends StatefulWidget {
  final int id;
  final int from;
  final String url;
  final String Title;
  final String hotWord;

  const DetailItem({Key key, this.url, this.Title, this.id, this.from, this.hotWord})
      : super(key: key);

  @override
  _DetailItemState createState() => _DetailItemState();
}

class _DetailItemState extends State<DetailItem> {
  bool isPlaying = true;

  @override
  void initState() {
    countView();
    App.setStatusBarColor(App.yellow, Brightness.light);
    super.initState();
    App.flutterTts.setStartHandler(() {
      setState(() {
        isPlaying = true;
      });
    });

    App.flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });

    App.flutterTts.setErrorHandler((msg) {
      setState(() {
        isPlaying = false;
      });
    });
    _speak();
  }

  Future _speak() async {
    App.flutterTts.speak(widget.hotWord != null ? widget.hotWord : "No Word");
  }

  Future _stop() async {
    App.flutterTts.stop();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: Scaffold(
            backgroundColor: App.yellow,
            body: Column(
              children: <Widget>[
                Container(
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.solidArrowAltCircleLeft,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    title: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          right: width * 0.13, top: height * 0.01),
                      child: TitleCustom(
                        Title: widget.Title,
                        accent: Color(0xFFFFAB00),
                        primary: Colors.white,
                        size: 25.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.only(
                        left: width * 0.03,
                        right: width * 0.03,
                      ),
                      height: height * 0.75,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 8,
                            child: Hero(
                              tag: "listitem" + widget.id.toString(),
                              child: Container(
                                child: Image.network(
                                  widget.url,
                                  height: 250,
                                  width: 250,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () {
                                  !isPlaying ? _speak() : _stop();
                                },
                                child: Icon(
                                  !isPlaying
                                      ? FontAwesomeIcons.solidPlayCircle
                                      : FontAwesomeIcons.solidPauseCircle,
                                  color: App.yellow,
                                  size: 70,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void countView() async {
    var countresponse = await http.get(
      App.baseUrl + 'addviewexedetails/' + widget.id.toString(),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    Map latestMap = jsonDecode(countresponse.body);
    if (latestMap['Success'] == true) {
      print("Ok");
    } else {
      print("Wrong");
    }
  }

  @override
  void dispose() {
    if (widget.from == 1) {
      App.setStatusBarColor(App.yellow, Brightness.light);
    } else if (widget.from == 0) {
      App.setStatusBarColor(App.green, Brightness.light);
    } else {
      App.setStatusBarColor(App.yellow, Brightness.light);
    }
    super.dispose();
  }
}
