// lib/presentation/home/bloc/news_songs_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/usecases/songs/get_news_songs.dart';
import 'package:my_app/presentation/home/bloc/news_songs_state.dart';
import 'package:my_app/service_locator.dart';

class NewsSongsCubit extends Cubit<NewsSongsState> {
  NewsSongsCubit() : super(NewsSongsLoading());

  Future<void> getNewsSongs() async {
    try {
      emit(NewsSongsLoading());
      final result = await sl<GetNewsSongsUseCase>().call();
      result.fold(
        (error) => emit(NewsSongsFailure(error)),
        (songs) => emit(NewsSongsLoaded(songs)),
      );
    } catch (e) {
      emit(NewsSongsFailure(e.toString()));
    }
  }
}
