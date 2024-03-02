import 'package:flutter/material.dart';
import 'models/product_model.dart';
import 'files/midmock.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        cardColor: Colors.green[50],
        
      ),
      home: const ProductDisplay(),
    );
  }
}
