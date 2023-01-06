import 'package:watchlist/data/models/watchlist_table.dart';
import 'package:watchlist/domain/entities/watchlist.dart';

const testWatchlist = Watchlist(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
    type: WatchListType.tv);

final testWatchlistArray = [testWatchlist];

const testMovieTable = WatchListTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
    type: 'tv');

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
  'type': 'tv'
};
