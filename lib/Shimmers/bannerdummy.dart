import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget bannerShimmer() {
  return Shimmer.fromColors(
    baseColor: const Color(0xBBE6E6E6),
    highlightColor: const Color(0x77EEEEEE),
    child: SizedBox(
      height: 180,
      width: 280,
      child: ListView.builder(
        itemCount: 2,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 250,
              height: 180,
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      ),
    ),
  );
}
