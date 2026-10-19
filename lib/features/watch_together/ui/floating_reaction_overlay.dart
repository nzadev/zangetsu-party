// lib/features/watch_together/ui/floating_reaction_overlay.dart
import 'dart:math';
import 'package:flutter/material.dart';

class FloatingReactionOverlay extends StatefulWidget {
  const FloatingReactionOverlay({super.key, this.child});

  final Widget? child;

  static FloatingReactionOverlayState? of(BuildContext context) {
    return context.findAncestorStateOfType<FloatingReactionOverlayState>();
  }

  @override
  State<FloatingReactionOverlayState> createState() => FloatingReactionOverlayState();
}

class FloatingReactionOverlayState extends State<FloatingReactionOverlay> {
  final List<_FloatingEmoteItem> _emotes = [];
  final Random _random = Random();

  void triggerEmote(String emoji) {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final startX = 0.75 + (_random.nextDouble() * 0.18); // Area kanan bawah
    final sway = (_random.nextDouble() - 0.5) * 60; // Goyang kiri-kanan
    final item = _FloatingEmoteItem(
      id: id,
      emoji: emoji,
      startXRatio: startX,
      sway: sway,
    );

    setState(() {
      _emotes.add(item);
    });
  }

  void _removeEmote(String id) {
    setState(() {
      _emotes.removeWhere((e) => e.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        if (widget.child != null) widget.child!,
        // Overlay render emotes
        IgnorePointer(
          child: Stack(
            children: _emotes.map((e) {
              return _AnimatedFloatingEmote(
                key: ValueKey(e.id),
                item: e,
                screenHeight: size.height,
                screenWidth: size.width,
                onComplete: () => _removeEmote(e.id),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _FloatingEmoteItem {
  _FloatingEmoteItem({
    required this.id,
    required this.emoji,
    required this.startXRatio,
    required this.sway,
  });

  final String id;
  final String emoji;
  final double startXRatio;
  final double sway;
}

class _AnimatedFloatingEmote extends StatefulWidget {
  const _AnimatedFloatingEmote({
    super.key,
    required this.item,
    required this.screenHeight,
    required this.screenWidth,
    required this.onComplete,
  });

  final _FloatingEmoteItem item;
  final double screenHeight;
  final double screenWidth;
  final VoidCallback onComplete;

  @override
  State<_AnimatedFloatingEmote> createState() => _AnimatedFloatingEmoteState();
}

class _AnimatedFloatingEmoteState extends State<_AnimatedFloatingEmote>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _progress = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    _controller.forward().then((_) {
      if (mounted) widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progress,
      builder: (context, _) {
        final t = _progress.value;
        // Bergerak ke atas dari bawah layar
        final startBottom = 80.0;
        final endBottom = widget.screenHeight * 0.65;
        final currentBottom = startBottom + (endBottom - startBottom) * t;

        // Goyangan sinusoidal horizontal
        final horizontalOffset = sin(t * pi * 3) * widget.item.sway;
        final currentLeft = (widget.screenWidth * widget.item.startXRatio) + horizontalOffset;

        // Fade out di bagian akhir
        final opacity = t < 0.6 ? 1.0 : (1.0 - (t - 0.6) / 0.4).clamp(0.0, 1.0);
        // Scale pop effect di awal
        final scale = t < 0.2 ? (t / 0.2) * 1.3 : (1.3 - (t - 0.2) * 0.3);

        return Positioned(
          left: currentLeft,
          bottom: currentBottom,
          child: Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: Text(
                widget.item.emoji,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
        );
      },
    );
  }
}
