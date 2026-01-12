import 'dart:collection';

import '../../data/dummy_data.dart';
import '../../repositories/statistics_repository.dart';
import 'map_models.dart';

/// Menghasilkan statistik wilayah dari endpoint agregasi Laravel:
/// GET `/region-statistics`.
class MapRepository {
  MapRepository({StatisticsRepository? statisticsRepository})
      : _stats = statisticsRepository ?? StatisticsRepository();

  final StatisticsRepository _stats;

  Future<List<RegionStat>> getRegionStats() async {
    final rows = await _stats.getRegionStatistics();

    final stats = <RegionStat>[];
    for (final row in rows) {
      final region = row['region']?.toString().trim() ?? '';
      if (region.isEmpty) continue;

      int toInt(Object? v) {
        if (v is int) return v;
        if (v is String) return int.tryParse(v) ?? 0;
        if (v is num) return v.toInt();
        return 0;
      }

      final perCat = <KiCategoryType, int>{
        KiCategoryType.ebt: toInt(row['ebt']),
        KiCategoryType.pt: toInt(row['pt']),
        KiCategoryType.pig: toInt(row['pig']),
        KiCategoryType.sdg: toInt(row['sdg']),
        KiCategoryType.ia: toInt(row['ia']),
        KiCategoryType.ig: toInt(row['ig']),
      };

      final total = toInt(row['total']);
      stats.add(
        RegionStat(
          daerahAsal: region,
          total: total,
          perCategory: UnmodifiableMapView(perCat),
        ),
      );
    }

    stats.sort((a, b) => b.total.compareTo(a.total));
    return stats;
  }
}
