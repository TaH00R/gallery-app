import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:gallery/features/gallery/gallery_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  final AssetEntity asset;

  const VideoView({
    super.key,
    required this.asset,
  });

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  bool initialized = false;
  bool showUI = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final file = await widget.asset.file;

    if (file == null) return;

    _videoController = VideoPlayerController.file(file);
    await _videoController!.initialize();
    await _videoController!.setLooping(true);

    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: true,
      looping: true,
      allowFullScreen: true,
      allowMuting: true,
    );

    if (mounted) {
      setState(() {
        initialized = true;
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GalleryProvider>();
    final currentAsset = provider.getAssetById(widget.asset.id) ?? widget.asset;
    if (!initialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(.35),
        elevation: 0,
        title: const Text(
          "Video",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
      
          IconButton(
                    onPressed: () async {
                      await provider.toggleFavoriteAsset(currentAsset);

                      if (mounted) {
                        setState(() {});
                      }
                    },
                    icon: Icon(
                      currentAsset.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: const Color(0xffC76A3A),
                    ),
                  ),
      
          IconButton(
            onPressed: () => provider.shareAsset(widget.asset),
            icon: const Icon(Icons.share),
          ),
      
          IconButton(
            onPressed: () => provider.deleteAsset(widget.asset),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),

      body: GestureDetector(
        onTap: () {
          setState(() {
            showUI = !showUI;
          });
        },
        child: Center(
          child: AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: Chewie(
              controller: _chewieController!,
            ),
          ),
        ),
      ),
    );
  }
}