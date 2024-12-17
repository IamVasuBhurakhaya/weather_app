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
          title: const Text("Search City",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: searchController,
            decoration: const InputDecoration(hintText: "Enter city name"),
            onSubmitted: (value) {
              Navigator.pop(context);
              searchCityWeather();
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                searchCityWeather();
              },
              child: const Text("Search"),
            ),
          ],
        );
      },
    );
  }

  void searchCityWeather() {
    String city = searchController.text.trim();
    if (city.isNotEmpty) {
      context.read<HomeProvider>().fetchWeatherData(city: city);
    }
  }

  void addToBookmark(String city) {
    context.read<HomeProvider>().bookmarkCity(city).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$city has been added to bookmarks')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          if (provider.weatherModel == null) {
            return const Center(child: CircularProgressIndicator());
          }

          String backgroundImage =
              getBackgroundImage(provider.weatherModel!.weathersList![0].icon!);

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.withOpacity(0.7),
                  Colors.white.withOpacity(0.5)
                ],
              ),
              image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.cover,
                opacity: 0.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.blueGrey,
                            offset: Offset(4, 4),
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              decoration: const InputDecoration(
                                hintText: "Enter city name",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16.0),
                              ),
                              onSubmitted: (value) {
                                searchCityWeather();
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.search, color: Colors.blue),
                            onPressed: () {
                              searchCityWeather();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              provider.weatherModel!.name ?? "City not found",
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.bookmark,
                                  color: Colors.yellow),
                              onPressed: () {
                                String city = searchController.text.trim();
                                if (city.isNotEmpty) {
                                  addToBookmark(city);
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          provider.weatherList.isNotEmpty
                              ? provider.weatherList.first.description ?? ""
                              : "No weather data available",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedRotation(
                              turns: 1,
                              duration: const Duration(seconds: 2),
                              child: Image.asset(
                                getWeatherIcon(provider
                                    .weatherModel!.weathersList![0].icon!),
                                width: 50,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "${provider.weatherModel!.mainModels!.temp}°C",
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Card(
                          elevation: 8,
                          shadowColor: Colors.blueGrey,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  "Humidity: ${provider.weatherModel!.mainModels!.humidity}%",
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.black54),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Wind Speed: ${provider.weatherModel!.windModel!.speed} m/s",
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.black54),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Pressure: ${provider.weatherModel!.mainModels!.pressure} hPa",
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Sunrise',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                Text(
                                  formatTime(
                                      provider.weatherModel!.sysModel!.sunrise),
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Sunset',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                Text(
                                  formatTime(
                                      provider.weatherModel!.sysModel!.sunset),
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String formatTime(int? time) {
    if (time == null) return "N/A";
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    return "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}
