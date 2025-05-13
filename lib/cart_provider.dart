


import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppinng_cart/db_helper.dart';

import 'cart_model.dart';

class CartProvider with ChangeNotifier{
 DBHelper db = DBHelper();
  int  _counter = 0;

  int get counter => _counter;

  double _totalPrice = 0.0;

  double get totalPrice => _totalPrice;

  late Future<List<Cart>> _cart;
   Future<List<Cart>> get cart => _cart;

  Future<List<Cart>?> getData () async{
     _cart = db.getCartList();
     return _cart;
  }

  void _setPrefitems() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_item', _counter);
    prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void _getPrefitems() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
  _counter = prefs.getInt('cart_item') ?? 0;
   _totalPrice =  prefs.getDouble('total_price') ?? 0;
    notifyListeners();
  }

  // Increment cart item count
  void addCounter() {
    _counter++;
    _setPrefitems();
    notifyListeners();
  }

  // Decrement cart item count (with minimum limit check)
  void removeCounter() {
    if (_counter > 0) {
      _counter--;
      _setPrefitems();
      notifyListeners();
    }
  }

  int getCounter(){
    _getPrefitems();
    return _counter;
  }

  // Add price to total
  void addTotalPrice(double productPrice) {
    _totalPrice += productPrice;
    _setPrefitems();
    notifyListeners();
  }

  // Remove price from total (with minimum limit check)
  void removeTotalPrice(double productPrice) {
    if (_totalPrice > 0) {
      _totalPrice -= productPrice;
      _setPrefitems();
      notifyListeners();
    }
  }

  double getTotalPrice(){
    _getPrefitems();
    return _totalPrice;
  }
}