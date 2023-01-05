import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/tv/get_popular_tv.dart';
import 'package:tv/presentation/bloc/tv/popular_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tv_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTv])
void main() {
  late MockGetPopularTv mockGetPopularTv;
  late PopularTvBloc nowPlayingTvBloc;

  setUp(() {
    mockGetPopularTv = MockGetPopularTv();
    nowPlayingTvBloc = PopularTvBloc(getPopularTv: mockGetPopularTv);
  });

  final testTv = Tv(
      firstAirDate: DateTime(2017, 9, 7, 17, 30),
      genreIds: [1, 2],
      id: 12,
      name: "dummy name",
      originCountry: ["dummy country"],
      originalLanguage: "dummy language",
      originalName: "dummy originalName",
      overview: "dummy overview",
      popularity: 4.8,
      posterPath: "dummy posterPath",
      voteAverage: 5,
      voteCount: 20,
      backdropPath: 'dummy backdrop');
  final testTvs = [testTv];

  blocTest<PopularTvBloc, PopularTvState>(
      'Should emit [Loading, HasData] when data is gotten successful',
      build: () {
        when(mockGetPopularTv.execute())
            .thenAnswer((_) async => Right(testTvs));
        return nowPlayingTvBloc;
      },
      act: (bloc) => bloc.add(OnFetchPopularTv()),
      expect: () => [PopularTvLoading(), PopularTvHasData(testTvs)],
      verify: (bloc) {
        verify(mockGetPopularTv.execute());
      });

  blocTest<PopularTvBloc, PopularTvState>(
      'Should emit [Loading, Error] when data is unsuccessful',
      build: () {
        when(mockGetPopularTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server failure')));
        return nowPlayingTvBloc;
      },
      act: (bloc) => bloc.add(OnFetchPopularTv()),
      expect: () => [PopularTvLoading(), PopularTvError('Server failure')],
      verify: (bloc) {
        verify(mockGetPopularTv.execute());
      });
}
