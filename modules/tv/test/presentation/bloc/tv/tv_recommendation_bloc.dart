import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/tv/get_tv_recommendation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/bloc/tv/tv_recommendation_bloc.dart';

import 'tv_recommendation_bloc.mocks.dart';

@GenerateMocks([GetTvRecommendation])
void main() {
  late MockGetTvRecommendation mockGetTvRecommendation;
  late TvRecommendationBloc tvRecommendationBloc;

  setUp(() {
    mockGetTvRecommendation = MockGetTvRecommendation();
    tvRecommendationBloc =
        TvRecommendationBloc(getTvRecommendation: mockGetTvRecommendation);
  });

  final id = 0;
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

  blocTest<TvRecommendationBloc, TvRecommendationState>(
      'Should emit [Loading, HasData] when data is gotten successful',
      build: () {
        when(mockGetTvRecommendation.execute(id))
            .thenAnswer((_) async => Right(testTvs));
        return tvRecommendationBloc;
      },
      act: (bloc) => bloc.add(OnFetchTvRecommendation(id)),
      expect: () =>
          [TvRecommendationLoading(), TvRecommendationHasData(testTvs)],
      verify: (bloc) {
        verify(mockGetTvRecommendation.execute(id));
      });

  blocTest<TvRecommendationBloc, TvRecommendationState>(
      'Should emit [Loading, Error] when data is unsuccessful',
      build: () {
        when(mockGetTvRecommendation.execute(id)).thenAnswer(
            (_) async => const Left(ServerFailure('Server failure')));
        return tvRecommendationBloc;
      },
      act: (bloc) => bloc.add(OnFetchTvRecommendation(id)),
      expect: () =>
          [TvRecommendationLoading(), TvRecommendationError('Server failure')],
      verify: (bloc) {
        verify(mockGetTvRecommendation.execute(id));
      });
}
