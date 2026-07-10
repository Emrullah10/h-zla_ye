import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/secure_storage_provider.dart';
import '../model/onboarding_status.dart';
import '../repository/onboarding_repository.dart';

const _personalInfoDoneKey = 'hizla_onboarding_personal_info_done';

class OnboardingData {
  const OnboardingData({required this.status, required this.step});
  final OnboardingStatus status;
  final OnboardingStep step;
}

/// Onboarding durumunu ve türetilmiş adımı yöneten ViewModel.
/// Backend'de "personal info" alanı olmadığı için bu adımın tamamlandığı
/// bilgisi lokal (secure storage) tutulur.
class OnboardingViewModel extends AsyncNotifier<OnboardingData> {
  @override
  Future<OnboardingData> build() async {
    return _load();
  }

  Future<OnboardingData> _load() async {
    final repository = await ref.watch(onboardingRepositoryProvider.future);
    final status = await repository.fetchStatus();
    final personalInfoDone = await _isPersonalInfoDone();
    final step = deriveOnboardingStep(status, personalInfoDone: personalInfoDone);
    return OnboardingData(status: status, step: step);
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_load);
  }

  Future<void> selectVehicle(String vehicleType) async {
    final repository = await ref.read(onboardingRepositoryProvider.future);
    await repository.selectVehicle(vehicleType);
    await refresh();
  }

  Future<void> uploadDocument({required String docType, required String filePath}) async {
    final repository = await ref.read(onboardingRepositoryProvider.future);
    await repository.uploadDocument(docType: docType, filePath: filePath);
    await refresh();
  }

  Future<void> markPersonalInfoDone() async {
    final storage = ref.read(secureStorageProvider);
    await storage.write(key: _personalInfoDoneKey, value: 'true');
    await refresh();
  }

  Future<void> completeTraining() async {
    final repository = await ref.read(onboardingRepositoryProvider.future);
    await repository.completeTraining();
    await refresh();
  }

  Future<bool> _isPersonalInfoDone() async {
    final storage = ref.read(secureStorageProvider);
    return await storage.read(key: _personalInfoDoneKey) == 'true';
  }
}

final onboardingViewModelProvider =
    AsyncNotifierProvider<OnboardingViewModel, OnboardingData>(
        OnboardingViewModel.new);
