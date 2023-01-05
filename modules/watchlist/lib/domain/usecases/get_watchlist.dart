import 'package:dartz/dartz.dart';
import 'package:watchlist/domain/entities/watchlist.dart';
import 'package:core/common/failure.dart';
import 'package:watchlist/domain/repositories/watchlist_repository.dart';

class GetWatchlistMovies {
  final WatchlistRepository _repository;

  GetWatchlistMovies(this._repository);

  Future<Either<Failure, List<Watchlist>>> execute() {
    return _repository.getWatchlist();
  }
}
