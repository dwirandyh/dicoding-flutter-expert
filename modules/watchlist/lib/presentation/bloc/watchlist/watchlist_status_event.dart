part of 'watchlist_status_bloc.dart';

abstract class WatchlistStatusEvent {}

class OnGetWatchlistStatus extends WatchlistStatusEvent {
  final int id;

  OnGetWatchlistStatus(this.id);
}

class OnAddToWatchlist extends WatchlistStatusEvent {
  final Watchlist watchlist;

  OnAddToWatchlist(this.watchlist);
}

class OnRemoveFromWatchlist extends WatchlistStatusEvent {
  final Watchlist watchlist;

  OnRemoveFromWatchlist(this.watchlist);
}
