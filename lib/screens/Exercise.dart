import 'dart:convert';

import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:first_word/components/ItemCard.dart';
import 'package:first_word/components/Loader.dart';
import 'package:first_word/components/NativeAd.dart';
import 'package:first_word/utils/allPackages.dart';
import 'package:http/http.dart' as http;

class Exercise extends StatefulWidget {
  @override
  _ExerciseState createState() => _ExerciseState();
}

class _ExerciseState extends State<Exercise> {
  bool isLoading = true;
  FacebookNativeAd nativeAd;
  popularItems _popularitem;
  bool isData = true;
  List<popularItems> _listpopularitem = [];
  String nextPage = App.baseUrl + "exercisepaginated";
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    App.setStatusBarColor(App.yellow, Brightness.light);
    super.initState();
    getdata();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (isData) {
          getdata();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: Scaffold(
        backgroundColor: App.yellow,
        body:isLoading? Loader(): Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin:
              EdgeInsets.only(left: width * 0.02, top: height * 0.02),
              child: TitleCustom(
                Title: "Exercise",
                accent: Color(0xFFFFAB00),
                primary: Colors.white,
                size: 25.0,
              ),
            ),
            Expanded(
              child: Theme(
                data: ThemeData(highlightColor: Colors.white),
                child: Scrollbar(
                  child: ListView.separated(
                    controller: _scrollController,
                    shrinkWrap: true,
                    addAutomaticKeepAlives: true,
                    itemCount: _listpopularitem.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == _listpopularitem.length) {
                        if (isData) {
                          return Loader();
                        } else {
                          return Container();
                        }
                      } else {
                        return Container(
                          padding: EdgeInsets.only(
                              left: width * 0.02,
                              right: width * 0.02,
                              top: height * 0.01,
                              bottom: height * 0.01),
                          child: ItemCard(
                            Title: _listpopularitem[index].Title,
                            url: App.publicImage +
                                _listpopularitem[index]
                                    .imgUrl
                                    .split('/')[1],
                            id: _listpopularitem[index].id,
                            from: 0,
                            to: 0,
                          ),
                        );
                      }
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      int customindex = index + 1;
                      if (customindex % 5 == 0) {
                        return NativeAd(
                          nativeAd: nativeAd,
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  loadAdvertisment() {
    if(!App.showAds)
    {
      return;
    }
    if (_listpopularitem.length > 5) {
      nativeAd = FacebookNativeAd(
        placementId: "491619161737512_491649995067762",
        adType: NativeAdType.NATIVE_AD,
        width: double.infinity,
        height: 300,
        backgroundColor: Colors.white,
        keepAlive: true,
        titleColor: Colors.black,
        descriptionColor: Colors.black,
        buttonColor: App.yellow,
        buttonTitleColor: Colors.white,
        buttonBorderColor: Colors.white,
        listener: (result, value) {
          setState(() {
            isLoading = false;
          });
        },
      );
    }
  }

  getdata() async {

    try {
      var response = await http.get(
        nextPage,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      Map responseMap = jsonDecode(response.body);
      if (responseMap['Success'] == true) {
        if (responseMap['exercise']['next_page_url'] != null) {
          setState(() {
            nextPage = responseMap['exercise']['next_page_url'];
            isData = true;
          });
        } else {
          if (isData) {
            setState(() {
              isData = false;
            });
          } else {
            return;
          }
        }
        List _temppro = [];
        _temppro = responseMap['exercise']['data'];
        for (int i = 0; i < _temppro.length; i++) {
          _popularitem =
              popularItems.fromJson(responseMap['exercise']['data'][i]);
          _listpopularitem.add(_popularitem);
          setState(() {});
        }
        loadAdvertisment();
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (err) {
      print("Error on Slides Fetching ==> " + err.toString());
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
