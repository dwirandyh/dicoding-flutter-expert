import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/movie/get_now_playing_movies.dart';
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
