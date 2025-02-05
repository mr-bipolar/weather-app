import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'WEATHER_KEY', obfuscate: true)
  static final String weatherKey = _Env.weatherKey;
}
