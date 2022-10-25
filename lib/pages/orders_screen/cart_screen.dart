
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:lojas_khuise/constants/cart.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import 'package:lojas_khuise/pages/orders_screen/add_address.dart';


class Cart_Screen extends StatefulWidget {


  @override
  Cart_Screen_State createState() =>Cart_Screen_State();
}

class Cart_Screen_State extends State<Cart_Screen> {


  @override
  Widget build(BuildContext context) {
    try{
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
                child: Text('Carrinho', style: TextStyle(fontSize: 13,color: Colors.grey)),
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
            if(cart.isNotEmpty && resume['total'] > 300) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    Add_Address()),
              );
            }else{
              AwesomeDialog(
                context: context,
                animType: AnimType.SCALE,
                dialogType: DialogType.ERROR,
                title: "Ops...",
                width: 500,
                desc:
                'Pedido mínimo a partir de R\$ 300,00 reais.\n'
                    'Faltando R\$ ${(300 - resume['total']).toStringAsFixed(2)} reias para completar seu pedido.',

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
            width: 130,
            child: Text("Continuar",style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),),
          ),
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(height: 30,),
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
                              child: Image.network(cart[index]['images'][0]))),
                          DataCell(Container(
                            width: 80, //SET width
                            child: Text(
                              '${cart[index]['name']}',
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
                              '',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black,

                              ),),)),
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
                              'R\$ ${resume['total'].toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black,

                              ),
                              maxLines: 3,
                            ),)),
                        ]))),
          ],
        ),
      );
    }catch(e){
      return Container();
    }
  }

}