import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/stats_utils.dart';
import '../../data/local/enums.dart';
import '../../data/repositories/repository_providers.dart';

class StatsPeriodNotifier extends Notifier<StatsPeriod> {
  @override
  StatsPeriod build() => StatsPeriod.mingguIni;

  void setPeriod(StatsPeriod period) {
    state = period;
  }
}

/// Period selected on the statistics screen.
final statsPeriodProvider = NotifierProvider<StatsPeriodNotifier, StatsPeriod>(
  StatsPeriodNotifier.new,
);

/// Aggregated report that re-emits whenever usage logs change.
final statsReportProvider = StreamProvider.autoDispose
    .family<StatsReport, StatsPeriod>(
      (ref, period) => ref.watch(statsRepositoryProvider).watchReport(period),
    );
