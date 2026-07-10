/// GET /courier/wallet yanıtı — get-wallet.use-case.js + courier.repository-impl.js ile birebir.
class WalletTransaction {
  const WalletTransaction({
    required this.txId,
    required this.orderId,
    required this.amount,
    required this.type,
    required this.description,
    required this.createdAt,
  });

  final String txId;
  final String? orderId;
  final double amount;
  final String type;
  final String description;
  final DateTime? createdAt;

  factory WalletTransaction.fromJson(Map<String, dynamic> json) => WalletTransaction(
        txId: json['txId']?.toString() ?? '',
        orderId: json['orderId']?.toString(),
        amount: (json['amount'] as num?)?.toDouble() ?? 0,
        type: json['type']?.toString() ?? 'credit',
        description: json['description']?.toString() ?? '',
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
      );
}

class Wallet {
  const Wallet({
    required this.walletId,
    required this.balance,
    required this.pending,
    required this.transactions,
  });

  final String walletId;
  final double balance;
  final double pending;
  final List<WalletTransaction> transactions;

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        walletId: json['walletId']?.toString() ?? '',
        balance: (json['balance'] as num?)?.toDouble() ?? 0,
        pending: (json['pending'] as num?)?.toDouble() ?? 0,
        transactions: (json['transactions'] as List<dynamic>?)
                ?.map((e) => WalletTransaction.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}
