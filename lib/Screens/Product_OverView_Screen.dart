import 'package:closet/Providers/Cart_Provider.dart';
import 'package:closet/Providers/Product_Provider.dart';
import 'package:closet/Screens/Cart_Screen.dart';
import 'package:closet/Screens/login_Screen.dart';
import 'package:closet/models/Main_drawer.dart';

import '../Widget/Product_Grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Widget/badge.dart';

enum FilterOptions { Favourites, All, Login }

class ProductOverView extends StatefulWidget {
  @override
  _ProductOverViewState createState() => _ProductOverViewState();
}

class _ProductOverViewState extends State<ProductOverView> {
  var showFavouriteOnly = false;
  @override
  void initState() {
    // Future.delayed(Duration.zero).then((value){
    // Provider.of<Product_Provider>(context).fetchandset();
    //})
    super.initState();
  }

  var isloading = false;
  var _isinit = true;
  @override
  void didChangeDependencies() {
    if (_isinit) {
      setState(() {
        isloading = true;
      });
      Provider.of<Product_Provider>(context).fetchandset().then((value) {
        setState(() {
          isloading = false;
        });
      });
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        title: Text(
          'Closet',
          style: TextStyle(color: Colors.cyan.shade200),
        ),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, i) =>
                Badge(child: i, value: cart.ItemCount.toString()),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favourites) {
                  //productcontainer.showFavouriteonly();
                  showFavouriteOnly = true;
                }
                if (selectedValue == FilterOptions.Login) {
                  print("Login");
                  Navigator.of(context).pushNamed(AuthScreen.routeName);
                }
                if (selectedValue == FilterOptions.All) {
                  //productcontainer.showAll();
                  showFavouriteOnly = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Favourites"),
                value: FilterOptions.Favourites,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: FilterOptions.All,
              ),
              PopupMenuItem(
                child: Text("Login"),
                value: FilterOptions.Login,
              ),
            ],
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: isloading
          ? Center(child: CircularProgressIndicator())
          : ProductGrid(showFavouriteOnly),
    );
  }
}
