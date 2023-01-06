part of 'tv_detail_bloc.dart';

abstract class TvDetailState extends Equatable {
  const TvDetailState();
}

class TvDetailLoading extends TvDetailState {
  @override
  List<Object> get props => [];
}

class TvDetailHasData extends TvDetailState {
  final TvDetail detail;

  const TvDetailHasData(this.detail);

  @override
  List<Object?> get props => [detail];
}

class TvDetailError extends TvDetailState {
  final String message;

  const TvDetailError(this.message);

  @override
  List<Object?> get props => [];
}
