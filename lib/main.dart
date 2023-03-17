import 'dart:developer';

import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';

ValueNotifier<double> lat = ValueNotifier(0);
ValueNotifier<double> long = ValueNotifier(0);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final hasPermission = await Geolocator.checkPermission();
  if (!(hasPermission == LocationPermission.always ||
      hasPermission == LocationPermission.whileInUse)) {
    await Geolocator.requestPermission();
  }

  _listenLocation();

  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    _listenLocation((pos) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text("Lat : ${lat.value} ||| Long : ${long.value}"),
          ],
        ),
      ),
    );
  }
}

void _listenLocation([void Function(Position)? onUpdate]) {
  const androidSetting = LocationSettings(
    distanceFilter: 0,
  );

  Geolocator.getPositionStream(locationSettings: androidSetting)
      .listen((position) {
    lat.value = position.latitude;
    long.value = position.longitude;

    log("Lat : $lat ||| Long : $long");

    onUpdate?.call(position);
    // setState(() {});
  });
}
