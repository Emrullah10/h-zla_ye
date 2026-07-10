import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

/// httpOnly accessToken/refreshToken cookie'leri diskte kalıcı tutan jar.
/// App restart sonrası oturum devam eder (web'deki tarayıcı cookie davranışının
/// mobil karşılığı).
final cookieJarProvider = FutureProvider<PersistCookieJar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return PersistCookieJar(
    storage: FileStorage('${dir.path}/.hizla_cookies'),
  );
});
