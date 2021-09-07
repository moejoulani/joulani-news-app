import 'package:flutter/material.dart';
import 'package:news_app/providers/favorite.dart';
import 'package:news_app/screens/auth_screen.dart';
import 'package:news_app/screens/favorite_screen.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 4,
      child: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.red],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  "assets/avatar.png",
                  width: 70,
                  height: 70,
                  fit: BoxFit.fill,
                ),
                Text(
                  "Welcome Mr " + Provider.of<Auth>(context).userName,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home "),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text("My Favorite Articles  "),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(FavoriteScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(" My Profile"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
              Provider.of<Favorite>(context, listen: false).clear();
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pushNamed(AuthScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
