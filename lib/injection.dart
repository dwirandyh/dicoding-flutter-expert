import 'package:core/db/database_helper.dart';
import 'package:core/network/ssl_pinning.dart';
import 'package:watchlist/data/datasources/watchlist_local_data_source.dart';
import 'package:movie/data/datasources/movie_remote_data_source.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:movie/data/repositories/movie_repository_impl.dart';
import 'package:tv/data/repositories/tv_repository_impl.dart';
import 'package:watchlist/data/repositories/watchlist_repository_impl.dart';
import 'package:movie/domain/repositories/movie_repository.dart';
import 'package:tv/domain/repositories/tv_repository.dart';
import 'package:watchlist/domain/repositories/watchlist_repository.dart';
import 'package:movie/domain/usecases/movie/get_movie_detail.dart';
import 'package:movie/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:tv/domain/usecases/tv/get_now_playing_tv.dart';
import 'package:movie/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:movie/domain/usecases/movie/get_popular_movies.dart';
import 'package:tv/domain/usecases/tv/get_popular_tv.dart';
import 'package:movie/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:tv/domain/usecases/tv/get_top_rated_tv.dart';
import 'package:watchlist/domain/usecases/get_watchlist.dart';
import 'package:watchlist/domain/usecases/get_watchlist_status.dart';
import 'package:watchlist/domain/usecases/remove_watchlist.dart';
import 'package:watchlist/domain/usecases/save_watchlist.dart';
import 'package:movie/domain/usecases/movie/search_movies.dart';
import 'package:tv/domain/usecases/tv/get_tv_detail.dart';
import 'package:tv/domain/usecases/tv/get_tv_recommendation.dart';
import 'package:tv/domain/usecases/tv/search_tv.dart';
import 'package:movie/presentation/bloc/movie/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie/movie_recommendation_bloc.dart';
import 'package:movie/presentation/bloc/movie/now_playing_movie_bloc.dart';
import 'package:movie/presentation/bloc/movie/popular_movie_bloc.dart';
import 'package:movie/presentation/bloc/movie/search_movie_bloc.dart';
import 'package:movie/presentation/bloc/movie/top_rated_movie_bloc.dart';
import 'package:tv/presentation/bloc/tv/now_playing_tv_bloc.dart';
import 'package:tv/presentation/bloc/tv/popular_tv_bloc.dart';
import 'package:tv/presentation/bloc/tv/search_tv_bloc.dart';
import 'package:tv/presentation/bloc/tv/top_rated_tv_bloc.dart';
import 'package:tv/presentation/bloc/tv/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv/tv_recommendation_bloc.dart';
import 'package:watchlist/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:watchlist/presentation/bloc/watchlist/watchlist_status_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // provider

  // MOVIE
  locator.registerFactory(
    () => NowPlayingMovieBloc(
      getNowPlayingMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailBloc(
      getMovieDetail: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieRecommendationBloc(
      getMovieRecommendations: locator(),
    ),
  );
  locator.registerFactory(
    () => SearchMovieBloc(
      searchMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMovieBloc(
      getPopularMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMovieBloc(
      getTopRatedMovies: locator(),
    ),
  );

  locator.registerFactory(
    () => WatchlistBloc(
      getWatchlistMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistStatusBloc(
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );

  // TV

  locator.registerFactory(
    () => PopularTvBloc(getPopularTv: locator()),
  );

  locator.registerFactory(
    () => TopRatedTvBloc(getTopRatedTv: locator()),
  );

  locator.registerFactory(
    () => NowPlayingTvBloc(getNowPlayingTv: locator()),
  );

  locator.registerFactory(
    () => TvRecommendationBloc(getTvRecommendation: locator()),
  );

  locator.registerFactory(
    () => TvDetailBloc(
      getTvDetail: locator(),
      getTvRecommendations: locator(),
    ),
  );

  locator.registerFactory(
    () => SearchTvBloc(searchTv: locator()),
  );

  // use case
  // MOVIE
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // TV
  locator.registerLazySingleton(() => GetNowPlayingTv(locator()));
  locator.registerLazySingleton(() => GetPopularTv(locator()));
  locator.registerLazySingleton(() => GetTopRatedTv(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendation(locator()));
  locator.registerLazySingleton(() => SearchTv(locator()));

  // repository
  // MOVIE
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
    ),
  );
  // TV
  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
    ),
  );
  // Watchlist
  locator.registerLazySingleton<WatchlistRepository>(
    () => WatchlistRepositoryImpl(
      localDataSource: locator(),
    ),
  );

  // data sources
  // MOVIE
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  // TV
  locator.registerLazySingleton<TvRemoteDataSource>(
      () => TvRemoteDataSourceImpl(client: locator()));
  // Watchlist
  locator.registerLazySingleton<WatchlistDataSource>(
      () => WatchlistLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => SSLPinning.client);
}
