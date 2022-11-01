import 'package:mercadopago_sdk/mercadopago_sdk.dart';

Future<dynamic>getPaymentMercadoPago(items) async {
  try {
    var mp = MP("1221699994255746", "i9mp08OiDjJ9HUIKCTNgEwxTEvc0C07I");

    var preference = {
      "items": items,
      "back_urls": {
        "failure": '',
        "pending": '',
        "success": ''
      }
    };

    var result = await mp.createPreference(preference);

    return result['response'];
  }catch(e){
    return 'error';
  }
}