part of 'watchlist_bloc.dart';

abstract class WatchlistState extends Equatable {}

class WatchlistLoading extends WatchlistState {
  @override
  List<Object?> get props => [];
}

class WatchlistError extends WatchlistState {
  final String message;

  WatchlistError(this.message);

  @override
  List<Object?> get props => [message];
}

class WatchlistHasData extends WatchlistState {
  final List<Watchlist> result;

  WatchlistHasData(this.result);

  @override
  List<Object?> get props => [result];
}
