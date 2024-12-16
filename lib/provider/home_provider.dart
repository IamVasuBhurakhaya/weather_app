import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:weather_app/helper/api_helper.dart';
import 'package:weather_app/model/weather_model.dart';

class HomeProvider with ChangeNotifier {
  List<WeatherListModel> weatherList = [];
  WeatherDataModel? weatherModel = WeatherDataModel();
  Future<void> WeatherData() async {
    ApiHelper helper = ApiHelper();
    weatherModel = await helper.getWeatherData();

    weatherList = weatherModel!.weathersListModel!;
    log('$weatherList');
    notifyListeners();
  }
}
