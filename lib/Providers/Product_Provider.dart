import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:closet/Providers/Product.dart';
import 'package:http/http.dart' as http;

class Product_Provider with ChangeNotifier {
  List<Product> _items = [
    /* Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),*/
  ];
  final String authToken;
  final String userId;
  Product_Provider(this.authToken, this.userId, this._items);
//  var _showFavouriteonly = false;
  List<Product> get item {
    /*if (_showFavouriteonly) {
      return _items.where((pro) => pro.isFavourite!).toList();
    }*/
    return [..._items];
  }

  Future<void> fetchandset([bool filterByuser = false]) async {
    final filterString =
        filterByuser ? 'orderBy="userId"&equalTo="$userId" ' : ' ';
    final url = Uri.parse(
        'https://closet-e63e8-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(url);
      //print(json.decode(response.body));
      final extracted_data = json.decode(response.body) as Map<String, dynamic>;
      if (extracted_data == null) {
        return;
      }
      final url1 = Uri.parse(
          'https://closet-e63e8-default-rtdb.firebaseio.com/userFavourites/$userId.json?auth=$authToken');
      final favouriteResponse = await http.get(url1);
      final favouriteData = json.decode(favouriteResponse.body);
      final List<Product> loadedProducts = [];
      extracted_data.forEach((proId, proData) {
        //print(favouriteData[proId]['IsFavourite']);
        loadedProducts.add(
          Product(
            id: proId,
            title: proData['title'],
            description: proData['Description'],
            price: proData['price'],
            imageUrl: proData['ImageUrl'],
            isFavourite: favouriteData == null
                ? false
                : favouriteData[proId]['IsFavourite'] ?? false,
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addItems(Product pro) async {
    final url = Uri.parse(
        'https://closet-e63e8-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final Response = await http.post(
        url,
        body: json.encode({
          'title': pro.title,
          'id': pro.id,
          'price': pro.price,
          'Description': pro.description,
          'ImageUrl': pro.imageUrl,
          // 'IsFavourite': pro.isFavourite,
          'userId': userId,
        }),
      );
      final newProduct = Product(
        id: json.decode(Response.body)['name'],
        price: pro.price,
        title: pro.title,
        description: pro.description,
        imageUrl: pro.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  /*void showFavouriteonly() {
    _showFavouriteonly = true;
    notifyListeners();
  }*/

  /*void showAll() {
    _showFavouriteonly = false;
    notifyListeners();
  }*/
  List<Product> get FavouriteItems {
    return _items.where((pro) => pro.isFavourite).toList();
  }

  Product findbyid(String id) {
    return _items.firstWhere((pro) => pro.id == id);
  }

  Future<void> UpdateProducts(String id, Product newProduct) async {
    final ProductIndex = _items.indexWhere((Prod) => Prod.id == id);
    if (ProductIndex >= 0) {
      final url = Uri.parse(
          'https://closet-e63e8-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'Description': newProduct.description,
            'ImageUrl': newProduct.imageUrl,
          }));
      _items[ProductIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> DeleteProduct(String id) async {
    final url = Uri.parse(
        'https://closet-e63e8-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    final existingproductindex = _items.indexWhere((prod) => prod.id == id);
    var existingproduct = _items[existingproductindex];

    _items.removeAt(existingproductindex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingproductindex, existingproduct);
      notifyListeners();
      throw HttpException("The item cant be deleted.");
    }
    existingproduct = Product(
        id: "dbhksad",
        title: "rough",
        description: "description",
        price: 0.2321,
        imageUrl: "imageUrl");
  }
}
