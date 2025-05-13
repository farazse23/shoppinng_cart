import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppinng_cart/cart_provider.dart';
import 'product_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => CartProvider(),
       child: Builder(builder: (BuildContext context){
         return MaterialApp(
           debugShowCheckedModeBanner: false,
           title: 'Flutter Demo',
           theme: ThemeData(
             colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
           ),
           home: ProductListScreen(),
         );
       }),
    );
  }
}




