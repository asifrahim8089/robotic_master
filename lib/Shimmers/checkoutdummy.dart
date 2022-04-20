import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget loadingShimmer() {
  return Shimmer.fromColors(
    baseColor: const Color(0xBBE6E6E6),
    highlightColor: const Color(0x77EEEEEE),
    child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: 4,
        itemBuilder: (context, int index) {
          return Container(
            height: 150,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          );
        }),
  );
}
