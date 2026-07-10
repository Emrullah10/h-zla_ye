/// Chat mesajı gönderen tarafı — backend yok, mock chat için kullanılır.
enum ChatSender { courier, agent, system }

/// Mock chat mesajı — Stitch destek.html chat balonlarıyla birebir alanlar.
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.isRead = false,
  });

  final String id;
  final ChatSender sender;
  final String text;
  final DateTime timestamp;
  final bool isRead;

  ChatMessage copyWith({bool? isRead}) => ChatMessage(
        id: id,
        sender: sender,
        text: text,
        timestamp: timestamp,
        isRead: isRead ?? this.isRead,
      );
}

/// Quick Responses — Stitch destek.html'deki hazır kalıp mesajlar.
const List<String> quickResponses = [
  'Restoran gecikti',
  'Adres yanlış',
  'Müşteri ulaşılamıyor',
  'Paket hasarlı',
];
