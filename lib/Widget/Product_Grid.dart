import 'package:closet/Providers/Product_Provider.dart';
import 'package:flutter/material.dart';
import 'package:closet/models/product_item.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  var Fav;
  ProductGrid(this.Fav);
  @override
  Widget build(BuildContext context) {
    final ProductData = Provider.of<Product_Provider>(context);
    final Products = Fav ? ProductData.FavouriteItems : ProductData.item;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: Products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: Products[i],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
    );
  }
}
