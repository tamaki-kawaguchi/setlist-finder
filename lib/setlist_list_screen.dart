import 'package:flutter/material.dart';
import 'setlist_api.dart';
import 'setlist_detail_screen.dart';

class SetlistListScreen extends StatefulWidget {
  final String artist;

  const SetlistListScreen({super.key, required this.artist});

  @override
  State<SetlistListScreen> createState() => _SetlistListScreenState();
}

class _SetlistListScreenState extends State<SetlistListScreen> {
  final SetlistApi api = SetlistApi();
  List<dynamic> setlists = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final mbid = await api.fetchArtistId(widget.artist);

      if (mbid == null) {
        setState(() {
          isLoading = false;
          setlists = [];
        });
        return;
      }

      final result = await api.fetchSetlistsById(mbid);

      setState(() {
        setlists = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('API error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.artist} の公演一覧'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: setlists.length,
              itemBuilder: (context, index) {
                final item = setlists[index];
                final eventDate = item['eventDate'] ?? '日付不明';
                final venue = item['venue']?['name'] ?? '会場不明';

                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    eventDate,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    venue,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SetlistDetailScreen(
                          setlistId: item['id'],
                          eventTitle: item['artist']['name'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}