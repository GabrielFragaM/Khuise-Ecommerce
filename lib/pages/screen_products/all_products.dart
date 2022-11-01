
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojas_khuise/constants/app_constants.dart';
import 'package:lojas_khuise/constants/cart.dart';
import 'package:flutter/material.dart';

import 'package:lojas_khuise/helpers/reponsiveness.dart';
import 'package:lojas_khuise/widgets/custom_text.dart';
import 'package:lojas_khuise/widgets/screens_templates_messages/loading_products.dart';
import 'package:lojas_khuise/widgets/screens_templates_messages/products_not_found.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:smart_select/smart_select.dart';
import '../orders_screen/cart_screen.dart';
import 'widgets/product_screen.dart';

class All_Products extends StatefulWidget {

  @override
  All_Products_State createState() =>
      All_Products_State();
}

class All_Products_State extends State<All_Products> {

  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: IconButton(
              onPressed: (){
                _controller.jumpTo(_controller.position.minScrollExtent);

              },icon: Icon(Icons.arrow_upward_sharp, size: 27,),
            ),
          ),
          InkWell(
            onTap: () async {

              QuerySnapshot products = await FirebaseFirestore.instance.collection('products').get();
              cart.clear();

              num total = 0;
              num quantity = 0;

              var size_null = false;


              for(var p in products.docs){

                try{
                  if(product_state['${p.id}']['quantity'] != 0){
                    if(product_state['${p.id}']['size'] == null || product_state['${p.id}']['size'] == ''){
                      setState(() {
                        size_null = true;
                      });
                    }

                    cart.add({
                      "uid": p.id,
                      "name": product_state['${p.id}']['name'],
                      "size": product_state['${p.id}']['size'],
                      "price": product_state['${p.id}']['price'],
                      "quantity": product_state['${p.id}']['quantity'],
                      "images": product_state['${p.id}']['images']
                    });

                    total = total += product_state['${p.id}']['price'];
                    quantity = quantity += product_state['${p.id}']['quantity'];
                  }
                }catch(e){

                }
              }

              if(cart.isNotEmpty && size_null == false){
                resume['total'] = total;
                resume['quantity'] = quantity;

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Cart_Screen()),
                );
              }else{
                AwesomeDialog(
                  context: context,
                  animType: AnimType.SCALE,
                  dialogType: DialogType.ERROR,
                  title: 'Ops...',
                  width: 500,
                  desc:
                  "Seu carrinho está vazio.",

                  btnCancelOnPress: () {
                  },
                  btnCancelText: 'Voltar',

                )..show();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink,
                    offset: Offset(0, 0),
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              height: 50,
              width: 80,
              child: Icon(Icons.shopping_cart_outlined, color: Colors.white,),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: !ResponsiveWidget.isSmallScreen(context) ? Container(): IconButton(icon: Icon(Icons.menu, color: Colors.black,), onPressed: (){
          scaffoldKey.currentState.openDrawer();
        }),
        title: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child:  Text('Lojas Khuise', style: TextStyle(fontSize: 17, color: Colors.pink),),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text('Todos / Produtos', style: TextStyle(fontSize: 13,color: Colors.grey)),
            )
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Loading_Products();
          else if(snapshot.data.docs.isNotEmpty)
            return ListView(
              controller: _controller,
              physics: BouncingScrollPhysics(),
              children: [
                ResponsiveGridList(
                    scroll: false,
                    desiredItemWidth: MediaQuery.of(context).size.width > 500 ? 240: 180,
                    minSpacing: 5,
                    children: snapshot.data.docs.map((item) {
                      return GestureDetector(
                          onTap: () async {


                            List<S2Choice<String>> sizes = [];

                            for(var size in item['sizes']){
                              sizes.add(S2Choice<String>(value: size, title: size));
                            }

                            if(product_state['${item.id}'] == null){
                              setState(() {
                                product_state['${item.id}'] = {'name': item['name'], 'quantity': 0, 'size': '',  'price': item['price'], 'images': item['images']};
                              });
                            }

                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Product_Screen(product: {'uid': item.id, 'sizes': sizes, 'name': item['name'], 'amount': item['amount'], 'description': item['description'], 'price': item['price'], 'images': item['images']})),
                            );

                            setState(() {
                              product_state = product_state;
                            });

                          },
                          child: Container(
                            width: 200,
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              shadowColor: Colors.black,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    width: 60.0,
                                    height: MediaQuery.of(context).size.width > 900 ? 250.0: 190.0,
                                    child: Image.network(item['images'][0],fit: BoxFit.cover,),
                                  ),
                                  Center(
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      height: 50,
                                      child: CustomText(
                                        text: "${item['name'].toString().toTitleCase()}",
                                        color: Colors.black,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      height: 39,
                                      child: RichText(
                                        overflow: TextOverflow.clip,
                                        strutStyle: StrutStyle(fontSize: 10),
                                        text: TextSpan(
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                            text: "${item['description'].toString().toCapitalized()}"),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  product_state['${item.id}'] != null ?
                                  product_state['${item.id}']['quantity'] != 0 ?
                                  Padding(
                                      padding: EdgeInsets.only(left: 5, right: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Icons.add_shopping_cart, color: Colors.pink, size: 15,),
                                          CustomText(
                                            text: "${product_state['${item.id}']['quantity']} Adicionado ao carrinho.",
                                            color: Colors.black,
                                            size: 12.5,
                                          ),
                                        ],
                                      )
                                  ):
                                  Center(
                                    child: CustomText(
                                      text: "A partir de ${item['price'].toStringAsFixed(2)}",
                                      color: Colors.black,
                                      size: 13,
                                    ),
                                  ) :
                                  Center(
                                    child: CustomText(
                                      text: "A partir de ${item['price'].toStringAsFixed(2)}",
                                      color: Colors.black,
                                      size: 13,
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                ],
                              ),
                            ),
                          )
                      );
                    }).toList()
                )
              ],
            );
          else
            return Products_Not_Found();
        },
      ),
    );
  }

}