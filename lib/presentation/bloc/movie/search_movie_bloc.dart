import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_movie_event.dart';
part 'search_movie_state.dart';

class SearchMovieBloc extends Bloc<SearchMovieEvent, SearchMovieState> {
  final SearchMovies searchMovies;

  SearchMovieBloc({required this.searchMovies}) : super(SearchMovieEmpty()) {
    on<OnSearchMovieInitState>(_onSearchMovieInitState);
    on<OnSearchMovieQueryChanged>(_onQueryChanged);
  }

  Future<void> _onQueryChanged(
      OnSearchMovieQueryChanged event, Emitter<SearchMovieState> emit) async {
    final query = event.query;

    emit(SearchMovieLoading());

    final result = await searchMovies.execute(query);

    result.fold((failure) {
      emit(SearchMovieError(failure.message));
    }, (data) {
      emit(SearchMovieHasData(data));
    });
  }

  Future<void> _onSearchMovieInitState(
      OnSearchMovieInitState event, Emitter<SearchMovieState> emit) async {
    emit(SearchMovieHasData([]));
  }
}
