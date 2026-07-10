import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/slot.dart';

/// Backend henüz yok — arayüz ileride gerçek API'ye bağlanabilecek şekilde
/// tasarlandı. Şu an tek implementasyon MockSlotRepository.
abstract class SlotRepository {
  Future<List<Slot>> fetchSlots(DateTime date);
  Future<void> claimSlot(String slotId);
  Future<void> releaseSlot(String slotId);
}

class MockSlotRepository implements SlotRepository {
  final List<Slot> _slots = [
    const Slot(
      id: 'slot-1',
      startTime: '08:00',
      endTime: '12:00',
      region: 'Kadıköy Bölgesi',
      demand: SlotDemand.normal,
      ownership: SlotOwnership.mine,
      estimatedBase: 400,
    ),
    const Slot(
      id: 'slot-2',
      startTime: '12:00',
      endTime: '16:00',
      region: 'Beşiktaş Bölgesi',
      demand: SlotDemand.high,
      ownership: SlotOwnership.available,
      estimatedBase: 450,
      multiplier: 1.5,
    ),
    const Slot(
      id: 'slot-3',
      startTime: '16:00',
      endTime: '20:00',
      region: 'Şişli Bölgesi',
      demand: SlotDemand.normal,
      ownership: SlotOwnership.available,
      estimatedBase: 380,
    ),
    const Slot(
      id: 'slot-4',
      startTime: '20:00',
      endTime: '00:00',
      region: 'Kadıköy Bölgesi',
      demand: SlotDemand.peak,
      ownership: SlotOwnership.available,
      estimatedBase: 520,
      multiplier: 2.0,
    ),
  ];

  @override
  Future<List<Slot>> fetchSlots(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_slots);
  }

  @override
  Future<void> claimSlot(String slotId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _slots.indexWhere((s) => s.id == slotId);
    if (index == -1) return;
    final slot = _slots[index];
    _slots[index] = Slot(
      id: slot.id,
      startTime: slot.startTime,
      endTime: slot.endTime,
      region: slot.region,
      demand: slot.demand,
      ownership: SlotOwnership.mine,
      estimatedBase: slot.estimatedBase,
      multiplier: slot.multiplier,
    );
  }

  @override
  Future<void> releaseSlot(String slotId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _slots.indexWhere((s) => s.id == slotId);
    if (index == -1) return;
    final slot = _slots[index];
    _slots[index] = Slot(
      id: slot.id,
      startTime: slot.startTime,
      endTime: slot.endTime,
      region: slot.region,
      demand: slot.demand,
      ownership: SlotOwnership.available,
      estimatedBase: slot.estimatedBase,
      multiplier: slot.multiplier,
    );
  }
}

final slotRepositoryProvider = Provider<SlotRepository>((ref) => MockSlotRepository());
