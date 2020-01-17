import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'allPackages.dart';

class App {
  static String appName = "First Word";
  static String appVersion = "V 1.0.0";
  static String appAuthor = "Rehan Abbas";
  static bool isDebug = false;
  static bool showAds = true;

//  static String baseUrl = "http://192.168.43.54/firstword/public/api/";
  static String baseUrl = "Your Web Site";
//  static String publicImage = "http://192.168.43.54/firstword/public/storage/";
  static String publicImage = "Your Web Site";

  static Color blue = Color(0xFF4BABFF);
  static Color red = Color(0xFFFF6464);
  static Color yellow = Color(0xFFFFCC00);
  static Color green = Color(0xFF52DE97);
  static Color textColor = Color(0xFF1b262c);




  static Color bottomBarDisable = Color(0xFFD9E8FB);
  static Color bottomBarActive = Color(0xFF52DE97);

  static setStatusBarColor(Color color, Brightness icon) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: color,
        statusBarIconBrightness: icon,
      ),
    );
  }

  static String homeBanner = "Your Ad Id";
  static String exerciseAd = "Your Ad Id";
  static String detailsExerciseAd = "Your Ad Id";
  static String videoAd = "Your Ad Id";
  static String detailsVideoAd = "Your Ad Id";
  static String videoPlayerAds = "Your Ad Id";
  static String ExericseFullscreenAd = "";
  static String VideoFullscreenAd = "";

  static AdmobInterstitial interstitialAd;
  static FlutterTts flutterTts;
}
