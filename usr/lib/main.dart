import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const VideoVaultApp());
}

class VideoVaultApp extends StatelessWidget {
  const VideoVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Vault',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<PlatformFile> _videos = [];

  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _videos.add(result.files.first);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Vault'),
      ),
      body: _videos.isEmpty
          ? const Center(
              child: Text('No videos uploaded yet. Tap + to add one.'),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                childAspectRatio: 16 / 9,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                final video = _videos[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerScreen(video: video),
                        ),
                      );
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          color: Colors.black12,
                          child: const Icon(
                            Icons.play_circle_fill,
                            size: 48,
                            color: Colors.white70,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            color: Colors.black54,
                            child: Text(
                              video.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickVideo,
        tooltip: 'Upload Video',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class VideoPlayerScreen extends StatelessWidget {
  final PlatformFile video;

  const VideoPlayerScreen({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(video.name),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.video_library, size: 64, color: Colors.deepPurple),
              const SizedBox(height: 16),
              Text(
                'Ready to play: ${video.name}',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'In a complete application, this file would be uploaded to a backend service like Supabase Storage and streamed here using the video_player package.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
