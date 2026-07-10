import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/chat_message.dart';
import '../repository/chat_repository.dart';

/// Mock chat mesaj listesi state'i.
class ChatViewModel extends AsyncNotifier<List<ChatMessage>> {
  @override
  Future<List<ChatMessage>> build() async {
    final repository = ref.watch(chatRepositoryProvider);
    return repository.fetchInitialMessages();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final repository = ref.read(chatRepositoryProvider);
    final current = state.valueOrNull ?? [];

    await for (final message in repository.sendMessage(text.trim())) {
      final updated = [...(state.valueOrNull ?? current), message];
      state = AsyncData(updated);
    }
  }
}

final chatViewModelProvider =
    AsyncNotifierProvider<ChatViewModel, List<ChatMessage>>(ChatViewModel.new);
