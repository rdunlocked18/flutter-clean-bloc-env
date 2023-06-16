// ignore_for_file: constant_identifier_names, use_setters_to_change_properties, avoid_classes_with_only_static_members
enum AppEnvironment { DEV, STAGING, PROD }

abstract class EnvInfo {
  static AppEnvironment _environment = AppEnvironment.DEV;

  static void initialize(AppEnvironment environment) {
    EnvInfo._environment = environment;
  }

  static String get appName => _environment._appTitle;
  static String get envName => _environment._envName;
  static String get connectionString => _environment._connectionString;
  static AppEnvironment get environment => _environment;
  static bool get isProduction => _environment == AppEnvironment.PROD;
}

extension _EnvProperties on AppEnvironment {
  static const _appTitles = {
    AppEnvironment.DEV: 'Flavour DEVELOPMENT',
    AppEnvironment.STAGING: 'Flavour STAGING',
    AppEnvironment.PROD: 'Flavour PRODUCTION',
  };

  static const _connectionStrings = {
    AppEnvironment.DEV: 'https://api.spoonacular.com', // Dev Server URL
    AppEnvironment.STAGING: 'https://api.spoonacular.com', // Staging Server URL
    AppEnvironment.PROD: 'https://api.spoonacular.com', // Production Server URL
  };

  static const _envs = {
    AppEnvironment.DEV: 'dev',
    AppEnvironment.STAGING: 'staging',
    AppEnvironment.PROD: 'prod',
  };

  String get _appTitle => _appTitles[this]!;
  String get _envName => _envs[this]!;
  String get _connectionString => _connectionStrings[this]!;
}
