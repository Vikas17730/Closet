import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  String ProductId;
  double price;
  int quantity;
  String title;

  CartItem(
      {@required this.ProductId,
      @required this.price,
      @required this.quantity,
      @required this.title});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get ItemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, CartItem) {
      total += CartItem.price * CartItem.quantity;
    });
    return total;
  }

  var addedtoCart = false;

  void addItem(String ProductID, String title, double Price) {
    if (_items.containsKey(ProductID)) {
      _items.update(
          ProductID,
          (exCartItem) => CartItem(
              ProductId: exCartItem.ProductId,
              price: exCartItem.price,
              title: exCartItem.title,
              quantity: exCartItem.quantity + 1));
    } else {
      _items.putIfAbsent(
          ProductID,
          () => CartItem(
              ProductId: DateTime.now().toString(),
              price: Price,
              quantity: 1,
              title: title));
    }
    ;
    notifyListeners();
  }

  void deleteItem(String ProductId) {
    _items.remove(ProductId);
    notifyListeners();
  }

  void removeSingleProduct(String ProductId) {
    if (!_items.containsKey(ProductId)) {
      return;
    }
    if (_items[ProductId].quantity > 1) {
      _items.update(
          ProductId,
          (ExCartItem) => CartItem(
              ProductId: ExCartItem.ProductId,
              price: ExCartItem.price,
              quantity: ExCartItem.quantity - 1,
              title: ExCartItem.title));
    } else {
      _items.remove(ProductId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
