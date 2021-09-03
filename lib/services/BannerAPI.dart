import 'package:nyoba/constant/constants.dart';

class BannerAPI {
  fetchBanner() async {
    var response = await baseAPI.getAsync('$banner', isCustom: true);
    return response;
  }

  fetchMiniBanner({String isBlog = ''}) async {
    var response = await baseAPI.getAsync('$homeMiniBanner?blog_banner=$isBlog',
        isCustom: true);
    return response;
  }
}
