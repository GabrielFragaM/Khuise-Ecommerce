import 'package:flutter/material.dart';
import 'package:lojas_khuise/helpers/local_navigator.dart';
import 'package:lojas_khuise/helpers/reponsiveness.dart';
import 'package:lojas_khuise/widgets/large_screen.dart';
import 'package:lojas_khuise/widgets/side_menu.dart';

import 'constants/app_constants.dart';

class SiteLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        child: SideMenu(),
      ),
      body: ResponsiveWidget(
        largeScreen: LargeScreen(),
      smallScreen: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: localNavigator(),
      )
      ),
    );
  }
}
