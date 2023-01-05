import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:watchlist/domain/entities/watchlist.dart';
import 'package:watchlist/domain/repositories/watchlist_repository.dart';

class RemoveWatchlist {
  final WatchlistRepository repository;

  RemoveWatchlist(this.repository);

  Future<Either<Failure, String>> execute(Watchlist movie) {
    return repository.removeWatchlist(movie);
  }
}
