import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppinng_cart/db_helper.dart';
import 'cart_model.dart';
import 'cart_provider.dart';
import 'db_helper.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("My Products", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        centerTitle: true,
        actions: [
          Center(
            child: badges.Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child){
                  return Text(value.getCounter().toString(), style: TextStyle(color: Colors.white),);
                },),
              badgeAnimation: badges.BadgeAnimation.rotation(
                animationDuration: Duration(seconds: 1),
              ),
              badgeStyle: badges.BadgeStyle(
                badgeColor: Colors.red,
              ),

              child:   Icon(Icons.shopping_bag_outlined, size: 30, color: Colors.white.withOpacity(.6)),
            ),
          ),
          SizedBox(width: 30,)
        ],
      ),
      body : Column(
        children: [
          FutureBuilder(
            future: cart.getData(),

            builder: (BuildContext context, AsyncSnapshot<List<Cart>?> snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
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
                                    image: NetworkImage(snapshot.data![index].image.toString()),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment : MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data![index].productName.toString(),
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                            ),
                                            InkWell(
                                              onTap: (){
                                                dbHelper.delete(snapshot.data![index].id!);
                                                cart.removeCounter();
                                                cart.removeTotalPrice(double.parse(  snapshot.data![index].productPrice.toString()));
                                              },
                                              child:  Icon(Icons.delete),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          snapshot.data![index].productPrice.toString() +
                                              r"$" +
                                              " " + snapshot.data![index].unitTag.toString(),
                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                                        ),
                                        SizedBox(height: 5),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: InkWell(
                                            onTap: () {},
                                            child: Container(
                                              height: 35,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                padding:  EdgeInsets.all(4),
                                                child: Row(
                                                  mainAxisAlignment : MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    InkWell(
                                                        onTap : (){

                                                          int quantity = snapshot.data![index].quantity!;
                                                          int price = snapshot.data![index].initialPrice!;
                                                          quantity--;
                                                          int? newPrice = price * quantity;

                                                          if(quantity>0){
                                                            dbHelper.updateQuantity(
                                                              Cart(id:  snapshot.data![index].id,
                                                                productId: snapshot.data![index].id.toString(),
                                                                productName: snapshot.data![index].productName!,
                                                                initialPrice: snapshot.data![index].initialPrice!,
                                                                productPrice: newPrice,
                                                                quantity: quantity,
                                                                unitTag: snapshot.data![index].unitTag.toString(),
                                                                image: snapshot.data![index].image.toString(),
                                                              ),
                                                            ).then((value) {
                                                              print("Quantity updated successfully!");
                                                              newPrice = 0;
                                                              quantity = 0;
                                                              cart.removeTotalPrice(double.parse( snapshot.data![index].initialPrice!.toString()));
                                                            }).onError((error, stackTrace) {
                                                              print("Error updating quantity: $error");
                                                            });
                                                          }


                                                        },
                                                        child: Icon(Icons.remove, color: Colors.white,)
                                                    ),
                                                    Text(
                                                      snapshot.data![index].quantity.toString(),
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                    InkWell(
                                                      onTap: (){
                                                        int quantity = snapshot.data![index].quantity!;
                                                        int price = snapshot.data![index].initialPrice!;
                                                        quantity++;
                                                        int? newPrice = price * quantity;
                                                        dbHelper.updateQuantity(
                                                          Cart(id:  snapshot.data![index].id,
                                                            productId: snapshot.data![index].id.toString(),
                                                            productName: snapshot.data![index].productName!,
                                                            initialPrice: snapshot.data![index].initialPrice!,
                                                            productPrice: newPrice,
                                                            quantity: quantity,
                                                            unitTag: snapshot.data![index].unitTag.toString(),
                                                            image: snapshot.data![index].image.toString(),
                                                          ),
                                                        ).then((value) {
                                                          print("Quantity updated successfully!");
                                                          newPrice = 0;
                                                          quantity = 0;
                                                          cart.addTotalPrice(double.parse( snapshot.data![index].initialPrice!.toString()));
                                                        }).onError((error, stackTrace) {
                                                          print("Error updating quantity: $error");
                                                        });
                                                      },
                                                      child:  Icon(Icons.add, color: Colors.white,),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Text("No products found",style: TextStyle(fontSize: 24, color: Color(0xffEAC977), fontWeight: FontWeight.bold),)); // Show loading while waiting
              } else {
                return Center(child: Text("No products found")); // Show this if no data
              }
            },




          ),
          Consumer<CartProvider>(builder: (context,value,child){
            return Column(
              children: [
                ReusableWidget(title: 'Sub Total', value:r'$'+value.getTotalPrice().toString() ),
                ReusableWidget(title: 'Discount 5%', value:r'$'+value.getTotalPrice().toString() ),
                ReusableWidget(title: 'Total Price', value:r'$'+value.getTotalPrice().toString() ),
              ],
            );
          })
        ],
      ),

    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;

  const ReusableWidget({required this.title, required this.value, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter, // Moves it towards the top
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9, // Make it responsive
            decoration: BoxDecoration(
              color: Colors.white, // Background color
              borderRadius: BorderRadius.circular(12), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black26, // Shadow color
                  blurRadius: 8, // Soft shadow
                  spreadRadius: 2,
                  offset: Offset(0, 4), // Vertical shadow offset
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Dark text color
                  fontSize: 18, // Adjust font size
                ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent, // Accent color
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

