import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/domain/entities/watchlist.dart';
import 'package:ditonton/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:ditonton/presentation/pages/movie/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/tv/tv_detail_page.dart';
import 'package:ditonton/presentation/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<WatchlistBloc>().add(OnFetchWatchlist()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<WatchlistBloc>().add(OnFetchWatchlist());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistBloc, WatchlistState>(
          builder: (context, state) {
            if (state is WatchlistLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchlistHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final watchlist = state.result[index];
                  return ItemCard(
                    item: ItemData(
                        title: watchlist.title,
                        overview: watchlist.overview,
                        posterPath: watchlist.posterPath),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        watchlist.type == WatchListType.movie
                            ? MovieDetailPage.ROUTE_NAME
                            : TvDetailPage.ROUTE_NAME,
                        arguments: watchlist.id,
                      );
                    },
                  );
                },
                itemCount: state.result.length,
              );
            } else if (state is WatchlistError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
