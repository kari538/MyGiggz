import 'package:flutter/material.dart';

class Stars extends StatelessWidget {
  const Stars(this.rating);

  final double rating;

  @override
  Widget build(BuildContext context) {
    int wholeStars = rating.truncate();
    double partStar = rating - wholeStars;
    print('Rating is $rating, giving $wholeStars whole stars and $partStar part star');
    List<Widget> stars = [];
    for (int i = 0; i < wholeStars; i++) {
      stars.add(Image(image: AssetImage('images/stars/star_no_bg.png'),));
    }
    Widget partStarImage;

    if (partStar > 0.1 && partStar < 0.37) {
      partStarImage = Image(image: AssetImage('images/stars/star_quarter_no_bg.png'));
    } else if (partStar >= 0.37 && partStar < 0.63) {
      partStarImage = Image(image: AssetImage('images/stars/star_half_no_bg.png'));
      // partStarImage = Image(image: AssetImage('images/stars/star_3quarter_no_bg.png'));
    } else if (partStar >= 0.63) {
      partStarImage = Image(image: AssetImage('images/stars/star_3quarter_no_bg.png'));
    }
    stars.add(
      partStarImage,
    );

    return SizedBox(
      height: 15,
      child: Row(
        children: stars,
        // children: [
        //   Image(image: AssetImage('images/stars/star_quarter_no_bg.png'),),
        //   Image(image: AssetImage('images/stars/star_half_no_bg.png'),),
        //   Image(image: AssetImage('images/stars/star_3quarter_no_bg.png'),),
        //   Image(image: AssetImage('images/stars/star_no_bg.png'),),
        // ],
      ),
    );
  }
}