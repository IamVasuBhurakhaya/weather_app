class WeatherDataModel {
  int? visibility, timezone;
  String? name;
  List<WeatherListModel>? weathersListModel = [];
  MainModel? mainModels;
  WindModel? windModel;
  SysModel? sysModel;

  WeatherDataModel({
    this.visibility,
    this.timezone,
    this.name,
    this.weathersListModel,
    this.mainModels,
    this.windModel,
    this.sysModel,
  });

  factory WeatherDataModel.mapToModel(Map m1) {
    List weather = m1['weather'];
    return WeatherDataModel(
      visibility: m1['visibility'],
      name: m1['name'],
      sysModel: SysModel.mapToModel(m1['sys']),
      mainModels: MainModel.mapToModel(m1['main']),
      timezone: m1['timezone'],
      windModel: WindModel.mapToModel(m1['wind']),
      weathersListModel: weather
          .map(
            (e) => WeatherListModel.mapToModel(e),
          )
          .toList(),
    );
  }
}

class WeatherListModel {
  String? main, description;

  WeatherListModel({this.main, this.description});

  factory WeatherListModel.mapToModel(Map m1) {
    return WeatherListModel(main: m1['main'], description: m1['description']);
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
