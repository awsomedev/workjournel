import 'package:flutter/material.dart';
import 'package:workjournel/models/brag_doc_record.dart';
import 'package:workjournel/theme/app_theme.dart';
import 'package:workjournel/viewmodels/brag_doc_viewmodel.dart';
import 'package:workjournel/widgets/logs/brag_doc_markdown_view.dart';
import 'package:workjournel/widgets/logs/brag_doc_timeframe_picker.dart';

class BragDocFlow extends StatelessWidget {
  final BragDocViewModel viewModel;
  final ValueChanged<BragDocRecord> onDownload;

  const BragDocFlow({
    super.key,
    required this.viewModel,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final size = AppBreakpoints.fromWidth(constraints.maxWidth);
            final isSm = size == ResponsiveSize.sm;
            final isMd = size == ResponsiveSize.md;
            final horizontalPadding = isSm ? 16.0 : (isMd ? 24.0 : 32.0);

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                16,
                horizontalPadding,
                24,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ActionHeader(
                        viewModel: viewModel,
                        onDownload: onDownload,
                        size: size,
                      ),
                      const SizedBox(height: 20),
                      viewModel.generatedMarkdown == null
                          ? const _EmptyPreview(message: _emptyPreviewText)
                          : Stack(
                              children: [
                                BragDocMarkdownView(
                                  markdown: viewModel.generatedMarkdown!,
                                ),
                                Positioned(
                                  top: 12,
                                  left: 12,
                                  child: _DownloadButton(
                                    onPressed:
                                        viewModel.selectedDoc == null ||
                                            viewModel.isDownloading
                                        ? null
                                        : () => onDownload(
                                            viewModel.selectedDoc!,
                                          ),
                                    isDownloading: viewModel.isDownloading,
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ActionHeader extends StatelessWidget {
  final BragDocViewModel viewModel;
  final ValueChanged<BragDocRecord> onDownload;
  final ResponsiveSize size;

  const _ActionHeader({
    required this.viewModel,
    required this.onDownload,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final isSm = size == ResponsiveSize.sm;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isSm) ...[
          BragDocTimeframePicker(
            fromDate: viewModel.fromDate,
            toDate: viewModel.toDate,
            onFromDateChanged: (value) => viewModel.setFromDate(value),
            onToDateChanged: (value) => viewModel.setToDate(value),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _GenerateButton(
                  onPressed: viewModel.isGenerating
                      ? null
                      : viewModel.generateForSelectedTimeframe,
                  isGenerating: viewModel.isGenerating,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _RecreateButton(
                  onPressed:
                      viewModel.selectedDoc == null || viewModel.isGenerating
                      ? null
                      : () => viewModel.recreateDoc(),
                ),
              ),
            ],
          ),
        ] else
          Row(
            children: [
              Expanded(
                flex: 3,
                child: BragDocTimeframePicker(
                  fromDate: viewModel.fromDate,
                  toDate: viewModel.toDate,
                  onFromDateChanged: (value) => viewModel.setFromDate(value),
                  onToDateChanged: (value) => viewModel.setToDate(value),
                ),
              ),
              const SizedBox(width: 12),
              _GenerateButton(
                onPressed: viewModel.isGenerating
                    ? null
                    : viewModel.generateForSelectedTimeframe,
                isGenerating: viewModel.isGenerating,
              ),
              const SizedBox(width: 8),
              _RecreateButton(
                onPressed:
                    viewModel.selectedDoc == null || viewModel.isGenerating
                    ? null
                    : () => viewModel.recreateDoc(),
              ),
            ],
          ),
        if (viewModel.errorMessage != null) ...[
          const SizedBox(height: 8),
          Text(
            viewModel.errorMessage!,
            style: AppFonts.lexend(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

class _GenerateButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isGenerating;

  const _GenerateButton({this.onPressed, required this.isGenerating});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
        minimumSize: const Size(120, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        isGenerating ? 'Generating...' : 'Generate',
        style: AppFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _RecreateButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _RecreateButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(120, 48),
        side: BorderSide(
          color: AppColors.outlineVariant.withValues(alpha: 0.5),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        'Recreate',
        style: AppFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _DownloadButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isDownloading;

  const _DownloadButton({this.onPressed, required this.isDownloading});

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.surfaceContainerHigh.withValues(alpha: 0.8),
        foregroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: isDownloading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            )
          : const Icon(Icons.download_rounded, size: 20),
      tooltip: 'Download PDF',
    );
  }
}

class _EmptyPreview extends StatelessWidget {
  final String message;

  const _EmptyPreview({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(40),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: AppFonts.lexend(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceVariant,
          height: 1.6,
        ),
      ),
    );
  }
}

const String _emptyPreviewText =
    'Select a timeframe and generate a brag document. Your latest document for the selected range will appear here.';
