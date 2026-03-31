import 'package:url_launcher/url_launcher.dart';

String appleMusicUrl(String song, String artist) {
  final query = Uri.encodeComponent('$song $artist');
  return 'https://music.apple.com/jp/search?term=$query';
}

String spotifyUrl(String song, String artist) {
  final query = Uri.encodeComponent('track:$song artist:$artist');
  return 'https://open.spotify.com/search/$query';
}

String youtubeMusicUrl(String song, String artist) {
  final query = Uri.encodeComponent('$song $artist official');
  return 'https://music.youtube.com/search?q=$query';
}

Future<void> openUrl(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}