import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

void main() {
  runApp(const DominatorKoraApp());
}

class DominatorKoraApp extends StatelessWidget {
  const DominatorKoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dominator Kora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Dark Slate Background
        primaryColor: const Color(0xFF38BDF8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E293B),
          elevation: 0,
        ),
      ),
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
  final List<Map<String, String>> channels = [
    {'name': 'beIN Sports 1 HD', 'url': 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8'},
    {'name': 'beIN Sports 2 HD', 'url': 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8'},
    {'name': 'beIN Sports 3 HD', 'url': 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8'},
    {'name': 'beIN Sports Premium 1', 'url': 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dominator Kora - beIN Sports', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'قنوات البث المباشر', 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: channels.length,
            itemBuilder: (context, index) {
              final channel = channels[index];
              return Card(
                color: const Color(0xFF1E293B),
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.tv, color: Color(0xFF38BDF8)),
                  title: Text(channel['name']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  trailing: const Icon(Icons.play_arrow, color: Colors.greenAccent),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerScreen(channelName: channel['name']!, streamUrl: channel['url']!),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class PlayerScreen extends StatefulWidget {
  final String channelName;
  final String streamUrl;
  const PlayerScreen({super.key, required this.channelName, required this.streamUrl});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.streamUrl));
    await _videoController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: true,
      isLive: true,
      aspectRatio: 16 / 9,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.channelName)),
      body: Center(
        child: _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
            ? AspectRatio(aspectRatio: 16 / 9, child: Chewie(controller: _chewieController!))
            : const CircularProgressIndicator(color: Color(0xFF38BDF8)),
      ),
    );
  }
}
