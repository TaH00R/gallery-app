import 'package:flutter/material.dart';
import 'package:gallery/features/gallery/screens/gallery.dart';
import 'package:gallery/models/album.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class AlbumTile extends StatelessWidget {
  final Album album;

  const AlbumTile(this.album, {super.key});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => Gallery(album: album.entity)),
          );
        },
        child: SizedBox(
          height: 200,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Back Photo 1
              if (album.cover != null)
                Positioned(
                  top: 10,
                  right: -12,
                  child: Transform.rotate(
                    angle: .18,
                    child: _photo(album.cover!),
                  ),
                ),
              
              // Back Photo 2
              if (album.cover != null)
                Positioned(
                  top: 10,
                  left: -12,
                  child: Transform.rotate(
                    angle: -.10,
                    child: _photo(album.cover!),
                  ),
                ),
              
              // Front Paper
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .67),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/images/paper.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              
              // Paper Clip
              Positioned(
                top: -10,
                left: 18,
                child: Transform.rotate(
                  angle: .35,
                  child: Icon(
                    Icons.attach_file,
                    size: 34,
                    color: Colors.brown.shade600,
                  ),
                ),
              ),
              
              // Content
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 42,
                        color: Colors.brown.shade700,
                      ),
              
                      const SizedBox(height: 12),
              
                      SizedBox(
                        width: 150,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              "assets/images/brush_stroke.jpg",
                              width: 150,
                              fit: BoxFit.contain,
                            ),
              
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                album.name,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.patrickHand(
                                  color: Colors.white,
                                  fontSize: 18,
                                  height: 1.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
          
                      Text(
                        "${album.count} items",
                        style: TextStyle(
                          color: Colors.brown.shade600,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _photo(AssetEntity cover) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: SizedBox(
        width: 82,
        height: 118,
        child: ClipRect(
          child: AssetEntityImage(
            cover,
            fit: BoxFit.cover,
            thumbnailSize: const ThumbnailSize.square(300),
          ),
        ),
      ),
    );
  }
}
