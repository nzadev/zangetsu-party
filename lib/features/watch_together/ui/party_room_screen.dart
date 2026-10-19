// lib/features/watch_together/ui/party_room_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../gamification/model/wibuku_rank.dart';
import '../../gamification/wibuku_exp_service.dart';
import 'floating_reaction_overlay.dart';
import 'party_chat_overlay.dart';

class PartyMember {
  const PartyMember({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.rank,
    this.isHost = false,
    this.isSynced = true,
  });

  final String id;
  final String name;
  final String avatarUrl;
  final WibukuRank rank;
  final bool isHost;
  final bool isSynced;
}

class PartyRoomScreen extends StatefulWidget {
  const PartyRoomScreen({
    super.key,
    required this.roomCode,
    this.showTitle = 'Solo Leveling: Arise',
    this.episodeTitle = 'Episode 08 - Green Light',
  });

  final String roomCode;
  final String showTitle;
  final String episodeTitle;

  @override
  State<PartyRoomScreen> createState() => _PartyRoomScreenState();
}

class _PartyRoomScreenState extends State<PartyRoomScreen> {
  bool _isPlaying = true;
  double _playbackPosition = 0.35; // 35%
  bool _isHost = true;

  late final List<PartyMember> _members;

  @override
  void initState() {
    super.initState();
    final myRank = WibukuExpService.instance.currentRank;
    _members = [
      PartyMember(
        id: '1',
        name: 'Nza',
        avatarUrl: '',
        rank: myRank,
        isHost: true,
        isSynced: true,
      ),
      const PartyMember(
        id: '2',
        name: 'Rayhan',
        avatarUrl: '',
        rank: WibukuRank.gold,
        isHost: false,
        isSynced: true,
      ),
      const PartyMember(
        id: '3',
        name: 'Dika_Wibu',
        avatarUrl: '',
        rank: WibukuRank.diamond,
        isHost: false,
        isSynced: true,
      ),
    ];
  }

  void _copyRoomCode() {
    Clipboard.setData(ClipboardData(text: widget.roomCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kode room ${widget.roomCode} disalin ke clipboard!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showInviteFriendsSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF1E1E2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person_add_alt_1, color: Colors.cyanAccent),
                const SizedBox(width: 8),
                const Text(
                  'Undang Teman ke Party',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white60),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(
                    'Kode Room: ${widget.roomCode}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text('Salin'),
                    onPressed: _copyRoomCode,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Teman Online',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 8),
            _FriendInviteTile(name: 'Adit_Kun', rank: WibukuRank.emerald),
            _FriendInviteTile(name: 'Salsa_Otaku', rank: WibukuRank.master),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F14),
      body: FloatingReactionOverlay(
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar: Room Info & Actions
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF161622),
                  border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.08))),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'PARTY ROOM',
                              style: TextStyle(
                                color: Colors.cyanAccent,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: InkWell(
                                onTap: _copyRoomCode,
                                child: Row(
                                  children: [
                                    Text(
                                      '#${widget.roomCode}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.copy, size: 12, color: Colors.white70),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.showTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.person_add_alt, color: Colors.cyanAccent),
                      tooltip: 'Undang Teman',
                      onPressed: _showInviteFriendsSheet,
                    ),
                  ],
                ),
              ),

              // Member Dock (Bubble Avatars dengan Badge Rank)
              Container(
                height: 72,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A28),
                  border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.06))),
                ),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _members.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final member = _members[index];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Avatar container
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF2C2C3E),
                                border: Border.all(
                                  color: Color(member.rank.glowColorValue),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  member.name[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            // Host Crown Badge
                            if (member.isHost)
                              const Positioned(
                                top: -6,
                                right: -4,
                                child: Text('👑', style: TextStyle(fontSize: 12)),
                              ),
                            // Wibuku Rank Icon Mini
                            Positioned(
                              bottom: -2,
                              right: -4,
                              child: Image.asset(
                                member.rank.badgeAsset,
                                width: 14,
                                height: 14,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const SizedBox(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          member.name,
                          style: const TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Video Playback Area (Sync Player)
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      color: Colors.black,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.movie_filter_rounded, size: 48, color: Colors.white24),
                            const SizedBox(height: 8),
                            Text(
                              widget.episodeTitle,
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                                    size: 44,
                                    color: Colors.cyanAccent,
                                  ),
                                  onPressed: () {
                                    if (_isHost) {
                                      setState(() => _isPlaying = !_isPlaying);
                                      // Bonus EXP saat nobar
                                      WibukuExpService.instance.addExp(10, context: context, isParty: true);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Floating Live Chat Overlay di atas Player
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: PartyChatOverlay(
                        onSendReaction: (emoji) {
                          // Kirim via websocket / realtime channel
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FriendInviteTile extends StatelessWidget {
  const _FriendInviteTile({required this.name, required this.rank});

  final String name;
  final WibukuRank rank;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Image.asset(rank.badgeAsset, width: 24, height: 24, fit: BoxFit.contain),
          const SizedBox(width: 10),
          Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
              foregroundColor: Colors.black,
              minimumSize: const Size(60, 30),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Undangan terkirim ke $name!')),
              );
            },
            child: const Text('Undang', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
