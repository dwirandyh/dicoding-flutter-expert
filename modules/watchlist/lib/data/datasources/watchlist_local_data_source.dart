import 'package:core/common/exception.dart';
import 'package:core/db/database_helper.dart';
import 'package:watchlist/data/models/watchlist_table.dart';

abstract class WatchlistDataSource {
  Future<String> insertWatchlist(WatchListTable movie);
  Future<String> removeWatchlist(WatchListTable movie);
  Future<WatchListTable?> getWatchlistById(int id);
  Future<List<WatchListTable>> getWatchlistMovies();
}

class WatchlistLocalDataSourceImpl implements WatchlistDataSource {
  final DatabaseHelper databaseHelper;

  WatchlistLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlist(WatchListTable movie) async {
    try {
      await databaseHelper.insertWatchlist(movie.toJson());
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(WatchListTable movie) async {
    try {
      await databaseHelper.removeWatchlist(movie.toJson());
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<WatchListTable?> getWatchlistById(int id) async {
    final result = await databaseHelper.getWatchlistById(id);
    if (result != null) {
      return WatchListTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<WatchListTable>> getWatchlistMovies() async {
    final result = await databaseHelper.getWatchlistMovies();
    return result.map((data) => WatchListTable.fromMap(data)).toList();
  }
}
