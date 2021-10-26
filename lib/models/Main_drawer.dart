import 'package:closet/Providers/Auth_Provider.dart';
import 'package:closet/Screens/Order_Screen.dart';
import 'package:closet/Screens/User_Product_Screen.dart';
import 'package:closet/helpers/custom_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.shop),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
            title: Text('Home'),
          ),
          ListTile(
            title: Text("My Orders"),
            leading: Icon(Icons.payment),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
              //  Navigator.of(context).pushReplacement(
              //    CustomRoutes(builder: (context) => OrderScreen()));
            },
          ),
          ListTile(
            title: Text("Manage Products"),
            leading: Icon(Icons.edit),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
            },
          ),
          ListTile(
            title: Text('LogOut'),
            leading: Icon(Icons.logout),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth_Provider>(context, listen: false).logout();
            },
          )
        ],
      ),
    );
  }
}
