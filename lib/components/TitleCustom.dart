import 'package:first_word/utils/allPackages.dart';

class TitleCustom extends StatelessWidget {
  final String Title;
  final Color primary;
  final Color accent;
  final double size;

  const TitleCustom(
      {Key key, this.Title, this.primary, this.accent, this.size = 17.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5),
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 5, top: 4),
              child: Text(
                Title != null ? Title : "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: size,
                  color: accent,
                ),
              ),
            ),
            Text(
              Title != null ? Title : "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: size,
                color: primary,
              ),
            ),
          ],
        ));
  }
}
