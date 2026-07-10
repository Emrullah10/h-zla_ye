import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/support_ticket.dart';
import '../repository/support_repository.dart';

/// Ticket oluşturma formunun loading/error/success state'i.
class SupportViewModel extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> submitTicket({
    required String category,
    required String message,
    String? subject,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final repository = await ref.read(supportRepositoryProvider.future);
      await repository.createTicket(
        SupportTicket(category: category, message: message, subject: subject),
      );
    });
    state = result;
    return !result.hasError;
  }

  void reset() {
    state = const AsyncData(null);
  }
}

final supportViewModelProvider =
    AsyncNotifierProvider<SupportViewModel, void>(SupportViewModel.new);
