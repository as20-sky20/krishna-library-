import 'package:flutter/material.dart';

Widget buildYouTubeIFrame(String videoId, {double? height}) {
  return Container(
    height: height,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.play_circle_fill, color: Colors.red, size: 56),
          const SizedBox(height: 8),
          Text(
            'YouTube Video: $videoId',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}

void openYouTubeUrl(String url) {
  // Non-web fallback
}
