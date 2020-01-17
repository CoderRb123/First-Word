import 'dart:convert';

import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:first_word/components/Loader.dart';
import 'package:first_word/components/NativeAd.dart';
import 'package:first_word/components/videoCard.dart';
import 'package:first_word/models/VideoModel.dart';
import 'package:first_word/utils/allPackages.dart';
import 'package:http/http.dart' as http;

class Video extends StatefulWidget {
  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  bool isData = true;
  bool isLoading = true;
  FacebookNativeAd nativeAd;
  VideoModel _videoModel;
  List<VideoModel> _listvideoModel = [];
  String nextPage;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    nextPage = App.baseUrl + "videopaginated";
    loadAdvertisment();
    getdata();
    App.setStatusBarColor(App.red, Brightness.light);
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: App.red,
        body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                margin:
                    EdgeInsets.only(top: height * 0.015, left: width * 0.02),
                child: TitleCustom(
                  Title: "Video",
                  size: 25.0,
                  primary: Colors.white,
                  accent: Color(0xFFF0134D),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  padding: EdgeInsets.only(
                    top: 0,
                    bottom: 10,
                  ),
                  itemCount: _listvideoModel.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == _listvideoModel.length) {
                      if (isData) {
                        return Loader();
                      } else {
                        return Container();
                      }
                    } else {
                      return VideoCard(
                        from: 0,
                        Title: _listvideoModel[index].Title,
                        Image: App.publicImage +
                            _listvideoModel[index].Image.split('/')[1],
                        id: _listvideoModel[index].id,
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
        if (responseMap['videos']['next_page_url'] != null) {
          setState(() {
            nextPage = responseMap['videos']['next_page_url'];
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
        _temppro = responseMap['videos']['data'];
        for (int i = 0; i < _temppro.length; i++) {
          _videoModel = VideoModel.fromJson(responseMap['videos']['data'][i]);
          _listvideoModel.add(_videoModel);
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
