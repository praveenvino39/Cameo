import 'package:cameo/models/cameo_model.dart';
import 'package:get/get.dart';
import 'package:cameo/Network/networkHelper.dart';

class CameoController extends GetxController {
  Future<Cameo> getCameobyId({String gigId}) async {
    Map<String, dynamic> cameoJson = await ApiHelper().cameoDetail(gigId);
    print(cameoJson);
    Cameo cameo = Cameo.fromJson(cameoJson["data"][0]);
    return cameo;
  }
}
