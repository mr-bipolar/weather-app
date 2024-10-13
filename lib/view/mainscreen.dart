import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/services/weather_services.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //* Textbos controller
  final TextEditingController _textEditingController = TextEditingController();

  //? net connection checker
  bool _isConnected = false;
  StreamSubscription? _streamSubscription;

  //* Data string for ui
  String? cityname,
      weather,
      temperature,
      maxtemp,
      mintemp,
      sunrise,
      sunset,
      humidity,
      visibility,
      presure,
      windspeed;

  //* Api data call function
  _getWeatherData(String city) async {
    //* service call
    WeatherServices weatherServices = WeatherServices();
    final WeatherData? weatherModel;

    if (city.isEmpty) {
      weatherModel = await weatherServices.weather();
    } else {
      weatherModel = await weatherServices.getWeather(city);
    }

    if (weatherModel != null) {
      //* set api value to ui strings
      setState(() {
        cityname = weatherModel?.name;
        weather = weatherModel?.weather[0].main;
        temperature = weatherModel?.main.temp.toStringAsFixed(1);
        maxtemp = weatherModel?.main.tempMax.toStringAsFixed(1);
        mintemp = weatherModel?.main.tempMin.toStringAsFixed(1);
        sunrise = DateFormat('hh:mm a').format(
            DateTime.fromMillisecondsSinceEpoch(
                weatherModel!.sys.sunrise * 1000));
        sunset = DateFormat('hh:mm a').format(
            DateTime.fromMillisecondsSinceEpoch(
                weatherModel.sys.sunset * 1000));
        humidity = weatherModel.main.humidity.toString();
        visibility = weatherModel.visibility.toString();
        presure = weatherModel.main.pressure.toString();
        windspeed = weatherModel.wind.speed.toString();
      });
    }
  }

  //* Device location permission check

  Future<bool> _deviceLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
      _getWeatherData('');
    }
    _getWeatherData('');
    return true;
  }

  @override
  void initState() {
    super.initState();
    //* device location permission check function

    _deviceLocation();

    //* internet connection check
    _streamSubscription =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          setState(() {
            _isConnected = true;
          });
          break;
        case InternetStatus.disconnected:
          setState(() {
            _isConnected = false;
          });
          break;
        default:
          setState(() {
            _isConnected = false;
          });
          break;
      }
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _streamSubscription?.cancel();
    super.dispose();
  }

  //* main window
  Widget _mainScreen() => Positioned.fill(
      top: 50,
      left: 20,
      right: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Platform.isIOS
              ? //* Search bar ios
              CupertinoSearchTextField(
                  controller: _textEditingController,
                  placeholder: "Enter a city",
                  placeholderStyle:
                      const TextStyle(color: CupertinoColors.white),
                  itemSize: 25,
                  onChanged: (value) => _getWeatherData(value),
                )
              //* Search bar android
              : TextField(
                  controller: _textEditingController,
                  autofocus: false,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  cursorColor: Colors.white54,
                  decoration: const InputDecoration(
                      filled: true,
                      isDense: true,
                      fillColor: Colors.transparent,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          borderSide: BorderSide(color: Colors.white38)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          borderSide: BorderSide(color: Colors.white38)),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.white60,
                      ),
                      hintText: "Enter City Name",
                      hintStyle:
                          TextStyle(color: Colors.white60, fontSize: 13)),
                  //? function call
                  onChanged: (value) => _getWeatherData(value),
                ),
          const Spacer(),
          //* weather image
          Image.asset(weather != null
                  ? 'assets/icons/$weather.png'
                  : 'assets/icons/Clear.png'
              // height: 50,
              ),
          const SizedBox(
            height: 10,
          ),
          //* temperature
          _labelText(
              label: temperature != null ? "$temperature\u{00B0}C" : "N/A",
              fontWeight: FontWeight.bold,
              size: 54),
          //* weather
          _labelText(
              label: weather?.toUpperCase() ?? "CLEAR",
              fontWeight: FontWeight.w500,
              size: 18),
          //* City Name
          _labelText(
              label: cityname ?? "N/A",
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(255, 187, 186, 186),
              size: 16),
          const SizedBox(height: 5),
          //* max min temperature
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.arrow_upward,
                color: Colors.greenAccent,
              ),
              _labelText(
                  label: maxtemp != null ? "$maxtemp\u{00B0}C" : "N/A",
                  fontWeight: FontWeight.w500,
                  size: 16),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.arrow_downward,
                color: Colors.redAccent,
              ),
              _labelText(
                  label: mintemp != null ? "$mintemp\u{00B0}C" : "N/A",
                  fontWeight: FontWeight.w500,
                  size: 16),
            ],
          ),
          const Spacer(),
          //* bottom table
          Column(
            children: [
              //* Row one
              RowDataTile(
                keyName: "Sunrise",
                keyValue: sunrise ?? "N/A",
                keyName2: "Sunset",
                keyValue2: sunset ?? "N/A",
              ),
              const Divider(
                color: Colors.white30,
              ),
              const SizedBox(height: 10),
              //* Row two
              RowDataTile(
                keyName: "Humidity",
                keyValue: humidity != null ? "$humidity%" : "N/A",
                keyName2: "Visibility",
                keyValue2: visibility ?? "N/A",
              ),
              const Divider(
                color: Colors.white30,
              ),
              const SizedBox(height: 10),
              //* Row three
              RowDataTile(
                keyName: "Precipitation",
                keyValue: presure != null ? "$presure%" : "N/A",
                keyName2: "Wind Speed",
                keyValue2: windspeed ?? "N/A",
              ),
              const SizedBox(height: 25),
            ],
          )
        ],
      ));

  //build class
  //* build tree
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        //* ios
        ? CupertinoPageScaffold(
            resizeToAvoidBottomInset: false,
            child: SizedBox(
              child: Stack(
                children: [
                  //* Background color
                  _background(colors: [
                    CupertinoColors.systemOrange,
                    CupertinoColors.systemIndigo,
                    CupertinoColors.black
                  ]),
                  //* Main window
                  _mainScreen(),
                  //? network error widget
                  _networkError(status: _isConnected)
                ],
              ),
            ))
        //* android
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: SizedBox(
              child: Stack(
                children: [
                  //* background
                  _background(colors: [
                    const Color.fromARGB(255, 255, 163, 34),
                    const Color.fromARGB(255, 255, 186, 90),
                    const Color.fromARGB(183, 45, 46, 68),
                    const Color.fromARGB(183, 37, 38, 66),
                    Colors.black.withOpacity(0.9),
                    Colors.black
                  ]),
                  //* main window
                  _mainScreen(),
                  //? network error widget
                  _networkError(status: _isConnected),
                ],
              ),
            ),
          );
  }
}

