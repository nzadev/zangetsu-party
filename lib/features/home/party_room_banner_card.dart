// lib/features/home/party_room_banner_card.dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../gamification/model/wibuku_rank.dart';
import '../gamification/wibuku_exp_service.dart';
import '../watch_together/ui/party_room_screen.dart';

class PartyRoomBannerCard extends StatelessWidget {
  const PartyRoomBannerCard({super.key});

  void _showJoinRoomDialog(BuildContext context) {
    final codeController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF1E1E2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                children: [
                  Icon(Icons.meeting_room_rounded, color: Colors.cyanAccent),
                  SizedBox(width: 8),
                  Text(
                    'Masuk Party Room',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'Masukkan 6-digit kode room dari teman kamu:',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: codeController,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
                decoration: InputDecoration(
                  hintText: 'CONTOH: 849201',
                  hintStyle: const TextStyle(
                    color: Colors.white24,
                    fontSize: 14,
                    letterSpacing: 1.5,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.06),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.cyanAccent),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white70,
                        side: const BorderSide(color: Colors.white24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        final code = codeController.text.trim();
                        if (code.isEmpty) return;
                        Navigator.of(ctx).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => PartyRoomScreen(roomCode: code),
                          ),
                        );
                      },
                      child: const Text('Masuk Room', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createNewParty(BuildContext context) {
    // Generate random 6-digit code
    final randomCode = (100000 + Random().nextInt(900000)).toString();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PartyRoomScreen(roomCode: randomCode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: WibukuExpService.instance,
      builder: (context, _) {
        final service = WibukuExpService.instance;
        final rank = service.currentRank;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF221E38), Color(0xFF161626)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.cyanAccent.withOpacity(0.35), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(0.08),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Tag & User Rank
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(radius: 3, backgroundColor: Colors.redAccent),
                        SizedBox(width: 5),
                        Text(
                          'NOBAR ROOM',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Rank Badge Display
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(rank.badgeAsset, width: 20, height: 20, fit: BoxFit.contain),
                      const SizedBox(width: 6),
                      Text(
                        rank.title,
                        style: TextStyle(
                          color: Color(rank.glowColorValue),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${service.currentExp} EXP',
                        style: const TextStyle(color: Colors.white54, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const Text(
                'Nonton Anime & Film Bareng Teman!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Sinkronkan pemutaran video, live chat, dan lempar stiker emoji melayang.',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),

              const SizedBox(height: 16),

              // Action Buttons: Bikin Room & Masuk Kode
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      icon: const Icon(Icons.add_circle_outline, size: 18),
                      label: const Text(
                        'Buat Room',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      onPressed: () => _createNewParty(context),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withOpacity(0.25)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      icon: const Icon(Icons.pin, size: 18, color: Colors.cyanAccent),
                      label: const Text(
                        'Masuk Kode',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      onPressed: () => _showJoinRoomDialog(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
