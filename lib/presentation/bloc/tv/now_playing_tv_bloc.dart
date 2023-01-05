import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_now_playing_tv.dart';
import 'package:equatable/equatable.dart';

part 'now_playing_tv_event.dart';
part 'now_playing_tv_state.dart';

class NowPlayingTvBloc extends Bloc<NowPlayingTvEvent, NowPlayingTvState> {
  final GetNowPlayingTv getNowPlayingTv;

  NowPlayingTvBloc({required this.getNowPlayingTv})
      : super(NowPlayingTvInitial()) {
    on<OnFetchNowPlayingTv>(_onFetchNowPlayingTv);
  }

  Future<void> _onFetchNowPlayingTv(
      OnFetchNowPlayingTv event, Emitter<NowPlayingTvState> emit) async {
    emit(NowPlayingTvLoading());

    final result = await getNowPlayingTv.execute();

    result.fold((failure) {
      emit(NowPlayingTvError(failure.message));
    }, (tvs) {
      emit(NowPlayingTvHasData(tvs));
    });
  }
}
