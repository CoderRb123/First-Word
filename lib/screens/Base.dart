import '../utils/allPackages.dart';

class Base extends StatefulWidget {
  @override
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<Base> {
  @override
  void initState() {
    super.initState();
  }

  int _cIndex = 0;
  List<Widget> _children = [
    Home(),
    Exercise(),
    Video(),
  ];

  void _incrementTab(index) {
    switch (index) {
      case 0:
        App.setStatusBarColor(App.green, Brightness.light);
        break;
      case 1:
        App.setStatusBarColor(App.yellow, Brightness.light);
        break;
      case 2:
        App.setStatusBarColor(App.red, Brightness.light);
        break;
      default:
        App.setStatusBarColor(App.green, Brightness.light);
        break;
    }
    setState(
      () {
        _cIndex = index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          elevation: 1,
          currentIndex: _cIndex,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          unselectedFontSize: 11,
          showUnselectedLabels: true,
          unselectedItemColor: App.bottomBarDisable,
          selectedItemColor: _cIndex == 0
              ? App.green
              : _cIndex == 1
                  ? App.yellow
                  : _cIndex == 2 ? App.red : App.bottomBarDisable,
          unselectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: App.bottomBarDisable,
              fontSize: 11),
          selectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 11,
            color: _cIndex == 0
                ? App.green
                : _cIndex == 1
                    ? App.yellow
                    : _cIndex == 2 ? App.red : App.bottomBarDisable,
          ),
          items: [
            BottomNavigationBarItem(
              activeIcon: Container(
                margin: EdgeInsets.only(top: height * 0.015),
                child: Icon(
                  FontAwesomeIcons.rocket,
                  color: App.green,
                ),
              ),
              icon: Container(
                margin: EdgeInsets.only(top: height * 0.015),
                child: Icon(
                  FontAwesomeIcons.rocket,
                  color: App.bottomBarDisable,
                ),
              ),
              title: new Text('Home'),
            ),
            BottomNavigationBarItem(
              activeIcon: Container(
                margin: EdgeInsets.only(top: height * 0.015),
                child: Icon(
                  FontAwesomeIcons.futbol,
                  color: App.yellow,
                ),
              ),
              icon: Container(
                margin: EdgeInsets.only(top: height * 0.015),
                child: Icon(
                  FontAwesomeIcons.futbol,
                  color: App.bottomBarDisable,
                ),
              ),
              title: new Text('Exercise'),
            ),
            BottomNavigationBarItem(
              activeIcon: Container(
                margin: EdgeInsets.only(top: height * 0.015),
                child: Icon(
                  FontAwesomeIcons.youtube,
                  color: App.red,
                ),
              ),
              icon: Container(
                margin: EdgeInsets.only(top: height * 0.015),
                child: Icon(
                  FontAwesomeIcons.youtube,
                  color: App.bottomBarDisable,
                ),
              ),
              title: new Text(
                'Video',
              ),
            ),
          ],
          onTap: (index) {
            _incrementTab(index);
          },
        ),
        body: _children[_cIndex],
      ),
    );
  }
}
