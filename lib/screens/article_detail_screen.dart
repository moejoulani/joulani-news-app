import 'package:flutter/material.dart';
import 'package:news_app/providers/articles.dart';
import 'package:news_app/providers/favorite.dart';
import 'package:provider/provider.dart';

class ArticleDetail extends StatelessWidget {
  static const routeName = "/article-detail-screen";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final articleId = ModalRoute.of(context).settings.arguments as String;
    final loadedArticle =
        Provider.of<Articles>(context, listen: false).findById(articleId);
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  Provider.of<Favorite>(context, listen: false).addItem(
                      loadedArticle.title,
                      loadedArticle.author,
                      loadedArticle.imageUrl);
                  _scaffoldKey.currentState.hideCurrentSnackBar();
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text("Added To Favorite"),
                    duration: Duration(seconds: 2),
                  ));
                },
                child: Row(
                  children: [
                    Icon(Icons.favorite),
                    Text("Add To Faviorte"),
                  ],
                ),
              ),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(Icons.done_all),
                    Text("Done"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedArticle.title),
              background: Hero(
                tag: loadedArticle.title,
                child: (loadedArticle.imageUrl == null)
                    ? Image.asset('assets/paper2.jpg')
                    : Image.network(
                        loadedArticle.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (tx, error, stackTrace) {
                          return Image.asset('assets/paper2.jpg');
                        },
                      ),

                // Image.network(
                //   loadedArticle.imageUrl,
                //   fit: BoxFit.cover,
                // ),
                /*
                (article.imageUrl == null)
                  ? AssetImage('assets/paper2.jpg')
                  : NetworkImage(article.imageUrl),
                */
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Text(
                loadedArticle.description,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Divider(),
            Container(
              decoration: BoxDecoration(),
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(10),
              child: Card(
                margin: EdgeInsets.all(20),
                elevation: 4,
                color: Colors.grey,
                shadowColor: Colors.black,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Content : " + loadedArticle.content,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ])),

          // Positioned(bottom: 0, right: 0, left: 0, child: Text("hello"))
          // Positioned(
          //   bottom: 0,
          //   right: 0,
          //   left: 0,
          //   child: Container(
          //     margin: EdgeInsets.only(left: 16, right: 16, bottom: 20),
          //     decoration: BoxDecoration(
          //       // borderRadius: BorderRadius.circular(22),

          //       borderRadius: BorderRadius.all(Radius.circular(200)),
          //       gradient: LinearGradient(
          //         colors: [Colors.indigo[900], Colors.deepOrange[300]],
          //         begin: Alignment.topLeft,
          //         end: Alignment.topRight,
          //         stops: [0.0, 0.8],
          //         tileMode: TileMode.clamp,
          //       ),
          //     ),
          //     child: BottomNavigationBar(
          //       // selectedIconTheme: ,
          //       // selectedIconTheme: ,
          //       // fixedColor: Colors.deepOrange,
          //       backgroundColor: Colors.transparent,
          //       type: BottomNavigationBarType.fixed,
          //       elevation: 0,
          //       selectedFontSize: 22,
          //       unselectedFontSize: 13,
          //       // iconSize: 22,
          //       // unselectedItemColor:Colors.indigo[900],
          //       unselectedItemColor: Colors.black,
          //       selectedItemColor: Colors.yellowAccent,
          //       showUnselectedLabels: false,
          //       showSelectedLabels: true,

          //       items: [
          //         // BottomNavigationBarItem(
          //         //   // icon:FaIcon(FontAwesomeIcons.solidCheckCircle,size: 22, ),
          //         //   icon:
          //         //       // ImageIcon(
          //         //       //   AssetImage("assets/images/Group 1383.png"),
          //         //       //   size: 32,
          //         //       // ),
          //         //       Icon(Icons.add),
          //         //   label: 'Cart',
          //         //   backgroundColor: Colors.deepOrange,
          //         // ),
          //         // BottomNavigationBarItem(
          //         //   // icon:FaIcon(FontAwesomeIcons.solidCheckCircle,size: 22, ),
          //         //   icon:
          //         //       // ImageIcon(
          //         //       //   AssetImage("assets/images/Group 1379.png"),
          //         //       //   size: 52,
          //         //       // ),
          //         //       Icon(Icons.add),
          //         //   label: 'Cart',
          //         //   backgroundColor: Colors.deepOrange,
          //         // ),
          //         // BottomNavigationBarItem(
          //         //   // icon:FaIcon(FontAwesomeIcons.solidCheckCircle,size: 22, ),
          //         //   icon:
          //         //       // ImageIcon(
          //         //       //   AssetImage("assets/images/Group 1419.png"),
          //         //       //   size: 32,
          //         //       // ),
          //         //       Icon(Icons.add),
          //         //   label: 'Cart',
          //         //   backgroundColor: Colors.deepOrange,
          //         // ),
          //         // BottomNavigationBarItem(
          //         //   // icon:FaIcon(FontAwesomeIcons.solidCheckCircle,size: 22, ),
          //         //   icon:
          //         //       // ImageIcon(
          //         //       //   AssetImage("assets/images/Group 1374.png"),
          //         //       //   size: 32,
          //         //       // ),
          //         //       Icon(Icons.add),
          //         //   label: 'Cart',
          //         //   backgroundColor: Colors.deepOrange,
          //         // ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
