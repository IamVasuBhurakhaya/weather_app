import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather_model.dart';

class ApiHelper {
  Future<WeatherDataModel?> getWeatherData() async {
    String link =
        "https://api.openweathermap.org/data/2.5/weather?q=new york&appid=0a437de7c8d0dbc045e9a27093a3abcf";

    http.Response response = await http.get(Uri.parse(link));

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);

      WeatherDataModel models = WeatherDataModel.mapToModel(json);

      log('$json');
      print('$models');
      return models;
    }
    return null;
  }
}
