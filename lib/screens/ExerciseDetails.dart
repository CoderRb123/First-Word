import 'dart:convert';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:first_word/components/ItemCard.dart';
import 'package:first_word/components/Loader.dart';
import 'package:first_word/components/NativeAd.dart';
import 'package:first_word/models/ItemListModel.dart';
import 'package:first_word/utils/allPackages.dart';
import 'package:http/http.dart' as http;

class ExerciseDetails extends StatefulWidget {
  final int id;
  final String imageUrl;
  final int from;
  final String title;

  const ExerciseDetails(
      {Key key, this.id, this.imageUrl, this.title, this.from})
      : super(key: key);

  @override
  _ExerciseDetailsState createState() => _ExerciseDetailsState();
}

class _ExerciseDetailsState extends State<ExerciseDetails> {
  bool isLoading = true;

  FacebookNativeAd nativeAd;
  ItemListModel _itemListModel;
  bool isData = true;
  List<ItemListModel> _listmodelItem = [];
  String nextPage;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    nextPage = App.baseUrl + 'exerciseDetailspaginated/' + widget.id.toString();
    countView();
    loadAdvertisment();
    getdata();
    App.setStatusBarColor(App.yellow, Brightness.light);
    super.initState();
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
      child: SafeArea(
        child: Scaffold(
          backgroundColor: App.yellow,
          body: isLoading
              ? Loader()
              : Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: height * 0.01),
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
                            Title: widget.title,
                            accent: Color(0xFFFFAB00),
                            primary: Colors.white,
                            size: 25.0,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.only(bottom: height * 0.05),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        controller: _scrollController,
                        itemCount: _listmodelItem.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == _listmodelItem.length) {
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
                                  top: height * 0.01),
                              child: ItemCard(
                                Title: _listmodelItem[index].Title,
                                url: App.publicImage +
                                    _listmodelItem[index].imgUrl.split('/')[1],
                                id: _listmodelItem[index].id,
                                from: 1,
                                to: 1,
                                hotWord: _listmodelItem[index].hotWord,
                              ),
                            );
                          }
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          int customindex = index + 1;
                          if (customindex % 3 == 0) {
                            return NativeAd(
                              nativeAd: nativeAd,
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  loadAdvertisment() {
    if(!App.showAds)
    {
      return;
    }
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
        print("Native Ad: $result --> $value");
        setState(() {
          isLoading = false;
        });
      },
    );
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
          _itemListModel =
              ItemListModel.fromJson(responseMap['exercise']['data'][i]);
          _listmodelItem.add(_itemListModel);
        }
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
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void countView() async {
    var countresponse = await http.get(
      App.baseUrl + 'addviewexe/' + widget.id.toString(),
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
      App.setStatusBarColor(App.green, Brightness.light);
    } else if (widget.from == 0) {
      App.setStatusBarColor(App.yellow, Brightness.light);
    } else {
      App.setStatusBarColor(App.green, Brightness.light);
    }
    _scrollController.dispose();
    super.dispose();
  }
}
