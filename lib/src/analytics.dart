import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tester_analytics_package/src/identifier_for_tester.dart';
import 'tester_session_tracker.dart';

class AppAnalytics {
  final String apiKey;
  TesterSessionTracker? _sessionTracker;

  AppAnalytics({required this.apiKey});

  Future<void> initialize() async {
    // Check if the device is an emulator or rooted
    bool isEmulator = await DeviceIdentifierService().isEmulator();
    if (isEmulator) {
      print('App cannot be used on an emulator');
      return;
    }

    // Get device ID and authenticate tester
    String deviceId = await DeviceIdentifierService.getDeviceId();
    // You need to provide the userId, you may obtain this from your app logic
    String userId = 'test-user'; // Replace with actual userId
    await DeviceIdentifierService().authenticateTester(userId);

    // Initialize session tracker
    _sessionTracker = TesterSessionTracker(this);
  }

  void startSession() {
    _sessionTracker?.startTracking();
  }

  void endSession() {
    _sessionTracker?.stopTracking();
  }

Future<void> sendSessionData(Duration dailyDuration) async {
    String deviceId = await DeviceIdentifierService.getDeviceId();

    final response = await http.post(
      Uri.parse('https://yourbackend.com/session_data'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'deviceId': deviceId,
        'dailyDuration': dailyDuration.inSeconds,
        'date': DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      print('Session data sent successfully');
    } else {
      print('Failed to send session data');
    }
  }
}
