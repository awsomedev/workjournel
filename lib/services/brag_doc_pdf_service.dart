import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:workjournel/models/brag_doc_record.dart';

class PdfSaveResult {
  final String filePath;

  const PdfSaveResult(this.filePath);
}

class BragDocPdfService {
  Future<PdfSaveResult> download(BragDocRecord doc) async {
    final bytes = await _buildPdf(doc);
    final fileName = _fileName(doc);
    final dir = await _saveDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    return PdfSaveResult(file.path);
  }

  Future<Directory> _saveDirectory() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final dir = await getExternalStorageDirectory();
      return dir ?? await getApplicationDocumentsDirectory();
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return getApplicationDocumentsDirectory();
    }
    try {
      final downloads = await getDownloadsDirectory();
      if (downloads != null) {
        final testFile = File('${downloads.path}/.wj_write_test');
        await testFile.writeAsString('');
        await testFile.delete();
        return downloads;
      }
    } catch (_) {}
    return getApplicationDocumentsDirectory();
  }

  Future<Uint8List> _buildPdf(BragDocRecord doc) async {
    final regularData = await rootBundle.load(
      'assets/fonts/plus_jakarta_sans/PlusJakartaSans-Regular.ttf',
    );
    final boldData = await rootBundle.load(
      'assets/fonts/plus_jakarta_sans/PlusJakartaSans-Bold.ttf',
    );
    final bodyData = await rootBundle.load(
      'assets/fonts/lexend/Lexend-Regular.ttf',
    );
    final bodyMediumData = await rootBundle.load(
      'assets/fonts/lexend/Lexend-Medium.ttf',
    );

    final regular = pw.Font.ttf(regularData);
    final bold = pw.Font.ttf(boldData);
    final body = pw.Font.ttf(bodyData);
    final bodyMedium = pw.Font.ttf(bodyMediumData);

    final document = pw.Document();
    final lines = doc.markdownContent.split('\n');

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 48, vertical: 48),
        theme: pw.ThemeData.withFont(base: body, bold: bold),
        build: (context) => _buildContent(
          lines,
          doc,
          regular: regular,
          bold: bold,
          body: body,
          bodyMedium: bodyMedium,
        ),
      ),
    );
    return document.save();
  }

  List<pw.Widget> _buildContent(
    List<String> lines,
    BragDocRecord doc, {
    required pw.Font regular,
    required pw.Font bold,
    required pw.Font body,
    required pw.Font bodyMedium,
  }) {
    final widgets = <pw.Widget>[];

    widgets.add(
      pw.Text(
        _rangeLabel(doc),
        style: pw.TextStyle(font: body, fontSize: 10, color: PdfColors.grey600),
      ),
    );
    widgets.add(pw.SizedBox(height: 16));

    for (final raw in lines) {
      final line = raw.trimRight();
      if (line.startsWith('# ')) {
        widgets.add(
          pw.Text(
            line.substring(2),
            style: pw.TextStyle(font: bold, fontSize: 22),
          ),
        );
        widgets.add(pw.SizedBox(height: 10));
      } else if (line.startsWith('## ')) {
        widgets.add(pw.SizedBox(height: 8));
        widgets.add(
          pw.Text(
            line.substring(3),
            style: pw.TextStyle(font: bold, fontSize: 16),
          ),
        );
        widgets.add(pw.SizedBox(height: 6));
      } else if (line.startsWith('### ')) {
        widgets.add(pw.SizedBox(height: 6));
        widgets.add(
          pw.Text(
            line.substring(4),
            style: pw.TextStyle(font: bold, fontSize: 13),
          ),
        );
        widgets.add(pw.SizedBox(height: 4));
      } else if (line.startsWith('- ') || line.startsWith('* ')) {
        widgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 12, bottom: 3),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '-  ',
                  style: pw.TextStyle(font: body, fontSize: 11),
                ),
                pw.Expanded(
                  child: pw.Text(
                    _stripInlineMarkdown(line.substring(2)),
                    style: pw.TextStyle(
                      font: body,
                      fontSize: 11,
                      lineSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (line.startsWith('---') || line.startsWith('***')) {
        widgets.add(pw.SizedBox(height: 6));
        widgets.add(pw.Divider(color: PdfColors.grey400));
        widgets.add(pw.SizedBox(height: 6));
      } else if (line.isEmpty) {
        widgets.add(pw.SizedBox(height: 6));
      } else {
        widgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 3),
            child: pw.Text(
              _stripInlineMarkdown(line),
              style: pw.TextStyle(font: body, fontSize: 11, lineSpacing: 2),
            ),
          ),
        );
      }
    }

    return widgets;
  }

  String _stripInlineMarkdown(String text) {
    return text
        .replaceAllMapped(RegExp(r'\*\*(.*?)\*\*'), (m) => m[1] ?? '')
        .replaceAllMapped(RegExp(r'\*(.*?)\*'), (m) => m[1] ?? '')
        .replaceAllMapped(RegExp(r'`(.*?)`'), (m) => m[1] ?? '')
        .replaceAllMapped(RegExp(r'\[(.*?)\]\(.*?\)'), (m) => m[1] ?? '');
  }

  String _fileName(BragDocRecord doc) {
    final start = DateTime.fromMillisecondsSinceEpoch(doc.timeframeStartMillis);
    final end = DateTime.fromMillisecondsSinceEpoch(
      doc.timeframeEndMillis,
    ).subtract(const Duration(days: 1));
    return 'brag-${_isoDate(start)}-to-${_isoDate(end)}.pdf';
  }

  String _rangeLabel(BragDocRecord doc) {
    final start = DateTime.fromMillisecondsSinceEpoch(doc.timeframeStartMillis);
    final end = DateTime.fromMillisecondsSinceEpoch(
      doc.timeframeEndMillis,
    ).subtract(const Duration(days: 1));
    return 'Timeframe: ${_isoDate(start)} to ${_isoDate(end)}';
  }

  String _isoDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
