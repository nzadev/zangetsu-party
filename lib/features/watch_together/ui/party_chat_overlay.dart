// lib/features/watch_together/ui/party_chat_overlay.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../gamification/model/wibuku_rank.dart';
import '../../gamification/wibuku_exp_service.dart';
import 'floating_reaction_overlay.dart';

class PartyChatMessage {
  PartyChatMessage({
    required this.id,
    required this.senderName,
    required this.senderAvatar,
    required this.rank,
    required this.message,
    required this.timestamp,
    this.isMe = false,
  });

  final String id;
  final String senderName;
  final String senderAvatar;
  final WibukuRank rank;
  final String message;
  final DateTime timestamp;
  final bool isMe;
}

class PartyChatOverlay extends StatefulWidget {
  const PartyChatOverlay({
    super.key,
    required this.onSendReaction,
    this.initialMessages,
  });

  final void Function(String emoji) onSendReaction;
  final List<PartyChatMessage>? initialMessages;

  @override
  State<PartyChatOverlay> createState() => _PartyChatOverlayState();
}

class _PartyChatOverlayState extends State<PartyChatOverlay> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final List<PartyChatMessage> _messages;

  final List<String> _quickReactions = ['🔥', '❤️', '😂', '😱', '🍿', '👏'];

  @override
  void initState() {
    super.initState();
    final myRank = WibukuExpService.instance.currentRank;
    _messages = widget.initialMessages ?? [
      PartyChatMessage(
        id: '1',
        senderName: 'Rayhan',
        senderAvatar: '',
        rank: BleachRank.shikai,
        message: 'Halo semua, anime nya seru banget!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      PartyChatMessage(
        id: '2',
        senderName: 'Nza (Host)',
        senderAvatar: '',
        rank: myRank,
        message: 'Siap! Gue putar episode selanjutnya ya',
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        isMe: true,
      ),
    ];
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final myRank = WibukuExpService.instance.currentRank;
    setState(() {
      _messages.add(PartyChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderName: 'Kamu',
        senderAvatar: '',
        rank: myRank,
        message: text,
        timestamp: DateTime.now(),
        isMe: true,
      ));
    });

    _textController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chat Stream Box (Glassmorphic)
        Container(
          height: 160,
          width: 280,
          margin: const EdgeInsets.only(left: 12, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge Rank Wibuku
                        Image.asset(
                          msg.rank.badgeAsset,
                          width: 16,
                          height: 16,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.shield,
                            size: 14,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${msg.senderName}: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: msg.isMe ? const Color(0xFF64B5F6) : Colors.amberAccent,
                                  ),
                                ),
                                TextSpan(
                                  text: msg.message,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        // Bottom Controls: Text Input & Floating Emote Quick Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              // Chat input field
              Expanded(
                child: Container(
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: const InputDecoration(
                            hintText: 'Kirim pesan...',
                            hintStyle: TextStyle(color: Colors.white54, fontSize: 12),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send_rounded, size: 18, color: Colors.cyanAccent),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Quick Reactions Row (Spam Emote)
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _quickReactions.map((emoji) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        widget.onSendReaction(emoji);
                        FloatingReactionOverlay.of(context)?.triggerEmote(emoji);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        child: Text(emoji, style: const TextStyle(fontSize: 18)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
