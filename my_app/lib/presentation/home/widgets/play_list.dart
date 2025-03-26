import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/common/helpers/is_dark_mode.dart';
import 'package:my_app/common/widgets/favorite_button/favorite_button.dart';
import 'package:my_app/domain/entities/song/song.dart';
import 'package:my_app/presentation/home/bloc/play_list_cubit.dart';
import 'package:my_app/presentation/home/bloc/play_list_state.dart';
import 'package:my_app/presentation/song_player/pages/song_player.dart';

class PlayList extends StatelessWidget {
  const PlayList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlayListCubit()..getPlayList(),
      child: BlocBuilder<PlayListCubit, PlayListState>(
        builder: (context, state) {
          if (state is PlayListLoading) {
            return Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          }
          if (state is PlayListLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Playlist',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'See More',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xffC6C6C6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _songs(context, state.songs),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _songs(BuildContext context, List<SongEntity> songs) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => SongPlayer(
                  song: songs[index],
                ),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.isDarkMode
                          ? const Color(0xffE6E6E6)
                          : const Color(0xffE6E6E6),
                    ),
                    child: songs[index].imageUrl != null &&
                            songs[index].imageUrl!.isNotEmpty
                        ? ClipOval(
                            child: Image.asset(
                              songs[index].imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.play_arrow_rounded,
                                  color: context.isDarkMode
                                      ? const Color(0xff959595)
                                      : const Color(0xff555555),
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.play_arrow_rounded,
                            color: context.isDarkMode
                                ? const Color(0xff959595)
                                : const Color(0xff555555),
                          ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        songs[index].title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        songs[index].artist,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    _formatDuration(
                        Duration(minutes: songs[index].duration.toInt())),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 20),
                  FavoriteButton(songEntity: songs[index]),
                ],
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemCount: songs.length,
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
