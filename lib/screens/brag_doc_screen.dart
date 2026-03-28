import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workjournel/models/brag_doc_record.dart';
import 'package:workjournel/theme/app_theme.dart';
import 'package:workjournel/viewmodels/brag_doc_viewmodel.dart';
import 'package:workjournel/widgets/logs/brag_doc_flow.dart';

class BragDocScreen extends StatefulWidget {
  const BragDocScreen({super.key});

  @override
  State<BragDocScreen> createState() => _BragDocScreenState();
}

class _BragDocScreenState extends State<BragDocScreen> {
  final _viewModel = BragDocViewModel();
  String? _lastHandledPdfPath;

  @override
  void initState() {
    super.initState();
    _viewModel.initialize();
    _viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    final path = _viewModel.savedPdfPath;
    if (path != null && path != _lastHandledPdfPath) {
      _lastHandledPdfPath = path;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'PDF downloaded',
            style: AppFonts.lexend(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final topInset = MediaQuery.of(context).padding.top;
          final bodyHeight = constraints.maxHeight - topInset - 64;
          return Column(
            children: [
              SafeArea(
                bottom: false,
                child: _BragDocTopBar(onBackTap: () => context.pop()),
              ),
              SizedBox(
                height: bodyHeight > 0 ? bodyHeight : constraints.maxHeight,
                child: BragDocFlow(
                  viewModel: _viewModel,
                  onDownload: _downloadBragDoc,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _downloadBragDoc(BragDocRecord doc) {
    _viewModel.downloadDoc(doc);
  }
}

class _BragDocTopBar extends StatelessWidget {
  final VoidCallback onBackTap;

  const _BragDocTopBar({required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBackTap,
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Text(
            'Brag Document',
            style: AppFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
