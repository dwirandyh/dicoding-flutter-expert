part of 'watchlist_status_bloc.dart';

abstract class WatchlistStatusEvent extends Equatable {}

class OnGetWatchlistStatus extends WatchlistStatusEvent {
  final int id;

  OnGetWatchlistStatus(this.id);

  @override
  List<Object?> get props => [id];
}

class OnAddToWatchlist extends WatchlistStatusEvent {
  final Watchlist watchlist;

  OnAddToWatchlist(this.watchlist);

  @override
  List<Object?> get props => [watchlist];
}

class OnRemoveFromWatchlist extends WatchlistStatusEvent {
  final Watchlist watchlist;

  OnRemoveFromWatchlist(this.watchlist);

  @override
  List<Object?> get props => [watchlist];
}
