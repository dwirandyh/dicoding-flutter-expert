part of 'tv_recommendation_bloc.dart';

@immutable
abstract class TvRecommendationState extends Equatable {}

class TvRecommendationLoading extends TvRecommendationState {
  @override
  List<Object?> get props => [];
}

class TvRecommendationHasData extends TvRecommendationState {
  final List<Tv> result;

  TvRecommendationHasData(this.result);

  @override
  List<Object?> get props => [result];
}

class TvRecommendationError extends TvRecommendationState {
  final String message;

  TvRecommendationError(this.message);

  @override
  List<Object?> get props => [];
}
