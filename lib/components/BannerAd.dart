import 'dart:io';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:first_word/utils/allPackages.dart';

class MyBanner extends StatefulWidget {
  final FacebookNativeAd ads;

  const MyBanner({Key key, this.ads}) : super(key: key);

  @override
  _MyBannerState createState() => _MyBannerState();
}

class _MyBannerState extends State<MyBanner> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  bool isError = false;

  @override
  void initState() {
    print(widget.ads);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.ads != null
        ? Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  child: Center(
                    child: Text("This Space Is For Advertisment"),
                  ),
                ),
                Container(
                  child: FacebookNativeAd(
                      placementId: App.homeBanner,
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
                      listener: AdListner),
                )
              ],
            ),
          )
        : Container();
  }

  void AdListner(result, value) {
    if (result == NativeAdResult.ERROR) {
      setState(() {
        isError = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    return null;
  }
}
