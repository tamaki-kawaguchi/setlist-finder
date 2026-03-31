import 'package:flutter/material.dart';
import 'setlist_list_screen.dart';
import 'setlist_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Setlist App',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 72, 141, 97)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  List<String> suggestions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setlist App')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:16.0, vertical:12.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'アーティスト名を入力',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) async {
                final result = await SetlistApi().fetchArtistSuggestions(text);
                setState(() {
                  suggestions = result;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final artist = _controller.text;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SetlistListScreen(artist: artist),
                  ),
                );
              },
              child: const Text('検索'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(suggestions[index]),
                    onTap: () {
                      _controller.text = suggestions[index];
                      setState(() {
                        suggestions = [];
                        });
                      },
                    );
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}