//* Background
Widget _background({required List<Color> colors}) => Positioned.fill(
      child: DecoratedBox(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter))),
    );

//* label text widget
Widget _labelText(
        {required String label,
        Color color = Colors.white,
        double size = 14,
        FontWeight fontWeight = FontWeight.normal}) =>
    Text(
      label,
      style: TextStyle(color: color, fontSize: size, fontWeight: fontWeight),
    );

//* network error widget
Widget _networkError({required bool status}) => status
    ? const Positioned(width: 0, height: 0, child: SizedBox())
    : Positioned.fill(
        child: DecoratedBox(
        decoration: const BoxDecoration(color: Colors.black87),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off_outlined,
                color: Colors.redAccent,
                size: 54,
              ),
              const SizedBox(height: 5),
              _labelText(
                  label: "Check your network connection..!",
                  size: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70)
            ],
          ),
        ),
      ));

//* Row Tile widget class
// ignore: must_be_immutable
class RowDataTile extends StatelessWidget {
  RowDataTile(
      {super.key,
      required this.keyName,
      required this.keyValue,
      required this.keyName2,
      required this.keyValue2});

  String keyName, keyValue, keyName2, keyValue2;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _labelText(
                label: keyName,
                color: const Color.fromARGB(255, 189, 186, 186),
                size: 14),
            _labelText(
                label: keyName2,
                color: const Color.fromARGB(255, 189, 186, 186),
                size: 14),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _labelText(label: keyValue, fontWeight: FontWeight.w500, size: 18),
            _labelText(label: keyValue2, fontWeight: FontWeight.w500, size: 18),
          ],
        ),
      ],
    );
  }
}
