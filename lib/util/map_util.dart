import 'package:geocoding/geocoding.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MapUtil {
  MapUtil._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleMapUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
    await launchUrlString(googleMapUrl);
  }

  static Future<void> openMapFromAddr(String addr) async {
    List<Location> placemarks = await locationFromAddress(addr);
    String googleMapUrl = "https://www.google.com/maps/search/?api=1&query=" +
        placemarks[0].latitude.toString() +
        ',' +
        placemarks[0].longitude.toString();
    //await launch(googleMapUrl);
    if (await canLaunchUrlString(googleMapUrl)) {
      await launchUrlString(googleMapUrl);
    } else {
      throw "Cannot open map";
    }
  }

  static Future<void> addrToMap(String addr) async {
    MapsLauncher.launchQuery(addr);
    // String addrPlus = addr.replaceAll(' ', '+');
    // String googleMapUrl = "https://www.google.com/maps/place/" + addrPlus;
    // await launchUrlString(googleMapUrl);
  }

  static Future<void> toTel(String telNo) async {
    await launchUrlString("tel:" + telNo);
  }

  static Future<void> toUrl(String url) async {
    await launchUrlString("https://" + url);
  }
}
