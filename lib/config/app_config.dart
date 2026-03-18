class AppConfig {
  // Default is localhost for physical Android device over USB + adb reverse.
  // For emulator use: --dart-define=API_BASE_URL=http://10.0.2.2:3000
  // For LAN/Wi-Fi mode use: run_mobile_lan.bat (auto-detects host IP)
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:3000',
  );
}
