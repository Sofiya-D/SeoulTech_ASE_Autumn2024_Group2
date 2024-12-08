import 'dart:math';

import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class DeviceIdentifierService {
  static final DeviceIdentifierService _instance = DeviceIdentifierService._internal();
  factory DeviceIdentifierService() => _instance;
  DeviceIdentifierService._internal();

  Future<String> getUniqueDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String uniqueDeviceId = '';

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        uniqueDeviceId = _generateAndroidId(androidInfo);
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        uniqueDeviceId = _generateIosId(iosInfo);
      } else if (Platform.isWindows) {
        WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
        uniqueDeviceId = _generateWindowsId(windowsInfo);
      } else if (Platform.isMacOS) {
        MacOsDeviceInfo macOsInfo = await deviceInfo.macOsInfo;
        uniqueDeviceId = _generateMacOsId(macOsInfo);
      } else if (Platform.isLinux) {
        LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
        uniqueDeviceId = _generateLinuxId(linuxInfo);
      }
    } on PlatformException {
      // Fallback method if platform info cannot be retrieved
      uniqueDeviceId = await _generateFallbackId();
    }

    return uniqueDeviceId;
  }

  String _generateAndroidId(AndroidDeviceInfo info) {
    // Combination of several unique identifiers
    return info.id + 
           // info.androidId + 
           info.model + 
           info.manufacturer;
  }

  String _generateIosId(IosDeviceInfo info) {
    // Using Apple's unique identifier
    return info.identifierForVendor ?? 
           (info.name + info.systemVersion + info.model);
  }

  String _generateWindowsId(WindowsDeviceInfo info) {
    return info.computerName + 
           info.deviceId + 
           info.systemMemoryInMegabytes.toString();
  }

  String _generateMacOsId(MacOsDeviceInfo info) {
    return info.computerName + 
           info.hostName + 
           info.model;
  }

  String _generateLinuxId(LinuxDeviceInfo info) {
    return info.machineId ?? 
           (info.name + (info.version??"") + info.id);
  }

  Future<String> _generateFallbackId() async {
    // Fallback method using uuid package
    // or generate simplified example :
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           Random().nextInt(10000).toString();
  }

  // Method to store ID persistently
  Future<void> persistDeviceId(String deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('unique_device_id', deviceId);
  }

  // Method to retrieve persistent ID
  Future<String?> getPersistedDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('unique_device_id');
  }
}

// usage in your app
class DeviceIdentifierManager {
  static Future<String> getDeviceIdentifier() async {
    DeviceIdentifierService deviceIdentifierService = DeviceIdentifierService();
    
    // first try to get the stored ID
    String? persistedId = await deviceIdentifierService.getPersistedDeviceId();
    if (persistedId != null) {
      return persistedId;
    }

    // generate new ID
    String uniqueDeviceId = await deviceIdentifierService.getUniqueDeviceId();
    
    // store ID for future usage
    await deviceIdentifierService.persistDeviceId(uniqueDeviceId);
    
    return uniqueDeviceId;
  }
}