import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:weather1/pages/search_page.dart';
import 'package:weather1/pages/settings_page.dart';
import 'package:weather1/providers/provider.dart';
import 'package:weather1/providers/weather_provider.dart';
import '../widgets/error_dialog.dart';
import '../services/weather_api_services.dart';
import '../repositories/weather_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _city;
  late final WeatherProvider _weatherProvider;

  @override
  void initState() {
    super.initState();
    _weatherProvider = context.read<WeatherProvider>();
    _weatherProvider.addListener(_registerListener);
  }

  @override
  void dispose() {
    _weatherProvider.removeListener(_registerListener);
    super.dispose();
  }

  void _registerListener() {
    final WeatherState ws = context.read<WeatherProvider>().state;
    if (ws.status == WeatherStatus.error) {
      errorDialog(context, ws.error.errMsg);
    }
  }

  String showTemperature(double temperature) {
    final tempUnit = context.watch<TempSettingsProvider>().state.tempUnit;
    if (tempUnit == TempUnit.fahrenheit) {
      return '${((temperature * 9 / 5) + 32).toStringAsFixed(2)}℉';
    }
    return '${temperature.toStringAsFixed(2)}\u2103';
  }

  Widget _showWeather() {
    final state = context.watch<WeatherProvider>().state;
    if (state.status == WeatherStatus.initial) {
      return const Center(
        child: Text(
          'Select a city',
          style: TextStyle(fontSize: 20),
        ),
      );
    }
    if (state.status == WeatherStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (state.status == WeatherStatus.error && state.weather.name == '') {
      return const Center(
        child: Text(
          'Select a city',
          style: TextStyle(fontSize: 20),
        ),
      );
    }
    return ListView(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 6,
        ),
        Text(
          state.weather.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              TimeOfDay.fromDateTime(state.weather.lastUpdated).format(context),
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              state.weather.country,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        const SizedBox(
          height: 60,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              showTemperature(state.weather.temp),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              children: [
                Text(
                  showTemperature(state.weather.tempMin),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  showTemperature(state.weather.tempMax),
                  style: const TextStyle(fontSize: 16),
                )
              ],
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        actions: [
          IconButton(
              onPressed: () async {
                _city = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return SearchPage();
                }));
                print(_city);
                if (_city != null) {
                  context.read<WeatherProvider>().fetchWeather(_city!);
                }
              },
              icon: Icon(Icons.search)),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              },
              icon: Icon(Icons.settings))
        ],
      ),
      body: _showWeather(),
    );
  }
}
