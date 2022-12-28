
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:lojas_khuise/constants/app_constants.dart';
import 'package:lojas_khuise/constants/cart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:lojas_khuise/helpers/validator_text.dart';
import 'package:lojas_khuise/pages/orders_screen/finish_order.dart';
import 'package:search_cep/search_cep.dart';

class Add_Address extends StatefulWidget {


  @override
  Add_Address_State createState() => Add_Address_State();
}

class Add_Address_State extends State<Add_Address> with Validator_Text{


  Future<Map>get_shipping(cep) async {
    try {
      final url = 'https://api-correios-brasil.herokuapp.com/get-shipping';

      DocumentSnapshot shipping_info_store = await FirebaseFirestore.instance.collection('config').doc('shipping')
          .get();

      var body = jsonEncode({
        "sCepOrigem": shipping_info_store.data()['sCepOrigem'],
        "sCepDestino": cep,
        "nVlPeso": shipping_info_store.data()['nVlPeso'],
        "nCdFormato": 1,
        "nVlComprimento" : shipping_info_store.data()['nVlComprimento'],
        "nVlAltura": shipping_info_store.data()['nVlAltura'],
        "nVlLargura": shipping_info_store.data()['nVlLargura'],
        "sCdMaoPropria": "N",
        "nVlValorDeclarado": 0,
        "sCdAvisoRecebimento": "S",
        "nCdServico": 40010,
        "nVlDiametro": shipping_info_store.data()['nVlDiametro'],
        "StrRetorno": "xml"
      });

      var response = await http.post(
          Uri.parse(url),
          body: body,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Access-Control_Allow_Origin": "*",
          },
          encoding: Encoding.getByName("utf-8")
      );

      return json.decode(response.body);
    }catch(e){
    }
  }

  Future<List>get_shippingMelhorEnvio(cep) async {
    String token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImQzMGFiYTU0MDMyYzllODc0MmY0Mjk2ZGMzMmJhMTc0ODZiZTJmNzg4MjFiZjM1ZWYzNjAwODViNzJiZDBjMTMyMmU5MjllMDI2MmEwMTI2In0.eyJhdWQiOiIxIiwianRpIjoiZDMwYWJhNTQwMzJjOWU4NzQyZjQyOTZkYzMyYmExNzQ4NmJlMmY3ODgyMWJmMzVlZjM2MDA4NWI3MmJkMGMxMzIyZTkyOWUwMjYyYTAxMjYiLCJpYXQiOjE2Njg3NTA1ODIsIm5iZiI6MTY2ODc1MDU4MiwiZXhwIjoxNzAwMjg2NTgyLCJzdWIiOiJiOTQ1MDVlYy1mMDA0LTQ2ZmItYjBmZC04MGIxZGFiMWMwOTciLCJzY29wZXMiOlsiY2FydC1yZWFkIiwiY2FydC13cml0ZSIsImNvbXBhbmllcy1yZWFkIiwiY29tcGFuaWVzLXdyaXRlIiwiY291cG9ucy1yZWFkIiwiY291cG9ucy13cml0ZSIsIm5vdGlmaWNhdGlvbnMtcmVhZCIsIm9yZGVycy1yZWFkIiwicHJvZHVjdHMtcmVhZCIsInByb2R1Y3RzLWRlc3Ryb3kiLCJwcm9kdWN0cy13cml0ZSIsInB1cmNoYXNlcy1yZWFkIiwic2hpcHBpbmctY2FsY3VsYXRlIiwic2hpcHBpbmctY2FuY2VsIiwic2hpcHBpbmctY2hlY2tvdXQiLCJzaGlwcGluZy1jb21wYW5pZXMiLCJzaGlwcGluZy1nZW5lcmF0ZSIsInNoaXBwaW5nLXByZXZpZXciLCJzaGlwcGluZy1wcmludCIsInNoaXBwaW5nLXNoYXJlIiwic2hpcHBpbmctdHJhY2tpbmciLCJlY29tbWVyY2Utc2hpcHBpbmciLCJ0cmFuc2FjdGlvbnMtcmVhZCIsInVzZXJzLXJlYWQiLCJ1c2Vycy13cml0ZSIsIndlYmhvb2tzLXJlYWQiLCJ3ZWJob29rcy13cml0ZSIsInRkZWFsZXItd2ViaG9vayJdfQ.bq38rrFrg4NbwseRWFZUu0WW36pAW5nMu5F64c48QleRk5waxLqaaisaA71KEqm7OI7e8f5QF23W-yKpF7BkW6xQjRFBUMrY1efqvUc7eMc3gOg3t_Bhj0MaFSSggD25wSHDjOTiYF-ppkMqc5Pdj-7DuXSainVJ__5gFa8Z6bHwLFYdgXp85jG_75YQO7yrQvELvG_-P5ySZmVyQTRlFdCqGCNXj5hE1TppvXaW036YWj2FZkWyf_exBOo-OdWPW8vXg0wlVOLNBLk511r6vzFawZECEpPn_klGZ8xSqW5WaQYGDRrrl1y6jjl_BuwbvBeSLNXnkLw6sp9vTSkaKQ9qW5XGp5dbER6II-AzvtrOmfXFG_IiZZN186wl-MIsaHMz5RHzX3Tvz2cQx1K1zrSWWIAts7ZTbTJ1uGaq2HxmuAMRPiMsX2KBy3V7IcRFskv_SGGsAvKIdGNduvl_yqLq6O729OM-ZQpbJV32ZTCoGEko421OWdHIptZM-tfcHDFrbQNdXEbu9lgjt3EWHS-Lk6YYJbHC3lm3Vzt38iCoW9PYZl0OzBRAIE4KUHfMbnKKmfgLa7mSXfUAJCHgGtwmT1oSKzll8e1k6RIjgHt79TkhwOkGxAGqbQpViC_qFpzXJlxQy-HkT3lJHMGntkKgLBcm6NezFTKIokzvKFI';

    try {
      final url = 'https://melhorenvio.com.br/api/v2/me/shipment/calculate';

      DocumentSnapshot shipping_info_store = await FirebaseFirestore.instance.collection('config').doc('shipping')
          .get();

      List products_send = [];
      
      for(var p in cart){
        products_send.add({
          "id": p['id'],
          "width": shipping_info_store.data()['nVlLargura'],
          "height": shipping_info_store.data()['nVlAltura'],
          "length": shipping_info_store.data()['nVlComprimento'],
          "weight": shipping_info_store.data()['nVlPeso'],
          "insurance_value": 0,
          "quantity": 1
        });
      }

      var body = jsonEncode({
        "from": {
          "postal_code": shipping_info_store.data()['sCepOrigem']
        },
        "to": {
          "postal_code": cep
        },
        "products": products_send,
      });

      var response = await http.post(
          Uri.parse(url),
          body: body,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Access-Control_Allow_Origin": "*",
            'Authorization': 'Bearer ' + token,
            'User-Agent': 'Frete Lojas Khuise (gilvan_pereira.catu@hotmail.com)'
          },
          encoding: Encoding.getByName("utf-8")
      );

      List servicesDeliveries = [];

      for(var service in json.decode(response.body)){
        if(!service.containsKey('error') && service['name'] != 'AmanhÃ£' && service['name'] != 'Ã©FÃ¡cil' && service['name'] != 'RodoviÃ¡rio'){
          servicesDeliveries.add({
            'id': service['id'],
            'name': service['name'],
            'price': num.parse(service['price']),
            'delivery_time': service['delivery_time'],
          });
        }
      }
    print(servicesDeliveries);
      return servicesDeliveries;
    }catch(e){
    }
  }

  String date_confirm;
  String cep = '';
  String endereco = '';
  String numero = '';
  String complemento = '';
  String bairro = '';
  String cidade = '';
  String estado = '';

  String cepValorTemp = '';

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
              child: Text('Pedido / Adicionar Endereço', style: TextStyle(fontSize: 13,color: Colors.grey)),
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
          if(cep == '' || numero == '' || deliveries == []){
            AwesomeDialog(
              context: context,
              animType: AnimType.SCALE,
              dialogType: DialogType.ERROR,
              title: "Ops...",
              width: 500,
              desc:
              'Preencha todas as informações do endereço antes de continuar.',

              btnCancelOnPress: () {
              },
              btnCancelText: 'Voltar',
            )..show();
          }else{
            Map <String, dynamic> addres_user = {
              "cep": cep,
              "endereco": endereco,
              "numero": numero,
              "complemento": complemento,
              "bairro": bairro,
              "cidade": cidade,
              "estado": estado,
            };

            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        Finish_Order_Screen(
                          addres_user: addres_user,
                        )));
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
          child: Text("Adicionar",style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
        ),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 18,),
          Padding(
            padding: EdgeInsets.only(left: 18, right: 18),
            child: Material(
              elevation: 5.0,
              shadowColor: Colors.black,
              child: TextFormField(
                key: Key(cep),
                initialValue: cep,
                validator: validateText,
                onChanged: (valor) async {
                  setState(() {
                    cepValorTemp = valor;
                  });
                  if(cepValorTemp.length == 9){

                    AwesomeDialog(
                      context: context,
                      animType: AnimType.SCALE,
                      dismissOnTouchOutside: false,
                      dismissOnBackKeyPress: false,
                      dialogType: DialogType.INFO_REVERSED,
                      title: 'Aguarde um momento...',
                      desc: 'Estamos calculando o frete do seu endereço com os correios.',
                    )..show();

                    final viaCepSearchCep = ViaCepSearchCep();
                    final infoCepJSON = await viaCepSearchCep.searchInfoByCep(cep: '${cepValorTemp.split('-')[0] + cepValorTemp.split('-')[1]}');

                    setState(() {
                      infoCepJSON.map((result) => {
                        cep = cepValorTemp,
                        endereco = result.logradouro,
                        estado = result.uf,
                        cidade = result.localidade,
                        bairro = result.bairro
                      });
                    });



                    List shipping = await get_shippingMelhorEnvio(cepValorTemp);

                    Navigator.pop(context);

                    final finish_api_shipping = SnackBar(
                      content: Text('Endereço encontrado.', style: TextStyle(color: Colors.white),),
                      backgroundColor: Colors.green,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(finish_api_shipping);

                    setState(() {
                      deliveries = shipping;
                    });
                  }

                },
                autofocus: false,
                style: TextStyle(
                    fontSize: 15.0, color: Colors.black),
                inputFormatters: [cep_formater],
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.only(
                      left: 14.0, bottom: 8.0, top: 8.0),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  suffixIcon: Icon(
                      Icons.apartment),
                  labelText: "CEP",
                  hintText: "00000-000",
                ),
              ),
            ),
          ),
          SizedBox(height: 5,),
          Padding(
            padding: EdgeInsets.only(left: 18, right: 18),
            child: Material(
              elevation: 5.0,
              shadowColor: Colors.black,
              child: TextFormField(
                onChanged: (valor) {
                  endereco = valor;
                },
                key: Key(endereco),
                initialValue: endereco,
                validator: validateText,
                autofocus: false,
                style: TextStyle(
                    fontSize: 15.0, color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.only(
                      left: 14.0, bottom: 8.0, top: 8.0),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  suffixIcon: Icon(
                      Icons.approval),
                  labelText: "Endereço",
                  hintText: "Meu endereço...",
                ),
              ),
            ),
          ),
          SizedBox(height: 5,),
          Padding(
            padding: EdgeInsets.only(left: 18, right: 18),
            child: Material(
              elevation: 5.0,
              shadowColor: Colors.black,
              child: TextFormField(
                onChanged: (valor) {
                  numero = valor;
                },
                key: Key(numero),
                initialValue: numero,
                validator: validateText,
                keyboardType: TextInputType.number,
                autofocus: false,
                style: TextStyle(
                    fontSize: 15.0, color: Colors.black),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    suffixIcon: Icon(
                        Icons.house_outlined),
                    labelText: "Número",
                    hintText: "555",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
          ),
          SizedBox(height: 5,),
          Padding(
            padding: EdgeInsets.only(left: 18, right: 18),
            child: Material(
              elevation: 5.0,
              shadowColor: Colors.black,
              child: TextFormField(
                onChanged: (valor) {
                  complemento = valor;
                },
                key: Key(complemento),
                initialValue: complemento,
                validator: validateText,
                autofocus: false,
                style: TextStyle(
                    fontSize: 15.0, color: Colors.black),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    suffixIcon: Icon(
                        Icons.question_answer_outlined),
                    labelText: "Complemento",
                    hintText: "Casa / Prédio",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
          ),
          SizedBox(height: 5,),
          Padding(
            padding: EdgeInsets.only(left: 18, right: 18),
            child: Material(
              elevation: 5.0,
              shadowColor: Colors.black,
              child: TextFormField(
                onChanged: (valor) {
                  bairro = valor;
                },
                key: Key(bairro),
                initialValue: bairro,
                validator: validateText,
                autofocus: false,
                style: TextStyle(
                    fontSize: 15.0, color: Colors.black),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    suffixIcon: Icon(
                        Icons.question_answer_outlined),
                    labelText: "Bairro",
                    hintText: "Bairro",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
          ),
          SizedBox(height: 5,),
          Padding(
            padding: EdgeInsets.only(left: 18, right: 18),
            child: Material(
              elevation: 5.0,
              shadowColor: Colors.black,
              child: TextFormField(
                onChanged: (valor) {
                  cidade = valor;
                },
                key: Key(cidade),
                initialValue: cidade,
                validator: validateText,
                autofocus: false,
                style: TextStyle(
                    fontSize: 15.0, color: Colors.black),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    suffixIcon: Icon(
                        Icons.apartment),
                    labelText: "Cidade",
                    hintText: "Cidade",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
          ),
          SizedBox(height: 5,),
          Padding(
            padding: EdgeInsets.only(left: 18, right: 18),
            child: Material(
              elevation: 5.0,
              shadowColor: Colors.black,
              child: TextFormField(
                onChanged: (valor) {
                  estado = valor;
                },
                key: Key(estado),
                initialValue: estado,
                validator: validateText,
                enabled: false,
                autofocus: false,
                style: TextStyle(
                    fontSize: 15.0, color: Colors.black),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    suffixIcon: Icon(
                        Icons.vpn_lock),
                    labelText: "Estado",
                    hintText: "UF",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }

}