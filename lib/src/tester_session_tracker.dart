import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tester_analytics_package/src/analytics.dart';

class TesterSessionTracker with WidgetsBindingObserver {
  DateTime? _sessionStartTime;
  DateTime? _currentDate;
  Duration _dailyDuration = Duration.zero;
  final AppAnalytics _appAnalytics;

  TesterSessionTracker(this._appAnalytics) {
    WidgetsBinding.instance.addObserver(this);
    _loadDailyDuration();
  }

  void startTracking() {
    _sessionStartTime = DateTime.now();
  }

  void stopTracking() {
    if (_sessionStartTime != null) {
      Duration sessionDuration = DateTime.now().difference(_sessionStartTime!);
      _dailyDuration += sessionDuration;
      _saveDailyDuration();
      _sendSessionData();
      _sessionStartTime = null;
    }
  }

  void _sendSessionData() {
    _appAnalytics.sendSessionData(_dailyDuration);
  }

  Future<void> _loadDailyDuration() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedDate = prefs.getString('lastDate');
    if (savedDate != null && DateTime.parse(savedDate).day == DateTime.now().day) {
      _dailyDuration = Duration(seconds: prefs.getInt('dailyDuration') ?? 0);
    } else {
      _dailyDuration = Duration.zero;
    }
  }

  Future<void> _saveDailyDuration() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastDate', DateTime.now().toIso8601String());
    await prefs.setInt('dailyDuration', _dailyDuration.inSeconds);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      startTracking();
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      stopTracking();
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
