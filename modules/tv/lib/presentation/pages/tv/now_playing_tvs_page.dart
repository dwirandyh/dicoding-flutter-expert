import 'package:tv/presentation/bloc/tv/now_playing_tv_bloc.dart';
import 'package:tv/presentation/pages/tv/tv_detail_page.dart';
import 'package:core/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NowPlayingTvsPage extends StatefulWidget {
  static const ROUTE_NAME = '/now-playing-tv';

  @override
  _NowPlayingTvsPageState createState() => _NowPlayingTvsPageState();
}

class _NowPlayingTvsPageState extends State<NowPlayingTvsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<NowPlayingTvBloc>().add(OnFetchNowPlayingTv()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playings TV'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NowPlayingTvBloc, NowPlayingTvState>(
          builder: (context, state) {
            if (state is NowPlayingTvLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is NowPlayingTvHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.result[index];
                  return ItemCard(
                    item: ItemData(
                        title: tv.originalName,
                        overview: tv.overview,
                        posterPath: tv.posterPath),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        TvDetailPage.ROUTE_NAME,
                        arguments: tv.id,
                      );
                    },
                  );
                },
                itemCount: state.result.length,
              );
            } else if (state is NowPlayingTvError) {
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
}
