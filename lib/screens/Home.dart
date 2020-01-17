import 'dart:convert';

import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:first_word/components/BannerAd.dart';
import 'package:first_word/components/ItemCard.dart';
import 'package:first_word/components/Loader.dart';
import 'package:first_word/utils/allPackages.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  FacebookNativeAd bannerAd;
  popularItems _popularitem;
  List<popularItems> _listpopularitem = [];
  popularItems _latestItem;
  List<popularItems> _latestItemlist = [];

  @override
  void initState() {
    loadAds();
    getdata();
    App.setStatusBarColor(App.green, Brightness.light);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: App.green,
        body: isLoading
            ? Loader()
            : ScrollConfiguration(
                behavior: MyBehavior(),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(
                                top: height * 0.015, left: width * 0.02),
                            child: TitleCustom(
                              Title: "Popular",
                              size: 25.0,
                              primary: Colors.white,
                              accent: Color(0xFF0A965A),
                            ),
                          ),
                          Expanded(
                            child: Theme(
                              data: ThemeData(
                                highlightColor: Colors.white, //Does not work
                              ),
                              child: Scrollbar(
                                child: ListView.builder(
                                  padding: EdgeInsets.only(
                                      left: width * 0.03,
                                      right: width * 0.03,
                                      bottom: height * 0.01),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _listpopularitem.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      padding: EdgeInsets.all(5),
                                      child: ItemCard(
                                        Title: _listpopularitem[index].Title,
                                        url: App.publicImage +
                                            _listpopularitem[index]
                                                .imgUrl
                                                .split('/')[1],
                                        id: _listpopularitem[index].id,
                                        from: 1,
                                        to: 0,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: MyBanner(
                        ads: bannerAd,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                top: height * 0.015, left: width * 0.02),
                            child: TitleCustom(
                              Title: "Latest",
                              size: 25.0,
                              primary: Colors.white,
                              accent: Color(0xFF0A965A),
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                          Expanded(
                            child: Theme(
                              data: ThemeData(
                                highlightColor: Colors.white
                                    .withOpacity(0.3), //Does not work
                              ),
                              child: Scrollbar(
                                child: ListView.builder(
                                  padding: EdgeInsets.only(
                                    top: height * 0.001,
                                    bottom: height * 0.02,
                                    left: width * 0.03,
                                    right: width * 0.03,
                                  ),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _latestItemlist.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      padding: EdgeInsets.all(5),
                                      child: ItemCard(
                                        Title: _latestItemlist[index].Title,
                                        url: App.publicImage +
                                            _latestItemlist[index]
                                                .imgUrl
                                                .split('/')[1],
                                        id: _latestItemlist[index].id,
                                        from: 1,
                                        to: 0,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  void loadAds() {
    if(!App.showAds){
      return;
    }
    try{
      bannerAd = FacebookNativeAd(
        placementId: "491619161737512_491624588403636",
        adType: NativeAdType.NATIVE_BANNER_AD,
        bannerAdSize: NativeBannerAdSize.HEIGHT_100,
        width: double.infinity,
        backgroundColor: Colors.white,
        titleColor: Colors.black,
        descriptionColor: Colors.black,
        buttonColor: App.green,
        buttonTitleColor: Colors.white,
        buttonBorderColor: App.green,
        keepAlive: true,
      );
    }catch(err){
      print("error ===>" + err.toString() );
    }
    setState(() {});
  }

  getdata() async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await http.get(
        App.baseUrl + 'exercisepopular',
        headers: {
          'Content-Type': 'application/json',
        },
      );
      Map responseMap = jsonDecode(response.body);
      if (responseMap['Success'] == true) {
        List _temppro = [];
        _temppro = responseMap['exercise'];
        for (int i = 0; i < _temppro.length; i++) {
          _popularitem = popularItems.fromJson(responseMap['exercise'][i]);
          _listpopularitem.add(_popularitem);
        }
        getLatest();
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

  getLatest() async {
    var latestresponse = await http.get(
      App.baseUrl + 'exerciselatest',
      headers: {
        'Content-Type': 'application/json',
      },
    );
    Map latestMap = jsonDecode(latestresponse.body);
    if (latestMap['Success'] == true) {
      List _latesttemp = [];
      _latesttemp = latestMap['exercise'];
      for (int i = 0; i < _latesttemp.length; i++) {
        _latestItem = popularItems.fromJson(latestMap['exercise'][i]);
        _latestItemlist.add(_latestItem);
      }
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print("Wrong");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
