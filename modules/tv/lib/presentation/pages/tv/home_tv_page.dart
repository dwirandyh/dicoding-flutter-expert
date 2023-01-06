import 'package:core/common/constants.dart';
import 'package:tv/presentation/bloc/tv/now_playing_tv_bloc.dart';
import 'package:tv/presentation/bloc/tv/popular_tv_bloc.dart';
import 'package:tv/presentation/bloc/tv/top_rated_tv_bloc.dart';
import 'package:tv/presentation/pages/tv/now_playing_tvs_page.dart';
import 'package:tv/presentation/pages/tv/popular_tvs_page.dart';
import 'package:tv/presentation/pages/tv/top_rated_tvs_page.dart';
import 'package:tv/presentation/pages/tv/tv_detail_page.dart';
import 'package:core/widgets/poster_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTvPage extends StatefulWidget {
  const HomeTvPage({Key? key}) : super(key: key);

  @override
  State<HomeTvPage> createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NowPlayingTvBloc>().add(OnFetchNowPlayingTv());
      context.read<PopularTvBloc>().add(OnFetchPopularTv());
      context.read<TopRatedTvBloc>().add(OnFetchTopRatedTv());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubHeading(
            title: "Now Playing TV Series",
            onTap: () =>
                Navigator.pushNamed(context, NowPlayingTvsPage.ROUTE_NAME),
          ),
          BlocBuilder<NowPlayingTvBloc, NowPlayingTvState>(
              builder: (context, state) {
            if (state is NowPlayingTvLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is NowPlayingTvHasData) {
              List<PosterCardData> posterCards = state.result
                  .map((e) => PosterCardData(e.posterPath))
                  .toList();
              return PosterCardList(
                  items: posterCards,
                  onTap: (index) {
                    Navigator.pushNamed(
                      context,
                      TvDetailPage.ROUTE_NAME,
                      arguments: state.result[index].id,
                    );
                  });
            } else {
              return const Text('Failed');
            }
          }),
          _buildSubHeading(
            title: 'Popular TV Series',
            onTap: () =>
                Navigator.pushNamed(context, PopularTvsPage.ROUTE_NAME),
          ),
          BlocBuilder<PopularTvBloc, PopularTvState>(builder: (context, state) {
            if (state is PopularTvLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularTvHasData) {
              List<PosterCardData> posterCards = state.result
                  .map((e) => PosterCardData(e.posterPath ?? ""))
                  .toList();
              return PosterCardList(
                  items: posterCards,
                  onTap: (index) {
                    Navigator.pushNamed(
                      context,
                      TvDetailPage.ROUTE_NAME,
                      arguments: state.result[index].id,
                    );
                  });
            } else {
              return const Text('Failed');
            }
          }),
          _buildSubHeading(
            title: 'Top Rated TV Series',
            onTap: () =>
                Navigator.pushNamed(context, TopRatedTvsPage.ROUTE_NAME),
          ),
          BlocBuilder<TopRatedTvBloc, TopRatedTvState>(
              builder: (context, state) {
            if (state is TopRatedTvLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedTvHasData) {
              List<PosterCardData> posterCards = state.result
                  .map((e) => PosterCardData(e.posterPath ?? ""))
                  .toList();
              return PosterCardList(
                  items: posterCards,
                  onTap: (index) {
                    Navigator.pushNamed(
                      context,
                      TvDetailPage.ROUTE_NAME,
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
      mainAxisSize: MainAxisSize.min,
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
