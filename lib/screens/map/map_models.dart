import '../../data/dummy_data.dart';

class RegionStat {
  const RegionStat({
    required this.daerahAsal,
    required this.total,
    required this.perCategory,
  });

  final String daerahAsal;
  final int total;
  final Map<KiCategoryType, int> perCategory;
}
