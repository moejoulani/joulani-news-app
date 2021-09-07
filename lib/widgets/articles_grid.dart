import 'package:flutter/material.dart';
import 'package:news_app/providers/article.dart';
import 'package:news_app/providers/articles.dart';
import 'package:provider/provider.dart';
import './articleItem.dart';

class ArticlesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final articlesData = Provider.of<Articles>(context);
    final List<Article> articles = articlesData.art;

    return articles.isEmpty
        ? Center(
            child: Text("There Are No Articles Available ! "),
          )
        : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            padding: EdgeInsets.all(10.0),
            itemCount: articles.length,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: articles[i],
              child: ArticleItem(),
            ),
          );
  }
}
