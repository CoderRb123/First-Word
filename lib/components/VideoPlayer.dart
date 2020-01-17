import 'dart:convert';

import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:first_word/components/NativeAd.dart';
import 'package:first_word/utils/allPackages.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  final int id;
  final String Title;
  final String Image;
  final String videoLink;

  const VideoPlayer({Key key, this.id, this.Title, this.Image, this.videoLink})
      : super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  bool isLoading;
  YoutubePlayerController _controller;
  FacebookNativeAd nativeAd;

  @override
  void initState() {
    countView();
    loadAdvertisment();
    App.setStatusBarColor(Colors.white, Brightness.dark);
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoLink,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: height * 0.01),
              child: ListTile(
                leading: IconButton(
                  icon: Icon(
                    FontAwesomeIcons.solidArrowAltCircleLeft,
                    color: Color(0xFFF0134D),
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Container(
                  alignment: Alignment.center,
                  margin:
                      EdgeInsets.only(right: width * 0.13, top: height * 0.01),
                  child: TitleCustom(
                    Title: widget.Title,
                    accent: Colors.white,
                    primary: Color(0xFFF0134D),
                    size: 25.0,
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 9,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: YoutubePlayer(
                          controller: _controller,
                          progressColors: ProgressBarColors(
                              backgroundColor: Color(0xFFF0134D),
                              bufferedColor: Color(0xFFF0134D).withOpacity(0.5),
                              handleColor: Color(0xFFF0134D),
                              playedColor: Color(0xFFF0134D)),
                          showVideoProgressIndicator: true,
                          bufferIndicator: CircularProgressIndicator(),
                          aspectRatio: 20,
                          liveUIColor: Colors.amber,
                          progressIndicatorColor: Color(0xFFF0134D),
                          thumbnailUrl: widget.Image,
                          bottomActions: [
                            CurrentPosition(),
                            SizedBox(width: 10.0),
                            ProgressBar(isExpanded: true),
                            SizedBox(width: 10.0),
                            RemainingDuration(),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: NativeAd(
                        nativeAd: nativeAd,
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void countView() async {
    var countresponse = await http.get(
      App.baseUrl + 'addviewvideoDetails/' + widget.id.toString(),
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

  loadAdvertisment() {
    if (!App.showAds) {
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

  @override
  void dispose() {
    App.setStatusBarColor(App.red, Brightness.light);
    super.dispose();
  }
}
