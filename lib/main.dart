
import 'package:flutter/material.dart';
import 'package:lojas_khuise/constants/style.dart';
import 'package:lojas_khuise/controllers/menu_controller.dart';
import 'package:lojas_khuise/controllers/navigation_controller.dart';
import 'package:lojas_khuise/layout.dart';
import 'package:lojas_khuise/pages/404/error.dart';
import 'package:lojas_khuise/pages/authentication/authentication.dart';
import 'package:lojas_khuise/services/auth_service.dart';
import 'package:get/get.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:provider/provider.dart';

import 'routing/routes.dart';

void main() async {
  await Firebase.initializeApp();
  Get.put(MenuController());
  Get.put(NavigationController());

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthService()),
        ],
        child: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: authenticationPageRoute,
      unknownRoute: GetPage(name: '/not-found', page: () => PageNotFound(), transition: Transition.fadeIn),
      getPages: [
        GetPage(name: rootRoute, page: () {
          return SiteLayout();
        }),
        GetPage(name: authenticationPageRoute, page: () => AuthenticationPage()),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Khuise',
      theme: ThemeData(
        scaffoldBackgroundColor: light,
        accentColor: Colors.pink,
        pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            }
        ),
        primarySwatch: Colors.pink,
      ),
      // home: AuthenticationPage(),
    );
  }
}