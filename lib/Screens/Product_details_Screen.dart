import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:closet/Providers/Product_Provider.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  static const routeName = 'Product-Details';

  @override
  Widget build(BuildContext context) {
    final ProductID = ModalRoute.of(context).settings.arguments as String;
    final loadedProducts =
        Provider.of<Product_Provider>(context).findbyid(ProductID);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).primaryColor,
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                loadedProducts.title,
                style: TextStyle(color: Colors.cyan.shade200),
              ),
              background: Hero(
                  tag: loadedProducts.id,
                  child: Image.network(loadedProducts.imageUrl)),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                '\$${loadedProducts.price}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                loadedProducts.title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text(
                loadedProducts.description,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor),
                softWrap: true,
                textAlign: TextAlign.center,
              ),
              width: double.infinity,
            ),
            SizedBox(
              height: 800,
            ),
          ]))
        ],
      ),
    );
  }
}
