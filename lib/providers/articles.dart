import 'dart:convert';

import 'package:flutter/material.dart';
import './article.dart';
import 'package:http/http.dart' as http;

class Articles extends ChangeNotifier {
  List<Article> _art = [];
  List<Article> get art {
    return this._art;
  }

  Article findById(String id) {
    return _art.firstWhere((element) => element.title == id);
  }

  Future<void> fetchAndSetData([String search]) async {
    if (search != null) {
      var url =
          "https://newsapi.org/v2/top-headlines?q=$search&apiKey=e71853ac8f6b4d4da87fd0df4e7c2e1c";
      try {
        var res = await http.get(Uri.parse(url));
        final Map<String, dynamic> extractedData =
            json.decode(res.body) as Map<String, dynamic>;
        if (extractedData == null) {
          return;
        } else {
          final List<Article> loadedArt = [];
          extractedData.forEach((key, value) {
            (extractedData['articles'] as List<dynamic>)
                .map((e) => {
                      loadedArt.add(Article(
                          id: "1",
                          title: e['title'],
                          author: e['author'],
                          content: e['content'],
                          articleDate: e['publishedAt'],
                          description: e['description'],
                          imageUrl: e['urlToImage']))
                    })
                .toList();
          });
          _art = loadedArt;
          notifyListeners();
        }
      } catch (e) {}
    } else {
      var url =
          "https://newsapi.org/v2/everything?q=tesla&from=2021-08-06&sortBy=publishedAt&apiKey=e71853ac8f6b4d4da87fd0df4e7c2e1c";
      try {
        var res = await http.get(Uri.parse(url));
        final Map<String, dynamic> extractedData =
            json.decode(res.body) as Map<String, dynamic>;
        if (extractedData == null) {
          return;
        } else {
          final List<Article> loadedArt = [];
          extractedData.forEach((key, value) {
            (extractedData['articles'] as List<dynamic>)
                .map((e) => {
                      loadedArt.add(Article(
                          id: "1",
                          title: e['title'],
                          author: e['author'],
                          content: e['content'],
                          articleDate: e['publishedAt'],
                          description: e['description'],
                          imageUrl: e['urlToImage']))
                    })
                .toList();
          });
          _art = loadedArt;
          notifyListeners();
        }
      } catch (e) {}
    }
  }
}
