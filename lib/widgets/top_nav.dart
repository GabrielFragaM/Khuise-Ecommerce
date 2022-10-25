import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojas_khuise/constants/style.dart';
import 'package:lojas_khuise/helpers/reponsiveness.dart';

import 'custom_text.dart';

AppBar topNavdigationBar(BuildContext context) =>
AppBar(
        leading: !ResponsiveWidget.isSmallScreen(context) ? Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Image.asset("assets/icons/logo.png", width: 28,),
            ),
          ],
        ): Container(),
        title: Container(
          child: Row(
            children: [
              Visibility(
                visible: !ResponsiveWidget.isSmallScreen(context),
                child: CustomText(text: "Khuise", color: lightGrey, size: 20, weight: FontWeight.bold,)),
            ],
          ),
        ),
        iconTheme: IconThemeData(color: Colors.pink),
        elevation: 0,
        backgroundColor: Colors.transparent,
      );