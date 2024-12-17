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

  // Mapping icon codes to background images
  String _getBackgroundImage(String iconCode) {
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
        return 'assets/09n.jpeg';
      case '10d':
        return 'assets/10d.jpeg';
      case '10n':
        return 'assets/10n.jpeg';
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

  @override
  void initState() {
    super.initState();
    context
        .read<HomeProvider>()
        .loadBookmarkedCities(); // Load the bookmarked city when screen loads
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

          // Get the background image based on the weather icon code
          String backgroundImage = _getBackgroundImage(
              provider.weatherModel!.weathersList![0].icon!);

          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
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
            ),
          );
        },
      ),
    );
  }
}
