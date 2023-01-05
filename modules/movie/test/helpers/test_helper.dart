import 'package:core/db/database_helper.dart';
import 'package:watchlist/data/datasources/watchlist_local_data_source.dart';
import 'package:movie/data/datasources/movie_remote_data_source.dart';
import 'package:movie/domain/repositories/movie_repository.dart';
import 'package:watchlist/domain/repositories/watchlist_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  MovieRepository,
  WatchlistRepository,
  MovieRemoteDataSource,
  WatchlistDataSource,
  DatabaseHelper,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
