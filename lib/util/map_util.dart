import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart';

class MapUtil {
  MapUtil._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleMapUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
    await launch(googleMapUrl);
  }

  static Future<void> openMapFromAddr(String addr) async {
    List<Location> placemarks = await locationFromAddress(addr);
    String googleMapUrl = "https://www.google.com/maps/search/?api=1&query=" +
        placemarks[0].latitude.toString() +
        ',' +
        placemarks[0].longitude.toString();
    //await launch(googleMapUrl);
    if (await canLaunch(googleMapUrl)) {
      await launch(googleMapUrl);
    } else {
      throw "Cannot open map";
    }
  }

  static Future<void> addrToMap(String addr) async {
    String addrPlus = addr.replaceAll(' ', '+');
    String googleMapUrl = "https://www.google.com/maps/place/" + addrPlus;
    await launch(googleMapUrl);
  }

  static Future<void> toTel(String telNo) async {
    await launch("tel:" + telNo);
  }
}
