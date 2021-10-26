import 'package:closet/Providers/Product_Provider.dart';
import 'package:closet/Screens/Edit_Product_Screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  String id;
  String title;
  String imageUrl;
  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold.of(context);
    final productdata = Provider.of<Product_Provider>(context);
    return Container(
      child: ListTile(
          title: Text(title),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          trailing: Container(
            width: 100,
            child: Row(children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditProductsScreen.routeName, arguments: id);
                  },
                  icon: Icon(Icons.edit)),
              IconButton(
                onPressed: () async {
                  try {
                    await Provider.of<Product_Provider>(context, listen: false)
                        .DeleteProduct(id);
                  } catch (error) {
                    scaffold.showSnackBar(
                        SnackBar(content: Text("Deletion failed!")));
                  }
                },
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
              )
            ]),
          )),
    );
  }
}
