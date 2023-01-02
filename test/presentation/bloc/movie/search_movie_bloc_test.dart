import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/tv/search_tv.dart';
import 'package:ditonton/presentation/bloc/movie/search_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/search_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import 'search_movie_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MockSearchMovies mockSearchMovie;
  late SearchMovieBloc searchMovieBloc;

  setUp(() {
    mockSearchMovie = MockSearchMovies();
    searchMovieBloc = SearchMovieBloc(searchMovies: mockSearchMovie);
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

  blocTest<SearchMovieBloc, SearchMovieState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockSearchMovie.execute(query))
            .thenAnswer((_) async => Right(tMovieList));
        return searchMovieBloc;
      },
      act: (bloc) => bloc.add(OnSearchMovieQueryChanged(query)),
      expect: () => [SearchMovieLoading(), SearchMovieHasData(tMovieList)],
      verify: (bloc) {
        verify(mockSearchMovie.execute(query));
      });

  blocTest<SearchMovieBloc, SearchMovieState>(
      'Should emit [Loading, Error] when data is unsuccesfull',
      build: () {
        when(mockSearchMovie.execute(query))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return searchMovieBloc;
      },
      act: (bloc) => bloc.add(OnSearchMovieQueryChanged(query)),
      expect: () => [SearchMovieLoading(), SearchMovieError('Server Failure')],
      verify: (bloc) {
        verify(mockSearchMovie.execute(query));
      });
}
