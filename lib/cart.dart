// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ricoz_project/model/api_model.dart';

class MyCart extends StatefulWidget {
  final ProductModel desc;
  const MyCart({Key? key, required this.desc}) : super(key: key);

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  List<bool> isLikedList = [false, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.desc.title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 400,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.desc.images.length,
              itemBuilder: (context, imageIndex) {
                return SizedBox(
                  width: 275,
                  height: 56,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 275,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(widget.desc.images[imageIndex]),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16),
                  child: Text(
                    widget.desc.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '${calculateDiscountedPrice(
                    widget.desc.price,
                    widget.desc.discountPercentage,
                  ).toInt()}\$',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
            ),
            child: Text(
              widget.desc.category,
              style: TextStyle(
                  color: Color(0xff9B9B9B),
                  fontSize: 11,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildRating(4.5),
                SizedBox(width: 5),
                Text('(${widget.desc.stock.toInt()})')
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16, top: 10),
            width: 343,
            child: Text(
              widget.desc.description,
              style: GoogleFonts.lato(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          Spacer(),
          Divider(
            height: 6,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 343,
              child: TextButton(
                onPressed: () {
                  print('TextButton pressed!');
                },
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xffDB3022),
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                  shape: StadiumBorder(),
                ),
                child: Text(
                  'ADD TO CART',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 5)
        ],
      ),
    );
  }

  Widget buildRating(double rating) {
    int numberOfFullStars = rating.floor();
    bool hasHalfStar = rating - numberOfFullStars > 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < numberOfFullStars; i++)
          Icon(
            Icons.star,
            color: Colors.yellow,
          ),
        if (hasHalfStar)
          Icon(
            Icons.star_half,
            color: Colors.yellow,
          ),
      ],
    );
  }

  double calculateDiscountedPrice(
      double actualPrice, double discountPercentage) {
    if (actualPrice <= 0 ||
        discountPercentage < 0 ||
        discountPercentage > 100) {
      // Invalid input, return the original price
      return actualPrice;
    }

    double discountAmount = (actualPrice * discountPercentage) / 100;
    double discountedPrice = actualPrice - discountAmount;

    return discountedPrice;
  }
}
