import 'package:flutter/material.dart';
import 'package:news_app/providers/article.dart';
import 'package:news_app/screens/article_detail_screen.dart';
import 'package:provider/provider.dart';

class ArticleItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final article = Provider.of<Article>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ArticleDetail.routeName, arguments: article.title);
          },
          child: Hero(
            tag: article.title,
            child: FadeInImage(
              placeholder: AssetImage('assets/paper2.jpg'),
              image: (article.imageUrl == null)
                  ? AssetImage('assets/paper2.jpg')
                  : NetworkImage(article.imageUrl),
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
              child: article.author != null
                  ? Text(
                      article.author,
                      style: TextStyle(color: Colors.white),
                    )
                  : Text(
                      "Author not available",
                      style: TextStyle(color: Colors.white),
                    ),
            ),
            GridTileBar(
              subtitle: Text(article.articleDate),
              backgroundColor: Colors.black87,
              title: Text(
                article.title,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
