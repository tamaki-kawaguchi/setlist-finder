import 'package:flutter/material.dart';
import 'setlist_api.dart';
import 'utils/music_links.dart';

class SetlistDetailScreen extends StatelessWidget {
  final String setlistId;
  final String eventTitle;

  const SetlistDetailScreen({
    super.key,
    required this.setlistId,
    required this.eventTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(eventTitle),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: SetlistApi().fetchSongs(setlistId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('セトリを取得できませんでした'));
          }
          final songs = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index]['name'] ?? '曲名不明';
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  radius: 14,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                title: Text(
                  song,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text('Apple Music で検索'),
                      onTap: () {
                        final url = appleMusicUrl(song, eventTitle);
                        openUrl(url);
                      },
                    ),
                    PopupMenuItem(
                      child: const Text('Spotify で検索'),
                      onTap: () {
                        final url = spotifyUrl(song, eventTitle);
                        openUrl(url);
                      },
                    ),
                    PopupMenuItem(
                      child: const Text('YouTube Music で検索'),
                      onTap: () {
                        final url = youtubeMusicUrl(song, eventTitle);
                        openUrl(url);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}