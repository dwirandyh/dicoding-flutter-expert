import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/usecases/tv/get_tv_detail.dart';
import 'package:equatable/equatable.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvDetail getTvDetail;

  TvDetailBloc({required this.getTvDetail}) : super(TvDetailLoading()) {
    on<OnFetchTvDetail>(onFetchTvDetail);
  }

  Future<void> onFetchTvDetail(
      OnFetchTvDetail event, Emitter<TvDetailState> emit) async {
    emit(TvDetailLoading());
    final detailResult = await getTvDetail.execute(event.id);
    detailResult.fold((failure) {
      emit(TvDetailError(failure.message));
    }, (result) {
      final tvDetail = result;
      emit(TvDetailHasData(tvDetail));
    });
  }
}
