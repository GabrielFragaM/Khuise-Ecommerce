
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:lojas_khuise/constants/app_constants.dart';
import 'dart:js' as js;
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:lojas_khuise/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderInfoScreen extends StatefulWidget {

  final QueryDocumentSnapshot order;
  final QuerySnapshot products;


  OrderInfoScreen({this.products, this.order});

  @override
  OrderInfoScreenState createState() => OrderInfoScreenState(products: products, order:order);
}

class OrderInfoScreenState extends State<OrderInfoScreen> {

  final OrderInfoScreen _infoScreen;

  OrderInfoScreenState({QuerySnapshot products,QueryDocumentSnapshot order})
      : _infoScreen = OrderInfoScreen(products: products,order: order);

  @override
  Widget build(BuildContext context) {
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
              child: Text('Pedido / Informações', style: TextStyle(fontSize: 13,color: Colors.grey)),
            )
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },icon: Icon(Icons.arrow_back),color: Colors.pink,),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 20,),
          Padding(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Pedido:',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                        ),
                        maxLines: 3,
                      ),
                      SizedBox(width: 5,),
                      Text(
                        '${_infoScreen.order.data()['orderNumber']}',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(height: 25),
                      Text(
                        'Copiar código do pedido:',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                        ),
                        maxLines: 3,
                      ),
                      SizedBox(width: 5,),
                      InkWell(
                          onTap: () async {
                            Clipboard.setData(ClipboardData(text: _infoScreen.order.data()['orderNumber']));
                            const snackBar = SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Código do pedido copiado.'),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                          child: Icon(Icons.copy, size: 20)
                      )
                    ],
                  )
                ],
              )),
          DataTable2(
              showCheckboxColumn: false,
              columnSpacing: 10,
              columns: [
                DataColumn(
                  label: Text(''),
                ),
                DataColumn(
                  label: Text('Produtos',style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500
                  ),),
                ),
                DataColumn(
                  label: Text('Quantidade',style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500
                  ),),
                ),
                DataColumn(
                  label: Text('Tamanho',style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500
                  ),),
                ),
                DataColumn(
                  label: Text('Preço',style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500
                  ),),
                ),
              ],
              rows: List<DataRow>.generate(
                  _infoScreen.products.docs.length,
                      (index) => DataRow(
                      onSelectChanged: (bool selected) {
                        if (selected) {

                        }
                      },
                      cells: [
                        DataCell(Container(
                            width: 50, //SE
                             child: Image.network(_infoScreen.products.docs[index].data()['images'][0]))),
                        DataCell(Container(
                          width: 80,
                          child: Text(
                            '${_infoScreen.products.docs[index].data()['name'].toString().toTitleCase()}',
                            style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500
                            ),
                            maxLines: 3,
                          ),)),
                        DataCell(Container(
                          width: 50, //SET width
                          child: Text(
                            '${_infoScreen.products.docs[index].data()['quantity']}',
                            style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500
                            ),
                            maxLines: 3,
                          ),)),
                        DataCell(Container(
                          width: 50, //SET width
                          child: Text(
                            '${_infoScreen.products.docs[index].data()['size']}',
                            style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500
                            ),
                            maxLines: 3,
                          ),)),
                        DataCell(Container(
                          width: 80, //SET width
                          child: Text(
                            'R\$ ${_infoScreen.products.docs[index].data()['price'].toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500
                            ),
                            maxLines: 3,
                          ),)),
                      ]))),
          DataTable2(
              showCheckboxColumn: false,
              columnSpacing: 10,
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
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500
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
                          width: 80, //SET width
                          child: Text(
                            'R\$ ${(_infoScreen.order.data()['preco_entrega'] + _infoScreen.order.data()['total']).toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500
                            ),
                            maxLines: 3,
                          ),)),
                      ]))),
          _infoScreen.order.data()['status'] == 0 ?
          Padding(padding: EdgeInsets.only(left: 3),
            child: Column(
              children: [
                ListTile(
                  title: Text('Status do Pedido:'),
                  trailing: Icon(Icons.warning_amber_outlined, color: Colors.yellow),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AGUARDANDO APROVAÇÃO.', style: TextStyle(fontSize: 13),),
                    ],
                  ),
                ),
              ],
            ),
          ):
          _infoScreen.order.data()['status'] == 1 ?
          Padding(padding: EdgeInsets.only(left: 3),
            child: Column(
              children: [
                ListTile(
                  title: Text('Status do Pedido:'),

                  trailing: Icon(Icons.check_circle, color: Colors.green),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('APROVADO.', style: TextStyle(fontSize: 13),),
                    ],
                  ),
                ),
              ],
            ),
          ):
          _infoScreen.order.data()['status'] == 2 ?
          Padding(padding: EdgeInsets.only(left: 3),
            child: Column(
              children: [
                ListTile(
                  title: Text('Status do Pedido:'),

                  trailing: Icon(Icons.move_to_inbox, color: Colors.blue),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('EM PREPARAÇÃO.', style: TextStyle(fontSize: 13),),
                    ],
                  ),
                ),
              ],
            ),
          ):
          _infoScreen.order.data()['status'] == 3 ?
          Padding(padding: EdgeInsets.only(left: 3),
            child: Column(
              children: [
                ListTile(
                  title: Text('Status do Pedido:'),

                  trailing: Icon(Icons.directions_car_rounded, color: Colors.blue),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('EM TRANSPORTE.', style: TextStyle(fontSize: 13),),
                    ],
                  ),
                ),
              ],
            ),
          ):
          _infoScreen.order.data()['status'] == 4 ?
          Padding(padding: EdgeInsets.only(left: 3),
            child: Column(
              children: [
                ListTile(
                  title: Text('Status do Pedido:'),

                  trailing: Icon(Icons.done, color: Colors.green),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ENTREGUE.', style: TextStyle(fontSize: 13),),
                    ],
                  ),
                ),
              ],
            ),
          ) :
          Padding(padding: EdgeInsets.only(left: 3),
            child: Column(
              children: [
                ListTile(
                  title: Text('Status do Pedido:'),

                  trailing: Icon(Icons.warning_amber_outlined, color: Colors.red),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('REJEITADO.', style: TextStyle(fontSize: 13),),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 3),
            child: Column(
              children: [
                ListTile(
                  title: Text('Data da Compra:'),
                  leading: Icon(Icons.date_range_sharp),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${date_format.format(DateTime.parse(_infoScreen.order.data()['date'].toDate().toString()))}', style: TextStyle(fontSize: 13),),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 3),
            child: Column(
              children: [
                ListTile(
                  title: Text('Entrega por Correios:'),
                  leading: Icon(Icons.local_shipping_outlined),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Preço: R\$ ${_infoScreen.order.data()['preco_entrega']}', style: TextStyle(fontSize: 13),),
                      Text('Tempo Estimado: ${_infoScreen.order.data()['tempo_entrega'] == 1 ? '1 a 2 dias' : '${_infoScreen.order.data()['tempo_entrega']} dias'}', style: TextStyle(fontSize: 13),),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _infoScreen.order.data()['payment_method'] == 'Boleto' ?
          Padding(padding: EdgeInsets.only(left: 3),
            child: Column(
              children: [
                ListTile(
                  title: Text('Tipo de Pagamento:'),
                  leading: Icon(Icons.monetization_on_outlined),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Boleto', style: TextStyle(fontSize: 13),),
                    ],
                  ),
                ),
              ],
            ),
          ):
          _infoScreen.order.data()['payment_method'] == 'Cartão de Crédito' ?
          Padding(padding: EdgeInsets.only(left: 3),
            child: Column(
              children: [
                ListTile(
                  title: Text('Tipo de Pagamento:'),
                  leading: Icon(Icons.credit_card_sharp),
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
              ],
            ),
          ) :
          Padding(padding: EdgeInsets.only(left: 3),
            child: Column(
              children: [
                ListTile(
                  title: Text('Tipo de Pagamento:'),
                  leading: Icon(Icons.account_balance_outlined),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pix', style: TextStyle(fontSize: 13),),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 3),
            child: Column(
              children: [
                ListTile(
                  title: Text('Observações:'),
                  leading: Icon(Icons.comment_sharp),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${_infoScreen.order.data()['observation'] == 'NaN' ? 'Nenhuma' : _infoScreen.order.data()['observation']}', style: TextStyle(fontSize: 13),),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _infoScreen.order.data()['status'] == 0 ?
          Padding(
            padding: EdgeInsets.all(10),
            child: InkWell(
              onTap: () async {
                try{
                  await launch(_infoScreen.order.data()['urlPayment']);
                }catch(e){
                  Map <String, dynamic> errorMap = {};

                  errorMap['errorLaunch'] = e.toString();

                  await FirebaseFirestore.instance.collection('logLink')
                      .doc(_infoScreen.order.id).update(errorMap);
                }
                try{
                  js.context.callMethod('open', [_infoScreen.order.data()['urlPayment']]);
                }catch(e){
                  Map <String, dynamic> errorMap = {};

                  errorMap['error'] = e.toString();

                  await FirebaseFirestore.instance.collection('logLink')
                      .doc(_infoScreen.order.id).update(errorMap);
                }
              },
              child: Container(
                decoration: BoxDecoration(color: Colors.green,
                    borderRadius: BorderRadius.circular(5)),
                alignment: Alignment.center,
                width: 130,
                padding: EdgeInsets.symmetric(vertical: 16),
                child: CustomText(
                  text: "Abrir Pagamento",
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          ) : Container()
        ],
      ),
    );
  }

}