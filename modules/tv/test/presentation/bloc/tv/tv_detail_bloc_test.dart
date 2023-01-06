import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:tv/domain/entities/genre.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/entities/tv_season.dart';
import 'package:tv/domain/usecases/tv/get_tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/bloc/tv/tv_detail_bloc.dart';

import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([GetTvDetail])
void main() {
  late MockGetTvDetail mockGetTvDetail;
  late TvDetailBloc tvDetailBloc;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    tvDetailBloc = TvDetailBloc(getTvDetail: mockGetTvDetail);
  });

  final id = 0;
  final tvDetail = TvDetail(
    backdropPath: 'dummy backdrop',
    firstAirDate: DateTime(2017, 9, 7, 17, 30),
    id: 12,
    name: "dummy name",
    genres: const [Genre(id: 1, name: "name")],
    originCountry: const ["dummy country"],
    originalLanguage: "dummy language",
    originalName: "dummy originalName",
    overview: "dummy overview",
    popularity: 4.8,
    posterPath: "dummy posterPath",
    voteAverage: 5,
    voteCount: 20,
    adult: false,
    episodeRunTime: const [],
    homepage: "homepage",
    inProduction: true,
    languages: const ["indonesia"],
    lastAirDate: DateTime(2017, 9, 7, 17, 30),
    nextEpisodeToAir: "nextEpisodeToAir",
    numberOfEpisodes: 1,
    numberOfSeasons: 1,
    seasons: [
      Season(
          airDate: DateTime(2017, 9, 7, 17, 30),
          episodeCount: 1,
          id: 1,
          name: "name",
          overview: "overview",
          posterPath: "posterPath",
          seasonNumber: 1)
    ],
    status: "status",
    tagline: "tagline",
    type: "type",
  );

  blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [Loading, HasData] when data is gotten successful',
      build: () {
        when(mockGetTvDetail.execute(id))
            .thenAnswer((_) async => Right(tvDetail));
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(OnFetchTvDetail(id)),
      expect: () => [TvDetailLoading(), TvDetailHasData(tvDetail)],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(id));
      });

  blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [Loading, Error] when data is unsuccessful',
      build: () {
        when(mockGetTvDetail.execute(id)).thenAnswer(
            (_) async => const Left(ServerFailure('Server failure')));
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(OnFetchTvDetail(id)),
      expect: () => [TvDetailLoading(), TvDetailError('Server failure')],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(id));
      });
}
