import 'package:first_word/screens/DetailItem.dart';
import 'package:first_word/screens/ExerciseDetails.dart';
import 'package:first_word/utils/allPackages.dart';

class ItemCard extends StatelessWidget {
  final String url;
  final int id;
  final int from;
  final int to;
  final String Title;
  final String hotWord;

  const ItemCard({Key key, this.url, this.Title, this.id, this.from, this.to, this.hotWord})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        if (to == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExerciseDetails(
                id: id,
                imageUrl: url,
                title: Title,
                from: from,
              ),
            ),
          );
        } else if (to == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailItem(
                id: id,
                url: url,
                Title: Title,
                from: from,
                hotWord: hotWord,
              ),
            ),
          );
        }
      },
      child: Container(
        height: height * 0.3,
        width: width * 0.5,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 8,
              child: Container(
                child: Image.network(
                  url,
                  height: height * 0.15,
                  width: height * 0.15,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  Title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: App.textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
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
