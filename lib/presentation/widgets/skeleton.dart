import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonView extends StatelessWidget {
  const SkeletonView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SkeletonAnimation(
      borderRadius: BorderRadius.circular(20),
      shimmerColor: Colors.white54,
      child: Container(
        height: size.height * 0.1,
        width: size.width * 1,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: Colors.grey[300]),
      ),
    );
  }
}
