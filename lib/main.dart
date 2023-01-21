import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:weather1/providers/provider.dart';
import 'package:weather1/providers/theme_provider.dart';
import 'package:weather1/repositories/weather_repository.dart';
import 'package:weather1/services/weather_api_services.dart';
import 'pages/home_page.dart';
import 'providers/weather_provider.dart';
import 'package:http/http.dart' as http;

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => WeatherRepository(
            weatherApiServices: WeatherApiServices(
              httpClient: http.Client(),
            ),
          ),
        ),
        ChangeNotifierProvider(
            create: (context) =>
                WeatherProvider(repository: context.read<WeatherRepository>())),
        ChangeNotifierProvider<TempSettingsProvider>(
            create: (context) => TempSettingsProvider()),
        ChangeNotifierProxyProvider<WeatherProvider, ThemeProvider>(
            create: (context) => ThemeProvider(),
            update: (
              BuildContext context,
              WeatherProvider weatherProvider,
              ThemeProvider? themeProvider,
            ) =>
                themeProvider!..update(weatherProvider)),
      ],
      builder: (context, _) => MaterialApp(
        title: 'Weather App',
        debugShowCheckedModeBanner: false,
        theme: context.watch<ThemeProvider>().state.appTheme == AppTheme.light
            ? ThemeData.light()
            : ThemeData.dark(),
        home: const HomePage(),
      ),
    );
  }
}
