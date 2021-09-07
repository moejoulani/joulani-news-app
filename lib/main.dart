import 'package:flutter/material.dart';
import 'package:news_app/providers/article.dart';
import 'package:news_app/providers/articles.dart';
import 'package:news_app/providers/favorite.dart';
import 'package:news_app/screens/article_detail_screen.dart';
import 'package:news_app/screens/favorite_screen.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:news_app/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: Articles()),
        ChangeNotifierProvider.value(value: Favorite()),

//ChangeNotifierProvider.value(value: Article()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.red,
            accentColor: Colors.red,
          ),
          home: auth.isAuth
              ? HomeScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ArticleDetail.routeName: (_) => ArticleDetail(),
            AuthScreen.routeName: (_) => AuthScreen(),
            HomeScreen.routeName: (_) => HomeScreen(),
            FavoriteScreen.routeName: (_) => FavoriteScreen(),
          },
        ),
      ),
    );
  }
}
