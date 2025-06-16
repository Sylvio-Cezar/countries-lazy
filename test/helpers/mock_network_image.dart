import 'package:flutter/material.dart';

class MockNetworkImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final BoxFit fit;

  const MockNetworkImage({
    super.key,
    required this.url,
    this.width = 100,
    this.height = 100,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.blue,
      child: const Center(child: Icon(Icons.image, color: Colors.white)),
    );
  }
}
