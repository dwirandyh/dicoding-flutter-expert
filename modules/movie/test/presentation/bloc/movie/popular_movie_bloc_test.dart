import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/movie/get_popular_movies.dart';
import 'package:movie/presentation/bloc/movie/popular_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_movie_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late GetPopularMovies mockGetPopularMovies;
  late PopularMovieBloc nowPlayingMovieBloc;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    nowPlayingMovieBloc =
        PopularMovieBloc(getPopularMovies: mockGetPopularMovies);
  });

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

  blocTest<PopularMovieBloc, PopularMovieState>(
      'Should emit [Loading, HasData] when data is gotten successful',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return nowPlayingMovieBloc;
      },
      act: (bloc) => bloc.add(OnFetchPopularMovie()),
      expect: () => [PopularMovieLoading(), PopularMovieHasData(tMovieList)],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      });

  blocTest<PopularMovieBloc, PopularMovieState>(
      'Should emit [Loading, Error] when data is unsuccessful',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => const Left(ServerFailure('Server failure')));
        return nowPlayingMovieBloc;
      },
      act: (bloc) => bloc.add(OnFetchPopularMovie()),
      expect: () =>
          [PopularMovieLoading(), PopularMovieError('Server failure')],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      });
}
