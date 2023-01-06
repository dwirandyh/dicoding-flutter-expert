part of 'movie_detail_bloc.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();
}

class MovieDetailLoading extends MovieDetailState {
  @override
  List<Object> get props => [];
}

class MovieDetailHasData extends MovieDetailState {
  final MovieDetail detail;

  const MovieDetailHasData(this.detail);

  @override
  List<Object?> get props => [detail];
}

class MovieDetailError extends MovieDetailState {
  final String message;

  const MovieDetailError(this.message);

  @override
  List<Object?> get props => [];
}
