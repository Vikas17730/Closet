import 'dart:math';

import 'package:closet/Providers/Order_Provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderItem1 extends StatefulWidget {
  final OrderItem order;
  OrderItem1(this.order);

  @override
  _OrderItem1State createState() => _OrderItem1State();
}

class _OrderItem1State extends State<OrderItem1> {
  var expand = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
      height: expand ? min(widget.order.Products.length * 20.0 + 110, 200) : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.Amount}'),
              subtitle: Text(
                  DateFormat('dd/MM/yyyy hh:mm').format(widget.order.time1)),
              trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      expand = !expand;
                    });
                  },
                  icon: Icon(expand ? Icons.expand_less : Icons.more)),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: expand
                  ? min(widget.order.Products.length * 20.0 + 10, 100)
                  : 0,
              child: ListView(
                  children: widget.order.Products
                      .map((pro) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(pro.title),
                              Text('${pro.quantity}x${pro.price}')
                            ],
                          ))
                      .toList()),
            )
          ],
        ),
      ),
    );
  }
}
