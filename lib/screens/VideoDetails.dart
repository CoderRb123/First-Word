import 'dart:convert';

import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:first_word/components/Loader.dart';
import 'package:first_word/components/NativeAd.dart';
import 'package:first_word/components/videoCard.dart';
import 'package:first_word/models/VideoDetailsModel.dart';
import 'package:first_word/utils/allPackages.dart';
import 'package:http/http.dart' as http;

class VideoDetails extends StatefulWidget {
  final int id;
  final String title;

  const VideoDetails({Key key, this.id, this.title}) : super(key: key);

  @override
  _VideoDetailsState createState() => _VideoDetailsState();
}

class _VideoDetailsState extends State<VideoDetails> {
  bool isData = true;
  bool isLoading = true;
  FacebookNativeAd nativeAd;
  VideoDetailsModel _videoDetailsModel;
  List<VideoDetailsModel> _listvideoDetailsModel = [];
  String nextPage;
  ScrollController _scrollController = new ScrollController();
  @override
  void initState() {
    countView();
    nextPage = App.baseUrl + "videoDetailspaginated/"+widget.id.toString();
    loadAdvertisment();
    getdata();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: App.red,
        body: Column(
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
                    accent: Color(0xFFF0134D),
                    primary: Colors.white,
                    size: 25.0,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount:_listvideoDetailsModel.length+1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == _listvideoDetailsModel.length) {
                    if (isData) {
                      return Loader();
                    } else {
                      return Container();
                    }
                  } else {
                    return VideoCard(
                      from: 1,
                      Title: _listvideoDetailsModel[index].Title,
                      Image: App.publicImage +
                          _listvideoDetailsModel[index].Image.split('/')[1],
                      id: _listvideoDetailsModel[index].id,
                      videoLink: _listvideoDetailsModel[index].videoLink,
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
  void countView() async {
    var countresponse = await http.get(
      App.baseUrl + 'addviewvideo/' + widget.id.toString(),
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
        print("videos ===> $_temppro");
        for (int i = 0; i < _temppro.length; i++) {
          _videoDetailsModel = VideoDetailsModel.fromJson(responseMap['videos']['data'][i]);
          _listvideoDetailsModel.add(_videoDetailsModel);
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
      print("Error on exedetails Fetching ==> " + err.toString());
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
