import 'package:core/common/constants.dart';
import 'package:core/common/feature_page_route.dart';
import 'package:core/common/utils.dart';
import 'package:ditonton/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie/presentation/bloc/movie/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie/movie_recommendation_bloc.dart';
import 'package:movie/presentation/bloc/movie/now_playing_movie_bloc.dart';
import 'package:movie/presentation/bloc/movie/popular_movie_bloc.dart';
import 'package:movie/presentation/bloc/movie/search_movie_bloc.dart';
import 'package:movie/presentation/bloc/movie/top_rated_movie_bloc.dart';
import 'package:tv/presentation/bloc/tv/now_playing_tv_bloc.dart';
import 'package:tv/presentation/bloc/tv/popular_tv_bloc.dart';
import 'package:tv/presentation/bloc/tv/search_tv_bloc.dart';
import 'package:tv/presentation/bloc/tv/top_rated_tv_bloc.dart';
import 'package:tv/presentation/bloc/tv/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv/tv_recommendation_bloc.dart';
import 'package:watchlist/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:watchlist/presentation/bloc/watchlist/watchlist_status_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_page.dart';
import 'package:movie/presentation/pages/movie/movie_detail_page.dart';
import 'package:movie/presentation/pages/movie/home_movie_page.dart';
import 'package:movie/presentation/pages/movie/popular_movies_page.dart';
import 'package:movie/presentation/pages/movie/search_movie_page.dart';
import 'package:movie/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:tv/presentation/pages/tv/now_playing_tvs_page.dart';
import 'package:tv/presentation/pages/tv/popular_tvs_page.dart';
import 'package:tv/presentation/pages/tv/search_tv_page.dart';
import 'package:tv/presentation/pages/tv/top_rated_tvs_page.dart';
import 'package:tv/presentation/pages/tv/tv_detail_page.dart';
import 'package:watchlist/presentation/pages/watchlist_movies_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:core/network/ssl_pinning.dart';
import 'package:ditonton/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SSLPinning.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<MovieDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieRecommendationBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<NowPlayingMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistStatusBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<NowPlayingTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvRecommendationBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: HomePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchMoviePage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchMoviePage());
            case PopularTvsPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTvsPage());
            case TopRatedTvsPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTvsPage());
            case NowPlayingTvsPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => NowPlayingTvsPage());
            case SearchTvPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => SearchTvPage());
            case TvDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                  builder: (_) => TvDetailPage(id: id), settings: settings);
            case FeaturePageRoute.watchlistPage:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
