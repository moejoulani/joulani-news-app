import 'package:flutter/material.dart';
import 'package:news_app/providers/favorite.dart';
import 'package:news_app/widgets/ArticleListFav.dart';
import 'package:news_app/widgets/articles_grid.dart';
import 'package:news_app/widgets/myDrawer.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  static final routeName = "/fav-s";
  @override
  Widget build(BuildContext context) {
    final fav = Provider.of<Favorite>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Favorite Articles"),
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          Text(
            "Your Favorites ",
            style: TextStyle(fontSize: 25),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: fav.artCount,
              itemBuilder: (tx, int index) => ArticleListFav(
                  title: fav.arts.values.toList()[index].title,
                  author: fav.arts.values.toList()[index].author,
                  imageUrl: fav.arts.values.toList()[index].imageUrl),
            ),
          )
        ],
      ),
    );
  }
}
