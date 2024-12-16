import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/provider/home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<HomeProvider>().WeatherData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: context.watch<HomeProvider>().weatherList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      "${context.watch<HomeProvider>().weatherList[index].main}"),
                  subtitle: Text(
                      "${context.watch<HomeProvider>().weatherModel!.name}"),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
