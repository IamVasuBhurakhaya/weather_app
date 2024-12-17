class WeatherModel {
  int? visibility, timezone;
  String? name, cod;
  List<WeatherListModel>? weathersList = [];
  MainModel? mainModels;
  WindModel? windModel;
  SysModel? sysModel;

  WeatherModel({
    this.visibility,
    this.timezone,
    this.name,
    this.weathersList,
    this.mainModels,
    this.windModel,
    this.sysModel,
  });

  factory WeatherModel.mapToModel(Map m1) {
    List weather = m1['weather'];
    return WeatherModel(
      visibility: m1['visibility'],
      name: m1['name'],
      sysModel: SysModel.mapToModel(m1['sys']),
      mainModels: MainModel.mapToModel(m1['main']),
      timezone: m1['timezone'],
      windModel: WindModel.mapToModel(m1['wind']),
      weathersList: weather
          .map(
            (e) => WeatherListModel.mapToModel(e),
          )
          .toList(),
    );
  }
}

class WeatherListModel {
  String? main, description, icon;

  WeatherListModel({this.main, this.description, this.icon});

  factory WeatherListModel.mapToModel(Map m1) {
    return WeatherListModel(
        main: m1['main'], description: m1['description'], icon: m1['icon']);
  }
}

class MainModel {
  double? temp, feelsLike, tempMin, tempMax;
  int? pressure, humidity, seaLevel, grndLevel;

  MainModel(
      {this.temp,
      this.feelsLike,
      this.tempMin,
      this.tempMax,
      this.pressure,
      this.humidity,
      this.seaLevel,
      this.grndLevel});

  factory MainModel.mapToModel(Map m4) {
    return MainModel(
      temp: m4['temp'],
      feelsLike: m4['feels_like'],
      tempMin: m4['temp_min'],
      tempMax: m4['temp_max'],
      pressure: m4['pressure'],
      humidity: m4['humidity'],
      seaLevel: m4['sea_level'],
      grndLevel: m4['grnd_level'],
    );
  }
}

class WindModel {
  double? speed, gust;
  int? deg;

  WindModel({this.speed, this.gust, this.deg});

  factory WindModel.mapToModel(Map m1) {
    return WindModel(
      speed: m1['speed'],
      deg: m1['deg'],
      gust: m1['gust'],
    );
  }
}

class SysModel {
  String? country;
  int? sunrise, sunset;

  SysModel({this.country, this.sunrise, this.sunset});

  factory SysModel.mapToModel(Map m1) {
    return SysModel(
      country: m1['country'],
      sunrise: m1['sunrise'],
      sunset: m1['sunset'],
    );
  }
}
