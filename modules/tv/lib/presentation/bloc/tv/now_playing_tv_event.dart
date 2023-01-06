part of 'now_playing_tv_bloc.dart';

abstract class NowPlayingTvEvent {
  const NowPlayingTvEvent();
}

class OnFetchNowPlayingTv extends NowPlayingTvEvent {}
