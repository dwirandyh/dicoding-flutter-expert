
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/tv_season.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvDetail usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvDetail(mockTvRepository);
  });

  final id = 1;
  final tvDetail = TvDetail(
    backdropPath: 'dummy backdrop',
    firstAirDate: DateTime(2017, 9, 7, 17, 30),
    id: 12,
    name: "dummy name",
    genres: [Genre(id: 1, name: "name")],
    originCountry: ["dummy country"],
    originalLanguage: "dummy language",
    originalName: "dummy originalName",
    overview: "dummy overview",
    popularity: 4.8,
    posterPath: "dummy posterPath",
    voteAverage: 5,
    voteCount: 20,
    adult: false,
    episodeRunTime: [],
    homepage: "homepage",
    inProduction: true,
    languages: ["indonesia"],
    lastAirDate: DateTime(2017, 9, 7, 17, 30),
    nextEpisodeToAir: "nextEpisodeToAir",
    numberOfEpisodes: 1,
    numberOfSeasons: 1,
    seasons: [Season(airDate: DateTime(2017, 9, 7, 17, 30), episodeCount: 1, id: 1, name: "name", overview: "overview", posterPath: "posterPath", seasonNumber: 1)],
    status: "status",
    tagline: "tagline",
    type: "type",
  );

  test('should get list of tv from repository', () async {
    // arrange
    when(mockTvRepository.getTvDetail(id))
        .thenAnswer((_) async => Right(tvDetail));
    // act
    final result = await usecase.execute(id);
    // assert
    expect(result, Right<Failure, TvDetail>(tvDetail));
  });

}