// lib/presentation/home/bloc/play_list_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/usecases/songs/get_play_list.dart';
import 'package:my_app/presentation/home/bloc/play_list_state.dart';
import 'package:my_app/service_locator.dart';

class PlayListCubit extends Cubit<PlayListState> {
  PlayListCubit() : super(PlayListLoading());

  Future<void> getPlayList() async {
    try {
      emit(PlayListLoading());
      final result = await sl<GetPlayListUseCase>().call();
      result.fold(
        (error) => emit(PlayListFailure(error)),
        (songs) => emit(PlayListLoaded(songs)),
      );
    } catch (e) {
      emit(PlayListFailure(e.toString()));
    }
  }
}
