import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/extensions.dart';

class LoadingProductCard extends StatelessWidget {
  final double? width;
  final double? height;

  const LoadingProductCard({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: Shimmer.fromColors(
          baseColor: context.colorScheme.surfaceContainerHighest,
          highlightColor: context.colorScheme.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                ),
              ),

              // Content placeholder
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand placeholder
                      Container(
                        width: 60,
                        height: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),

                      // Title placeholder
                      Container(
                        width: double.infinity,
                        height: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 120,
                        height: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),

                      // Rating placeholder
                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 30,
                            height: 12,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      const Spacer(),

                      // Price placeholder
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 18,
                            color: Colors.white,
                          ),
                          const Spacer(),
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ],
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
}