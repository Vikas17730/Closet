import 'package:closet/Providers/Cart_Provider.dart';
import 'package:closet/Providers/Order_Provider.dart';
import 'package:closet/models/Cart_Items.dart' as ci;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        title: Text("Your Cart",
            style: TextStyle(color: Theme.of(context).accentColor)),
      ),
      body: Column(
        children: [
          Card(
            color: Theme.of(context).primaryColor,
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                        fontSize: 20, color: Theme.of(context).accentColor),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Card(
                    color: Theme.of(context).primaryColor,
                    elevation: 3,
                    borderOnForeground: true,
                    child: Orderbutton(cart: cart),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, i) => ci.CartItem1(
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].title,
                cart.items.values.toList()[i].price.toString(),
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].ProductId),
            itemCount: cart.items.length,
          )),
        ],
      ),
    );
  }
}

class Orderbutton extends StatefulWidget {
  const Orderbutton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderbuttonState createState() => _OrderbuttonState();
}

class _OrderbuttonState extends State<Orderbutton> {
  @override
  var _isloading = false;
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: (widget.cart.totalAmount <= 0 || _isloading)
            ? null
            : () async {
                setState(() {
                  _isloading = true;
                });
                await Provider.of<Orders>(context, listen: false).addItem(
                    widget.cart.items.values.toList(), widget.cart.totalAmount);
                setState(() {
                  _isloading = false;
                });
                widget.cart.clearCart();
              },
        child: _isloading
            ? CircularProgressIndicator()
            : Text(
                "Order Now",
                style: TextStyle(color: Theme.of(context).accentColor),
              ));
  }
}
