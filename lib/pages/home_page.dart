import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:weather1/constants/constants.dart';
import 'package:weather1/pages/search_page.dart';
import 'package:weather1/pages/settings_page.dart';
import 'package:weather1/providers/provider.dart';
import '../models/weather.dart';
import '../widgets/error_dialog.dart';

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

  Widget showIcon(String icon) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/images/loading.gif',
      image: 'http://$kIconHost/img/wn/$icon@4x.png',
      width: 96,
      height: 96,
    );
  }

  Widget formatText(String description) {
    final formatedString = description.titleCase;
    return Text(
      formatedString,
      style: const TextStyle(fontSize: 24),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigator = Navigator.of(context);
    Future<void> searchCity() async {
      _city = await navigator.push(MaterialPageRoute(builder: (context) {
        return const SearchPage();
      }));
      print(_city);
      if (_city != null) {
        context.read<WeatherProvider>().fetchWeather(_city!);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        actions: [
          IconButton(onPressed: searchCity, icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                navigator.push(
                    MaterialPageRoute(builder: (context) => const SettingsPage()));
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: _showWeather(),
    );
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
    final Weather? weather = state.weather;
    if (weather == null ||
        state.status == WeatherStatus.error ||
        weather.name == '') {
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

        /// City name
        Text(
          weather.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),

        /// Last update time and country
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              TimeOfDay.fromDateTime(weather.lastUpdated).format(context),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              weather.country,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        const SizedBox(
          height: 60,
        ),

        /// Current temperature
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              showTemperature(weather.temp),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 20,
            ),

            /// Min and Max temperature during a day
            Column(
              children: [
                Text(
                  showTemperature(weather.tempMin),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  showTemperature(weather.tempMax),
                  style: const TextStyle(fontSize: 16),
                )
              ],
            )
          ],
        ),
        const SizedBox(
          height: 40,
        ),

        ///Image and description of the weather
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Spacer(),
            showIcon(weather.icon),
            Expanded(
              flex: 3,
              child: formatText(weather.description),
            ),
            const Spacer(),
          ],
        )
      ],
    );
  }
}
