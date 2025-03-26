import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_app/service_locator.dart';
import 'package:my_app/domain/usecases/songs/get_news_songs.dart';

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
        await _audioPlayer.setUrl(songUrl);
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
    return FutureBuilder(
      future: sl<GetNewsSongsUseCase>().call(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        }
        return snapshot.data!.fold(
          (l) => Center(child: Text('Error: $l')),
          (songs) => songs.isEmpty
              ? const Center(child: Text('No songs found'))
              : ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    print(
                        "Song URL: ${song.songUrl}, Image URL: ${song.imageUrl}");
                    return ListTile(
                      leading:
                          song.imageUrl != null && song.imageUrl!.isNotEmpty
                              ? Image.network(
                                  song.imageUrl!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image),
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
                    );
                  },
                ),
        );
      },
    );
  }
}
