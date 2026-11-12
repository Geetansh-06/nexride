import 'package:flutter/material.dart';
import 'package:nexride/screens/splash_screen/splash_screen.dart';
import 'core/theme/app_theme.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NexRideApp());
}

class NexRideApp extends StatefulWidget {
  const NexRideApp({super.key});

  @override
  State<NexRideApp> createState() => _NexRideAppState();
}

class _NexRideAppState extends State<NexRideApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NexRide',
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
