import 'package:flutter/material.dart';
import 'package:news_app/providers/favorite.dart';
import 'package:provider/provider.dart';

class ArticleListFav extends StatelessWidget {
  final String title;
  final String author;
  final String imageUrl;
  ArticleListFav(
      {@required this.title, @required this.author, @required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    final articlesData = Provider.of<Favorite>(context);
    //final List<Favorite> articles = articlesData.arts;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Hero(
            tag: title,
            child: FadeInImage(
              placeholder: AssetImage('assets/paper2.jpg'),
              image: (imageUrl == null)
                  ? AssetImage('assets/paper2.jpg')
                  : NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.red),
              padding: EdgeInsets.all(10),
              child: author != null
                  ? Text(
                      author,
                      style: TextStyle(color: Colors.white),
                    )
                  : Text(
                      "Author not available",
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
