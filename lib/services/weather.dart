import 'package:geolocator/geolocator.dart';

import '../utilities/constants.dart';
import 'networking.dart';

class WeatherModel {
  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.low,
    distanceFilter: 100,
  );

  Future<dynamic> getLocationWeatherByCity(String cityname) async {
    var url = Uri.http(
      kOpenWeatherMap,
      '/geo/1.0/direct',
      {
        'q': cityname,
        'limit': '1',
        'appid': kApiKey,
      },
    );

    var cityLatLog = await NetworkHelper(url).getData();

    var url2 = Uri.https(
      kOpenWeatherMap,
      '/data/2.5/weather',
      {
        'lat': cityLatLog[0]['lat'].toString(),
        'lon': cityLatLog[0]['lon'].toString(),
        'appid': kApiKey,
        'units': 'metric',
      },
    );

    var weatherData = await NetworkHelper(url2).getData();
    return weatherData;
  }

  Future<dynamic> getLocationWeather() async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    var url = Uri.https(
      kOpenWeatherMap,
      '/data/2.5/weather',
      {
        'lat': position.latitude.toString(),
        'lon': position.longitude.toString(),
        'appid': kApiKey,
        'units': 'metric',
      },
    );

    NetworkHelper networkHelper = new NetworkHelper(url);
    var weatherData = await networkHelper.getData();

    return weatherData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
