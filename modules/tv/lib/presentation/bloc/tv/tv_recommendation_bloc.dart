import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/tv/get_tv_recommendation.dart';
import 'package:equatable/equatable.dart';

part 'tv_recommendation_event.dart';
part 'tv_recommendation_state.dart';

class TvRecommendationBloc
    extends Bloc<TvRecommendationEvent, TvRecommendationState> {
  final GetTvRecommendation getTvRecommendation;

  TvRecommendationBloc({required this.getTvRecommendation})
      : super(TvRecommendationLoading()) {
    on<OnFetchTvRecommendation>(onFetchTvRecommendation);
  }

  Future<void> onFetchTvRecommendation(OnFetchTvRecommendation event,
      Emitter<TvRecommendationState> emit) async {
    emit(TvRecommendationLoading());

    final result = await getTvRecommendation.execute(event.id);

    result.fold((failure) {
      emit(TvRecommendationError(failure.message));
    }, (tvs) {
      emit(TvRecommendationHasData(tvs));
    });
  }
}
