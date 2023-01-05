part of 'search_movie_bloc.dart';

abstract class SearchMovieEvent extends Equatable {
  const SearchMovieEvent();

  @override
  List<Object> get props => [];
}

class OnSearchMovieQueryChanged extends SearchMovieEvent {
  final String query;

  OnSearchMovieQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

class OnSearchMovieInitState extends SearchMovieEvent {
  const OnSearchMovieInitState();

  @override
  List<Object> get props => [];
}
