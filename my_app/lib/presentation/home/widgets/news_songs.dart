import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_app/presentation/home/bloc/news_songs_cubit.dart';
import 'package:my_app/presentation/home/bloc/news_songs_state.dart';
import 'package:my_app/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:my_app/presentation/song_player/pages/song_player.dart';

class NewsSongs extends StatefulWidget {
  const NewsSongs({super.key});

  @override
  State<NewsSongs> createState() => _NewsSongsState();
}

class _NewsSongsState extends State<NewsSongs> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  String? currentSongId;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playSong(String songUrl, String songId) async {
    try {
      print("Playing song with URL: $songUrl");
      if (currentSongId == songId && isPlaying) {
        await _audioPlayer.pause();
        setState(() {
          isPlaying = false;
        });
      } else {
        await _audioPlayer.setAsset(songUrl);
        await _audioPlayer.play();
        setState(() {
          isPlaying = true;
          currentSongId = songId;
        });
      }
    } catch (e) {
      print("Error playing song: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error playing song: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewsSongsCubit>(
      create: (context) => NewsSongsCubit()..getNewsSongs(),
      child: Builder(
        builder: (context) {
          return SafeArea(
            child: BlocBuilder<NewsSongsCubit, NewsSongsState>(
              builder: (context, state) {
                if (state is NewsSongsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is NewsSongsFailure) {
                  return Center(child: Text('Error: ${state.error}'));
                }
                if (state is NewsSongsLoaded) {
                  final songs = state.songs;
                  if (songs.isEmpty) {
                    return const Center(child: Text('No songs found'));
                  }
                  return ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      print(
                          "Song URL: ${song.songUrl}, Image URL: ${song.imageUrl}");
                      return ListTile(
                        leading: song.imageUrl != null &&
                                song.imageUrl!.isNotEmpty
                            ? Image.asset(
                                song.imageUrl!,
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.width * 0.15,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  print("Error loading image: $error");
                                  return const Icon(
                                    Icons.broken_image,
                                    size: 50,
                                  );
                                },
                              )
                            : const Icon(Icons.music_note),
                        title: Text(song.title),
                        subtitle: Text(song.artist),
                        trailing: IconButton(
                          icon: Icon(
                            currentSongId == song.songId && isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                          onPressed: () {
                            if (song.songUrl != null &&
                                song.songUrl!.isNotEmpty) {
                              playSong(song.songUrl!, song.songId);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Song URL not available')),
                              );
                            }
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => SongPlayerCubit(),
                                child: SongPlayer(song: song),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
                return const Center(child: Text('No data available'));
              },
            ),
          );
        },
      ),
    );
  }
}
