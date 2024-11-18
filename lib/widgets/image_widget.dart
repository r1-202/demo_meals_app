import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String? path;
  ImageWidget(this.path);
  @override
  Widget build(BuildContext context) {
    if (path != null) {
      return Image.network(
        path!,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child; // The image has loaded.
          } else {
            // Display a loading indicator while the image is loading.
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          }
        },
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          // Display a local placeholder image if there's an error loading the network image.
          return Image.asset('assets/meal_thumb_placeholder.png');
        },
      );
    }
    return Image.asset('assets/meal_thumb_placeholder.png');
  }
}
