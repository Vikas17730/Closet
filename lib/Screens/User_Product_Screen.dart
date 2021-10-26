import 'package:closet/Providers/Product_Provider.dart';
import 'package:closet/Screens/Edit_Product_Screen.dart';
import 'package:closet/models/Main_drawer.dart';
import 'package:closet/models/User_Product_Item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '\UserProductScreen';
  Future<void> refreshProduct(BuildContext context) async {
    await Provider.of<Product_Provider>(context, listen: false)
        .fetchandset(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productdata = Provider.of<Product_Provider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        title: Text(
          'Your Products',
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductsScreen.routeName);
              },
              icon: Icon(Icons.add),
              color: Theme.of(context).accentColor)
        ],
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
        future: refreshProduct(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => refreshProduct(context),
                    child: Container(
                      child: Consumer<Product_Provider>(
                        builder: (ctx, productdata, _) => Padding(
                          padding: EdgeInsets.all(8),
                          child: Expanded(
                            child: ListView.builder(
                              itemBuilder: (_, i) => Column(
                                children: [
                                  UserProductItem(
                                      productdata.item[i].id,
                                      productdata.item[i].title,
                                      productdata.item[i].imageUrl),
                                  Divider()
                                ],
                              ),
                              itemCount: productdata.item.length,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
