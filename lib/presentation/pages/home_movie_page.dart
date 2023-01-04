import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/movie/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/movie/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/presentation/widgets/poster_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeMoviePage extends StatefulWidget {
  const HomeMoviePage({Key? key}) : super(key: key);

  @override
  State<HomeMoviePage> createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Provider.of<MovieListNotifier>(context, listen: false)
          ..fetchNowPlayingMovies()
          ..fetchPopularMovies()
          ..fetchTopRatedMovies());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Now Playing Movie',
            style: kHeading6,
          ),
          Consumer<MovieListNotifier>(builder: (context, data, child) {
            final state = data.nowPlayingState;
            if (state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state == RequestState.Loaded) {
              List<PosterCardData> posterCards = data.nowPlayingMovies
                  .map((e) => PosterCardData(e.posterPath ?? ""))
                  .toList();
              return PosterCardList(
                  items: posterCards,
                  onTap: (index) {
                    Navigator.pushNamed(
                      context,
                      MovieDetailPage.ROUTE_NAME,
                      arguments: data.nowPlayingMovies[index].id,
                    );
                  });
            } else {
              return Text('Failed');
            }
          }),
          _buildSubHeading(
            title: 'Popular Movie',
            onTap: () =>
                Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
          ),
          Consumer<MovieListNotifier>(builder: (context, data, child) {
            final state = data.popularMoviesState;
            if (state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state == RequestState.Loaded) {
              List<PosterCardData> posterCards = data.popularMovies
                  .map((e) => PosterCardData(e.posterPath ?? ""))
                  .toList();
              return PosterCardList(
                  items: posterCards,
                  onTap: (index) {
                    Navigator.pushNamed(
                      context,
                      MovieDetailPage.ROUTE_NAME,
                      arguments: data.popularMovies[index].id,
                    );
                  });
            } else {
              return Text('Failed');
            }
          }),
          _buildSubHeading(
            title: 'Top Rated Movie',
            onTap: () =>
                Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
          ),
          Consumer<MovieListNotifier>(builder: (context, data, child) {
            final state = data.topRatedMoviesState;
            if (state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state == RequestState.Loaded) {
              List<PosterCardData> posterCards = data.topRatedMovies
                  .map((e) => PosterCardData(e.posterPath ?? ""))
                  .toList();
              return PosterCardList(
                  items: posterCards,
                  onTap: (index) {
                    Navigator.pushNamed(
                      context,
                      MovieDetailPage.ROUTE_NAME,
                      arguments: data.topRatedMovies[index].id,
                    );
                  });
            } else {
              return Text('Failed');
            }
          }),
        ],
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: kHeading6,
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}
