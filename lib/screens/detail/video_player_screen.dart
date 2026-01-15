import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key, required this.url, this.title});

  final String url;
  final String? title;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final VideoPlayerController _controller;
  late final Future<void> _init;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _init = _controller.initialize().then((_) {
      _controller.play();
      setState(() {});
    });
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;

    return Scaffold(
      appBar: isLandscape
          ? null
          : AppBar(
              title: Text(widget.title ?? 'Video'),
            ),
      backgroundColor: Colors.black,
      body: SafeArea(
        // Saat landscape fullscreen, kita juga ingin sampai ke atas (tanpa padding)
        // tapi tetap aman untuk notch kiri/kanan.
        top: !isLandscape,
        bottom: !isLandscape,
        child: FutureBuilder(
          future: _init,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Gagal memuat video.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            final value = _controller.value;
            if (!value.isInitialized) {
              return const Center(
                child: Text(
                  'Gagal memuat video (controller tidak initialized).',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final player = Center(
              child: AspectRatio(
                aspectRatio: value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            );

            // Landscape: fullscreen video (tanpa kontrol bawah) -> tidak overflow.
            if (isLandscape) {
              return Stack(
                children: [
                  Positioned.fill(child: player),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton.filled(
                      tooltip: 'Tutup',
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ),
                ],
              );
            }

            // Portrait: video + kontrol bawah dengan layout fleksibel.
            return Column(
              children: [
                Expanded(child: player),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: IconButton(
                    tooltip: _controller.value.isPlaying ? 'Pause' : 'Play',
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                    icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_fill_rounded,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
