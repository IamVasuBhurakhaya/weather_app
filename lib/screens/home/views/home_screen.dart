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

  void searchCityWeather() {
    String city = searchController.text.trim();
    if (city.isNotEmpty) {
      context.read<HomeProvider>().fetchWeatherData(city: city);
    }
  }

  void addToBookmark(String city) {
    context.read<HomeProvider>().bookmarkCity(city).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$city has been added to bookmarks'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          if (provider.weatherModel == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Welcome message
                    Text(
                      'Welcome to WeatherApp!',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(2, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        'Enter a city name to get the latest weather information.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
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
                                hintStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
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
                  ],
                ),
              ),
            );
          }

          String backgroundImage = provider.getBackgroundImage(
              provider.weatherModel!.weathersList![0].icon!);

          return SingleChildScrollView(
            child: Container(
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
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Expanded(
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
                                icon: const Icon(Icons.search,
                                    color: Colors.blue),
                                onPressed: () {
                                  searchCityWeather();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    if (provider.bookmarkedCities.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(30.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10.0,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.bookmark,
                                    color: Colors.amber,
                                    size: 28.0,
                                  ),
                                  const SizedBox(width: 6.0),
                                  Text(
                                    'Bookmarked City: ${provider.bookmarkedCities.last}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (provider.weatherModel != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    provider.weatherModel!.name ??
                                        "City not found",
                                    style: const TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 5.0,
                                          color: Colors.black26,
                                          offset: Offset(2.0, 2.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    provider.weatherModel?.sysModel?.country ??
                                        "Country not found",
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.bookmark,
                                  color: Colors.yellow,
                                  size: 30,
                                ),
                                onPressed: () {
                                  String city = searchController.text.trim();
                                  if (city.isNotEmpty) {
                                    addToBookmark(city);
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 6.0),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              provider.weatherList.isNotEmpty
                                  ? provider.weatherList.first.description ?? ""
                                  : "No weather data available",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                letterSpacing: 1.0,
                                shadows: [
                                  Shadow(
                                    blurRadius: 3.0,
                                    color: Colors.black26,
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedRotation(
                                turns: 1,
                                duration: const Duration(seconds: 2),
                                child: Image.asset(
                                  provider.getWeatherIcon(provider
                                      .weatherModel!.weathersList![0].icon!),
                                  width: 50,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "${provider.weatherModel!.mainModels!.temp}°C",
                                style: const TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 6.0,
                                      color: Colors.black26,
                                      offset: Offset(2.0, 2.0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14.0),
                          Card(
                            elevation: 10,
                            shadowColor: Colors.blueGrey.withOpacity(0.3),
                            margin: const EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade200,
                                    Colors.white,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildWeatherRow(
                                          icon: Icons.water_drop,
                                          title: "Humidity",
                                          value:
                                              "${provider.weatherModel!.mainModels!.humidity}%",
                                        ),
                                        buildWeatherRow(
                                          icon: Icons.air,
                                          title: "Wind Speed",
                                          value:
                                              "${provider.weatherModel!.windModel!.speed} m/s",
                                        ),
                                        buildWeatherRow(
                                          icon: Icons.compress,
                                          title: "Pressure",
                                          value:
                                              "${provider.weatherModel!.mainModels!.pressure} hPa",
                                        ),
                                        buildWeatherRow(
                                          icon: Icons.thermostat_outlined,
                                          title: "Feels Like",
                                          value:
                                              "${provider.weatherModel!.mainModels!.feelsLike}°C",
                                        ),
                                        buildWeatherRow(
                                          icon: Icons.home_mini,
                                          title: "Min Temperature",
                                          value:
                                              "${provider.weatherModel!.mainModels!.tempMin}°C",
                                        ),
                                        buildWeatherRow(
                                          icon: Icons.home_max,
                                          title: "Max Temperature",
                                          value:
                                              "${provider.weatherModel!.mainModels!.tempMax}°C",
                                        ),
                                        buildWeatherRow(
                                          icon: Icons.water,
                                          title: "Sea Level",
                                          value:
                                              "${provider.weatherModel!.mainModels!.seaLevel} m",
                                        ),
                                        buildWeatherRow(
                                          icon: Icons.landscape,
                                          title: "Ground Level",
                                          value:
                                              "${provider.weatherModel!.mainModels!.grndLevel} m",
                                        ),
                                      ],
                                    ),
                                    const Divider(color: Colors.black38),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Sunrise',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black38),
                                            ),
                                            const SizedBox(height: 5),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.orangeAccent
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.orangeAccent
                                                        .withOpacity(0.5),
                                                    blurRadius: 8,
                                                    spreadRadius: 2,
                                                    offset: const Offset(2, 2),
                                                  ),
                                                ],
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 15),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.wb_sunny,
                                                    color: Colors.yellow,
                                                    size: 24,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    formatTime(provider
                                                        .weatherModel!
                                                        .sysModel!
                                                        .sunrise),
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const Text(
                                              'Sunset',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black38),
                                            ),
                                            const SizedBox(height: 5),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.deepPurpleAccent
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors
                                                        .deepPurpleAccent
                                                        .withOpacity(0.5),
                                                    blurRadius: 8,
                                                    spreadRadius: 2,
                                                    offset: const Offset(2, 2),
                                                  ),
                                                ],
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 15),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.nightlight_round,
                                                    color: Colors.white,
                                                    size: 24,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    formatTime(provider
                                                        .weatherModel!
                                                        .sysModel!
                                                        .sunset),
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildWeatherRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.blue.shade400,
            size: 24,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  String formatTime(int? time) {
    if (time == null) return "";
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    return "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}
