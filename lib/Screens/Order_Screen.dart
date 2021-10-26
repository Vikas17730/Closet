import 'package:closet/Providers/Order_Provider.dart';
import 'package:closet/models/Main_drawer.dart';
import 'package:closet/models/Order_Items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '\Orders';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _Isloading = false;
  @override
  void initState() {
    //Future.delayed(Duration.zero).then((value) async {

    _Isloading = true;

    Provider.of<Orders>(context, listen: false).getandset().then((_) {
      setState(() {
        _Isloading = false;
      });
    });
    //  });
    super.initState();
  }

  Widget build(BuildContext context) {
    final Order1 = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        title: Text(
          "Order Details",
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
      ),
      drawer: MainDrawer(),
      body: _Isloading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (ctx, index) => OrderItem1(Order1.Order[index]),
              itemCount: Order1.Order.length,
            ),
    );
  }
}
