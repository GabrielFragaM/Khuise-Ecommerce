import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

Future<dynamic>getPaymentId(items) async {
  try {
    final response2 = await http.post(
      Uri.parse('https://pagamento.azurewebsites.net/api/checkout-pro?code=3ObCWrPY2MtUJxyuPJRk4ebfOC9uglqYDy_-B1PQOORhAzFugQmB7Q=='),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Access-Control_Allow_Origin": "*",
      },
      body: jsonEncode(items)
    );

    String response = utf8.decoder.convert(response2.bodyBytes);

    Map<String, dynamic> logError = {
      'order': 'log getPaymentId line 21 api',
      'error': response.toString(),
    };

    try{
      await FirebaseFirestore.instance.collection('log').add(logError);
    }catch(e){
      Map<String, dynamic> log = {
        'order': 'Error catch line 30 api',
        'error': e.toString(),
      };
      await FirebaseFirestore.instance.collection('log').add(log);
    }

    return response;
  }catch(e){
    Map<String, dynamic> logError = {
      'order': 'Error catch line 39 api',
      'error': e.toString()
    };

    try{
      await FirebaseFirestore.instance.collection('log').add(logError);
    }catch(e){
      Map<String, dynamic> log = {
        'order': 'Error catch line 47 api',
        'error': e.toString(),
      };
      await FirebaseFirestore.instance.collection('log').add(log);
    }
    return 'error';
  }
}

Future<bool>getStatusPayment(String paymentId) async {
  try {
    final response = await http.get(
        Uri.parse('https://api.mercadopago.com/v1/payments/${paymentId.toString()}'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Access-Control_Allow_Origin": "*",
          'Authorization': 'Bearer ${'APP_USR-1221699994255746-092811-1ea9efdeb02f5422d446a4dc74fc22ba-564924351'}'
        },
    );

    print(response.body);
    String responseBody = utf8.decoder.convert(response.bodyBytes);

    return jsonDecode(responseBody)['status'] == 'approved';
  }catch(e){
    print(e);
    return false;
  }
}