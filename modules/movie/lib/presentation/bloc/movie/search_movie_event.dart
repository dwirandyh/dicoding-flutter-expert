part of 'search_movie_bloc.dart';

abstract class SearchMovieEvent {
  const SearchMovieEvent();
}

class OnSearchMovieQueryChanged extends SearchMovieEvent {
  final String query;

  const OnSearchMovieQueryChanged(this.query);
}

class OnSearchMovieInitState extends SearchMovieEvent {
  const OnSearchMovieInitState();
}
