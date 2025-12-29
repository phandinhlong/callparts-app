import 'package:url_launcher/url_launcher.dart';
class OpenShopee{
  Future<void> openShopeeUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Không thể mở $url');
    }
  }
  Future<void> openZaloChat() async {
    const String phone = "0123456789";

    final Uri zaloUri = Uri.parse("zalo://chat?phone=$phone");
    final Uri webFallback = Uri.parse("https://zalo.me/$phone");

    if (await canLaunchUrl(zaloUri)) {
      await launchUrl(
        zaloUri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      await launchUrl(
        webFallback,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}