part of 'watchlist_bloc.dart';

abstract class WatchlistEvent {
  const WatchlistEvent();
}

class OnFetchWatchlist extends WatchlistEvent {}
