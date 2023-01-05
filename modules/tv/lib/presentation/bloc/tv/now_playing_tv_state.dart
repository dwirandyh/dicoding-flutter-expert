part of 'now_playing_tv_bloc.dart';

abstract class NowPlayingTvState extends Equatable {}

class NowPlayingTvInitial extends NowPlayingTvState {
  @override
  List<Object?> get props => [];
}

class NowPlayingTvLoading extends NowPlayingTvState {
  @override
  List<Object?> get props => [];
}

class NowPlayingTvError extends NowPlayingTvState {
  final String message;

  NowPlayingTvError(this.message);

  @override
  List<Object?> get props => [message];
}

class NowPlayingTvHasData extends NowPlayingTvState {
  final List<Tv> result;

  NowPlayingTvHasData(this.result);

  @override
  List<Object?> get props => [result];
}
