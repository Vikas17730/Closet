import 'package:closet/Providers/Cart_Provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  String Id;
  double Amount;
  List<CartItem> Products;
  final DateTime time1;

  OrderItem({
    this.Id,
    this.Amount,
    this.Products,
    this.time1,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _Order = [];
  final String authToken;
  final String userId;
  Orders(this.authToken, this.userId, this._Order);
  List<OrderItem> get Order {
    return [..._Order];
  }

  Future<void> getandset() async {
    final url = Uri.parse(
        'https://closet-e63e8-default-rtdb.firebaseio.com/Orders/$userId.json?auth=$authToken');
    final response = await http.get(url);
    final List<OrderItem> loadedOrder = [];
    final extracted_Data = json.decode(response.body) as Map<String, dynamic>;
    if (extracted_Data == null) {
      return;
    }
    extracted_Data.forEach((OrderId, OrderData) {
      loadedOrder.add(OrderItem(
          Id: OrderId,
          Amount: OrderData['amount'],
          Products: (OrderData['Products'] as List<dynamic>)
              .map((items) => CartItem(
                  ProductId: items['id'],
                  price: items['price'],
                  quantity: items['quantity'],
                  title: items['title']))
              .toList(),
          time1: DateTime.parse(OrderData['time'])));
    });
    print(json.decode(response.body));
    _Order = loadedOrder.reversed.toList();
    notifyListeners();
  }

  Future<void> addItem(List<CartItem> cartProduct, double total) async {
    final url = Uri.parse(
        'https://closet-e63e8-default-rtdb.firebaseio.com/Orders/$userId.json?auth=$authToken');
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'time': timestamp.toIso8601String(),
          'Products': cartProduct
              .map((cp) => {
                    'id': cp.ProductId,
                    'title': cp.title,
                    'price': cp.price,
                    'quantity': cp.quantity,
                  })
              .toList(),
        }));
    _Order.insert(
        0,
        OrderItem(
            Id: json.decode(response.body)['name'],
            Amount: total,
            time1: timestamp,
            Products: cartProduct));
    notifyListeners();
  }
}
