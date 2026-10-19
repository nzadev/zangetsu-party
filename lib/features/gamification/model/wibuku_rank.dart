// lib/features/gamification/model/wibuku_rank.dart

/// Representasi Tingkatan Rank Alam Semesta Bleach (Zangetsu Tier System)
enum BleachRank {
  rukongai('Rukongai', 0, 'assets/ranks/ic_rank_stone.webp', 0xFF9E9E9E, 'Jiwa Baru'),
  shinoAcademy('Shino Academy', 500, 'assets/ranks/ic_rank_bronze.webp', 0xFF78909C, 'Murid Akademi'),
  substituteShinigami('Substitute Shinigami', 1500, 'assets/ranks/ic_rank_silver.webp', 0xFFFFB74D, 'Shinigami Pengganti'),
  shikai('Shikai Zangetsu', 3500, 'assets/ranks/ic_rank_gold.webp', 0xFFFF7043, 'Kebangkitan Zangetsu'),
  lieutenant('Lieutenant (Fukutaicho)', 7000, 'assets/ranks/ic_rank_emerald.webp', 0xFF42A5F5, 'Wakil Kapten Gotei 13'),
  captain('Captain (Taicho)', 12000, 'assets/ranks/ic_rank_diamond.webp', 0xFFAB47BC, 'Kapten Divisi'),
  arrancar('Arrancar / Espada', 20000, 'assets/ranks/ic_rank_master.webp', 0xFF26A69A, 'Resurrección & Cero'),
  vizard('Vizard (Hollowfied)', 32000, 'assets/ranks/bleach_hollow_badge.png', 0xFFE53935, 'Topeng Hollow'),
  bankai('Bankai: Tensa Zangetsu', 50000, 'assets/ranks/sample_custom_mythical.png', 0xFFD32F2F, 'Getsuga Tensho Hitam'),
  squadZero('Royal Guard (Squad 0)', 80000, 'assets/ranks/ic_rank_eternal.webp', 0xFFFFD700, 'Divisi 0 Penjaga Jiwa'),
  mugetsu('Mugetsu / Soul King', 120000, 'assets/ranks/ic_rank_celestial.webp', 0xFF00E5FF, 'Reiatsu Tak Terbatas');

  const BleachRank(this.title, this.minExp, this.badgeAsset, this.glowColorValue, this.subtitle);

  final String title;
  final int minExp;
  final String badgeAsset;
  final int glowColorValue;
  final String subtitle;

  static BleachRank fromExp(int exp) {
    for (final rank in BleachRank.values.reversed) {
      if (exp >= rank.minExp) {
        return rank;
      }
    }
    return BleachRank.rukongai;
  }

  BleachRank? get nextRank {
    final idx = index;
    if (idx + 1 < BleachRank.values.length) {
      return BleachRank.values[idx + 1];
    }
    return null;
  }

  double progressToNext(int currentExp) {
    final next = nextRank;
    if (next == null) return 1.0;
    final span = next.minExp - minExp;
    final progress = (currentExp - minExp) / span;
    return progress.clamp(0.0, 1.0);
  }
}

// Alias kompatibilitas
typedef WibukuRank = BleachRank;
