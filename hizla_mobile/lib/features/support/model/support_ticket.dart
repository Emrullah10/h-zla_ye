/// Destek talebi kategorileri — web-app SupportTicketForm.jsx ile birebir.
const List<String> supportTicketCategories = [
  'Sipariş Sorunu',
  'Ödeme Sorunu',
  'Teknik Problem',
  'Diğer',
];

/// POST /courier/support request/response modeli —
/// create-support-ticket.use-case.js ile birebir (category, subject, message).
class SupportTicket {
  const SupportTicket({
    required this.category,
    required this.message,
    this.subject,
  });

  final String category;
  final String message;
  final String? subject;

  Map<String, dynamic> toJson() => {
        'category': category,
        'subject': subject ?? '',
        'message': message,
      };
}
