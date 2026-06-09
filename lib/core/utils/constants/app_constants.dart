

class AppConstants {
  AppConstants._();

  //? Base URL
  static String get baseUrl => 'https://sams-api.uaenorth.cloudapp.azure.com/api/v1/';
  static const int maxSizeUploadPic = 5 * 1024 * 1024;
  static const String googleDocUrl = 'https://docs.google.com/gview?embedded=true&url=';
  static const Duration s3SendTimeout = Duration(minutes: 20);
  static const Duration s3ReceiveTimeout = Duration(minutes: 20);
  static const String agoraAppId = '336015a4e09144aeaf16108e5edbf3bc';
  static const String zegoBaseUrl = 'https://tangerine-mousse-1333b5.netlify.app/';
}
