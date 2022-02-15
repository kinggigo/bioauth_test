import 'package:get/get.dart';
import 'package:tistoryapp/locale/en/en.dart';
import 'package:tistoryapp/locale/ko/ko.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en_US': enUS, 'ko_KR': koKR};
}
