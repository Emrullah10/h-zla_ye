import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/chat_message.dart';

/// Backend YOK — chat tamamen mock. Gerçek bir backend geldiğinde bu arayüzü
/// karşılayan bir WebSocket/REST implementasyonu eklenebilir.
abstract class ChatRepository {
  /// Başlangıç mesaj akışı (agent karşılama mesajı vb.).
  Future<List<ChatMessage>> fetchInitialMessages();

  /// Kurye mesaj gönderir; bir süre sonra sahte bir agent cevabı üretir.
  Stream<ChatMessage> sendMessage(String text);
}

class MockChatRepository implements ChatRepository {
  @override
  Future<List<ChatMessage>> fetchInitialMessages() async {
    final now = DateTime.now();
    return [
      ChatMessage(
        id: 'welcome-1',
        sender: ChatSender.agent,
        text: 'Merhaba, siparişinizle ilgili nasıl yardımcı olabilirim?',
        timestamp: now.subtract(const Duration(minutes: 3)),
      ),
    ];
  }

  @override
  Stream<ChatMessage> sendMessage(String text) async* {
    // Kuryenin kendi mesajı — hemen "gönderildi" olarak eklenir.
    final courierMessage = ChatMessage(
      id: 'c-${DateTime.now().microsecondsSinceEpoch}',
      sender: ChatSender.courier,
      text: text,
      timestamp: DateTime.now(),
    );
    yield courierMessage;

    await Future.delayed(const Duration(milliseconds: 1400));

    final reply = ChatMessage(
      id: 'a-${DateTime.now().microsecondsSinceEpoch}',
      sender: ChatSender.agent,
      text: _mockReplyFor(text),
      timestamp: DateTime.now(),
    );
    yield reply;
  }

  String _mockReplyFor(String text) {
    if (text.contains('gecik')) {
      return 'Bilgi için teşekkürler. Müşteriye gecikme bilgisini iletiyorum. Lütfen beklemeye devam edin.';
    }
    if (text.contains('adres')) {
      return 'Adresi kontrol ediyorum, size en kısa sürede güncel konum bilgisini ileteceğim.';
    }
    if (text.contains('ulaşılamıyor')) {
      return 'Müşteriyle iletişime geçmeye çalışıyoruz, birkaç dakika daha bekleyebilir misiniz?';
    }
    if (text.contains('hasar')) {
      return 'Paket hasarı için bir tutanak oluşturuyorum, lütfen fotoğraf ekleyin.';
    }
    return 'Mesajınızı aldım, en kısa sürede dönüş yapacağım.';
  }
}

final chatRepositoryProvider = Provider<ChatRepository>((ref) => MockChatRepository());
