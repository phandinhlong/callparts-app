import 'package:url_launcher/url_launcher.dart';
class OpenShopee{
  Future<void> openShopeeUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Không thể mở $url');
    }
  }
}