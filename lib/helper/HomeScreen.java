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
        return 'assets/icons/03d.png';
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

  String formatTime(int? time) {
    if (time == null) return "N/A";
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    return "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
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
                  // Search Field
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search city...",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: searchCityWeather,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (value) => searchCityWeather(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Weather Data
                  if (provider.weatherModel != null)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            provider.weatherModel!.name ?? "",
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Image.asset(
                            getWeatherIcon(
                                provider.weatherModel!.weathersList![0].icon!),
                            width: 100,
                          ),
                          Text(
                            "${provider.weatherModel!.mainModels!.temp}°C",
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
