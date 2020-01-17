import 'package:first_word/utils/allPackages.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    App.setStatusBarColor(Colors.white, Brightness.dark);
    super.initState();
    Future.delayed(
      Duration(seconds: 2),
    ).then((val) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Base(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image.asset(
              'assets/images/Logo.png',
              height: 150,
              width: 150,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: height * 0.02),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "Fir",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: App.blue,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: "st",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: App.green,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: " Wo",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: App.yellow,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: "rd",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: App.red,
                        fontSize: 25,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
