import 'dart:convert';

import 'package:http/http.dart' as http;

const baseUrl = 'https://cameo.deliveryventure.com/api';

const endPoints = {
  //authentication and authorization
  "country": '/user/country',
  "state": '/user/state',
  "login": '/user/login',
  "registration": '/user/registration',

  //Homescreen
  "popular": '/gigs/popularGigs',
  "latest": '/gigs/latestGigs',
  "charity": '/charity',
  "new": '/new',
  "category": '/category',
  "musician": '/musician',
  "cameo_detail": '/gigs/gigs_details'
};

class ApiHelper {
  Future<http.Response> login(user) async {
    print('calling: $baseUrl${endPoints["login"]}');
    http.Response response =
        await http.post('$baseUrl${endPoints["login"]}', body: user);
    return response;
  }

  Future<http.Response> country() async {
    print('calling: $baseUrl${endPoints["country"]}');
    http.Response response = await http.get('$baseUrl${endPoints["country"]}');
    return response;
  }

  Future<http.Response> state(int countryId) async {
    print('calling: $baseUrl${endPoints["state"]}/$countryId');
    http.Response response =
        await http.get('$baseUrl${endPoints["state"]}/$countryId');
    return response;
  }

  Future<http.Response> registration(Map<String, String> user) async {
    print('calling: $baseUrl${endPoints["regitration"]} $user');
    http.Response response =
        await http.post('$baseUrl${endPoints["registration"]}', body: user);
    return response;
  }

//Poplular Cameos
  Future<List> popularCameos() async {
    print('calling: $baseUrl${endPoints["popular"]}');
    http.Response response = await http.get('$baseUrl${endPoints["popular"]}');
    var data = jsonDecode(response.body);
    return data["primary"];
  }

//Latest Cameos
  Future<List> latestCameo() async {
    print('calling: $baseUrl${endPoints["latest"]}');
    http.Response response = await http.get('$baseUrl${endPoints["latest"]}');
    var data = jsonDecode(response.body);
    return data["primary"];
  }

//Get Specific Detail
  Future<Map> cameoDetail(id) async {
    print('calling: $baseUrl${endPoints["cameo_detail"]}');
    http.Response response = await http.post(
        '$baseUrl${endPoints["cameo_detail"]}',
        body: {"gig_id": id.toString()});
    Map data = jsonDecode(response.body);
    return data;
  }
}
