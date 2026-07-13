import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/glass_panel.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/hizla_app_bar.dart';
import '../model/chat_message.dart';
import '../model/support_ticket.dart';
import '../viewmodel/chat_viewmodel.dart';
import '../viewmodel/support_viewmodel.dart';
import 'package:hizla_mobile/core/theme/theme_context.dart';

/// Stitch destek.html ("Courier Support Hub") uyarlaması — Chat + Ticket
/// Oluştur sekmeli tek ekran.
class SupportHubScreen extends StatefulWidget {
  const SupportHubScreen({super.key});

  @override
  State<SupportHubScreen> createState() => _SupportHubScreenState();
}

class _SupportHubScreenState extends State<SupportHubScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.scaffold,
      appBar: HizlaAppBar(
        title: 'Destek Merkezi',
        actions: [
          Icon(Icons.support_agent_rounded,
              color: AppColors.brand, size: 22),
          const SizedBox(width: AppSpacing.lg),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: context.colors.surfaceContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                gradient: AppGradients.primary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: context.colors.onPrimary,
              unselectedLabelColor: context.colors.onSurfaceVariant,
              labelStyle: AppTypography.title.copyWith(fontSize: 14),
              tabs: const [
                Tab(text: 'Chat'),
                Tab(text: 'Ticket Oluştur'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _ChatTab(),
                _TicketFormTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatTab extends ConsumerStatefulWidget {
  const _ChatTab();

  @override
  ConsumerState<_ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends ConsumerState<_ChatTab> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send([String? presetText]) async {
    final text = presetText ?? _inputController.text.trim();
    if (text.isEmpty || _isSending) return;
    setState(() => _isSending = true);
    _inputController.clear();
    await ref.read(chatViewModelProvider.notifier).sendMessage(text);
    if (mounted) setState(() => _isSending = false);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatViewModelProvider);

    return Column(
      children: [
        Expanded(
          child: AsyncValueView<List<ChatMessage>>(
            value: chatState,
            data: (messages) {
              _scrollToBottom();
              return ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  const _OrderContextCard(),
                  const SizedBox(height: AppSpacing.lg),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.colors.surfaceContainerHighest
                            .withValues(alpha: 0.7),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Text(
                        'Bugün',
                        style: AppTypography.labelSmall,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  for (final message in messages) ...[
                    _ChatBubble(message: message),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  if (_isSending)
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Text('Yazıyor…', style: AppTypography.bodyMuted),
                    ),
                ],
              );
            },
          ),
        ),
        _QuickResponses(onTap: _send),
        _ChatInputBar(controller: _inputController, onSend: () => _send()),
      ],
    );
  }
}

class _OrderContextCard extends StatelessWidget {
  const _OrderContextCard();

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
            ),
            child: const Icon(Icons.fastfood_rounded, color: AppColors.gradientStart),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Genel Destek', style: AppTypography.labelSmall),
                Text('Nasıl yardımcı olabiliriz?', style: AppTypography.title.copyWith(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isCourier = message.sender == ChatSender.courier;
    final time =
        '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}';

    final bubble = Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      constraints: const BoxConstraints(maxWidth: 280),
      decoration: BoxDecoration(
        color: isCourier ? AppColors.gradientEnd : context.colors.surfaceContainerHigh.withValues(alpha: 0.85),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(isCourier ? 18 : 4),
          bottomRight: Radius.circular(isCourier ? 4 : 18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.text,
            style: AppTypography.body.copyWith(
              color: isCourier ? context.colors.onPrimary : context.colors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                time,
                style: AppTypography.labelSmall.copyWith(
                  color: isCourier
                      ? context.colors.onPrimary.withValues(alpha: 0.7)
                      : context.colors.onSurfaceVariant,
                ),
              ),
              if (isCourier) ...[
                const SizedBox(width: 4),
                Icon(Icons.done_all_rounded,
                    size: 12, color: context.colors.onPrimary.withValues(alpha: 0.7)),
              ],
            ],
          ),
        ],
      ),
    );

    if (isCourier) {
      return Align(alignment: Alignment.centerRight, child: bubble);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          margin: const EdgeInsets.only(right: AppSpacing.sm, top: 2),
          decoration: BoxDecoration(
            color: context.colors.neonCyanContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.support_agent_rounded, size: 16, color: context.colors.onSurface),
        ),
        Flexible(child: bubble),
      ],
    );
  }
}

