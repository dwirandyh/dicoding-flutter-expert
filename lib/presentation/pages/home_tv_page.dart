import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/tv_list_provider.dart';
import 'package:ditonton/presentation/widgets/poster_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTvPage extends StatefulWidget {
  const HomeTvPage({Key? key}) : super(key: key);

  @override
  State<HomeTvPage> createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(
            () => Provider.of<TvListNotifier>(context, listen: false)
          ..fetchNowPlayingTvs()
          ..fetchPopularTvs()
          ..fetchTopRatedTvs());
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Now Playing TV Series',
            style: kHeading6,
          ),
          Consumer<TvListNotifier>(builder: (context, data, child) {
            final state = data.nowPlayingState;
            if (state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state == RequestState.Loaded) {
              List<PosterCardData> posterCards = data.nowPlayingTvs.map((e) => PosterCardData(e.posterPath)).toList();
              return PosterCardList(items: posterCards, onTap: (index) {
                // Navigator.pushNamed(
                //   context,
                //   MovieDetailPage.ROUTE_NAME,
                //   arguments: data.nowPlayingMovies[index].id,
                // );
              });
            } else {
              return Text('Failed');
            }
          }),
          _buildSubHeading(
            title: 'Popular TV Series',
            onTap: () =>
                Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
          ),
          Consumer<TvListNotifier>(builder: (context, data, child) {
            final state = data.popularTvState;
            if (state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state == RequestState.Loaded) {
              List<PosterCardData> posterCards = data.popularTvs.map((e) => PosterCardData(e.posterPath ?? "")).toList();
              return PosterCardList(items: posterCards, onTap: (index) {
                // Navigator.pushNamed(
                //   context,
                //   MovieDetailPage.ROUTE_NAME,
                //   arguments: data.nowPlayingMovies[index].id,
                // );
              });
            } else {
              return Text('Failed');
            }
          }),
          _buildSubHeading(
            title: 'Top Rated TV Series',
            onTap: () =>
                Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
          ),
          Consumer<TvListNotifier>(builder: (context, data, child) {
            final state = data.topRatedTvsState;
            if (state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state == RequestState.Loaded) {
              List<PosterCardData> posterCards = data.topRatedTvs.map((e) => PosterCardData(e.posterPath ?? "")).toList();
              return PosterCardList(items: posterCards, onTap: (index) {
                // Navigator.pushNamed(
                //   context,
                //   MovieDetailPage.ROUTE_NAME,
                //   arguments: data.nowPlayingMovies[index].id,
                // );
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
        Text(
          title,
          style: kHeading6,
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
