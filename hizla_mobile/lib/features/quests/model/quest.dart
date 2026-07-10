/// GET /courier/quests yanıtı — get-quests.use-case.js + courier.repository-impl.js ile birebir.
class Quest {
  const Quest({
    required this.questId,
    required this.title,
    required this.description,
    required this.reward,
    required this.targetCount,
    required this.rarity,
    required this.progress,
    required this.expiresAt,
    required this.completedAt,
  });

  final String questId;
  final String title;
  final String description;
  final double reward;
  final int targetCount;
  final String rarity;
  final int progress;
  final DateTime? expiresAt;
  final DateTime? completedAt;

  bool get isCompleted => completedAt != null;
  double get progressRatio => targetCount <= 0 ? 0 : (progress / targetCount).clamp(0.0, 1.0);

  factory Quest.fromJson(Map<String, dynamic> json) => Quest(
        questId: json['questId']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        reward: (json['reward'] as num?)?.toDouble() ?? 0,
        targetCount: (json['targetCount'] as num?)?.toInt() ?? 0,
        rarity: json['rarity']?.toString() ?? 'common',
        progress: (json['progress'] as num?)?.toInt() ?? 0,
        expiresAt: json['expiresAt'] != null
            ? DateTime.tryParse(json['expiresAt'].toString())
            : null,
        completedAt: json['completedAt'] != null
            ? DateTime.tryParse(json['completedAt'].toString())
            : null,
      );
}

class QuestsResponse {
  const QuestsResponse({required this.quests});
  final List<Quest> quests;

  factory QuestsResponse.fromJson(Map<String, dynamic> json) => QuestsResponse(
        quests: (json['quests'] as List<dynamic>?)
                ?.map((e) => Quest.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}
