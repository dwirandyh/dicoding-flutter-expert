part of 'tv_recommendation_bloc.dart';

abstract class TvRecommendationEvent {}

class OnFetchTvRecommendation extends TvRecommendationEvent {
  final int id;

  OnFetchTvRecommendation(this.id);
}
