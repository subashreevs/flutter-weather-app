import 'dart:convert';

import 'package:weather_app/models/weather_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart' as geo;

class WeatherSevice{

  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherSevice(this.apiKey);

  Future<Weather> getWeather(String cityName) async{
    final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if(response.statusCode == 200){
      return Weather.fromJson(jsonDecode(response.body));
    }
    else{
      throw Exception('Failed to load weather data');
    }
  }

  // get permission
  Future<String> getCurrentCity() async{
    geo.LocationPermission permission = await geo.Geolocator.checkPermission();
    if(permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
    }


    //fetch current location
    geo.Position position = await geo.Geolocator.getCurrentPosition(
      desiredAccuracy: geo.LocationAccuracy.high
    );

    //convert location into a list of placemark objects
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    // extract city name from first placemark
    String? city = placemarks[0].administrativeArea;

    return city ?? "";
  }

  


}