import 'package:flutter/material.dart';
import 'file_picker_helper.dart';
import 'study_data.dart';
import 'video_data.dart';
import 'video_views.dart';
import 'whatsapp_url_helper.dart';

class DocumentReaderScreen extends StatefulWidget {
  final StudyDocument document;

  const DocumentReaderScreen({super.key, required this.document});

  @override
  State<DocumentReaderScreen> createState() => _DocumentReaderScreenState();
}

class _DocumentReaderScreenState extends State<DocumentReaderScreen> {
  double fontSize = 15.0;
  int readingTheme = 0; // 0: Normal White, 1: Sepia (Paper), 2: Dark
  int selectedSection = 0;
  final Map<String, int> selectedAnswers = {};
  final Map<String, bool> showExplanations = {};

  @override
  Widget build(BuildContext context) {
    final doc = widget.document;
    final isDark = readingTheme == 2;
    final isSepia = readingTheme == 1;

    final bgColor = isDark
        ? const Color(0xFF121820)
        : isSepia
            ? const Color(0xFFFAF4E8)
            : Colors.white;

    final cardColor = isDark
        ? const Color(0xFF1E2630)
        : isSepia
            ? const Color(0xFFF3ECE0)
            : const Color(0xFFF7FAFD);

    final textColor = isDark
        ? const Color(0xFFE2E8F0)
        : isSepia
            ? const Color(0xFF2C2218)
            : const Color(0xFF102A43);

    final subTextColor = isDark
        ? const Color(0xFF94A3B8)
        : isSepia
            ? const Color(0xFF6B5843)
            : const Color(0xFF486581);

    final isHindi = doc.language == 'Hindi';

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1A2332) : const Color(0xFF102A43),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isHindi ? const Color(0xFF269C70) : const Color(0xFF1769AA),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isHindi ? 'हिन्दी PDF' : 'ENGLISH PDF',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    doc.title,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Text(
              '${doc.category} • ${doc.pages} Pages • ${doc.readTime}',
              style: const TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Text Smaller',
            icon: const Icon(Icons.text_decrease, size: 20),
            onPressed: () {
              if (fontSize > 13) setState(() => fontSize -= 1);
            },
          ),
          IconButton(
            tooltip: 'Text Larger',
            icon: const Icon(Icons.text_increase, size: 20),
            onPressed: () {
              if (fontSize < 22) setState(() => fontSize += 1);
            },
          ),
          PopupMenuButton<int>(
            tooltip: 'Reading Mode',
            icon: const Icon(Icons.palette_outlined),
            onSelected: (mode) => setState(() => readingTheme = mode),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 0, child: Text('⚪ Light Mode (White)')),
              PopupMenuItem(value: 1, child: Text('📜 Paper Mode (Sepia)')),
              PopupMenuItem(value: 2, child: Text('🌙 Night Mode (Dark)')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Section Tabs
          if (doc.sections.length > 1)
            Container(
              color: isDark ? const Color(0xFF1A2332) : const Color(0xFF0D2235),
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                itemCount: doc.sections.length,
                itemBuilder: (ctx, idx) {
                  final isCurrent = idx == selectedSection;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        'Part ${idx + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isCurrent ? Colors.white : Colors.white70,
                        ),
                      ),
                      selected: isCurrent,
                      selectedColor: const Color(0xFF1769AA),
                      backgroundColor: Colors.transparent,
                      side: BorderSide(
                        color: isCurrent ? const Color(0xFF1769AA) : Colors.white24,
                      ),
                      onSelected: (_) => setState(() => selectedSection = idx),
                    ),
                  );
                },
              ),
            ),

          // Document Reading Body
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              children: [
                // Document Cover Header
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? const Color(0xFF2D3748) : const Color(0xFFCBD5E1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.picture_as_pdf, color: Color(0xFFE16D5A), size: 28),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              doc.title,
                              style: TextStyle(
                                fontSize: fontSize + 3,
                                fontWeight: FontWeight.w900,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        doc.description,
                        style: TextStyle(
                          fontSize: fontSize - 1,
                          color: subTextColor,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Chip(
                            label: Text(
                              isHindi ? 'भाषा: हिन्दी' : 'Language: English',
                              style: TextStyle(fontSize: 11, color: textColor),
                            ),
                            backgroundColor: bgColor,
                            visualDensity: VisualDensity.compact,
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(
                              'Verified Academic Content',
                              style: TextStyle(
                                fontSize: 11,
                                color: const Color(0xFF269C70),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: const Color(0xFF269C70).withValues(alpha: 0.12),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      if (doc.pdfUrl != null && doc.pdfUrl!.trim().isNotEmpty) ...[
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF161F2E) : const Color(0xFFFFF5F5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE16D5A).withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.picture_as_pdf, color: Color(0xFFE16D5A), size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      doc.localFileName ?? 'Attached PDF Document',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (doc.localFileSize != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE16D5A).withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        doc.localFileSize!,
                                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFE16D5A)),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFE16D5A),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        elevation: 0,
                                      ),
                                      icon: const Icon(Icons.open_in_new, size: 16),
                                      label: const Text(
                                        'Open PDF (फाइल देखें)',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () => WhatsAppLauncher.openUrl(doc.pdfUrl!),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(0xFFE16D5A),
                                        side: const BorderSide(color: Color(0xFFE16D5A)),
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      icon: const Icon(Icons.download, size: 16),
                                      label: const Text(
                                        'Download (डाउनलोड)',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        LocalFilePicker.download(
                                          url: doc.pdfUrl!,
                                          filename: doc.localFileName ?? '${doc.title}.pdf',
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                      Builder(
                        builder: (ctx) {
                          final matchingVideo = VideoLibraryData.getByRelatedPdfId(doc.id);
                          if (matchingVideo == null) return const SizedBox.shrink();

                          return Column(
                            children: [
                              const SizedBox(height: 14),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => VideoPlayerScreen(lecture: matchingVideo),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF0000).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFFF0000).withValues(alpha: 0.3)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.play_circle_fill, color: Color(0xFFFF0000), size: 26),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Watch YouTube Class for this Subject (वीडियो देखें)',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w900,
                                                color: isDark ? const Color(0xFFFF8080) : const Color(0xFF990000),
                                              ),
                                            ),
                                            Text(
                                              '${matchingVideo.channel} • ${matchingVideo.duration}',
                                              style: TextStyle(
                                                fontSize: 10.5,
                                                color: isDark ? Colors.white70 : Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFFFF0000)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Render current section content
                _buildSection(doc.sections[selectedSection], textColor, subTextColor, cardColor, bgColor, isDark),

                const SizedBox(height: 40),

                // Section Navigation Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (selectedSection > 0)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cardColor,
                          foregroundColor: textColor,
                          elevation: 0,
                        ),
                        onPressed: () => setState(() => selectedSection--),
                        icon: const Icon(Icons.arrow_back),
                        label: Text(isHindi ? 'पिछला भाग' : 'Previous Part'),
                      )
                    else
                      const SizedBox.shrink(),
                    if (selectedSection < doc.sections.length - 1)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1769AA),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => setState(() => selectedSection++),
                        icon: const Icon(Icons.arrow_forward),
                        label: Text(isHindi ? 'अगला भाग' : 'Next Part'),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF269C70).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Color(0xFF269C70), size: 18),
                            const SizedBox(width: 6),
                            Text(
                              isHindi ? 'अध्याय पूर्ण हुआ' : 'End of Document',
                              style: const TextStyle(
                                color: Color(0xFF269C70),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    StudySection section,
    Color textColor,
    Color subTextColor,
    Color cardColor,
    Color bgColor,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Text(
          section.title,
          style: TextStyle(
            fontSize: fontSize + 4,
            fontWeight: FontWeight.w900,
            color: textColor,
          ),
        ),
        if (section.subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            section.subtitle!,
            style: TextStyle(
              fontSize: fontSize - 1,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1769AA),
            ),
          ),
        ],
        const SizedBox(height: 16),

        // Section Paragraphs
        for (final p in section.paragraphs) ...[
          Text(
            p,
            style: TextStyle(
              fontSize: fontSize,
              height: 1.6,
              color: textColor,
            ),
          ),
          const SizedBox(height: 14),
        ],

        // Key Points / Formulas / Rules Box
        if (section.keyPoints != null && section.keyPoints!.isNotEmpty) ...[
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border(
                left: BorderSide(
                  color: const Color(0xFF1769AA),
                  width: 4,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, color: Color(0xFFE6A62C), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      widget.document.language == 'Hindi'
                          ? 'मुख्य बिन्दु, सूत्र एवं परीक्षा ट्रिक्स'
                          : 'Key Rules, Formulas & High-Yield Tips',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                for (final point in section.keyPoints!)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• ', style: TextStyle(color: const Color(0xFF1769AA), fontSize: fontSize, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(
                            point,
                            style: TextStyle(
                              fontSize: fontSize - 0.5,
                              color: textColor,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],

        // Practice Questions (MCQs)
        if (section.questions != null && section.questions!.isNotEmpty) ...[
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.quiz_outlined, color: Color(0xFF269C70), size: 22),
              const SizedBox(width: 8),
              Text(
                widget.document.language == 'Hindi'
                    ? 'अभ्यास प्रश्न एवं विस्तृत हल (MCQs)'
                    : 'Practice Questions & Solutions (MCQs)',
                style: TextStyle(
                  fontSize: fontSize + 1,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < section.questions!.length; i++)
            _buildMCQCard(section.questions![i], i + 1, textColor, subTextColor, cardColor, bgColor),
        ],
      ],
    );
  }

  Widget _buildMCQCard(
    StudyMCQ mcq,
    int qNum,
    Color textColor,
    Color subTextColor,
    Color cardColor,
    Color bgColor,
  ) {
    final qKey = '${widget.document.id}_${selectedSection}_$qNum';
    final userAns = selectedAnswers[qKey];
    final isExplShown = showExplanations[qKey] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Q$qNum. ${mcq.question}',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: textColor,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          for (int optIdx = 0; optIdx < mcq.options.length; optIdx++) ...[
            InkWell(
              onTap: () {
                setState(() {
                  selectedAnswers[qKey] = optIdx;
                  showExplanations[qKey] = true;
                });
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: userAns == null
                      ? bgColor
                      : optIdx == mcq.correctIndex
                          ? const Color(0xFF269C70).withValues(alpha: 0.15)
                          : userAns == optIdx
                              ? const Color(0xFFE16D5A).withValues(alpha: 0.15)
                              : bgColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: userAns == null
                        ? Colors.black12
                        : optIdx == mcq.correctIndex
                            ? const Color(0xFF269C70)
                            : userAns == optIdx
                                ? const Color(0xFFE16D5A)
                                : Colors.black12,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: userAns == null
                          ? Colors.grey.shade300
                          : optIdx == mcq.correctIndex
                              ? const Color(0xFF269C70)
                              : userAns == optIdx
                                  ? const Color(0xFFE16D5A)
                                  : Colors.grey.shade300,
                      child: Text(
                        String.fromCharCode(65 + optIdx),
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        mcq.options[optIdx],
                        style: TextStyle(
                          fontSize: fontSize - 1,
                          color: textColor,
                          fontWeight: userAns != null && optIdx == mcq.correctIndex
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (userAns != null && optIdx == mcq.correctIndex)
                      const Icon(Icons.check_circle, color: Color(0xFF269C70), size: 18)
                    else if (userAns == optIdx)
                      const Icon(Icons.cancel, color: Color(0xFFE16D5A), size: 18),
                  ],
                ),
              ),
            ),
          ],
          if (isExplShown) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF269C70).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF269C70).withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.document.language == 'Hindi' ? 'व्याख्या (Explanation):' : 'Explanation:',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF269C70),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mcq.explanation,
                    style: TextStyle(
                      fontSize: fontSize - 1.5,
                      color: textColor,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            TextButton.icon(
              onPressed: () => setState(() => showExplanations[qKey] = true),
              icon: const Icon(Icons.visibility_outlined, size: 16),
              label: Text(widget.document.language == 'Hindi' ? 'उत्तर व व्याख्या देखें' : 'Show Answer & Explanation'),
            ),
          ],
        ],
      ),
    );
  }
}
