import 'package:closet/Providers/Auth_Provider.dart';
import 'package:closet/Providers/Cart_Provider.dart';
import 'package:closet/Providers/Order_Provider.dart';
import 'package:closet/Providers/Product.dart';
import 'package:closet/Providers/Product_Provider.dart';
import 'package:closet/Screens/Cart_Screen.dart';
import 'package:closet/Screens/Edit_Product_Screen.dart';
import 'package:closet/Screens/Order_Screen.dart';
import 'package:closet/Screens/Product_OverView_Screen.dart';
import 'package:closet/Screens/Product_details_Screen.dart';
import 'package:closet/Screens/User_Product_Screen.dart';
import 'package:closet/Screens/login_Screen.dart';
import 'package:closet/Screens/splash_screen.dart';
import 'package:closet/helpers/custom_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Auth_Provider()),
          ChangeNotifierProxyProvider<Auth_Provider, Product_Provider>(
            // create: (ctx)=>,
            update: (ctx, auth, previousData) => Product_Provider(auth.token,
                auth.userID, previousData == null ? [] : previousData.item),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth_Provider, Orders>(
              update: (ctx, auth, previousData) => Orders(auth.token,
                  auth.userID, previousData == null ? [] : previousData.Order)),
        ],
        child: Consumer<Auth_Provider>(
          builder: (ctx, auth, _) => MaterialApp(
            title: "Closet",
            theme: ThemeData(
                primaryColor: Colors.grey.shade800,
                accentColor: Colors.cyan.shade200,
                fontFamily: 'Lato',
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomTransitionRoute(),
                  TargetPlatform.iOS: CustomTransitionRoute(),
                })),
            home: auth.IsAuth
                ? ProductOverView()
                : FutureBuilder(
                    future: auth.autologin(),
                    builder: (ctx, authresultsnapshot) =>
                        authresultsnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetails.routeName: (ctx) => ProductDetails(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrderScreen.routeName: (ctx) => OrderScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProductsScreen.routeName: (ctx) => EditProductsScreen(),
              AuthScreen.routeName: (ctx) => AuthScreen(),
            },
          ),
        ));
  }
}
