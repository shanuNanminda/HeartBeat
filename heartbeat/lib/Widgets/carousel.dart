import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Carousel extends StatelessWidget {
  final List<Widget> itemList;
  Carousel(this.itemList);
  // const CarouselSlider({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: itemList,
      options: CarouselOptions(
        autoPlay: true,
        // autoPlayAnimationDuration: Duration(milliseconds: 300),

        viewportFraction: .85,
        aspectRatio: 3 / 4,
        height: 260.0,
      ),
    );
  }
}
