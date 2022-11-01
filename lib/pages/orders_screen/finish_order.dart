import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojas_khuise/constants/app_constants.dart';
import 'package:lojas_khuise/constants/cart.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:lojas_khuise/services/api.dart';
import 'package:lojas_khuise/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:url_launcher/url_launcher.dart';

class Finish_Order_Screen extends StatefulWidget {

  final Map<String, dynamic> addres_user;

  Finish_Order_Screen({ this.addres_user});

  @override
  Finish_Order_Screen_State createState() =>Finish_Order_Screen_State( addres_user: addres_user);
}

class Finish_Order_Screen_State extends State<Finish_Order_Screen> {

  final Finish_Order_Screen _finish_order_screen;

  Finish_Order_Screen_State({Map<String, dynamic> addres_user})
      : _finish_order_screen = Finish_Order_Screen( addres_user: addres_user);


  String observation = '';
  int payment_method = 0;

  bool payment_boleto = true;
  bool payment_card_credit = false;
  bool payment_pix = false;

  change_payment_method(type){
    if(type == 0){
      setState(() {
        payment_method = 0;
        payment_boleto = true;
        payment_card_credit = false;
        payment_pix = false;
      });

      final method_change = SnackBar(
        content: Text('Método de pagamento: Boleto', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      );

      ScaffoldMessenger.of(context).showSnackBar(method_change);

    }else if(type == 1){
      setState(() {
        payment_method = 1;
        payment_boleto = false;
        payment_card_credit = true;
        payment_pix = false;
      });
      final method_change = SnackBar(
        content: Text('Método de pagamento: Cartão de Crédito', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      );

      ScaffoldMessenger.of(context).showSnackBar(method_change);
    }else{
      setState(() {
        payment_method = 2;
        payment_boleto = false;
        payment_card_credit = false;
        payment_pix = true;
      });
      final method_change = SnackBar(
        content: Text('Método de pagamento: Pix', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      );

      ScaffoldMessenger.of(context).showSnackBar(method_change);
    }
  }

  @override
  Widget build(BuildContext context) {

    AuthService auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child:  Text('Lojas Khuise', style: TextStyle(fontSize: 17, color: Colors.pink),),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text('Pedido / Finalizar Pedido', style: TextStyle(fontSize: 13,color: Colors.grey)),
            )
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },icon: Icon(Icons.arrow_back),color: Colors.pink,),
      ),
      floatingActionButton: InkWell(
        onTap: () async {

          AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            dismissOnTouchOutside: true,
            dismissOnBackKeyPress: false,
            dialogType: DialogType.INFO_REVERSED,
            title: 'Aguarde um momento...',
            desc: 'Validando o seu pedido.',
          )..show();

          List items = [
            {
              "title": 'Pedido Lojas Khuise\nRealizar Pagamento para finalizar a compra.',
              "quantity": 1,
              "unit_price": resume['total'] + preco_entrega,
            },
          ];

          final mercadoPagoPayment = await getPaymentMercadoPago(items);

          Map<String, dynamic>order_info = {
            "payment_method": payment_method,
            "orderNumber": mercadoPagoPayment['id'],
            "urlPayment": mercadoPagoPayment['init_point'],
            "preco_entrega": preco_entrega,
            "confirmation": false,
            "status": 0,
            "status_text": "AGUARDANDO APROVAÇÃO",
            "tempo_entrega": tempo_entrega,
            "observation": observation == '' ? 'NaN' : observation,
            "total": resume['total'],
            "date": DateTime.now(),
            "uid_user": auth.usuario.uid,
          };
          try{
           await FirebaseFirestore.instance.collection('users').doc(auth.usuario.uid)
                .collection('orders').doc(order_info['orderNumber']).set(order_info);

            for(var product in cart){
              await FirebaseFirestore.instance.collection('users').doc(auth.usuario.uid)
                  .collection('orders').doc(order_info['orderNumber']).collection('products').add(product);
            }

            await FirebaseFirestore.instance.collection('users').doc(auth.usuario.uid)
                .collection('address').doc('address').set(_finish_order_screen.addres_user);

            await FirebaseFirestore.instance.collection('orders')
                .doc(order_info['orderNumber']).set(order_info);

            Navigator.pop(context);

            await launch(order_info['urlPayment']);

           AwesomeDialog(
             context: context,
             animType: AnimType.SCALE,
             dismissOnTouchOutside: false,
             dismissOnBackKeyPress: false,
             dialogType: DialogType.SUCCES,
             title: 'Pagamento',
             btnOkOnPress: () async {
               await launch(order_info['urlPayment']);
               Restart.restartApp();
             },
             desc: 'Aguardando pagamento...',
             btnOkText: 'Realizar Pagamento',
           )..show();


          }catch(e){
            Map<String, dynamic> logError = {
              'order': 'Error Finish order',
              'error': e.toString()
            };

            await FirebaseFirestore.instance.collection('log').add(logError);

            Navigator.pop(context);
            AwesomeDialog(
              context: context,
              animType: AnimType.SCALE,
              dismissOnTouchOutside: false,
              dismissOnBackKeyPress: false,
              dialogType: DialogType.ERROR,
              title: 'Ops...',
              btnOkOnPress: () {
              },
              desc: 'Não foi possível realizar seu pedido no momento.\n'
                  '${e.toString()}',
              btnOkText: 'Tentar novamente',
            )..show();
          }

        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.green.withAlpha(225),
                offset: Offset(0, 0),
              ),
            ],
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          height: 50,
          width: 130,
          child: Text("Finalizar Pedido",style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
        ),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 30,),
          Padding(padding: EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Text(
                  'Resumo do Pedido',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  maxLines: 3,
                ),
              ],
            ),),
          DataTable2(
              showCheckboxColumn: false,
              columnSpacing: 20.0,
              columns: [
                DataColumn(
                  label: Text(''),
                ),
                DataColumn(
                  label: Text('Produtos',style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,

                  ),),
                ),
                DataColumn(
                  label: Text('Tamanho',style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,

                  ),),
                ),
                DataColumn(
                  label: Text('Quantidade',style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,

                  ),),
                ),
                DataColumn(
                  label: Text('Total',style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,

                  ),),
                ),
              ],
              rows: List<DataRow>.generate(
                  cart.length,
                      (index) => DataRow(
                      onSelectChanged: (bool selected) {
                        if (selected) {

                        }
                      },
                      cells: [
                        DataCell(Container(
                            width: 50, //SET width
                            child: Image.network(cart[index]['images'][0])),
                        ),
                        DataCell(Container(
                          width: 80, //SET width
                          child: Text(
                            '${cart[index]['name'].toString()}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black,

                            ),
                            maxLines: 3,
                          ),)),
                        DataCell(Container(
                          width: 50, //SET width
                          child: Text(
                            '${cart[index]['size'].toString().toUpperCase()}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black,

                            ),
                            maxLines: 3,
                          ),)),
                        DataCell(Container(
                          width: 50, //SET width
                          child: Text(
                            '${cart[index]['quantity']}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black,

                            ),
                            maxLines: 3,
                          ),)),
                        DataCell(Container(
                          width: 50, //SET width
                          child: Text(
                            'R\$ ${cart[index]['price'].toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black,

                            ),
                            maxLines: 3,
                          ),)),
                      ]))),
          DataTable2(
              showCheckboxColumn: false,
              columnSpacing: 20.0,
              columns: [
                DataColumn(
                  label: Text(''),
                ),
              ],
              rows: List<DataRow>.generate(
                  1,
                      (index) => DataRow(
                      onSelectChanged: (bool selected) {
                        if (selected) {

                        }
                      },
                      cells: [
                        DataCell(Container()),
                      ]))),
          Padding(padding: EdgeInsets.only(left: 3),
            child: Column(
              children: [
                ListTile(
                  title: Text('Entrega por Correios:'),
                  leading: Icon(Icons.local_shipping_outlined),
                  trailing: Icon(Icons.check_circle, color: Colors.pink,),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Preço: R\$ ${preco_entrega}', style: TextStyle(fontSize: 13),),
                      Text('Tempo Estimado: ${tempo_entrega == 1 ? '1 a 2 dias' : '${tempo_entrega} dias'}', style: TextStyle(fontSize: 13),),
                    ],
                  ),
                ),
              ],
            ),
          ),
          DataTable2(
              showCheckboxColumn: false,
              columnSpacing: 20.0,
              columns: [
                DataColumn(
                  label: Text(''),
                ),
              ],
              rows: List<DataRow>.generate(
                  1,
                      (index) => DataRow(
                      onSelectChanged: (bool selected) {
                        if (selected) {

                        }
                      },
                      cells: [
                        DataCell(Container()),
                      ]))),
          Padding(padding: EdgeInsets.only(left: 3),
            child: Column(
              children: [
                ListTile(
                  title: Text('Escolha um método de pagamento.'),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 3),
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    change_payment_method(0);
                  },
                  child: ListTile(
                    title: Text('Tipo de Pagamento:'),
                    leading: Icon(Icons.monetization_on_outlined),
                    trailing: payment_boleto == true ? Icon(Icons.check_circle, color: Colors.pink,)
                        : Icon(Icons.circle_outlined),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Boleto', style: TextStyle(fontSize: 13),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 3),
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    change_payment_method(1);
                  },
                  child: ListTile(
                    title: Text('Tipo de Pagamento:'),
                    leading: Icon(Icons.credit_card_sharp),
                    trailing: payment_card_credit == true ? Icon(Icons.check_circle, color: Colors.pink,)
                        : Icon(Icons.circle_outlined),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Cartão de crédio.', style: TextStyle(fontSize: 13),),
                            SizedBox(width: 3,),
                            Text('Taxa de 10%', style: TextStyle(fontSize: 13, color: Colors.pink), ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 3),
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    change_payment_method(2);
                  },
                  child: ListTile(
                    title: Text('Tipo de Pagamento:'),
                    leading: Icon(Icons.account_balance_outlined),
                    trailing: payment_pix == true ? Icon(Icons.check_circle, color: Colors.pink,)
                        : Icon(Icons.circle_outlined),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pix', style: TextStyle(fontSize: 13),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          DataTable2(
              showCheckboxColumn: false,
              columnSpacing: 20.0,
              columns: [
                DataColumn(
                  label: Text(''),
                ),
                DataColumn(
                  label: Text(''),
                ),
                DataColumn(
                  label: Text('',style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500
                  ),),
                ),
                DataColumn(
                  label: Text('',style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500
                  ),),
                ),
                DataColumn(
                  label: Text('',style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500
                  ),),
                ),
              ],
              rows: List<DataRow>.generate(
                  1,
                      (index) => DataRow(
                      onSelectChanged: (bool selected) {
                        if (selected) {

                        }
                      },
                      cells: [
                        DataCell(Container()),
                        DataCell(Container()),
                        DataCell(Container(
                          width: 50, //SET width
                          child: Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black,

                            ),
                            maxLines: 3,
                          ),)),
                        DataCell(Container(
                          width: 50, //SET width
                          child: Text(
                            '+(Frete)',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black,

                            ),),)),
                        DataCell(Container(
                          width: 50, //SET width
                          child: Text(
                            'R\$ ${(preco_entrega + resume['total']).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black,

                            ),
                            maxLines: 3,
                          ),)),
                      ]))),
          SizedBox(height: 20,),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Material(
              elevation: 5.0,
              shadowColor: Colors.black,
              child: TextFormField(
                maxLines: 3,
                onChanged: (valor) {
                  setState(() {
                    observation = valor;
                  });
                },
                autofocus: false,
                style: TextStyle(
                    fontSize: 15.0, color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Observações...',
                  hintText: 'Observações',
                  contentPadding: const EdgeInsets.only(
                      left: 14.0, bottom: 8.0, top: 8.0),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }

}