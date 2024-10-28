import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key, required this.imageList});

  final List<String> imageList;

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  late String image;
  late int imageCount;

  @override
  void initState() {
    image = widget.imageList.first;
    imageCount = widget.imageList.length;
    super.initState();
  }

  void changeImage(bool isNext) {
    int index = widget.imageList.indexOf(image);
    if (index + 1 > imageCount) {
      index = 0;
    } else if (index - 1 < 0) {
      index = imageCount;
    }
    if (!isNext) {
      image = widget.imageList[index + 1];
    } else {
      image = widget.imageList[index - 1];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails direction) {
        setState(() {
          if (direction.velocity.pixelsPerSecond.dx.isNegative) {
            changeImage(false);
          } else {
            changeImage(true);
          }
        });
      },
      child: Container(
        height: 400,
        child: Image.network(image, fit: BoxFit.cover),
      ),
    );
  }
}
