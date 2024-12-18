import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather_model.dart';

class ApiHelper {
  final String apiKey = "0a437de7c8d0dbc045e9a27093a3abcf";
  final String baseUrl = "https://api.openweathermap.org/data/2.5/weather";

  Future<WeatherModel?> getWeatherData({required String city}) async {
    final url = "$baseUrl?q=$city&appid=$apiKey&units=metric";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return WeatherModel.mapToModel(json);
      } else {
        log('Error: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception: $e');
    }
    return null;
  }
}
