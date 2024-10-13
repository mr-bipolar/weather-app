class WeatherData {
  final List<Weather> _weather;
  final Main _main;
  final int _visibility;
  final Wind _wind;
  final Sys _sys;
  final String _name;

  //* Main constructor
  WeatherData({
    required List<Weather> weather,
    required Main main,
    required int visibility,
    required Wind wind,
    required Sys sys,
    required String name,
  })  : _weather = weather,
        _main = main,
        _visibility = visibility,
        _wind = wind,
        _sys = sys,
        _name = name;

  //* Data from api
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      weather: (json['weather'] as List)
          .map((item) => Weather.fromJson(item))
          .toList(),
      main: Main.fromJson(json['main']),
      visibility: json['visibility'],
      wind: Wind.fromJson(json['wind']),
      sys: Sys.fromJson(json['sys']),
      name: json['name'],
    );
  }

  //* Get value
  List<Weather> get weather => _weather;
  Main get main => _main;
  int get visibility => _visibility;
  Wind get wind => _wind;
  Sys get sys => _sys;
  String get name => _name;
}

//* inner class Weather

class Weather {
  final String _main;
  final String _description;

  Weather({
    required String main,
    required String description,
  })  : _main = main,
        _description = description;

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      main: json['main'],
      description: json['description'],
    );
  }

  String get main => _main;
  String get description => _description;
}

//* inner class Main
class Main {
  final double _temp;
  final double _tempMin;
  final double _tempMax;
  final int _pressure;
  final int _humidity;

  Main({
    required double temp,
    required double tempMin,
    required double tempMax,
    required int pressure,
    required int humidity,
  })  : _temp = temp,
        _tempMin = tempMin,
        _tempMax = tempMax,
        _pressure = pressure,
        _humidity = humidity;

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
      temp: json['temp'].toDouble(),
      tempMin: json['temp_min'].toDouble(),
      tempMax: json['temp_max'].toDouble(),
      pressure: json['pressure'],
      humidity: json['humidity'],
    );
  }

  double get temp => _temp;
  double get tempMin => _tempMin;
  double get tempMax => _tempMax;
  int get pressure => _pressure;
  int get humidity => _humidity;
}

//* inner class wind
class Wind {
  final double _speed;
  final int _deg;

  Wind({
    required double speed,
    required int deg,
  })  : _speed = speed,
        _deg = deg;

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: json['speed'].toDouble(),
      deg: json['deg'],
    );
  }

  double get speed => _speed;
  int get deg => _deg;
}

//* inner class Sys
class Sys {
  final int _sunrise;
  final int _sunset;

  Sys({
    required int sunrise,
    required int sunset,
  })  : _sunrise = sunrise,
        _sunset = sunset;

  factory Sys.fromJson(Map<String, dynamic> json) {
    return Sys(
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }

  int get sunrise => _sunrise;
  int get sunset => _sunset;
}
