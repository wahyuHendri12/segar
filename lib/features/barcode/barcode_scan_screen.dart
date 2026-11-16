import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/barcode_utils.dart';
import '../../core/widgets/app_button.dart';
import '../../l10n/app_localizations.dart';

/// Full-screen camera scanner that returns normalized barcode digits.
///
/// Manual entry is always available, so the flow still works on devices
/// without a camera or when permission is denied.
class BarcodeScanScreen extends StatefulWidget {
  const BarcodeScanScreen({super.key});

  @override
  State<BarcodeScanScreen> createState() => _BarcodeScanScreenState();
}

class _BarcodeScanScreenState extends State<BarcodeScanScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const <BarcodeFormat>[
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
      BarcodeFormat.code128,
      BarcodeFormat.code39,
      BarcodeFormat.itf14,
    ],
  );

  bool _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    for (final barcode in capture.barcodes) {
      final raw = barcode.rawValue;
      if (raw == null) continue;
      final normalized = normalizeBarcode(raw);
      if (isValidBarcode(normalized)) {
        _finish(normalized);
        return;
      }
    }
  }

  Future<void> _finish(String barcode) async {
    if (_handled) return;
    _handled = true;
    try {
      await _controller.stop();
    } on Object {
      // The camera may already be stopped by the lifecycle.
    }
    if (!mounted) return;
    Navigator.of(context).pop(barcode);
  }

  Future<void> _manualEntry() async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    final raw = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.barcodeManualTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          maxLength: 14,
          decoration: InputDecoration(
            labelText: l10n.barcodeFieldLabel,
            hintText: l10n.barcodeFieldHint,
          ),
          onSubmitted: (value) => Navigator.of(dialogContext).pop(value),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.genericCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(controller.text),
            child: Text(l10n.barcodeLookupAction),
          ),
        ],
      ),
    );
    controller.dispose();
    if (raw == null || !mounted) return;

    final normalized = normalizeBarcode(raw);
    if (!isValidBarcode(normalized)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.barcodeInvalid)));
      return;
    }
    await _finish(normalized);
  }

  Future<void> _toggleTorch() async {
    try {
      await _controller.toggleTorch();
    } on Object {
      // Torch is optional and may be unavailable on the device.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(l10n.barcodeScanTitle),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: <Widget>[
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: _controller,
            builder: (context, state, child) {
              final enabled = state.torchState == TorchState.on;
              return IconButton(
                tooltip: l10n.barcodeScanTorch,
                onPressed: _toggleTorch,
                icon: Icon(
                  enabled
                      ? Icons.flashlight_on_rounded
                      : Icons.flashlight_off_rounded,
                ),
              );
            },
          ),
          IconButton(
            tooltip: l10n.barcodeScanManual,
            onPressed: _manualEntry,
            icon: const Icon(Icons.keyboard_rounded),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error) =>
                _CameraError(onManualEntry: _manualEntry),
          ),
          IgnorePointer(
            child: Center(
              child: Container(
                width: 280,
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(color: colors.primary, width: 3),
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.xxl,
            child: Column(
              children: <Widget>[
                Text(
                  l10n.barcodeScanHint,
                  textAlign: TextAlign.center,
                  style: context.texts.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: l10n.barcodeScanManual,
                  icon: Icons.keyboard_rounded,
                  variant: AppButtonVariant.tonal,
                  onPressed: _manualEntry,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraError extends StatelessWidget {
  const _CameraError({required this.onManualEntry});

  final VoidCallback onManualEntry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.no_photography_outlined,
                size: 56,
                color: Colors.white70,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.barcodeScanError,
                textAlign: TextAlign.center,
                style: context.texts.bodyMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: l10n.barcodeScanManual,
                icon: Icons.keyboard_rounded,
                onPressed: onManualEntry,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
