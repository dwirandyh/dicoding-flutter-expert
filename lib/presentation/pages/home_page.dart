import 'package:core/common/feature_page_route.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:movie/presentation/pages/movie/home_movie_page.dart';
import 'package:tv/presentation/pages/tv/home_tv_page.dart';
import 'package:movie/presentation/pages/movie/search_movie_page.dart';
import 'package:tv/presentation/pages/tv/search_tv_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedMenuIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        key: Key('home.drawer.drawer-menu'),
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                setState(() {
                  selectedMenuIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.tv),
              title: Text('TV Series'),
              onTap: () {
                setState(() {
                  selectedMenuIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, FeaturePageRoute.watchlistPage);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            key: Key('home.button.search-button'),
            onPressed: () {
              switch (selectedMenuIndex) {
                case 0:
                  Navigator.pushNamed(context, SearchMoviePage.ROUTE_NAME);
                  break;
                default:
                  Navigator.pushNamed(context, SearchTvPage.ROUTE_NAME);
              }
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildSelectedPage(),
      ),
    );
  }

  Widget _buildSelectedPage() {
    if (selectedMenuIndex == 0) {
      return HomeMoviePage();
    } else {
      return HomeTvPage();
    }
  }
}
