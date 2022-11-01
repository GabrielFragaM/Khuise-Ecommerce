import 'package:flutter/material.dart';
import 'package:lojas_khuise/constants/controllers.dart';
import 'package:lojas_khuise/constants/style.dart';
import 'package:lojas_khuise/helpers/reponsiveness.dart';
import 'package:lojas_khuise/routing/routes.dart';
import 'package:lojas_khuise/widgets/custom_text.dart';
import 'package:lojas_khuise/widgets/side_menu_item.dart';
import 'package:get/get.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({ Key key }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _heigth = MediaQuery.of(context).size.height - 330;

    return Container(
            color: light,
            child: ListView(
              children: [
                if(ResponsiveWidget.isSmallScreen(context))
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          SizedBox(width: _width / 48),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Image.asset("assets/icons/logo.png", width: 50, height: 50,),
                          ),
                          Flexible(
                            child: CustomText(
                              text: "Khuise",
                              size: 20,
                              weight: FontWeight.bold,
                              color: Colors.pink,
                            ),
                          ),
                          SizedBox(width: _width / 48),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                  ],
                ),
                    Divider(color: lightGrey.withOpacity(.1), ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: sideMenuItemRoutes
                      .map((item) => SideMenuItem(
                          itemName: item.name,
                          onTap: () {
                            if(item.route == authenticationPageRoute){
                              Get.offAllNamed(authenticationPageRoute);
                              menuController.changeActiveItemTo(AllProductsPageDisplayName);

                            }
                            if (!menuController.isActive(item.name)) {
                              menuController.changeActiveItemTo(item.name);
                              if(ResponsiveWidget.isSmallScreen(context))
                              Get.back();
                              navigationController.navigateTo(item.route);
                            }
                          }))
                      .toList(),
                ),
                SizedBox(height: _heigth),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Versão do Aplicativo: v1.2', style: TextStyle(fontSize: 11),
                    )
                  ]
                ),

              ],
            ),
          );
  }
}