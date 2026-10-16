import 'package:flutter/material.dart';
import 'study_data.dart';
import 'file_picker_helper.dart';
import 'whatsapp_url_helper.dart';

const blue = Color(0xFF1769AA);
const navy = Color(0xFF102A43);
const green = Color(0xFF269C70);
const red = Color(0xFFE16D5A);
const amber = Color(0xFFE6A62C);
const purple = Color(0xFF6D5DD3);

/// Dialog allowing Admin to upload a local PDF file from device or add notes.
void showAddStudyMaterialDialog(BuildContext context, {VoidCallback? onSaved}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _AddStudyMaterialDialogContent(onSaved: onSaved),
  );
}

class _AddStudyMaterialDialogContent extends StatefulWidget {
  final VoidCallback? onSaved;

  const _AddStudyMaterialDialogContent({this.onSaved});

  @override
  State<_AddStudyMaterialDialogContent> createState() => _AddStudyMaterialDialogContentState();
}

class _AddStudyMaterialDialogContentState extends State<_AddStudyMaterialDialogContent> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _pagesController = TextEditingController(text: '12');
  final TextEditingController _readTimeController = TextEditingController(text: '20 min');
  final TextEditingController _pdfUrlController = TextEditingController();
  final TextEditingController _notesContentController = TextEditingController();

  PickedFileData? _pickedFile;
  bool _showManualLink = false;
  String _selectedCategory = 'Exam Material';
  String _selectedLanguage = 'Hindi';

  final List<String> _categories = const [
    'Exam Material',
    'GK',
    'Maths',
    'Reasoning',
    'Current Affairs',
    'Hindi',
    'English',
    'Computer',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _pagesController.dispose();
    _readTimeController.dispose();
    _pdfUrlController.dispose();
    _notesContentController.dispose();
    super.dispose();
  }

  void _chooseLocalFile() {
    LocalFilePicker.pickPdf(
      onFilePicked: (file) {
        setState(() {
          _pickedFile = file;

          // Auto-suggest title if empty
          if (_titleController.text.trim().isEmpty) {
            String cleanName = file.name;
            if (cleanName.contains('.')) {
              cleanName = cleanName.substring(0, cleanName.lastIndexOf('.'));
            }
            cleanName = cleanName.replaceAll('_', ' ').replaceAll('-', ' ');
            _titleController.text = cleanName;
          }

          // If text file was read, fill in notes
          if (file.textContent != null && file.textContent!.trim().isNotEmpty) {
            _notesContentController.text = file.textContent!;
          }
        });
      },
    );
  }

  void _saveDocument() {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final desc = _descController.text.trim();
    final pages = int.tryParse(_pagesController.text.trim()) ?? 10;
    final readTime = _readTimeController.text.trim().isEmpty ? '15 min read' : '${_readTimeController.text.trim()} read';
    
    final pdfUrl = _pickedFile != null ? _pickedFile!.blobUrl : _pdfUrlController.text.trim();
    final rawNotes = _notesContentController.text.trim();

    // Prepare Sections
    final List<StudySection> sections = [];
    if (rawNotes.isNotEmpty) {
      final paragraphs = rawNotes
          .split('\n\n')
          .map((p) => p.trim())
          .where((p) => p.isNotEmpty)
          .toList();

      sections.add(
        StudySection(
          title: 'Notes & Key Points (मुख्य बिंदु)',
          subtitle: 'Authored by Krishna Library Faculty & Admin',
          paragraphs: paragraphs.isNotEmpty ? paragraphs : [rawNotes],
          keyPoints: [
            'Regular revision of this chapter ensures high retention.',
            'Solve practice questions after completing this section.',
          ],
        ),
      );
    } else {
      sections.add(
        StudySection(
          title: 'Official Study Module (आधिकारिक नोट्स)',
          subtitle: 'Curated by Krishna Library Branch 01',
          paragraphs: [
            desc.isNotEmpty ? desc : 'This document is available for all registered students.',
            if (_pickedFile != null) 'Actual file: ${_pickedFile!.name} (${_pickedFile!.formattedSize})',
            if (pdfUrl.isNotEmpty) 'Direct PDF Download / View option is available at the top.',
          ],
        ),
      );
    }

    final newDoc = StudyDocument(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      language: _selectedLanguage,
      category: _selectedCategory,
      readTime: readTime,
      pages: pages,
      description: desc.isNotEmpty ? desc : 'Official study notes for Krishna Library students.',
      sections: sections,
      pdfUrl: pdfUrl.isNotEmpty ? pdfUrl : null,
      localFileName: _pickedFile?.name,
      localFileSize: _pickedFile?.formattedSize,
      isCustom: true,
    );

    StudyRepository.addDocument(newDoc);

    Navigator.pop(context);
    widget.onSaved?.call();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: green,
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '✅ "$title" सफलतापूर्वक जोड़ा गया!',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 760),
        child: Column(
          children: [
            // Dialog Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: navy,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: red.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.upload_file_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload / Add PDF Material',
                          style: TextStyle(color: Colors.white, fontSize: 16.5, fontWeight: FontWeight.w900),
                        ),
                        Text(
                          'कंप्यूटर या फोन से PDF फाइल सीधे अपलोड करें',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Form Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. PRIMARY OPTION: Local File Picker Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _pickedFile != null ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _pickedFile != null ? green : const Color(0xFFCBD5E1),
                            width: _pickedFile != null ? 2 : 1.5,
                          ),
                        ),
                        child: _pickedFile == null
                            ? Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: red.withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.cloud_upload_rounded, color: red, size: 36),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Select PDF File from Device',
                                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14.5, color: navy),
                                  ),
                                  const SizedBox(height: 3),
                                  const Text(
                                    'अपने कंप्यूटर या फोन की स्टोरेज से PDF चुनें (.pdf, .doc, .txt)',
                                    style: TextStyle(fontSize: 11.5, color: Colors.blueGrey),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 14),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: red,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      elevation: 0,
                                    ),
                                    icon: const Icon(Icons.folder_open_rounded, size: 20),
                                    label: const Text(
                                      'Browse File (फाइल चुनें)',
                                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5),
                                    ),
                                    onPressed: _chooseLocalFile,
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: green.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(Icons.picture_as_pdf, color: green, size: 28),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(color: green, borderRadius: BorderRadius.circular(4)),
                                                  child: const Text('ATTACHED FILE', style: TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.w900)),
                                                ),
                                                const SizedBox(width: 6),
                                                Text(_pickedFile!.formattedSize, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              _pickedFile!.name,
                                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5, color: navy),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        tooltip: 'हटाएं (Remove file)',
                                        icon: const Icon(Icons.cancel, color: red, size: 22),
                                        onPressed: () => setState(() => _pickedFile = null),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: blue,
                                            side: const BorderSide(color: blue),
                                            padding: const EdgeInsets.symmetric(vertical: 9),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          ),
                                          icon: const Icon(Icons.open_in_new, size: 16),
                                          label: const Text('Preview File (खोलकर देखें)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                          onPressed: () => WhatsAppLauncher.openUrl(_pickedFile!.blobUrl),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: navy,
                                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                                            padding: const EdgeInsets.symmetric(vertical: 9),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          ),
                                          icon: const Icon(Icons.swap_horiz, size: 16),
                                          label: const Text('Change File (बदलें)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                          onPressed: _chooseLocalFile,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                      ),
                      const SizedBox(height: 18),

                      // Document Title
                      const Text('Document Title (शीर्षक) *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: navy)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: 'उदा: SSC GD 2026 Complete Reasoning Notes',
                          prefixIcon: const Icon(Icons.title, color: blue, size: 20),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty ? 'कृपया शीर्षक दर्ज करें' : null,
                      ),
                      const SizedBox(height: 16),

                      // Category and Language Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Category (विषय) *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: navy)),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  initialValue: _selectedCategory,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFF8FAFC),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                                  ),
                                  items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13)))).toList(),
                                  onChanged: (val) {
                                    if (val != null) setState(() => _selectedCategory = val);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Language (माध्यम) *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: navy)),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  initialValue: _selectedLanguage,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFF8FAFC),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                                  ),
                                  items: const [
                                    DropdownMenuItem(value: 'Hindi', child: Text('🇮🇳 Hindi (हिन्दी)', style: TextStyle(fontSize: 13))),
                                    DropdownMenuItem(value: 'English', child: Text('🇬🇧 English', style: TextStyle(fontSize: 13))),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) setState(() => _selectedLanguage = val);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Pages and Reading time Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Total Pages (कुल पेज)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: navy)),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _pagesController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: '12',
                                    prefixIcon: const Icon(Icons.menu_book, color: amber, size: 20),
                                    filled: true,
                                    fillColor: const Color(0xFFF8FAFC),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Read Time (अनुमानित समय)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: navy)),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _readTimeController,
                                  decoration: InputDecoration(
                                    hintText: '20 min',
                                    prefixIcon: const Icon(Icons.timer_outlined, color: green, size: 20),
                                    filled: true,
                                    fillColor: const Color(0xFFF8FAFC),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Short Description
                      const Text('Short Description (संक्षिप्त विवरण)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: navy)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _descController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'उदा: यह पीडीएफ सभी छात्रों के लिए महत्वपूर्ण है।',
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Secondary Option: Toggle Online Link / Text Notes
                      InkWell(
                        onTap: () => setState(() => _showManualLink = !_showManualLink),
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Icon(
                                _showManualLink ? Icons.expand_less : Icons.expand_more,
                                color: blue,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _showManualLink
                                    ? 'Hide Online Link & Direct Text Option'
                                    : '+ Or Paste Google Drive Link / Type Direct Text (वैकल्पिक)',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: blue),
                              ),
                            ],
                          ),
                        ),
                      ),

                      if (_showManualLink) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: green.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.link, color: green, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Online PDF / Google Drive URL (वैकल्पिक)',
                                    style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF0F5132), fontSize: 13),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _pdfUrlController,
                                decoration: InputDecoration(
                                  hintText: 'https://drive.google.com/file/d/...',
                                  prefixIcon: const Icon(Icons.link, color: green, size: 20),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text('Direct Text Notes / Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: navy)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _notesContentController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'सीधे नोट्स या मुख्य बिंदु यहाँ पेस्ट करें...',
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Dialog Footer Actions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('रद्द करें (Cancel)'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text(
                        'Publish PDF File',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      onPressed: _saveDocument,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
