import 'package:flutter/material.dart';
import 'package:weather_app/helper/api_helper.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/preference/shr_helper.dart';

class HomeProvider with ChangeNotifier {
  WeatherModel? weatherModel = WeatherModel();
  List<WeatherListModel> weatherList = [];
  ShrHelper helper = ShrHelper();

  String cityName = "surat"; // Default city name
  List<String> bookmarkedCities = [];

  HomeProvider() {
    loadBookmarkedCities(); // Load the bookmarked cities when the provider is created
  }

  // Fetch weather data for the specified city
  Future<void> fetchWeatherData({required String city}) async {
    ApiHelper apiHelper = ApiHelper();
    weatherModel = await apiHelper.getWeatherData(city: city);

    if (weatherModel != null) {
      weatherList = weatherModel!.weathersList!;
      notifyListeners(); // Notify listeners when the weather data is fetched
    }
  }

  // Bookmark a city only when explicitly clicked
  Future<void> bookmarkCity(String city) async {
    // Save the new city to SharedPreferences
    await helper.saveBookmarkedCity(city);
    bookmarkedCities =
        await helper.getBookmarkedCities(); // Reload the bookmarked cities list
    cityName = city; // Update the current city name
    await fetchWeatherData(
        city: city); // Fetch weather data for the new bookmarked city
    notifyListeners(); // Notify listeners about the change
  }

  // Load the bookmarked cities from SharedPreferences
  Future<void> loadBookmarkedCities() async {
    bookmarkedCities = await helper.getBookmarkedCities();
    if (bookmarkedCities.isNotEmpty) {
      cityName = bookmarkedCities
          .last; // Set the last bookmarked city as the current city
      await fetchWeatherData(
          city: cityName); // Fetch weather data for the last bookmarked city
    }
    notifyListeners(); // Notify listeners when the bookmarked cities are loaded
  }

  // Remove the old bookmark and add a new one
  Future<void> removeOldBookmarkAndAddNew(String city) async {
    await helper
        .removeBookmarkedCity(cityName); // Remove the old bookmarked city
    await bookmarkCity(city); // Bookmark the new city
  }
}
