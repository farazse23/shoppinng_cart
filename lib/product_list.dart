import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shoppinng_cart/cart_model.dart';
import 'package:shoppinng_cart/cart_provider.dart';
import 'package:shoppinng_cart/cart_screen.dart';
import 'package:shoppinng_cart/db_helper.dart';
import 'package:sqflite/sqflite.dart';


class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {

  DBHelper? dbhelper = DBHelper();

  List<String> productName = ['Mango','Orange','Grapes','Banana','Cherry','Peach'];
  List<String> productUnit = ['KG', 'Dozen', 'KG', 'Dozen', 'KG','KG'];
  List<int> productPrice =  [10, 20, 30, 40, 50,60];
  List<String> productImage = [
    'https://tse4.mm.bing.net/th?id=OIP.Dthb-I9m204FuHRtPzkcPAHaEa&w=282&h=282&c=7', // Mango
    'https://tse2.mm.bing.net/th?id=OIP.fYYYEYkYKvJX3TQtF5ssIQHaE8&w=316&h=316&c=7', // Orange
    'https://tse4.mm.bing.net/th?id=OIP.g84nICklA5fnZDhFV23t-QHaFS&w=338&h=338&c=7', // Grapes
    'https://tse3.mm.bing.net/th?id=OIP.DzzBtp9wRuY1VocmOurZ7gHaJE&w=474&h=474&c=7', // Banana
    'https://tse4.mm.bing.net/th?id=OIP.7lFskQ-SD1PvqYXAicvqcQHaJ3&w=474&h=474&c=7', // Cherry
    'https://tse4.mm.bing.net/th?id=OIP.NfjjxbuEOTjgtKxPmS382wHaI2&w=474&h=474&c=7'  // Peach
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Product List", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));
            },
            child:  Center(
              child: badges.Badge(
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value, child){
                    return Text(value.getCounter().toString(), style: TextStyle(color: Colors.white),);
                  },),
                badgeAnimation: badges.BadgeAnimation.rotation(
                  animationDuration: Duration(seconds: 1),
                ),
                badgeStyle: badges.BadgeStyle(
                  badgeColor: Provider.of<CartProvider>(context).getCounter() == 0
                      ? Colors.red // If cart is empty, color is red
                      : Colors.green, // If cart has items, color is green
                ),

                child:   Icon(Icons.shopping_bag_outlined, size: 30, color: Colors.white.withOpacity(.6)),
              ),
            ),
          ),
          SizedBox(width: 30,)
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: productName.length,
                  itemBuilder: (context, index){
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(

                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image(
                                    height: 100,
                                    width: 100,
                                    image: NetworkImage(productImage[index].toString())
                                ),
                                SizedBox(width: 10,),
                                Expanded(child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(productName[index].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                    SizedBox(height: 3,),
                                    Text(productPrice[index].toString()+r"$"+" "+productUnit[index].toString(), style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
                                    SizedBox(height: 5,),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child:  InkWell(
                                        onTap: () {
                                          dbhelper!.insert(
                                              Cart(id: index,
                                                productId: index.toString(),
                                                productName: productName[index]
                                                    .toString(),
                                                initialPrice: productPrice[index],
                                                productPrice: productPrice[index],
                                                quantity: 1,
                                                unitTag: productUnit[index].toString(),
                                                image: productImage[index].toString(),
                                              )
                                          ).then((value) {
                                            print('Added to cart');
                                            cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                            cart.addCounter();

                                          }).onError((error, stackTrace) {
                                            print(error.toString());
                                          });
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text("Add To Cart", style: TextStyle(color: Colors.white),),
                                          ),
                                        ),
                                      ),
                                    )

                                  ],
                                ), ),

                              ],

                            ),
                          ],
                        ),
                      ),
                    );
                  })),

        ],
      ),
    );
  }
}
