import 'package:flutter/material.dart';
import 'package:weather_app/helper/api_helper.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/preference/shr_helper.dart';

class HomeProvider with ChangeNotifier {
  WeatherModel? weatherModel;
  List<WeatherListModel> weatherList = [];
  final ShrHelper helper = ShrHelper();

  String cityName = "surat";
  List<String> bookmarkedCities = [];

  HomeProvider() {
    loadBookmarkedCities();
  }

  Future<void> fetchWeatherData({required String city}) async {
    final apiHelper = ApiHelper();
    weatherModel = await apiHelper.getWeatherData(city: city);

    if (weatherModel != null) {
      weatherList = weatherModel!.weathersList ?? [];
      notifyListeners();
    }
  }

  Future<void> bookmarkCity(String city) async {
    await helper.saveBookmarkedCity(city);
    bookmarkedCities = await helper.getBookmarkedCities();
    cityName = city;
    await fetchWeatherData(city: city);
    notifyListeners();
  }

  Future<void> loadBookmarkedCities() async {
    bookmarkedCities = await helper.getBookmarkedCities();
    if (bookmarkedCities.isNotEmpty) {
      cityName = bookmarkedCities.last;
      await fetchWeatherData(city: cityName);
    }
    notifyListeners();
  }

  Future<void> removeOldBookmarkAndAddNew(String city) async {
    await helper.removeBookmarkedCity(cityName);
    await bookmarkCity(city);
  }
}
