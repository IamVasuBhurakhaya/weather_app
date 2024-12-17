import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/provider/home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<HomeProvider>().loadBookmarkedCities();
  }

  void showSearchDialog() {
    searchController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Search City"),
          content: TextField(
            controller: searchController,
            decoration: const InputDecoration(hintText: "Enter city name"),
            onSubmitted: (value) {
              Navigator.pop(context);
              _searchCityWeather();
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _searchCityWeather();
              },
              child: const Text("Search"),
            ),
          ],
        );
      },
    );
  }

  void _searchCityWeather() {
    String city = searchController.text.trim();
    if (city.isNotEmpty) {
      // Fetch weather data for the searched city
      context.read<HomeProvider>().fetchWeatherData(city: city);
    }
  }

  void _addToBookmark(String city) {
    // Bookmark the searched city
    context.read<HomeProvider>().bookmarkCity(city).then((_) {
      // Show a Snackbar after bookmarking the city
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$city has been added to bookmarks')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearchDialog(); // Open search dialog
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              String city = searchController.text.trim();
              if (city.isNotEmpty) {
                _addToBookmark(city); // Add current city to bookmark
              }
            },
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          if (provider.weatherModel == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (provider.bookmarkedCities.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.bookmark, color: Colors.yellow),
                        const SizedBox(width: 8.0),
                        Text(
                          'Bookmarked City: ${provider.bookmarkedCities.last}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (provider.weatherModel != null)
                  Column(
                    children: [
                      Text(
                        provider.weatherModel!.name ?? "City not found",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        provider.weatherList.isNotEmpty
                            ? provider.weatherList.first.description ?? ""
                            : "No weather data available",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Card(
                        elevation: 5,
                        shadowColor: Colors.blueGrey,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                "Temperature: ${provider.weatherModel!.mainModels!.temp}°C",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Humidity: ${provider.weatherModel!.mainModels!.humidity}%",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Wind Speed: ${provider.weatherModel!.windModel!.speed} m/s",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                if (provider.weatherModel == null)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        },
      ),
    );
  }
}
