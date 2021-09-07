import 'package:flutter/material.dart';

class Article with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String articleDate;
  final String author;
  final String content;
  Article({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.articleDate,
    @required this.author,
    @required this.content,
  });
}
