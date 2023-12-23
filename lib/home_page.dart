// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ricoz_project/cart.dart';
import 'package:http/http.dart' as http;
import 'package:ricoz_project/model/api_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<ProductModel> productList = [];

class _MyHomePageState extends State<MyHomePage> {
  Future<List<ProductModel>> fetchProducts() async {
    const String url = 'https://dummyjson.com/products';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final mapResponse = json.decode(response.body);

        productList = List<ProductModel>.from(
          mapResponse["products"]
              .map((ele) => ProductModel.fromJson(ele))
              .toList(),
        );
        return productList;
      } else {
        print('Request failed with status code: ${response.statusCode}');
        print('Response data: ${response.body}');
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch products');
    }
  }

  @override
  void initState() {
    initializeData();
    super.initState();
  }

  Future<void> initializeData() async {
    try {
      await fetchProducts();
      setState(() {}); // Trigger a rebuild to update the UI
    } catch (error) {
      // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    // var w = MediaQuery.of(context).size.width;
    // var h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: InkWell(
                  onTap: () {
                    fetchProducts();
                    print(productList[1].thumbnail);
                  },
                  child: Text(
                    "Products",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Color(
                        0xff222222,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Text(
                  'Super Summer Sale',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff9B9B9B),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MyCart(desc: productList[index]),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                // color: Colors.amber,
                                image: DecorationImage(
                                    image: NetworkImage(
                                      productList[index].thumbnail,
                                    ),
                                    fit: BoxFit.fill),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              width: 171,
                              height: 145,
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Container(
                                      width: 40,
                                      height: 25,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Color(0xFFDB3022)),
                                      child: Center(
                                        child: Text(
                                          '${productList[index].discountPercentage.toInt()}%',
                                          style: GoogleFonts.lato(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 155,
                              height: 145,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        buildRating(4.5),
                                        SizedBox(width: 5),
                                        Text(
                                            '(${productList[index].stock.toInt()})')
                                      ],
                                    ),
                                    Text(
                                      productList[index].brand,
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff9B9B9B)),
                                    ),
                                    Text(
                                      productList[index].title,
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${productList[index].price.toInt()}\$',
                                          style: TextStyle(
                                              color: Color(0xff9B9B9B),
                                              fontSize: 14,
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '${calculateDiscountedPrice(
                                            productList[index].price,
                                            productList[index]
                                                .discountPercentage,
                                          ).toInt()}\$',
                                          style: TextStyle(
                                            color: Color(0xffDB3022),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
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
