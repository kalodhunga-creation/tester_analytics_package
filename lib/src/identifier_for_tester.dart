  import 'dart:io';

  import 'package:device_info_plus/device_info_plus.dart';
  import 'package:http/http.dart' as http;


  class DeviceIdentifierService {
    static DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

    static Future<String> getDeviceId() async {
      var deviceInfo = await _deviceInfoPlugin.deviceInfo;
      
      if (deviceInfo is AndroidDeviceInfo) {
        return deviceInfo.id ?? 'unknown-device'; // Unique for Android
      } else if (deviceInfo is IosDeviceInfo) {
        return deviceInfo.identifierForVendor ?? 'unknown-device'; // Unique for iOS
      } else {
        return 'unknown-device';
      }
    }

  Future<bool> isEmulator() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.isPhysicalDevice == false;  // Returns false if on an emulator
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.isPhysicalDevice == false;  // Returns false if on an emulator
    }
    return false;
  }


  Future<void> authenticateTester(String userId) async {
    String deviceId = await getDeviceId();

    // Send the deviceId and userId to backend to verify if tester can proceed
    final response = await http.post(
      Uri.parse('https://yourbackend.com/authenticate'),
      body: {
        'userId': userId,
        'deviceId': deviceId,
      },
    );

    if (response.statusCode == 200) {
      // Handle successful authentication
      print('Authentication successful');
    } else {
      // Handle error - show message or block multiple accounts
      print('Device already registered for another tester');
    }
  }



  }




