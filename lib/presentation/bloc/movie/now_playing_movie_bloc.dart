import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:equatable/equatable.dart';

part 'now_playing_movie_event.dart';
part 'now_playing_movie_state.dart';

class NowPlayingMovieBloc
    extends Bloc<NowPlayingMovieEvent, NowPlayingMovieState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMovieBloc({required this.getNowPlayingMovies})
      : super(NowPlayingMovieInitial()) {
    on<OnFetchNowPlayingMovie>(_onFetchNowPlayingMovie);
  }

  Future<void> _onFetchNowPlayingMovie(
      OnFetchNowPlayingMovie event, Emitter<NowPlayingMovieState> emit) async {
    emit(NowPlayingMovieLoading());

    final result = await getNowPlayingMovies.execute();

    result.fold((failure) {
      emit(NowPlayingMovieError(failure.message));
    }, (movies) {
      emit(NowPlayingMovieHasData(movies));
    });
  }
}
