
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_now_playing_tv.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv.dart';
import 'package:flutter/material.dart';

class TvListNotifier extends ChangeNotifier {
  var _nowPlayingTvs = <Tv>[];
  List<Tv> get nowPlayingTvs => _nowPlayingTvs;

  RequestState _nowPlayingState = RequestState.Empty;
  RequestState get nowPlayingState => _nowPlayingState;

  var _popularTvs = <Tv>[];
  List<Tv> get popularTvs => _popularTvs;

  RequestState _popularTvState = RequestState.Empty;
  RequestState get popularTvState => _popularTvState;

  var _topRatedTvs = <Tv>[];
  List<Tv> get topRatedTvs => _topRatedTvs;

  RequestState _topRatedTvsState = RequestState.Empty;
  RequestState get topRatedTvsState => _topRatedTvsState;

  String _message = '';
  String get message => _message;

  final GetNowPlayingTv getNowPlayingTv;
  final GetPopularTv getPopularTv;
  final GetTopRatedTv getTopRatedTv;

  TvListNotifier({
    required this.getNowPlayingTv,
    required this.getPopularTv,
    required this.getTopRatedTv
  });

  Future<void> fetchNowPlayingTvs() async {
    _nowPlayingState = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlayingTv.execute();
    result.fold(
        (failure) {
          _nowPlayingState = RequestState.Error;
          _message = failure.message;
          notifyListeners();
        },
        (tvList) {
          _nowPlayingState = RequestState.Loaded;
          _nowPlayingTvs = tvList;
          notifyListeners();
        }
    );
  }

  Future<void> fetchPopularTvs() async {
    _popularTvState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTv.execute();
    result.fold(
            (failure) {
          _popularTvState = RequestState.Error;
          _message = failure.message;
          notifyListeners();
        },
            (tvList) {
          _popularTvState = RequestState.Loaded;
          _popularTvs = tvList;
          notifyListeners();
        }
    );
  }

  Future<void> fetchTopRatedTvs() async {
    _topRatedTvsState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTv.execute();
    result.fold(
            (failure) {
              _topRatedTvsState = RequestState.Error;
          _message = failure.message;
          notifyListeners();
        },
            (tvList) {
              _topRatedTvsState = RequestState.Loaded;
              _topRatedTvs = tvList;
          notifyListeners();
        }
    );
  }
}