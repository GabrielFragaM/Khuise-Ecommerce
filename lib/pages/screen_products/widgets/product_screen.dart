
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:lojas_khuise/constants/cart.dart';
import 'package:flutter/material.dart';
import 'package:lojas_khuise/constants/app_constants.dart';
import 'package:smart_select/smart_select.dart';


class Product_Screen extends StatefulWidget {

  final Map product;

  Product_Screen({this.product});

  @override
  ProductState createState() =>ProductState(product: product);
}

class ProductState extends State<Product_Screen> {

  final Product_Screen _product_screen;

  ProductState({Map product, int index})
      : _product_screen = Product_Screen(product: product);


  @override
  Widget build(BuildContext context) {

    try{
      return Scaffold(
          appBar: AppBar(
            title: Text('${_product_screen.product['name'].toString().toTitleCase()}'),
            centerTitle: true,
            elevation: 0.5,
            leading: IconButton(onPressed: (){
              Navigator.pop(context);
            },icon: Icon(Icons.arrow_back),),
          ),
          body: ListView(
            children: <Widget>[
              _product_screen.product['images'].length != 0 ?
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_product_screen.product['images'].length, (index) {
                    return Center(
                      child: Container(
                        width: 380,
                        height: 370,
                        padding: EdgeInsets.all(5),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(_product_screen.product['images'][index]),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            Positioned(
                              bottom: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  '.',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ) :
              Padding(
                padding: EdgeInsets.all(5),
                child: Container(
                  width: 380,
                  height: 370,
                  child: Image.network(
                    _product_screen.product['images'][0],
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 14.0, right: 16, top: 10),
                child: Text(
                  '${_product_screen.product['name'].toString().toTitleCase()}',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500
                  ),
                  maxLines: 3,
                ),
              ),
              SizedBox(height: 10,),
              Container(
                color: Color.fromRGBO(141, 141, 141, 0.6980392156862745),
                child: Padding(
                  padding: EdgeInsets.only(left: 14.0, right: 16),
                  child: Text(
                    "${_product_screen.product['description'].toString().toCapitalized()}",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              SmartSelect<String>.single(
                placeholder: '',
                title: 'TAMANHOS',
                value: product_state['${_product_screen.product['uid']}']['size'],
                choiceItems: _product_screen.product['sizes'],
                onChange: (state) {

                  setState(() {
                    product_state['${_product_screen.product['uid']}']['size'] = state.value;
                  });

                },
              ),
              Padding(
                padding: EdgeInsets.only(left: 14.0, right: 16, top: 15, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'A PARTIR DE: R\$ ${_product_screen.product['price']}',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500
                      ),
                      maxLines: 3,
                    ),
                    _product_screen.product['amount'] != 0 ?
                    Row(
                      children: [
                        Text(
                          'ESTOQUE DISPONÍVEL',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.w500
                          ),
                          maxLines: 3,
                        ),
                        SizedBox(width: 5,),
                        Icon(Icons.check_circle_outline, color: Colors.green, size: 14,)
                      ],
                    ):
                    Row(
                      children: [
                        Text(
                          'ESTOQUE INDISPONÍVEL',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                              fontWeight: FontWeight.w500
                          ),
                          maxLines: 3,
                        ),
                        SizedBox(width: 5,),
                        Icon(Icons.cancel_outlined, color: Colors.red, size: 14,)
                      ],
                    )
                  ],
                ),
              ),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                shadowColor: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 10,),
                    RawMaterialButton(
                      constraints: BoxConstraints.expand(width: 50, height: 60),
                      onPressed: () {
                        if(product_state['${_product_screen.product['uid']}']['price'] == _product_screen.product['price'] && product_state['${_product_screen.product['uid']}']['quantity'] == 0){
                          return;
                        }else if(product_state['${_product_screen.product['uid']}']['quantity'] == 1){
                          setState(() {
                            product_state['${_product_screen.product['uid']}']['quantity'] = 0;
                          });
                          setState(() {
                            product_state['${_product_screen.product['uid']}']['price'] = _product_screen.product['price'];
                          });
                          return;
                        }else{
                          setState(() {
                            product_state['${_product_screen.product['uid']}']['quantity'] = product_state['${_product_screen.product['uid']}']['quantity'] - 1;
                          });
                          setState(() {
                            product_state['${_product_screen.product['uid']}']['price'] = product_state['${_product_screen.product['uid']}']['price'] - _product_screen.product['price'];
                          });

                          return;
                        }
                      },
                      elevation: 2.0,
                      fillColor: Colors.white,
                      child: Icon(Icons.remove, size: 16,),
                      shape: CircleBorder(),
                    ),
                    Text('${product_state['${_product_screen.product['uid']}'] == null ? 0: product_state['${_product_screen.product['uid']}']['quantity']}', style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,

                    )),
                    RawMaterialButton(
                      constraints: BoxConstraints.expand(width: 50, height: 60),
                      onPressed: () {
                        if(_product_screen.product['amount'] != 0){
                          if(product_state['${_product_screen.product['uid']}']['size'] == ''){
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.SCALE,
                              dialogType: DialogType.ERROR,
                              title: 'Ops...',
                              width: 500,
                              desc:
                              "Selecione um tamanho antes de continuar.",

                              btnCancelOnPress: () {
                              },
                              btnCancelText: 'Voltar',

                            )..show();

                            return;
                          }else if(product_state['${_product_screen.product['uid']}']['quantity'] < _product_screen.product['amount'] && product_state['${_product_screen.product['uid']}']['quantity'] > 0){

                            setState(() {
                              product_state['${_product_screen.product['uid']}']['price'] =
                                  product_state['${_product_screen.product['uid']}']['price'] +
                                      _product_screen.product['price'];
                              product_state['${_product_screen.product['uid']}']['quantity'] = product_state['${_product_screen.product['uid']}']['quantity'] + 1;
                            });

                            return;
                          }else if(product_state['${_product_screen.product['uid']}']['quantity'] == 0){
                            setState(() {
                              product_state['${_product_screen.product['uid']}']['quantity'] = 1;
                              product_state['${_product_screen.product['uid']}']['price'] = _product_screen.product['price'];
                            });
                          }
                        }
                      },
                      elevation: 2.0,
                      fillColor: Colors.white,
                      child:  Icon(Icons.add, size: 16,),
                      shape: CircleBorder(),
                    ),
                    SizedBox(width: 10,),
                  ],
                ),
              ),
              SizedBox(height: 10,),
            ],
          ),
      );
    }catch(e){
      return Scaffold(
        appBar: AppBar(
          title: Text('${_product_screen.product['name']}'),
          centerTitle: true,
          elevation: 0.5,
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          },icon: Icon(Icons.arrow_back),),
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.stretch,
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.category,
                size: 96.0,
                color: Colors.black,
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                "Vizualização não disoinível.",
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
  }

}