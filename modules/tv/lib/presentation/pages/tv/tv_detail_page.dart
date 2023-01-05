import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:tv/domain/entities/genre.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/entities/tv_season.dart';
import 'package:watchlist/domain/entities/watchlist.dart';
import 'package:tv/presentation/bloc/tv/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv/tv_recommendation_bloc.dart';
import 'package:watchlist/presentation/bloc/watchlist/watchlist_status_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv/detail';

  final int id;
  TvDetailPage({required this.id});

  @override
  _TvDetailPageState createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvDetailBloc>().add(OnFetchTvDetail(widget.id));
      context.read<WatchlistStatusBloc>().add(OnGetWatchlistStatus(widget.id));
      context
          .read<TvRecommendationBloc>()
          .add(OnFetchTvRecommendation(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvDetailBloc, TvDetailState>(
        builder: (context, state) {
          if (state is TvDetailLoading) {
            return Center(
              key: Key('tvdetail-progress-indicator'),
              child: CircularProgressIndicator(),
            );
          } else if (state is TvDetailHasData) {
            final tv = state.detail;
            return SafeArea(
              child: DetailContent(tv),
            );
          } else if (state is TvDetailError) {
            return Text(state.message);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvDetail tv;

  DetailContent(this.tv);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tv.originalName,
                              style: kHeading5,
                            ),
                            BlocConsumer<WatchlistStatusBloc,
                                WatchlistStatusState>(
                              listener: (context, state) {
                                if (state.additionalMessage != null) {
                                  if (state.isSuccess) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text(state.additionalMessage ?? ""),
                                      ),
                                    );
                                  } else if (state.isSuccess) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(
                                              state.additionalMessage ?? ""),
                                        );
                                      },
                                    );
                                  }
                                }
                              },
                              builder: (context, state) {
                                return ElevatedButton(
                                  onPressed: () {
                                    final Watchlist watchlist = Watchlist(
                                      id: tv.id,
                                      title: tv.originalName,
                                      posterPath: tv.posterPath,
                                      overview: tv.overview,
                                      type: WatchListType.tv,
                                    );
                                    if (!state.isExists) {
                                      context
                                          .read<WatchlistStatusBloc>()
                                          .add(OnAddToWatchlist(watchlist));
                                    } else {
                                      context.read<WatchlistStatusBloc>().add(
                                          OnRemoveFromWatchlist(watchlist));
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      state.isExists
                                          ? Icon(Icons.check)
                                          : Icon(Icons.add),
                                      Text('Watchlist'),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Text(
                              _showGenres(tv.genres),
                            ),
                            Text(
                              "${tv.seasons.length} seasons",
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tv.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tv.overview,
                            ),
                            SizedBox(height: 16),
                            Text("Seasons", style: kHeading6),
                            _buildSeason(),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            _buildRecommendation(),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _buildRecommendation() {
    return BlocBuilder<TvRecommendationBloc, TvRecommendationState>(
      builder: (context, state) {
        if (state is TvRecommendationLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TvRecommendationError) {
          return Text(state.message);
        } else if (state is TvRecommendationHasData) {
          return Container(
            height: 180,
            child: ListView.builder(
              key: Key('tv-detail-recommendation-listview'),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final recommendation = state.result[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        TvDetailPage.ROUTE_NAME,
                        arguments: recommendation.id,
                      );
                    },
                    child: _buildPosterImage(recommendation.posterPath),
                  ),
                );
              },
              itemCount: state.result.length,
            ),
          );
        } else {
          return Text('No recommendation found');
        }
      },
    );
  }

  Widget _buildPosterImage(String? posterPath) {
    if (posterPath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        child: CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500$posterPath',
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildSeason() {
    if (tv.seasons.isNotEmpty) {
      return Container(
        height: 200,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: tv.seasons.length,
            itemBuilder: (context, index) {
              final season = tv.seasons[index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSeasonThumbnail(season),
                    SizedBox(height: 8),
                    _buildSeasonInfo(season)
                  ],
                ),
              );
            }),
      );
    } else {
      return Text('No season found');
    }
  }

  Widget _buildSeasonThumbnail(Season season) {
    if (season.posterPath != null) {
      return ClipRRect(
        child: Container(
            color: Colors.grey,
            height: 120,
            width: 80,
            child: Icon(Icons.error)),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      );
    } else {
      return ClipRRect(
        child: Container(
            color: Colors.grey,
            height: 120,
            width: 80,
            child: Icon(Icons.error)),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      );
    }
  }

  Widget _buildSeasonInfo(Season season) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(season.name), Text('${season.episodeCount} episodes')],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}
