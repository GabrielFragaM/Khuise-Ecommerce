import 'package:flutter/material.dart';
import 'package:lojas_khuise/constants/style.dart';
import 'package:lojas_khuise/routing/routes.dart';
import 'package:get/get.dart';

class MenuController extends GetxController {
  static MenuController instance = Get.find();
  var activeItem = AllProductsPageDisplayName.obs;

  var hoverItem = "".obs;

  changeActiveItemTo(String itemName) {
    activeItem.value = itemName;
  }

  onHover(String itemName) {
    if (!isActive(itemName)) hoverItem.value = itemName;
  }

  isHovering(String itemName) => hoverItem.value == itemName;

  isActive(String itemName) => activeItem.value == itemName;

  Widget returnIconFor(String itemName) {
    switch (itemName) {
      case AllProductsPageDisplayName:
        return _customIcon(Icons.store, itemName);
      case driversPageDisplayName:
        return _customIcon(Icons.shopping_cart_outlined, itemName);
      case authenticationPageDisplayName:
        return _customIcon(Icons.exit_to_app, itemName);
      default:
        return _customIcon(Icons.exit_to_app, itemName);
    }
  }

  Widget _customIcon(IconData icon, String itemName) {
    if (isActive(itemName)) return Icon(icon, size: 22, color: Colors.pink);

    return Icon(
      icon,
      color: isHovering(itemName) ? Colors.pink : lightGrey,
    );
  }
}
