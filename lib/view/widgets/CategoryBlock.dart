// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../screens/category_screen.dart';

// ignore: must_be_immutable
class CategoryBlock extends StatelessWidget {
  String categoryName;
  String categoryImgSrc;
  CategoryBlock({
    Key? key,
    required this.categoryName,
    required this.categoryImgSrc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryScreen(
                    catImgUrl: categoryImgSrc, catName: categoryName)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                  height: 50, width: 100, fit: BoxFit.cover, categoryImgSrc),
            ),
            Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12)),
            ),
            Positioned(
              left: 30,
              top: 15,
              child: Text(
                categoryName,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }
}