class _QuickResponses extends StatelessWidget {
  const _QuickResponses({required this.onTap});

  final void Function(String) onTap;

  static const _icons = {
    'Restoran gecikti': Icons.timer_rounded,
    'Adres yanlış': Icons.location_off_rounded,
    'Müşteri ulaşılamıyor': Icons.person_off_rounded,
    'Paket hasarlı': Icons.inventory_2_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: quickResponses.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final label = quickResponses[index];
          return Material(
            color: context.colors.surfaceContainerHigh.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              onTap: () => onTap(label),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  border: Border.all(
                      color: context.colors.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_icons[label] ?? Icons.chat_bubble_outline_rounded,
                        size: 14, color: AppColors.gradientStart),
                    const SizedBox(width: 6),
                    Text(label,
                        style: AppTypography.title.copyWith(fontSize: 12)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  const _ChatInputBar({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.lg),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add_photo_alternate_outlined,
                color: context.colors.onSurfaceVariant),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.colors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                border: Border.all(
                    color: context.colors.outlineVariant.withValues(alpha: 0.2)),
              ),
              child: TextField(
                controller: controller,
                style: AppTypography.body,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: 'Bir mesaj yazın…',
                  hintStyle: AppTypography.bodyMuted,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            decoration: BoxDecoration(
              gradient: AppGradients.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: onSend,
              icon: Icon(Icons.send_rounded, size: 18, color: context.colors.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketFormTab extends ConsumerStatefulWidget {
  const _TicketFormTab();

  @override
  ConsumerState<_TicketFormTab> createState() => _TicketFormTabState();
}

class _TicketFormTabState extends ConsumerState<_TicketFormTab> {
  String? _category;
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final category = _category;
    final message = _messageController.text.trim();
    if (category == null || message.isEmpty) return;

    final success = await ref
        .read(supportViewModelProvider.notifier)
        .submitTicket(category: category, message: message);

    if (!mounted) return;
    if (success) {
      _messageController.clear();
      setState(() => _category = null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Destek talebiniz oluşturuldu.')),
      );
    } else {
      final error = ref.read(supportViewModelProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error?.toString() ?? 'Talep gönderilemedi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ticketState = ref.watch(supportViewModelProvider);
    final isLoading = ticketState.isLoading;
    final canSubmit = _category != null && _messageController.text.trim().isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: GlassPanel(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kategori', style: AppTypography.label),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final category in supportTicketCategories)
                  ChoiceChip(
                    label: Text(category),
                    selected: _category == category,
                    onSelected: (_) => setState(() => _category = category),
                    labelStyle: AppTypography.title.copyWith(
                      fontSize: 12,
                      color: _category == category
                          ? context.colors.onPrimary
                          : context.colors.onSurfaceVariant,
                    ),
                    selectedColor: AppColors.brand,
                    backgroundColor: context.colors.surfaceContainerHigh,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      side: BorderSide.none,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Mesajınız', style: AppTypography.label),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _messageController,
              maxLines: 5,
              onChanged: (_) => setState(() {}),
              style: AppTypography.body,
              decoration: InputDecoration(
                hintText: 'Sorununuzu açıklayın…',
                hintStyle: AppTypography.bodyMuted,
                filled: true,
                fillColor: context.colors.surfaceContainerHigh,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            GradientButton(
              label: isLoading ? 'Gönderiliyor…' : 'Talebi Gönder',
              isLoading: isLoading,
              onPressed: canSubmit ? _submit : null,
            ),
          ],
        ),
      ),
    );
  }
}
