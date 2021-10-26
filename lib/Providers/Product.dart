import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;
  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavourite = false});

  Future<void> toggleFavourtie(String token, String userId) async {
    final oldstatus = isFavourite;
    isFavourite = !(isFavourite);
    notifyListeners();
    final url = Uri.parse(
        'https://closet-e63e8-default-rtdb.firebaseio.com/userFavourites/$userId/$id.json?auth=$token');
    try {
      await http.put(url,
          body: json.encode({
            'IsFavourite': isFavourite,
          }));
    } catch (error) {
      isFavourite = oldstatus;
      notifyListeners();
    }
  }
}
