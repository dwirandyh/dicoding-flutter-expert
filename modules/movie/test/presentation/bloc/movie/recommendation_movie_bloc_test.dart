import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:movie/presentation/bloc/movie/movie_recommendation_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'recommendation_movie_bloc_test.mocks.dart';

@GenerateMocks([GetMovieRecommendations])
void main() {
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MovieRecommendationBloc movieRecommendationBloc;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    movieRecommendationBloc = MovieRecommendationBloc(
        getMovieRecommendations: mockGetMovieRecommendations);
  });

  final id = 0;
  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovieList = <Movie>[tMovie];

  blocTest<MovieRecommendationBloc, MovieRecommendationState>(
      'Should emit [Loading, HasData] when data is gotten successful',
      build: () {
        when(mockGetMovieRecommendations.execute(id))
            .thenAnswer((_) async => Right(tMovieList));
        return movieRecommendationBloc;
      },
      act: (bloc) => bloc.add(OnFetchMovieRecommendation(id)),
      expect: () => [
            MovieRecommendationLoading(),
            MovieRecommendationHasData(tMovieList)
          ],
      verify: (bloc) {
        verify(mockGetMovieRecommendations.execute(id));
      });

  blocTest<MovieRecommendationBloc, MovieRecommendationState>(
      'Should emit [Loading, Error] when data is unsuccessful',
      build: () {
        when(mockGetMovieRecommendations.execute(id)).thenAnswer(
            (_) async => const Left(ServerFailure('Server failure')));
        return movieRecommendationBloc;
      },
      act: (bloc) => bloc.add(OnFetchMovieRecommendation(id)),
      expect: () => [
            MovieRecommendationLoading(),
            MovieRecommendationError('Server failure')
          ],
      verify: (bloc) {
        verify(mockGetMovieRecommendations.execute(id));
      });
}
