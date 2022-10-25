import 'package:flutter/material.dart';
import 'package:lojas_khuise/pages/screen_products/all_products.dart';
import 'package:lojas_khuise/pages/orders_screen/orders_user/all_orders.dart';
import 'package:lojas_khuise/routing/routes.dart';

Route<dynamic> generateRoute(RouteSettings settings){
  switch (settings.name) {
    case AllProductsPageRoute:
      return _getPageRoute(All_Products());
    case driversPageRoute:
      return _getPageRoute(OrdersUserScreen());
    default:
      return _getPageRoute(All_Products());

  }
}

PageRoute _getPageRoute(Widget child){
  return MaterialPageRoute(builder: (context) => child);
}