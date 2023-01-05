import 'package:core/db/database_helper.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:watchlist/data/datasources/watchlist_local_data_source.dart';
import 'package:tv/domain/repositories/tv_repository.dart';
import 'package:watchlist/domain/repositories/watchlist_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  TvRepository,
  WatchlistRepository,
  TvRemoteDataSource,
  WatchlistDataSource,
  DatabaseHelper,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
