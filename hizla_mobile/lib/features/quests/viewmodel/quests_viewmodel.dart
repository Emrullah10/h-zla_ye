import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/quest.dart';
import '../repository/quests_repository.dart';

class QuestsViewModel extends AsyncNotifier<List<Quest>> {
  @override
  Future<List<Quest>> build() async {
    return _load();
  }

  Future<List<Quest>> _load() async {
    final repository = await ref.watch(questsRepositoryProvider.future);
    return repository.fetchQuests();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_load);
  }
}

final questsViewModelProvider =
    AsyncNotifierProvider<QuestsViewModel, List<Quest>>(QuestsViewModel.new);
