part of 'tv_recommendation_bloc.dart';

abstract class TvRecommendationEvent extends Equatable {}

class OnFetchTvRecommendation extends TvRecommendationEvent {
  final int id;

  OnFetchTvRecommendation(this.id);

  @override
  List<Object?> get props => [];
}
