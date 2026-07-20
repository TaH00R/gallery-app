import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:share_plus/share_plus.dart';
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
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.asset.isFavorite;
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

  Future<void> _toggleFavorite() async {
    await PhotoManager.plugin.favoriteAsset(
      widget.asset.id,
      !isFavorite,
    );

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  Future<void> _share() async {
    final file = await widget.asset.originFile;

    if (file == null) return;

    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile(file.path),
        ],
      ),
    );
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Video"),
        content: const Text(
          "This video will be permanently deleted.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await PhotoManager.editor.deleteWithIds([
      widget.asset.id,
    ]);

    if (mounted) {
      Navigator.pop(context);
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
            onPressed: _toggleFavorite,
            icon: Icon(
              isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: const Color(0xffC76A3A),
            ),
          ),
      
          IconButton(
            onPressed: _share,
            icon: const Icon(Icons.share),
          ),
      
          IconButton(
            onPressed: _delete,
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