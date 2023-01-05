import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:watchlist/domain/usecases/get_watchlist.dart';
import 'package:watchlist/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late WatchlistBloc nowPlayingTvBloc;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    nowPlayingTvBloc =
        WatchlistBloc(getWatchlistMovies: mockGetWatchlistMovies);
  });

  blocTest<WatchlistBloc, WatchlistState>(
      'Should emit [Loading, HasData] when data is gotten successful',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right([]));
        return nowPlayingTvBloc;
      },
      act: (bloc) => bloc.add(OnFetchWatchlist()),
      expect: () => [WatchlistLoading(), WatchlistHasData([])],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      });

  blocTest<WatchlistBloc, WatchlistState>(
      'Should emit [Loading, Error] when data is unsuccessful',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server failure')));
        return nowPlayingTvBloc;
      },
      act: (bloc) => bloc.add(OnFetchWatchlist()),
      expect: () => [WatchlistLoading(), WatchlistError('Server failure')],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      });
}
