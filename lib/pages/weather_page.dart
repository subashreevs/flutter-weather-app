import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  // api key
  final _weatherService = WeatherSevice('79f0e9fff4795093aced54e9760e33fa');
  Weather? _weather ;
  

  // fetch weather
  _fetchWeather() async{

    String cityName = await _weatherService.getCurrentCity();

    try{
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    catch(e){
      print(e);
    }

  }


  // weather animations
  // Weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      case 'snow':
      case 'heavy snow':
      case 'light snow':
        return 'assets/snow.json';
      default:
        return 'assets/sunny.json';
    }
  }


  //initial state
  @override
  void initState(){
    super.initState();

    //fetch weather on start up
    _fetchWeather();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        //city
        Text(
          _weather?.cityName ?? "Loading City...",
          style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
          ),
        ),
        

        //animation
        if (_weather != null)
          Lottie.asset(getWeatherAnimation(_weather?.mainCondition),
          width: 200, height: 200, fit: BoxFit.cover)
        else
          CircularProgressIndicator(color: Colors.white),

        const SizedBox(height: 20),

        //temp
        Text('${_weather?.temperature.round() ?? ""}°C',
         style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
        ),),

        const SizedBox(height: 10),

        //weather condition
        Text(_weather?.mainCondition ?? "",
        style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
        ),)


        ],
      ),      
    )
    );
  }
}