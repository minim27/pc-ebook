import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'my_loading.dart';

class MyImage extends StatelessWidget {
  const MyImage({
    super.key,
    required this.image,
    this.fit = BoxFit.cover,
    this.bgColor = Colors.transparent,
    this.errorWidget,
  });

  final String image;
  final BoxFit? fit;
  final Color? bgColor;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      fit: fit,
      placeholder: (context, url) =>
          const Center(child: MyImageLoading()),
    );
  }
}
