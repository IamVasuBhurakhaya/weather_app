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

  String getBackgroundImage(String iconCode) {
    switch (iconCode) {
      case '01d':
        return 'assets/images/01d.jpeg';
      case '01n':
        return 'assets/images/01n.jpeg';
      case '02d':
        return 'assets/images/02d.jpeg';
      case '02n':
        return 'assets/images/02n.jpeg';
      case '03d':
        return 'assets/images/03d.jpeg';
      case '03n':
        return 'assets/images/03n.jpeg';
      case '04d':
        return 'assets/images/04d.jpeg';
      case '04n':
        return 'assets/images/04n.jpeg';
      case '09d':
        return 'assets/images/09d.jpeg';
      case '09n':
        return 'assets/images/09n.jpeg';
      case '10d':
        return 'assets/images/10d.jpeg';
      case '10n':
        return 'assets/images/10n.jpeg';
      case '11d':
        return 'assets/images/11d.jpeg';
      case '11n':
        return 'assets/images/11n.jpeg';
      case '13d':
        return 'assets/images/13d.jpeg';
      case '13n':
        return 'assets/images/13n.jpeg';
      case '50d':
        return 'assets/images/50d.jpeg';
      case '50n':
        return 'assets/images/50n.jpeg';
      default:
        return 'assets/default.jpeg';
    }
  }

  String getWeatherIcon(String iconCode) {
    switch (iconCode) {
      case '01d':
        return 'assets/icons/01d.png';
      case '01n':
        return 'assets/icons/01n.png';
      case '02d':
        return 'assets/icons/02d.png';
      case '02n':
        return 'assets/icons/02n.png';
      case '03d':
        return 'assets/icons/03n.png';
      case '03n':
        return 'assets/icons/03n.png';
      case '04d':
        return 'assets/icons/04d.png';
      case '04n':
        return 'assets/icons/04n.png';
      case '09d':
        return 'assets/icons/09d.png';
      case '09n':
        return 'assets/icons/09n.png';
      case '10d':
        return 'assets/icons/10d.png';
      case '10n':
        return 'assets/icons/10n.png';
      case '11d':
        return 'assets/icons/11d.png';
      case '11n':
        return 'assets/icons/11n.png';
      case '13d':
        return 'assets/icons/13d.png';
      case '13n':
        return 'assets/icons/13n.png';
      case '50d':
        return 'assets/icons/50d.png';
      case '50n':
        return 'assets/icons/50n.png';
      default:
        return '🔅';
    }
  }
}
