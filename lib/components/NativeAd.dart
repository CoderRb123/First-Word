import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:first_word/utils/allPackages.dart';

class NativeAd extends StatefulWidget {
  final FacebookNativeAd nativeAd;

  const NativeAd({Key key, this.nativeAd}) : super(key: key);

  @override
  _NativeAdState createState() => _NativeAdState();
}

class _NativeAdState extends State<NativeAd> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.nativeAd != null
        ? Container(
            height: 300,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(5),
            child: Stack(
              children: <Widget>[
                Container(
                  child: Center(
                    child: Text(
                      "This Space Is For Advertisment",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                widget.nativeAd
              ],
            ))
        : Container();
  }
}
