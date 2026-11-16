import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/format_utils.dart';
import '../../core/utils/stats_utils.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/loading_skeleton.dart';
import '../../core/widgets/section_header.dart';
import '../../data/local/enums.dart';
import '../../l10n/app_labels.dart';
import '../../l10n/app_localizations.dart';
import 'stats_providers.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  Future<void> _refresh(WidgetRef ref, StatsPeriod period) async {
    ref.invalidate(statsReportProvider(period));
    await ref.read(statsReportProvider(period).future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final period = ref.watch(statsPeriodProvider);
    final reportAsync = ref.watch(statsReportProvider(period));

    return ColoredBox(
      color: colors.surface,
      child: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () => _refresh(ref, period),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            children: <Widget>[
              Text(
                l10n.statsTitle,
                style: context.texts.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                l10n.statsSubtitle,
                style: context.texts.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _PeriodSelector(
                selected: period,
                onSelected: ref.read(statsPeriodProvider.notifier).setPeriod,
              ),
              const SizedBox(height: AppSpacing.lg),
              reportAsync.when(
                loading: () => const LoadingSkeleton(items: 4),
                error: (error, stackTrace) => AppCard(
                  padding: EdgeInsets.zero,
                  child: EmptyState(
                    icon: Icons.error_outline_rounded,
                    title: l10n.actionFailed,
                    message: l10n.statsEmptyBody,
                    action: AppButton(
                      label: l10n.genericRetry,
                      variant: AppButtonVariant.outline,
                      onPressed: () =>
                          ref.invalidate(statsReportProvider(period)),
                    ),
                  ),
                ),
                data: (report) => _StatsContent(
                  report: report,
                  onShowAll: () => ref
                      .read(statsPeriodProvider.notifier)
                      .setPeriod(StatsPeriod.semua),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({required this.selected, required this.onSelected});

  final StatsPeriod selected;
  final ValueChanged<StatsPeriod> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = <StatsPeriod, String>{
      StatsPeriod.mingguIni: l10n.statsPeriodWeek,
      StatsPeriod.bulanIni: l10n.statsPeriodMonth,
      StatsPeriod.tigaBulan: l10n.statsPeriodThreeMonths,
      StatsPeriod.semua: l10n.statsPeriodAll,
    };

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: StatsPeriod.values.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.xxs),
        itemBuilder: (context, index) {
          final period = StatsPeriod.values[index];
          return ChoiceChip(
            label: Text(labels[period]!),
            selected: period == selected,
            showCheckmark: false,
            onSelected: (_) => onSelected(period),
          );
        },
      ),
    );
  }
}

class _StatsContent extends StatelessWidget {
  const _StatsContent({required this.report, required this.onShowAll});

  final StatsReport report;
  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (report.isEmpty) {
      if (report.period != StatsPeriod.semua && report.trackingSince != null) {
        return AppCard(
          child: Column(
            children: <Widget>[
              Icon(
                Icons.event_note_rounded,
                size: 40,
                color: context.colors.primary,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.statsPeriodEmptyTitle,
                textAlign: TextAlign.center,
                style: context.texts.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                l10n.statsPeriodEmptyBody,
                textAlign: TextAlign.center,
                style: context.texts.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: l10n.statsShowAll,
                variant: AppButtonVariant.outline,
                onPressed: onShowAll,
              ),
            ],
          ),
        );
      }

      return AppCard(
        padding: EdgeInsets.zero,
        child: EmptyState(
          icon: Icons.insights_rounded,
          title: l10n.statsEmptyTitle,
          message: l10n.statsEmptyBody,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _SavingsHero(report: report),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: <Widget>[
            Expanded(
              child: _MiniStat(
                icon: Icons.restaurant_rounded,
                title: l10n.statsUsedTitle,
                count: report.usedCount,
                valueIdr: report.summary.savedIdr,
                color: context.segarColors.success,
                containerColor: context.segarColors.successContainer,
                foregroundColor: context.segarColors.onSuccessContainer,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _MiniStat(
                icon: Icons.delete_sweep_rounded,
                title: l10n.statsWastedTitle,
                count: report.wastedCount,
                valueIdr: report.summary.wastedIdr,
                color: context.segarColors.expired,
                containerColor: context.segarColors.expiredContainer,
                foregroundColor: context.segarColors.onExpiredContainer,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _DistributionCard(report: report),
        const SizedBox(height: AppSpacing.lg),
        _TrendCard(trend: report.trend),
        const SizedBox(height: AppSpacing.lg),
        _ImpactCard(report: report),
        if (report.categories.isNotEmpty) ...<Widget>[
          const SizedBox(height: AppSpacing.lg),
          _CategoryCard(report: report),
          const SizedBox(height: AppSpacing.lg),
          _InsightCard(report: report),
        ],
        if (report.wasteReasons.isNotEmpty) ...<Widget>[
          const SizedBox(height: AppSpacing.lg),
          _WasteReasonCard(report: report),
        ],
        if (report.trackingSince != null) ...<Widget>[
          const SizedBox(height: AppSpacing.lg),
          _StreakCard(report: report),
        ],
        if (report.summary.hasEstimate) ...<Widget>[
          const SizedBox(height: AppSpacing.md),
          _EstimateNote(),
        ],
      ],
    );
  }
}

class _SavingsHero extends StatelessWidget {
  const _SavingsHero({required this.report});

  final StatsReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final segar = context.segarColors;
    final share = (report.usedSharePercent / 100).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            colors.primaryContainer,
            Color.lerp(colors.primaryContainer, colors.surface, 0.45)!,
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.primary.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.savings_rounded,
                  size: 21,
                  color: colors.onPrimary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.statsSavedLabel,
                  style: context.texts.labelMedium?.copyWith(
                    color: colors.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            formatRupiah(report.summary.savedIdr),
            style: context.texts.displaySmall?.copyWith(
              color: colors.onPrimaryContainer,
              fontWeight: FontWeight.w800,
              height: 1.05,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            l10n.statsSavedPercent(report.usedSharePercent.round()),
            style: context.texts.bodyMedium?.copyWith(
              color: colors.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: share,
              minHeight: 8,
              backgroundColor: colors.surface.withValues(alpha: 0.65),
              color: segar.success,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.icon,
    required this.title,
    required this.count,
    required this.valueIdr,
    required this.color,
    required this.containerColor,
    required this.foregroundColor,
  });

  final IconData icon;
  final String title;
  final int count;
  final int valueIdr;
  final Color color;
  final Color containerColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: containerColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: foregroundColor),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  title,
                  style: context.texts.labelMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.statsItemCount(count),
            style: context.texts.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            formatRupiah(valueIdr),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.texts.labelSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _DistributionCard extends StatelessWidget {
  const _DistributionCard({required this.report});

  final StatsReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final segar = context.segarColors;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SectionHeader(
            title: l10n.statsDistributionTitle,
            subtitle: l10n.statsDistributionTotal(report.totalCount),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 190,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                PieChart(
                  key: const Key('stats-distribution-chart'),
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 58,
                    startDegreeOffset: -90,
                    sections: <PieChartSectionData>[
                      PieChartSectionData(
                        value: report.usedCount.toDouble(),
                        color: segar.success,
                        radius: 26,
                        showTitle: false,
                      ),
                      if (report.wastedCount > 0)
                        PieChartSectionData(
                          value: report.wastedCount.toDouble(),
                          color: segar.expired,
                          radius: 26,
                          showTitle: false,
                        ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '${report.totalCount}',
                      style: context.texts.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      l10n.statsTotalItemsLabel,
                      style: context.texts.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: _LegendItem(
                  color: segar.success,
                  label: l10n.statsDistributionSaved,
                  count: report.usedCount,
                ),
              ),
              Expanded(
                child: _LegendItem(
                  color: segar.expired,
                  label: l10n.statsDistributionWasted,
                  count: report.wastedCount,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.count,
  });

  final Color color;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: <Widget>[
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.xxs),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.texts.labelMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          '$count',
          style: context.texts.labelMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard({required this.trend});

  final StatsTrend trend;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final segar = context.segarColors;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SectionHeader(title: l10n.statsTrendTitle),
          const SizedBox(height: AppSpacing.sm),
          if (!trend.hasData)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Text(
                l10n.statsTrendEmpty,
                textAlign: TextAlign.center,
                style: context.texts.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            )
          else ...<Widget>[
            SizedBox(height: 180, child: _TrendChart(trend: trend)),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.xxs,
              children: <Widget>[
                _ChartLegendDot(
                  color: segar.success,
                  label: l10n.statsTrendSaved,
                ),
                _ChartLegendDot(
                  color: segar.expired,
                  label: l10n.statsTrendWasted,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _TrendChart extends StatelessWidget {
  const _TrendChart({required this.trend});

  final StatsTrend trend;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final segar = context.segarColors;
    final useValue = trend.points.any(
      (point) => point.savedIdr > 0 || point.wastedIdr > 0,
    );

    double savedFor(StatsTrendPoint point) =>
        (useValue ? point.savedIdr : point.savedCount).toDouble();
    double wastedFor(StatsTrendPoint point) =>
        (useValue ? point.wastedIdr : point.wastedCount).toDouble();

    final maxValue = trend.points.fold<double>(
      0,
      (current, point) =>
          math.max(current, math.max(savedFor(point), wastedFor(point))),
    );

    return BarChart(
      key: const Key('stats-trend-chart'),
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        minY: 0,
        maxY: maxValue <= 0 ? 1 : maxValue * 1.18,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.round();
                if (index < 0 || index >= trend.points.length) {
                  return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  meta: meta,
                  space: 6,
                  child: Text(
                    _trendLabel(trend, trend.points[index]),
                    style: context.texts.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: <BarChartGroupData>[
          for (var index = 0; index < trend.points.length; index++)
            BarChartGroupData(
              x: index,
              barsSpace: 3,
              barRods: <BarChartRodData>[
                BarChartRodData(
                  toY: savedFor(trend.points[index]),
                  color: segar.success,
                  width: 9,
                  borderRadius: BorderRadius.circular(3),
                ),
                BarChartRodData(
                  toY: wastedFor(trend.points[index]),
                  color: segar.expired,
                  width: 9,
                  borderRadius: BorderRadius.circular(3),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _trendLabel(StatsTrend trend, StatsTrendPoint point) {
    return switch (trend.granularity) {
      StatsTrendGranularity.daily => formatWeekdayShort(point.start),
      StatsTrendGranularity.weekly => '${point.start.day}',
      StatsTrendGranularity.monthly => formatMonthShort(point.start),
    };
  }
}

class _ChartLegendDot extends StatelessWidget {
  const _ChartLegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.texts.labelSmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _ImpactCard extends StatelessWidget {
  const _ImpactCard({required this.report});

  final StatsReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final segar = context.segarColors;
    final summary = report.summary;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            segar.successContainer,
            Color.lerp(segar.successContainer, colors.surface, 0.3)!,
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: segar.success.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.surface.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                child: const Text('🌱', style: TextStyle(fontSize: 19)),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  l10n.statsImpactTitle,
                  style: context.texts.titleSmall?.copyWith(
                    color: segar.onSuccessContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _motivationText(l10n, report),
            style: context.texts.bodyMedium?.copyWith(
              color: segar.onSuccessContainer,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: _ImpactMetric(
                  icon: Icons.eco_rounded,
                  value: l10n.statsImpactKgValue(
                    formatQuantity(summary.kgWasteReduced),
                  ),
                  label: l10n.statsImpactKgLabel,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _ImpactMetric(
                  icon: Icons.rice_bowl_rounded,
                  value: l10n.statsImpactPortionValue(
                    formatQuantity(summary.ricePortions),
                  ),
                  label: l10n.statsImpactPortionLabel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _motivationText(AppLocalizations l10n, StatsReport report) {
    final summary = report.summary;
    final kg = formatQuantity(summary.kgWasteReduced);
    final portions = formatQuantity(summary.ricePortions);
    final percent = summary.managedPercentage.round();

    return switch (motivationLevelFor(report)) {
      MotivationLevel.empty => l10n.statsMotivationEmpty,
      MotivationLevel.excellent => l10n.statsMotivationExcellent(
        percent,
        kg,
        portions,
      ),
      MotivationLevel.good => l10n.statsMotivationGood(percent, kg, portions),
      MotivationLevel.lowWaste => l10n.statsMotivationLowWaste(kg, portions),
      MotivationLevel.learning => l10n.statsMotivationLearning,
    };
  }
}

class _ImpactMetric extends StatelessWidget {
  const _ImpactMetric({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final segar = context.segarColors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.colors.surface.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 18, color: segar.success),
          const SizedBox(height: 4),
          Text(
            value,
            style: context.texts.titleSmall?.copyWith(
              color: segar.onSuccessContainer,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.texts.labelSmall?.copyWith(
              color: segar.onSuccessContainer.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.report});

  final StatsReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SectionHeader(
            title: l10n.statsCategoryTitle,
            subtitle: l10n.statsCategorySubtitle,
          ),
          const SizedBox(height: AppSpacing.sm),
          for (var index = 0; index < report.categories.length; index++) ...[
            _CategoryRow(stat: report.categories[index]),
            if (index != report.categories.length - 1)
              const Divider(height: AppSpacing.lg),
          ],
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.stat});

  final StatsCategoryStat stat;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final segar = context.segarColors;
    final percent = stat.efficiencyPercent.round();
    final healthy = percent >= 80;
    final color = healthy ? segar.success : segar.warning;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          child: Text(
            _categoryEmoji(stat.category),
            style: const TextStyle(fontSize: 20),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      l10n.categoryLabel(stat.category),
                      style: context.texts.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    l10n.statsCategoryEfficiency(percent),
                    style: context.texts.labelMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: LinearProgressIndicator(
                  value: (stat.efficiencyPercent / 100).clamp(0.0, 1.0),
                  minHeight: 6,
                  backgroundColor: colors.surfaceContainerHigh,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stat.hasWaste
                    ? l10n.statsCategoryUsage(stat.usedCount, stat.totalCount)
                    : l10n.statsCategoryNoWaste,
                style: context.texts.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WasteReasonCard extends StatelessWidget {
  const _WasteReasonCard({required this.report});

  final StatsReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final topReason = report.topWasteReason;
    final maxCount = report.wasteReasons.first.count;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SectionHeader(
            title: l10n.statsWasteReasonTitle,
            subtitle: topReason == null
                ? null
                : l10n.statsWasteReasonSubtitle(
                    l10n.wasteReasonName(topReason),
                  ),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (var index = 0; index < report.wasteReasons.length; index++) ...[
            _ReasonRow(
              label: l10n.wasteReasonName(report.wasteReasons[index].reason),
              count: report.wasteReasons[index].count,
              maxCount: maxCount,
            ),
            if (index != report.wasteReasons.length - 1)
              const SizedBox(height: AppSpacing.sm),
          ],
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.statsWasteReasonCount(report.wasteLogCount),
            style: context.texts.labelSmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReasonRow extends StatelessWidget {
  const _ReasonRow({
    required this.label,
    required this.count,
    required this.maxCount,
  });

  final String label;
  final int count;
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final segar = context.segarColors;
    final ratio = maxCount <= 0 ? 0.0 : count / maxCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                style: context.texts.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '$count',
              style: context.texts.labelSmall?.copyWith(
                color: segar.warning,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: LinearProgressIndicator(
            value: ratio.clamp(0.0, 1.0),
            minHeight: 5,
            backgroundColor: colors.surfaceContainerHigh,
            color: segar.warning,
          ),
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.report});

  final StatsReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final worst = worstCategory(<IngredientCategory, double>{
      for (final stat in report.categories)
        stat.category: stat.efficiencyPercent,
    });
    final text = worst == null
        ? l10n.statsInsightAllGood
        : _insightText(l10n, worst);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.primaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.lightbulb_rounded,
            size: 22,
            color: colors.onPrimaryContainer,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.statsInsightTitle,
                  style: context.texts.labelMedium?.copyWith(
                    color: colors.onPrimaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  text,
                  style: context.texts.bodySmall?.copyWith(
                    color: colors.onPrimaryContainer,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _insightText(AppLocalizations l10n, IngredientCategory category) {
    return switch (category) {
      IngredientCategory.sayur => l10n.statsInsightSayur,
      IngredientCategory.buah => l10n.statsInsightBuah,
      IngredientCategory.daging => l10n.statsInsightDaging,
      IngredientCategory.ikanSeafood => l10n.statsInsightIkanSeafood,
      IngredientCategory.telurSusu => l10n.statsInsightTelurSusu,
      IngredientCategory.bumbu => l10n.statsInsightBumbu,
      IngredientCategory.bahanKering => l10n.statsInsightBahanKering,
      IngredientCategory.minuman => l10n.statsInsightMinuman,
      IngredientCategory.makananOlahan => l10n.statsInsightMakananOlahan,
      IngredientCategory.lainnya => l10n.statsInsightLainnya,
    };
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.report});

  final StatsReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final segar = context.segarColors;
    final lastWastedAt = report.lastWastedAt;

    return AppCard(
      child: Row(
        children: <Widget>[
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: segar.warningContainer,
              shape: BoxShape.circle,
            ),
            child: const Text('🔥', style: TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.statsStreakTitle,
                  style: context.texts.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  lastWastedAt == null
                      ? l10n.statsStreakClean
                      : l10n.statsStreakBody(formatDateId(lastWastedAt)),
                  style: context.texts.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              l10n.statsStreakDays(report.streakDays),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: context.texts.titleMedium?.copyWith(
                color: segar.warning,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EstimateNote extends StatelessWidget {
  const _EstimateNote();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          Icons.info_outline_rounded,
          size: 16,
          color: colors.onSurfaceVariant,
        ),
        const SizedBox(width: AppSpacing.xxs),
        Expanded(
          child: Text(
            l10n.statsEstimateNote,
            style: context.texts.labelSmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

String _categoryEmoji(IngredientCategory category) {
  return switch (category) {
    IngredientCategory.sayur => '🥬',
    IngredientCategory.buah => '🍎',
    IngredientCategory.daging => '🍗',
    IngredientCategory.ikanSeafood => '🐟',
    IngredientCategory.telurSusu => '🥛',
    IngredientCategory.bumbu => '🧄',
    IngredientCategory.bahanKering => '🌾',
    IngredientCategory.minuman => '🥤',
    IngredientCategory.makananOlahan => '🥫',
    IngredientCategory.lainnya => '🍽️',
  };
}
