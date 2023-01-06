import 'package:core/common/constants.dart';
import 'package:movie/presentation/bloc/movie/now_playing_movie_bloc.dart';
import 'package:movie/presentation/bloc/movie/popular_movie_bloc.dart';
import 'package:movie/presentation/bloc/movie/top_rated_movie_bloc.dart';
import 'package:movie/presentation/pages/movie/movie_detail_page.dart';
import 'package:movie/presentation/pages/movie/popular_movies_page.dart';
import 'package:movie/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:core/widgets/poster_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeMoviePage extends StatefulWidget {
  const HomeMoviePage({Key? key}) : super(key: key);

  @override
  State<HomeMoviePage> createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NowPlayingMovieBloc>().add(OnFetchNowPlayingMovie());
      context.read<TopRatedMovieBloc>().add(OnFetchTopRatedMovie());
      context.read<PopularMovieBloc>().add(OnFetchPopularMovie());
    });
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
          BlocBuilder<NowPlayingMovieBloc, NowPlayingMovieState>(
              builder: (context, state) {
            if (state is NowPlayingMovieLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is NowPlayingMovieHasData) {
              List<PosterCardData> posterCards = state.result
                  .map((e) => PosterCardData(e.posterPath ?? ""))
                  .toList();
              return PosterCardList(
                  items: posterCards,
                  onTap: (index) {
                    Navigator.pushNamed(
                      context,
                      MovieDetailPage.ROUTE_NAME,
                      arguments: state.result[index].id,
                    );
                  });
            } else {
              return const Text('Failed');
            }
          }),
          _buildSubHeading(
            title: 'Popular Movie',
            onTap: () =>
                Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
          ),
          BlocBuilder<PopularMovieBloc, PopularMovieState>(
              builder: (context, state) {
            if (state is PopularMovieLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularMovieHasData) {
              List<PosterCardData> posterCards = state.result
                  .map((e) => PosterCardData(e.posterPath ?? ""))
                  .toList();
              return PosterCardList(
                items: posterCards,
                onTap: (index) {
                  Navigator.pushNamed(
                    context,
                    MovieDetailPage.ROUTE_NAME,
                    arguments: state.result[index].id,
                  );
                },
              );
            } else {
              return const Text('Failed');
            }
          }),
          _buildSubHeading(
            title: 'Top Rated Movie',
            onTap: () =>
                Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
          ),
          BlocBuilder<TopRatedMovieBloc, TopRatedMovieState>(
              builder: (context, state) {
            if (state is TopRatedMovieLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedMovieHasData) {
              List<PosterCardData> posterCards = state.result
                  .map((e) => PosterCardData(e.posterPath ?? ""))
                  .toList();
              return PosterCardList(
                  items: posterCards,
                  onTap: (index) {
                    Navigator.pushNamed(
                      context,
                      MovieDetailPage.ROUTE_NAME,
                      arguments: state.result[index].id,
                    );
                  });
            } else {
              return const Text('Failed');
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
              children: const [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}
