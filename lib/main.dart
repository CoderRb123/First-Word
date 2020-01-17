import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:first_word/utils/allPackages.dart';
import 'package:flutter_tts/flutter_tts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize(getAppId());
  App.flutterTts = FlutterTts();
  await App.flutterTts.setVolume(50.0);
  App.interstitialAd = AdmobInterstitial(
    adUnitId: App.ExericseFullscreenAd,
    listener: (AdmobAdEvent event, Map<String, dynamic> args) {
      if (event == AdmobAdEvent.closed) App.interstitialAd.load();
    },
  );
  runApp(
    MaterialApp(
      title: App.appName,
      home: SplashScreen(),
      debugShowCheckedModeBanner: App.isDebug,
    ),
  );
}

String getAppId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544~1458002511';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544~3347511713';
  }
  return null;
}
