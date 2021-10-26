import 'package:closet/Providers/Auth_Provider.dart';
import 'package:closet/Providers/Cart_Provider.dart';
import 'package:closet/Providers/Product.dart';
import 'package:closet/Screens/Product_details_Screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final product = Provider.of<Product>(context);
    final authData = Provider.of<Auth_Provider>(context, listen: false);
    void selectProduct(context) {
      Navigator.of(context)
          .pushNamed(ProductDetails.routeName, arguments: product.id);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () => selectProduct(context),
        child: GridTile(
          child: Hero(
            tag: product.id,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            leading: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavourtie(authData.token, authData.userID);
              },
            ),
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            trailing: IconButton(
                onPressed: () {
                  cart.addItem(product.id, product.title, product.price);
                  Scaffold.of(context).removeCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "Item added to Cart!",
                    ),
                    duration: Duration(seconds: 3),
                    action: SnackBarAction(
                        label: "UNDO",
                        onPressed: () {
                          cart.removeSingleProduct(product.id);
                        }),
                  ));
                },
                icon: Icon(Icons.shopping_cart),
                color: Theme.of(context).accentColor),
          ),
        ),
      ),
    );
  }
}
