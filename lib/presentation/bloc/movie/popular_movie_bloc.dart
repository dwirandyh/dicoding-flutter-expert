import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movie/get_popular_movies.dart';
import 'package:equatable/equatable.dart';

part 'popular_movie_event.dart';
part 'popular_movie_state.dart';

class PopularMovieBloc extends Bloc<PopularMovieEvent, PopularMovieState> {
  final GetPopularMovies getPopularMovies;

  PopularMovieBloc({required this.getPopularMovies})
      : super(PopularMovieInitial()) {
    on<OnFetchPopularMovie>(_onFetchPopularMovie);
  }

  Future<void> _onFetchPopularMovie(
      OnFetchPopularMovie event, Emitter<PopularMovieState> emit) async {
    emit(PopularMovieLoading());

    final result = await getPopularMovies.execute();

    result.fold((failure) {
      emit(PopularMovieError(failure.message));
    }, (movies) {
      emit(PopularMovieHasData(movies));
    });
  }
}
