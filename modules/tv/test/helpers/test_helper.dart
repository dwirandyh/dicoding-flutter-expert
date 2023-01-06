import 'package:core/db/database_helper.dart';
import 'package:core/network/ssl_pinning.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:watchlist/data/datasources/watchlist_local_data_source.dart';
import 'package:tv/domain/repositories/tv_repository.dart';
import 'package:watchlist/domain/repositories/watchlist_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/io_client.dart';

@GenerateMocks([
  TvRepository,
  WatchlistRepository,
  TvRemoteDataSource,
  WatchlistDataSource,
  DatabaseHelper,
  SSLPinning,
], customMocks: [
  MockSpec<IOClient>(as: #MockHttpClient)
])
void main() {}
