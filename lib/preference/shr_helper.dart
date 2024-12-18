import 'package:shared_preferences/shared_preferences.dart';

class ShrHelper {
  static const String bookmarkedCitiesKey = "bookmarkedCities";

  Future<void> saveBookmarkedCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> bookmarkedCities =
        prefs.getStringList(bookmarkedCitiesKey) ?? [];

    if (bookmarkedCities.contains(city)) {
      bookmarkedCities.remove(city);
    }
    bookmarkedCities.add(city);

    await prefs.setStringList(bookmarkedCitiesKey, bookmarkedCities);
  }

  Future<List<String>> getBookmarkedCities() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(bookmarkedCitiesKey) ?? [];
  }

  Future<void> removeBookmarkedCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> bookmarkedCities =
        prefs.getStringList(bookmarkedCitiesKey) ?? [];

    bookmarkedCities.remove(city);

    await prefs.setStringList(bookmarkedCitiesKey, bookmarkedCities);
  }
}
