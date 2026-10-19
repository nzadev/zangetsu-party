// lib/features/gamification/wibuku_exp_service.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'model/wibuku_rank.dart';

class WibukuExpService extends ChangeNotifier {
  static final WibukuExpService instance = WibukuExpService._();
  WibukuExpService._();

  static const String boxName = 'wibuku_gamification';
  static const String _expKey = 'user_exp';
  static const String _gemsKey = 'user_gems';

  Box? _box;
  int _exp = 1600; // Default awal untuk testing (Substitute Shinigami)
  int _gems = 50;

  int get currentExp => _exp;
  int get currentGems => _gems;
  BleachRank get currentRank => BleachRank.fromExp(_exp);

  Future<void> init() async {
    try {
      if (Hive.isBoxOpen(boxName)) {
        _box = Hive.box(boxName);
      } else {
        _box = await Hive.openBox(boxName);
      }
      _exp = _box?.get(_expKey, defaultValue: 1600) as int? ?? 1600;
      _gems = _box?.get(_gemsKey, defaultValue: 50) as int? ?? 50;
      notifyListeners();
    } catch (_) {
      // Fallback in-memory
    }
  }

  /// Tambah EXP/Reiatsu dari aktivitas nonton
  void addExp(int amount, {BuildContext? context, bool isParty = false}) {
    final oldRank = currentRank;
    final bonus = isParty ? (amount * 1.5).round() : amount;
    _exp += bonus;
    _box?.put(_expKey, _exp);
    notifyListeners();

    final newRank = currentRank;
    if (newRank.index > oldRank.index && context != null && context.mounted) {
      _showRankUpDialog(context, oldRank, newRank);
    }
  }

  void _showRankUpDialog(BuildContext context, BleachRank oldRank, BleachRank newRank) {
    _gems += 30; // Bonus Soul Orbs
    _box?.put(_gemsKey, _gems);

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF14121E),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Color(newRank.glowColorValue), width: 2),
            boxShadow: [
              BoxShadow(
                color: Color(newRank.glowColorValue).withOpacity(0.4),
                blurRadius: 28,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '⚡ REIATSU AWAKENED! ⚡',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  newRank.badgeAsset,
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.shield,
                    size: 80,
                    color: Colors.redAccent,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                newRank.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(newRank.glowColorValue),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                newRank.subtitle,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Reiatsu kamu meningkat dari ${oldRank.title} ke ${newRank.title}!',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.amberAccent, size: 18),
                    SizedBox(width: 6),
                    Text(
                      '+30 Soul Orbs Bonus!',
                      style: TextStyle(
                        color: Colors.amberAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(newRank.glowColorValue),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('TERIMA KEKUATAN', style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
