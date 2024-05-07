import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  // api key
  final _weatherService = WeatherService(apiKey: '5b6721da57e7344a558ddc31215c615c');
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    // get current city
    String cityName = await _weatherService.getCurrentCity();
    // get weather for city
    try{
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    // any errors
    catch(e){
      print(e);
    }
  }

  // weather animations
  String getWeatherAnimation(String? mainCondition){
    if (mainCondition == null) return 'assets/sun.json';

    switch(mainCondition.toLowerCase()){
      case 'clouds': return 'assets/cloud.json';
      case 'rain': return 'assets/rain.json';
      case 'thunder': return 'assets/thunder.json';
      case 'clear': return 'assets/sun.json';
      default: return 'assets/sun.json';
    }
  }
  // init state
  @override
  void initState() {
    super.initState();
    // fetch the weather on startup
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
            // city name
            Text(_weather?.cityName ?? "loading city..",
              style: const TextStyle(
                color: Colors.white
              ),
            ),

            // animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
        
            // temperature
            Text('${_weather?.temperature.round()}*C',
              style: const TextStyle(
                color: Colors.white
              ),
            ),

            // weather condition
            Text(_weather?.mainCondition ?? "",
              style: const TextStyle(
                color: Colors.white
              ),
            ),
          ],
        ),
      ),
    );
  }
}