import 'package:flutter/material.dart';
import 'package:ricoz_project/bottom_nav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffDB3022)),
        useMaterial3: true,
      ),

      //home: MyCart(),
      home: BtmNav(),
    );
  }
}
