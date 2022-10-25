
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
          if(cep == '' || numero == '' || preco_entrega == null || tempo_entrega == null){
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



                    var _shipping = await get_shipping(cepValorTemp);

                    Navigator.pop(context);

                    final finish_api_shipping = SnackBar(
                      content: Text('Endereço encontrado.', style: TextStyle(color: Colors.white),),
                      backgroundColor: Colors.green,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(finish_api_shipping);

                    setState(() {
                      preco_entrega = _shipping['price'];
                      resume['total'] = _shipping['price'] + resume['total'];
                      tempo_entrega = _shipping['delivery_time'];
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