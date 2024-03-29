import 'dart:developer';

import 'package:cameo/models/payment_credential.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http_auth/http_auth.dart';

class PaypalServices {
  PaymentCredential _paymentCredential = Get.find<PaymentCredential>();

  String domain = "https://api-m.sandbox.paypal.com"; // for sandbox mode
//  String domain = "https://api.paypal.com"; // for production mode

  // change clientId and secret with your own, provided by paypal
  // String clientId =
  //     'AZ2rshoF3MoBg0i2qVHibTgqStD7MP6HnTHBufRrr6R9YkYNf4fgXScYyPdDsiNM8gvaHl7_rAUhJCMS';
  // String secret =
  //     'EB7sbK6Jh6q78I489WzGC6Z68YKkUXC6GCtJ7Iubp4cL9sVH46rS9c04k3tYEcy36fgJgTlUfiNrlRa2';

  // for getting the access token from Paypal
  Future<String> getAccessToken() async {
    log(_paymentCredential.paypalClientId);
    try {
      var client = BasicAuthClient(
          _paymentCredential.paypalClientId, _paymentCredential.paypalSecretId);
      var response = await client.post('$domain/v1/oauth2/token',
          body: {"grant_type": "client_credentials"});
      if (response.statusCode == 200) {
        final body = convert.jsonDecode(response.body);
        return body["access_token"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // for creating the payment request with Paypal
  Future<Map<String, String>> createPaypalPayment(
      transactions, accessToken) async {
    try {
      var response = await http.post("$domain/v1/payments/payment",
          body: convert.jsonEncode(transactions),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];

          String executeUrl = "";
          String approvalUrl = "";
          final item = links.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        return null;
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  // for executing the payment transaction
  Future<String> executePayment(url, payerId, accessToken) async {
    try {
      var response = await http.post(url,
          body: convert.jsonEncode({"payer_id": payerId}),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        log(response.body);
        return response.body;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
