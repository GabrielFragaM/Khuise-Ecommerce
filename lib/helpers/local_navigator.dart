import 'package:flutter/cupertino.dart';
import 'package:lojas_khuise/constants/controllers.dart';
import 'package:lojas_khuise/routing/router.dart';
import 'package:lojas_khuise/routing/routes.dart';

Navigator localNavigator() =>   Navigator(
      key: navigationController.navigatorKey,
      onGenerateRoute: generateRoute,
      initialRoute: AllProductsPageRoute,
    );



