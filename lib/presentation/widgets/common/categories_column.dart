import 'package:callparts/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoryItem extends StatelessWidget {
  final String imagePath;
  final String text;
  final VoidCallback? onTap;

  const CategoryItem({
    super.key,
    required this.imagePath,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkImage = imagePath.startsWith('http://') ||
        imagePath.startsWith('https://') ||
        imagePath.startsWith('/');

    final imageUrl = imagePath;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 130,
              width: 130,
              child: isNetworkImage
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.category,
                        color: AppColors.buttonHome.withOpacity(0.5),
                        size: 28,
                      ),
                    )
                  : Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.category,
                        color: AppColors.buttonHome.withOpacity(0.5),
                        size: 28,
                      ),
                    ),
            ),
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey.shade900,
                  height: 1.1,
                  letterSpacing: -0.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
