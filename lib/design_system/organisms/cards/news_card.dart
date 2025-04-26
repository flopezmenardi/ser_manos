import 'package:flutter/material.dart';
import 'package:ser_manos/design_system/molecules/buttons/text_button.dart';

class NewsCardSermanos extends StatelessWidget {
  final String imageUrl;
  final String preTitle;
  final String title;
  final String subtitle;
  final String ctaText;
  final VoidCallback onPressed;

  const NewsCardSermanos({
    super.key,
    required this.imageUrl,
    required this.preTitle,
    required this.title,
    required this.subtitle,
    required this.ctaText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 158,
      width: 328,
      child: Card(
        elevation: 2,
        child: Row(
          children: [
            Image.asset(
              imageUrl,
              width: 118,
              height: 156,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      preTitle.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextOnlySermanosButton(
                        onPressed: onPressed,
                        text: ctaText
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
