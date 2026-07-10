/// GET /onboarding/status yanıtı — get-status.use-case.js ile birebir.
class OnboardingStatus {
  const OnboardingStatus({
    required this.status,
    required this.appId,
    required this.vehicleType,
    required this.documents,
    required this.trainingComplete,
  });

  final String status;
  final String? appId;
  final String? vehicleType;
  final List<String> documents;
  final bool trainingComplete;

  bool get isApproved => status.toLowerCase() == 'approved';
  bool get isPending => status.toLowerCase() == 'pending';

  factory OnboardingStatus.fromJson(Map<String, dynamic> json) => OnboardingStatus(
        status: json['status']?.toString() ?? 'pending',
        appId: json['appId']?.toString(),
        vehicleType: json['vehicleType']?.toString(),
        documents: (json['documents'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
        trainingComplete: json['trainingComplete'] == true,
      );
}

/// Onboarding akışının hangi adımda olduğunu belirler (backend'de ayrı bir
/// "step" alanı yok — mevcut alanlardan türetilir).
enum OnboardingStep {
  vehicle,
  documents,
  personalInfo,
  training,
  pendingApproval,
  approved,
}

OnboardingStep deriveOnboardingStep(OnboardingStatus status, {required bool personalInfoDone}) {
  if (status.isApproved) return OnboardingStep.approved;
  if (status.vehicleType == null) return OnboardingStep.vehicle;
  if (status.documents.isEmpty) return OnboardingStep.documents;
  if (!personalInfoDone) return OnboardingStep.personalInfo;
  if (!status.trainingComplete) return OnboardingStep.training;
  return OnboardingStep.pendingApproval;
}
