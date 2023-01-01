import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/tv/now_playing_tvs_page.dart';
import 'package:ditonton/presentation/pages/tv/popular_tvs_page.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tvs_page.dart';
import 'package:ditonton/presentation/pages/tv/tv_detail_page.dart';
import 'package:ditonton/presentation/provider/tv/tv_list_provider.dart';
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
    Future.microtask(() => Provider.of<TvListNotifier>(context, listen: false)
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
          _buildSubHeading(
            title: "Now Playing TV Series",
            onTap: () =>
                Navigator.pushNamed(context, NowPlayingTvsPage.ROUTE_NAME),
          ),
          Consumer<TvListNotifier>(builder: (context, data, child) {
            final state = data.nowPlayingState;
            if (state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state == RequestState.Loaded) {
              List<PosterCardData> posterCards = data.nowPlayingTvs
                  .map((e) => PosterCardData(e.posterPath))
                  .toList();
              return PosterCardList(
                  items: posterCards,
                  onTap: (index) {
                    Navigator.pushNamed(
                      context,
                      TvDetailPage.ROUTE_NAME,
                      arguments: data.nowPlayingTvs[index].id,
                    );
                  });
            } else {
              return Text('Failed');
            }
          }),
          _buildSubHeading(
            title: 'Popular TV Series',
            onTap: () =>
                Navigator.pushNamed(context, PopularTvsPage.ROUTE_NAME),
          ),
          Consumer<TvListNotifier>(builder: (context, data, child) {
            final state = data.popularTvState;
            if (state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state == RequestState.Loaded) {
              List<PosterCardData> posterCards = data.popularTvs
                  .map((e) => PosterCardData(e.posterPath ?? ""))
                  .toList();
              return PosterCardList(
                  items: posterCards,
                  onTap: (index) {
                    Navigator.pushNamed(
                      context,
                      TvDetailPage.ROUTE_NAME,
                      arguments: data.popularTvs[index].id,
                    );
                  });
            } else {
              return Text('Failed');
            }
          }),
          _buildSubHeading(
            title: 'Top Rated TV Series',
            onTap: () =>
                Navigator.pushNamed(context, TopRatedTvsPage.ROUTE_NAME),
          ),
          Consumer<TvListNotifier>(builder: (context, data, child) {
            final state = data.topRatedTvsState;
            if (state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state == RequestState.Loaded) {
              List<PosterCardData> posterCards = data.topRatedTvs
                  .map((e) => PosterCardData(e.posterPath ?? ""))
                  .toList();
              return PosterCardList(
                  items: posterCards,
                  onTap: (index) {
                    Navigator.pushNamed(
                      context,
                      TvDetailPage.ROUTE_NAME,
                      arguments: data.topRatedTvs[index].id,
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
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}
