part of 'watchlist_bloc.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();
}

class OnFetchWatchlist extends WatchlistEvent {
  @override
  List<Object?> get props => [];
}
