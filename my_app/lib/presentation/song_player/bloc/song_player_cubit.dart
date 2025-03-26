import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_app/presentation/song_player/bloc/song_player_state.dart';

class SongPlayerCubit extends Cubit<SongPlayerState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int songDurationInSeconds = 217; // Giá trị mặc định, sẽ được cập nhật

  SongPlayerCubit() : super(SongPlayerLoading());

  Future<void> loadSong(String songUrl, int durationInSeconds) async {
    try {
      emit(SongPlayerLoading());
      songDurationInSeconds = durationInSeconds; // Lưu duration từ SongEntity
      await _audioPlayer.setAsset(songUrl);
      _audioPlayer.positionStream.listen((position) {
        emit(SongPlayerLoaded(
          isPlaying: _audioPlayer.playing,
          currentPosition: position,
          totalDuration: Duration(seconds: songDurationInSeconds),
        ));
      });
      _audioPlayer.durationStream.listen((duration) {
        emit(SongPlayerLoaded(
          isPlaying: _audioPlayer.playing,
          currentPosition: _audioPlayer.position,
          totalDuration: Duration(seconds: songDurationInSeconds),
        ));
      });
      emit(SongPlayerLoaded(
        isPlaying: false,
        currentPosition: Duration.zero,
        totalDuration: Duration(seconds: songDurationInSeconds),
      ));
    } catch (e) {
      emit(SongPlayerFailure(e.toString()));
    }
  }

  Future<void> playOrPauseSong() async {
    try {
      if (_audioPlayer.playing) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play();
      }
      emit(SongPlayerLoaded(
        isPlaying: _audioPlayer.playing,
        currentPosition: _audioPlayer.position,
        totalDuration: Duration(seconds: songDurationInSeconds),
      ));
    } catch (e) {
      emit(SongPlayerFailure(e.toString()));
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
      emit(SongPlayerLoaded(
        isPlaying: _audioPlayer.playing,
        currentPosition: _audioPlayer.position,
        totalDuration: Duration(seconds: songDurationInSeconds),
      ));
    } catch (e) {
      emit(SongPlayerFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }
}
