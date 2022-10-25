
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojas_khuise/constants/app_constants.dart';
import 'package:lojas_khuise/helpers/reponsiveness.dart';
import 'package:lojas_khuise/pages/orders_screen/orders_user/widgets/order_details.dart';
import 'package:lojas_khuise/services/auth_service.dart';
import 'package:provider/provider.dart';



class OrdersUserScreen extends StatefulWidget {

  @override
  OrdersUserScreenState createState() =>OrdersUserScreenState();
}

class OrdersUserScreenState extends State<OrdersUserScreen> {

  @override
  Widget build(BuildContext context) {

    AuthService auth = Provider.of<AuthService>(context);

    return Scaffold(
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
              child: Text('Pedidos / Meus Pedidos', style: TextStyle(fontSize: 13,color: Colors.grey)),
            )
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users')
        .doc(auth.usuario.uid).collection('orders').orderBy('date', descending: true)
        .snapshots(),
    builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.stretch,
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 96.0,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    "Carregando seus pedidos...",
                    style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.black,
                        fontWeight:
                        FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                ],
              ),
            ),
          );
        }
        else if(snapshot.data.docs.isEmpty || snapshot.data == null)
            return Scaffold(
              body: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.stretch,
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.info_outline,
                      size: 96.0,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      "Nenhum pedido encontrado.",
                      style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.black,
                          fontWeight:
                          FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                  ],
                ),
              ),
            );
          else
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: ListTile(
                          onTap: () async {

                            QuerySnapshot products = await FirebaseFirestore.instance.collection('users')
                            .doc(auth.usuario.uid).collection('orders').doc(snapshot.data.docs[index].id)
                            .collection('products').get();

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => OrderInfoScreen(order: snapshot.data.docs[index], products: products,)),
                            );

                          },
                          title: Text('Pedido: ${snapshot.data.docs[index]['orderNumber']}'),
                          subtitle: Text('Data da compra: ${date_format.format(DateTime.parse(snapshot.data.docs.toList()[index]['date'].toDate().toString()))}\n'
                              'Prazo de entrega: ${snapshot.data.docs[index]['tempo_entrega'] == 1 ? '1 a 2 dias' : '${snapshot.data.docs[index]['tempo_entrega']} dias'}\n'
                              'Total: R\$ ${snapshot.data.docs[index]['total'].toStringAsFixed(2)}'
                      )
                  ),
                )
                );
              },
            );

        },
      ),
    );
  }

}