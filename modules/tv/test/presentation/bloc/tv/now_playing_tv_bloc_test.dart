import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/tv/get_now_playing_tv.dart';
import 'package:tv/presentation/bloc/tv/now_playing_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'now_playing_tv_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTv])
void main() {
  late MockGetNowPlayingTv mockGetNowPlayingTv;
  late NowPlayingTvBloc nowPlayingTvBloc;

  setUp(() {
    mockGetNowPlayingTv = MockGetNowPlayingTv();
    nowPlayingTvBloc = NowPlayingTvBloc(getNowPlayingTv: mockGetNowPlayingTv);
  });

  final testTv = Tv(
      firstAirDate: DateTime(2017, 9, 7, 17, 30),
      genreIds: const [1, 2],
      id: 12,
      name: "dummy name",
      originCountry: const ["dummy country"],
      originalLanguage: "dummy language",
      originalName: "dummy originalName",
      overview: "dummy overview",
      popularity: 4.8,
      posterPath: "dummy posterPath",
      voteAverage: 5,
      voteCount: 20,
      backdropPath: 'dummy backdrop');
  final testTvs = [testTv];

  blocTest<NowPlayingTvBloc, NowPlayingTvState>(
      'Should emit [Loading, HasData] when data is gotten successful',
      build: () {
        when(mockGetNowPlayingTv.execute())
            .thenAnswer((_) async => Right(testTvs));
        return nowPlayingTvBloc;
      },
      act: (bloc) => bloc.add(OnFetchNowPlayingTv()),
      expect: () => [NowPlayingTvLoading(), NowPlayingTvHasData(testTvs)],
      verify: (bloc) {
        verify(mockGetNowPlayingTv.execute());
      });

  blocTest<NowPlayingTvBloc, NowPlayingTvState>(
      'Should emit [Loading, Error] when data is unsuccessful',
      build: () {
        when(mockGetNowPlayingTv.execute())
            .thenAnswer((_) async => const Left(ServerFailure('Server failure')));
        return nowPlayingTvBloc;
      },
      act: (bloc) => bloc.add(OnFetchNowPlayingTv()),
      expect: () =>
          [NowPlayingTvLoading(), NowPlayingTvError('Server failure')],
      verify: (bloc) {
        verify(mockGetNowPlayingTv.execute());
      });
}
