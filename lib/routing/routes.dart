const rootRoute = "/";

const AllProductsPageDisplayName = "Todos Produtos";
const AllProductsPageRoute = "/all_products";

const driversPageDisplayName = "Meus Pedidos";
const driversPageRoute = "/drivers";

const authenticationPageDisplayName = "Sair";
const authenticationPageRoute = "/auth";

class MenuItem {
  final String name;
  final String route;

  MenuItem(this.name, this.route);
}



List<MenuItem> sideMenuItemRoutes = [
 MenuItem(AllProductsPageDisplayName, AllProductsPageRoute),
 MenuItem(driversPageDisplayName, driversPageRoute),
 MenuItem(authenticationPageDisplayName, authenticationPageRoute),
];
