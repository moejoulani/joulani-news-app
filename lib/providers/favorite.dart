import 'package:flutter/material.dart';
import 'package:news_app/widgets/articleItem.dart';

class FavoriteArticle {
  final String id;
  final String title;

  final String imageUrl;

  final String author;

  FavoriteArticle({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
    @required this.author,
  });
}

class Favorite with ChangeNotifier {
  Map<String, FavoriteArticle> _art = {};
  Map<String, FavoriteArticle> get arts {
    return this._art;
  }

  int get artCount {
    return this._art.length;
  }

  void addItem(String title, String author, String imageUrl) {
    _art.putIfAbsent(
        title,
        () => FavoriteArticle(
            id: null, title: title, imageUrl: imageUrl, author: author));

    notifyListeners();
  }

  void clear() {
    _art.clear();
    notifyListeners();
  }
}
