import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_movie_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovie;
  late TopRatedMovieBloc nowPlayingMovieBloc;

  setUp(() {
    mockGetTopRatedMovie = MockGetTopRatedMovies();
    nowPlayingMovieBloc =
        TopRatedMovieBloc(getTopRatedMovies: mockGetTopRatedMovie);
  });

  final query = "query";
  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
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

  blocTest<TopRatedMovieBloc, TopRatedMovieState>(
      'Should emit [Loading, HasData] when data is gotten successful',
      build: () {
        when(mockGetTopRatedMovie.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return nowPlayingMovieBloc;
      },
      act: (bloc) => bloc.add(OnFetchTopRatedMovie()),
      expect: () => [TopRatedMovieLoading(), TopRatedMovieHasData(tMovieList)],
      verify: (bloc) {
        verify(mockGetTopRatedMovie.execute());
      });

  blocTest<TopRatedMovieBloc, TopRatedMovieState>(
      'Should emit [Loading, Error] when data is unsuccessful',
      build: () {
        when(mockGetTopRatedMovie.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server failure')));
        return nowPlayingMovieBloc;
      },
      act: (bloc) => bloc.add(OnFetchTopRatedMovie()),
      expect: () =>
          [TopRatedMovieLoading(), TopRatedMovieError('Server failure')],
      verify: (bloc) {
        verify(mockGetTopRatedMovie.execute());
      });
}
