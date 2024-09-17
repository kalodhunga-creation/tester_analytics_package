import 'package:flutter/material.dart';
import 'package:tester_analytics_package/src/analytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize AppAnalytics with your API key
  final appAnalytics = AppAnalytics(apiKey: 'YOUR_API_KEY');
  await appAnalytics.initialize();

  runApp(MyApp(appAnalytics: appAnalytics));
}

class MyApp extends StatelessWidget {
  final AppAnalytics appAnalytics;

  MyApp({required this.appAnalytics});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(appAnalytics: appAnalytics),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final AppAnalytics appAnalytics;

  HomeScreen({required this.appAnalytics});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.appAnalytics.startSession();
  }

  @override
  void dispose() {
    widget.appAnalytics.endSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Text('Welcome to the App!'),
      ),
    );
  }
}
