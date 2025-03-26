// lib/presentation/profile/bloc/favorite_songs_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/entities/song/song.dart';
import 'package:my_app/domain/usecases/songs/get_favorite_songs.dart';
import 'package:my_app/domain/usecases/songs/add_or_remove_favorite_song.dart';
import 'package:my_app/presentation/profile/bloc/favorite_songs_state.dart';
import 'package:my_app/service_locator.dart';

class FavoriteSongsCubit extends Cubit<FavoriteSongsState> {
  FavoriteSongsCubit() : super(FavoriteSongsLoading());

  Future<void> getFavoriteSongs() async {
    try {
      emit(FavoriteSongsLoading());
      final result = await sl<GetFavoriteSongsUseCase>().call();
      result.fold(
        (error) => emit(FavoriteSongsFailure(error)),
        (songs) => emit(FavoriteSongsLoaded(songs)),
      );
    } catch (e) {
      emit(FavoriteSongsFailure(e.toString()));
    }
  }

  Future<void> removeSong(int index) async {
    if (state is FavoriteSongsLoaded) {
      final currentState = state as FavoriteSongsLoaded;
      final song = currentState.favoriteSongs[index];
      final result =
          await sl<AddOrRemoveFavoriteSongUseCase>().call(params: song.songId);
      result.fold(
        (error) => emit(FavoriteSongsFailure(error)),
        (_) {
          final updatedSongs = List<SongEntity>.from(currentState.favoriteSongs)
            ..removeAt(index);
          emit(FavoriteSongsLoaded(updatedSongs));
        },
      );
    }
  }
}
