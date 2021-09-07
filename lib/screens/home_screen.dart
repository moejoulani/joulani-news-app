import 'package:flutter/material.dart';
import 'package:news_app/providers/articles.dart';
import 'package:news_app/widgets/articles_grid.dart';
import 'package:news_app/widgets/myDrawer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  static final routeName = "/home-screen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SearchBar searchBar;
  bool _isLoadingxx = false;
  AppBar buildAppBar(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return new AppBar(
        title: new Text('News App'),
        actions: [searchBar.getSearchAction(context)]);
  }

  void onSubmitted(String value) {
    setState(() => _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text('You wrote $value!'))));
  }

  _HomeScreenState() {
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: (value) {
          _isLoading = true;

          Provider.of<Articles>(context, listen: false)
              .fetchAndSetData("$value")
              .then((value) => {
                    setState(() {
                      _isLoading = false;
                    })
                  });
        },
        buildDefaultAppBar: buildAppBar);
  }

  var _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = true;
    Provider.of<Articles>(context, listen: false)
        .fetchAndSetData()
        .then((value) => {
              setState(() {
                _isLoading = false;
              })
            })
        .catchError((e) {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // return AppBar(
    //   title: Text("News App"),
    //   actions: [searchBar.getSearchAction(context)],
    // );
    return Scaffold(
      appBar: searchBar.build(context),
      drawer: MyDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ArticlesList(),
    );
  }
}
