import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/slot.dart';
import '../repository/slot_repository.dart';

class SlotViewModel extends AsyncNotifier<List<Slot>> {
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  @override
  Future<List<Slot>> build() async {
    return _load();
  }

  Future<List<Slot>> _load() async {
    final repository = ref.watch(slotRepositoryProvider);
    return repository.fetchSlots(_selectedDate);
  }

  Future<void> selectDate(DateTime date) async {
    if (_selectedDate.year == date.year &&
        _selectedDate.month == date.month &&
        _selectedDate.day == date.day) {
      return;
    }
    _selectedDate = date;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_load);
  }

  Future<void> claimSlot(String slotId) async {
    final repository = ref.read(slotRepositoryProvider);
    await repository.claimSlot(slotId);
    state = await AsyncValue.guard(_load);
  }

  Future<void> releaseSlot(String slotId) async {
    final repository = ref.read(slotRepositoryProvider);
    await repository.releaseSlot(slotId);
    state = await AsyncValue.guard(_load);
  }
}

final slotViewModelProvider = AsyncNotifierProvider<SlotViewModel, List<Slot>>(SlotViewModel.new);
