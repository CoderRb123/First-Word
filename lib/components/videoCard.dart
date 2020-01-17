import 'package:first_word/components/VideoPlayer.dart';
import 'package:first_word/screens/VideoDetails.dart';
import 'package:first_word/utils/allPackages.dart';

class VideoCard extends StatelessWidget {
  final int from;
  final int id;
  final String Title;
  final String Image;
  final String videoLink;

  const VideoCard(
      {Key key, this.from, this.Title, this.Image, this.id, this.videoLink})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.35,
      margin: EdgeInsets.only(
        top: height * 0.005,
        bottom: height * 0.005,
        left: width * 0.025,
        right: width * 0.025,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          if (from == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoDetails(
                  id: id,
                  title: Title,
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPlayer(
                  id: id,
                  Image: Image,
                  Title: Title,
                  videoLink: videoLink,
                ),
              ),
            );
          }
        },
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 9,
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      Image,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  Title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: App.textColor,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
