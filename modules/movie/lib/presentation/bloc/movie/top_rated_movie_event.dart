part of 'top_rated_movie_bloc.dart';

abstract class TopRatedMovieEvent extends Equatable {
  const TopRatedMovieEvent();
}

class OnFetchTopRatedMovie extends TopRatedMovieEvent {
  List<Object?> get props => [];
}