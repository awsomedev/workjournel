import 'package:flutter/foundation.dart';
import 'package:workjournel/models/brag_doc_record.dart';
import 'package:workjournel/services/brag_doc_llm_service.dart';
import 'package:workjournel/services/brag_doc_pdf_service.dart';
import 'package:workjournel/services/brag_doc_storage_service.dart';
import 'package:workjournel/services/journal_storage_service.dart';
import 'package:workjournel/viewmodels/model_selection_viewmodel.dart';

class BragDocViewModel extends ChangeNotifier {
  BragDocViewModel({
    BragDocLlmService? llmService,
    BragDocPdfService? pdfService,
    ModelSelectionViewModel? modelSelectionViewModel,
  }) : _llmService = llmService ?? BragDocLlmService(),
       _pdfService = pdfService ?? BragDocPdfService(),
       _modelSelectionViewModel =
           modelSelectionViewModel ?? ModelSelectionViewModel();

  final BragDocLlmService _llmService;
  final BragDocPdfService _pdfService;
  final ModelSelectionViewModel _modelSelectionViewModel;

  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 29));
  DateTime _toDate = DateTime.now();
  BragDocRecord? _selectedDoc;
  String? _generatedMarkdown;
  String? _errorMessage;
  String? _savedPdfPath;
  bool _isGenerating = false;
  bool _isDownloading = false;
  bool _isInitialized = false;

  DateTime get fromDate => _fromDate;
  DateTime get toDate => _toDate;
  BragDocRecord? get selectedDoc => _selectedDoc;
  String? get generatedMarkdown => _generatedMarkdown;
  String? get errorMessage => _errorMessage;
  String? get savedPdfPath => _savedPdfPath;
  bool get isGenerating => _isGenerating;
  bool get isDownloading => _isDownloading;
  bool get hasSelectedModel => _modelSelectionViewModel.activeModel != null;
  String? get activeModelName => _modelSelectionViewModel.activeModel?.name;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }
    _isInitialized = true;
    await _modelSelectionViewModel.initialize();
    _loadLatestDoc();
  }

  Future<void> setFromDate(DateTime value) async {
    _fromDate = _startOfDay(value);
    if (_fromDate.isAfter(_toDate)) {
      _toDate = _fromDate;
    }
    notifyListeners();
  }

  Future<void> setToDate(DateTime value) async {
    _toDate = _startOfDay(value);
    if (_toDate.isBefore(_fromDate)) {
      _fromDate = _toDate;
    }
    notifyListeners();
  }

  void _loadLatestDoc() {
    _selectedDoc = BragDocStorageService.getLatest();
    if (_selectedDoc != null) {
      _fromDate = DateTime.fromMillisecondsSinceEpoch(
        _selectedDoc!.timeframeStartMillis,
      );
      _toDate = DateTime.fromMillisecondsSinceEpoch(
        _selectedDoc!.timeframeEndMillis,
      ).subtract(const Duration(days: 1));
    }
    _generatedMarkdown = _selectedDoc?.markdownContent;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> generateForSelectedTimeframe() async {
    final activeModel = _modelSelectionViewModel.activeModel;
    if (activeModel == null) {
      _errorMessage = 'Select and activate a model in Settings to generate.';
      notifyListeners();
      return;
    }
    _isGenerating = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final memories = JournalStorageService.getEntriesByDateRange(
        _fromDate,
        _toDate,
      );
      final markdown = await _llmService.generateBragDoc(
        memories: memories,
        fromDate: _fromDate,
        toDate: _toDate,
        modelId: activeModel.id,
        modelType: activeModel.modelType,
      );
      await BragDocStorageService.upsert(
        fromDate: _fromDate,
        toDate: _toDate,
        markdownContent: markdown,
        modelId: activeModel.id,
      );
      _selectedDoc = BragDocStorageService.getLatest();
      _generatedMarkdown = _selectedDoc?.markdownContent ?? markdown;
    } catch (error) {
      _errorMessage = 'Failed to generate brag document. Please try again.';
    } finally {
      _isGenerating = false;
      notifyListeners();
    }
  }

  Future<void> recreateDoc() async {
    final doc = _selectedDoc;
    if (doc == null) {
      return;
    }
    _fromDate = DateTime.fromMillisecondsSinceEpoch(doc.timeframeStartMillis);
    _toDate = DateTime.fromMillisecondsSinceEpoch(
      doc.timeframeEndMillis,
    ).subtract(const Duration(days: 1));
    notifyListeners();
    await generateForSelectedTimeframe();
  }

  Future<void> downloadDoc(BragDocRecord doc) async {
    _isDownloading = true;
    _errorMessage = null;
    _savedPdfPath = null;
    notifyListeners();
    try {
      final result = await _pdfService.download(doc);
      _savedPdfPath = result.filePath;
    } catch (e, stack) {
      debugPrint('PDF save error: $e\n$stack');
      _errorMessage = 'PDF error: $e';
    } finally {
      _isDownloading = false;
      notifyListeners();
    }
  }

  DateTime _startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  void dispose() {
    _llmService.dispose();
    super.dispose();
  }
}
