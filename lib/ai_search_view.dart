import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ai_search_service.dart';
import 'whatsapp_url_helper.dart';

const blue = Color(0xFF1769AA);
const navy = Color(0xFF102A43);
const green = Color(0xFF269C70);
const red = Color(0xFFE16D5A);
const amber = Color(0xFFE6A62C);
const purple = Color(0xFF6D5DD3);
const gold = Color(0xFFD4AF37);

/// Opens the Krishna AI Study Guru Hindi Chat & Search Modal Sheet
void showKrishnaAiSearchSheet(BuildContext context, {String? initialQuery}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => _KrishnaAiChatModal(initialQuery: initialQuery),
  );
}

/// Home Screen Glowing AI Search Bar Widget
class KrishnaAiSearchBar extends StatelessWidget {
  final VoidCallback onTap;

  const KrishnaAiSearchBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6D5DD3), Color(0xFF1769AA), Color(0xFF269C70)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: purple.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(2), // Border gradient effect
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: purple.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome, color: purple, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'कृष्णा AI गुरु से हिन्दी में पूछें',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: navy),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Gemini Flash ⚡',
                          style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: purple),
                        ),
                      ],
                    ),
                    SizedBox(height: 1),
                    Text(
                      'हिन्दी में बात करें: गणित, इतिहास, संविधान, फोकस या कोई भी डाउट...',
                      style: TextStyle(fontSize: 11, color: Colors.blueGrey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.chat, size: 13, color: purple),
                    SizedBox(width: 4),
                    Text('बातचीत', style: TextStyle(color: purple, fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KrishnaAiChatModal extends StatefulWidget {
  final String? initialQuery;

  const _KrishnaAiChatModal({this.initialQuery});

  @override
  State<_KrishnaAiChatModal> createState() => _KrishnaAiChatModalState();
}

class _KrishnaAiChatModalState extends State<_KrishnaAiChatModal> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String _selectedLanguage = 'hi'; // 'hi' by default

  final List<String> _quickHindiPrompts = [
    '🙏 नमस्ते गुरुजी! आज का स्टडी प्लान क्या हो?',
    '🧠 पढ़ाई में 100% फोकस कैसे लगाएं?',
    '📜 मौलिक अधिकार (Articles 14-32) सरल हिन्दी में समझाओ',
    '🔢 प्रतिशत (Percentage) निकालने की आसान ट्रिक',
    '📅 8-घंटे का आदर्श स्टडी टाइम-टेबल',
    '⚔️ 1857 की क्रांति के मुख्य कारण क्या थे?',
    '🏛️ कृष्णा लाइब्रेरी की फीस व सुविधाएं बताओ',
  ];

  @override
  void initState() {
    super.initState();
    _selectedLanguage = AiSearchService.currentLanguage;

    // Initial greeting from Krishna AI Guru in Hindi
    _messages.add(
      ChatMessage(
        text: '''🙏 **नमस्ते प्रिय विद्यार्थी!**
मैं आपका **कृष्णा AI स्टडी गुरु** हूँ — कृष्णा लाइब्रेरी (हिसार) का आपका व्यक्तिगत मार्गदर्शक।

आप मुझसे अपनी प्रतियोगी परीक्षा (UPSC, SSC, Banking, State PCS, Railway), किसी भी विषय (गणित, इतिहास, संविधान, विज्ञान) या पढ़ाई में फोकस व मन लगाने को लेकर **शुद्ध व सरल हिन्दी में कुछ भी पूछ सकते हैं**।

आज आप किस विषय पर बात करना चाहते हैं? नीचे दिए गए सुझावों पर टैप करें या अपना सवाल टाइप करें! 😊''',
        isUser: false,
        source: 'कृष्णा AI स्टडी गुरु ⚡',
      ),
    );

    if (widget.initialQuery != null && widget.initialQuery!.trim().isNotEmpty) {
      _sendMessage(widget.initialQuery!.trim());
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String query) async {
    final text = query.trim();
    if (text.isEmpty) return;

    _textController.clear();

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });
    _scrollToBottom();

    final res = await AiSearchService.ask(text, language: _selectedLanguage);

    if (mounted) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: res.answer,
            isUser: false,
            source: res.source,
          ),
        );
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _openSettingsDialog() {
    final keyController = TextEditingController(text: AiSearchService.customApiKey);
    String selectedModel = AiSearchService.selectedModel;
    bool isTesting = false;
    String? statusMsg;
    Color statusColor = Colors.blueGrey;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: purple.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.vpn_key, color: purple, size: 20),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gemini Flash API Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: navy)),
                    Text('Google AI Studio Connection', style: TextStyle(fontSize: 11, color: Colors.blueGrey)),
                  ],
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'लाइव इंटरनेट आधारित गूगल जेमिनी फ्लैश से हिन्दी में बातचीत के लिए अपनी फ्री API Key यहाँ जोड़ें:',
                  style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.3),
                ),
                const SizedBox(height: 12),

                // Model Selection
                const Text('AI मॉडल चुनें:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: navy)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedModel,
                      items: AiSearchService.availableModels
                          .map(
                            (m) => DropdownMenuItem(
                              value: m,
                              child: Text(
                                '$m ⚡',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: navy),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => selectedModel = val);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // API Key Field
                const Text('Google Gemini API Key:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: navy)),
                const SizedBox(height: 4),
                TextField(
                  controller: keyController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Paste AIzaSy... key here',
                    hintStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.paste, size: 18),
                      onPressed: () async {
                        final data = await Clipboard.getData('text/plain');
                        if (data?.text != null) {
                          keyController.text = data!.text!.trim();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // How to get key note
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('💡 फ्री API Key पाने का तरीका (30 सेकंड):', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: navy)),
                      SizedBox(height: 2),
                      Text('1. ब्राउज़र में खोलें: aistudio.google.com/app/apikey', style: TextStyle(fontSize: 10, color: Colors.blueGrey)),
                      Text('2. Google से लॉगिन करें और "Create API Key" दबाएं।', style: TextStyle(fontSize: 10, color: Colors.blueGrey)),
                      Text('3. की (Key) कॉपी करके यहाँ पेस्ट करें। बिल्कुल मुफ्त!', style: TextStyle(fontSize: 10, color: Colors.blueGrey)),
                    ],
                  ),
                ),

                if (statusMsg != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(statusColor == green ? Icons.check_circle : Icons.info, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          statusMsg!,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                AiSearchService.setApiKey('');
                setState(() {});
                Navigator.pop(ctx);
              },
              child: const Text('Clear Key', style: TextStyle(color: red)),
            ),
            OutlinedButton(
              onPressed: isTesting
                  ? null
                  : () async {
                      final key = keyController.text.trim();
                      if (key.isEmpty) {
                        setDialogState(() {
                          statusMsg = 'कृपया पहले अपनी Key पेस्ट करें';
                          statusColor = red;
                        });
                        return;
                      }
                      setDialogState(() {
                        isTesting = true;
                        statusMsg = 'गूगल जेमिनी से कनेक्ट कर रहे हैं...';
                        statusColor = blue;
                      });

                      final ok = await AiSearchService.testApiKey(key);
                      setDialogState(() {
                        isTesting = false;
                        if (ok) {
                          statusMsg = 'सफल! Gemini Flash API कनेक्ट हो गया ✓';
                          statusColor = green;
                        } else {
                          statusMsg = 'कनेक्शन असफल। Google AI Studio (aistudio.google.com) से AIzaSy... वाली Key लें।';
                          statusColor = red;
                        }
                      });
                    },
              child: isTesting
                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Test Connection'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: navy, foregroundColor: Colors.white),
              onPressed: () {
                final key = keyController.text.trim();
                AiSearchService.setApiKey(key);
                AiSearchService.setModel(selectedModel);
                setState(() {});
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      key.isNotEmpty
                          ? 'Gemini Flash API ($selectedModel) सफलतापूर्वक सेट हो गया!'
                          : 'कृष्णा इन-बिल्ट हिन्दी स्टडी इंजन सक्रिय है।',
                    ),
                    backgroundColor: green,
                  ),
                );
              },
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }

  void _shareToWhatsApp(String text) {
    final msg = '''📖 *KRISHNA AI STUDY GURU - हिन्दी में बातचीत*
━━━━━━━━━━━━━━━━━━━━━━━
$text
━━━━━━━━━━━━━━━━━━━━━━━
📍 *Krishna Library & Study Lounge, Hisar*
📞 *Director Kamal:* +91 98123 45678''';

    WhatsAppLauncher.openChat(phone: '+91 98123 45678', message: msg);
  }

  void _copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('उत्तर कॉपी हो गया!'),
        backgroundColor: navy,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.94,
      child: Column(
        children: [
          // Header Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [purple, blue]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'कृष्णा AI गुरु (हिन्दी में बातचीत)',
                            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w900, color: navy),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: AiSearchService.hasCustomKey ? green : purple.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              AiSearchService.hasCustomKey ? 'LIVE GEMINI ⚡' : 'हिन्दी AI ⚡',
                              style: TextStyle(
                                color: AiSearchService.hasCustomKey ? Colors.white : purple,
                                fontSize: 8.5,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        AiSearchService.hasCustomKey
                            ? 'Google ${AiSearchService.selectedModel} (सक्रिय)'
                            : 'हिन्दी स्टडी गुरु • 24x7 परीक्षा व पढ़ाई सहायता',
                        style: const TextStyle(fontSize: 10.5, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),

                // Language Mode Selector Chip
                InkWell(
                  onTap: () {
                    setState(() {
                      if (_selectedLanguage == 'hi') {
                        _selectedLanguage = 'hinglish';
                      } else if (_selectedLanguage == 'hinglish') {
                        _selectedLanguage = 'en';
                      } else {
                        _selectedLanguage = 'hi';
                      }
                      AiSearchService.setLanguage(_selectedLanguage);
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: purple.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _selectedLanguage == 'hi'
                              ? '🇮🇳 हिन्दी'
                              : _selectedLanguage == 'hinglish'
                                  ? '🔤 Hinglish'
                                  : '🇬🇧 English',
                          style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: navy),
                        ),
                        const SizedBox(width: 2),
                        const Icon(Icons.arrow_drop_down, size: 14, color: navy),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 4),

                IconButton(
                  tooltip: 'Gemini API Settings',
                  icon: Icon(
                    Icons.settings_suggest,
                    color: AiSearchService.hasCustomKey ? green : navy,
                  ),
                  onPressed: _openSettingsDialog,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Quick Hindi Prompts Slider
          Container(
            color: const Color(0xFFF8FAFC),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              height: 34,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _quickHindiPrompts.length,
                separatorBuilder: (_, i) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  final prompt = _quickHindiPrompts[i];
                  return InkWell(
                    onTap: () => _sendMessage(prompt),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        prompt,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: navy),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const Divider(height: 1),

          // Chat Messages Thread
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              itemCount: _messages.length,
              itemBuilder: (ctx, idx) {
                final msg = _messages[idx];
                return _buildMessageBubble(msg);
              },
            ),
          ),

          // Typing Indicator
          if (_isLoading)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: purple.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2, color: purple),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'कृष्णा AI गुरु हिन्दी में उत्तर तैयार कर रहे हैं...',
                    style: TextStyle(fontSize: 11.5, color: Colors.blueGrey, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),

          // Chat Input Area
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.withValues(alpha: 0.15))),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, -2)),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: TextField(
                      controller: _textController,
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sendMessage,
                      decoration: const InputDecoration(
                        hintText: 'हिन्दी में पूछें (जैसे: 1857 की क्रांति, प्रतिशत ट्रिक)...',
                        hintStyle: TextStyle(fontSize: 12.5, color: Colors.blueGrey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                    elevation: 0,
                  ),
                  onPressed: _isLoading ? null : () => _sendMessage(_textController.text),
                  child: const Icon(Icons.send_rounded, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    if (msg.isUser) {
      // User Question Bubble (Right aligned)
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [navy, Color(0xFF2C3E50)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(4),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(color: navy.withValues(alpha: 0.15), blurRadius: 6, offset: const Offset(0, 2)),
                  ],
                ),
                child: Text(
                  msg.text,
                  style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.35),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 14,
              backgroundColor: Color(0xFFE2E8F0),
              child: Icon(Icons.person, size: 16, color: navy),
            ),
          ],
        ),
      );
    }

    // AI Guru Response Bubble (Left aligned)
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [purple, Color(0xFF1769AA)]),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: purple.withValues(alpha: 0.25), blurRadius: 6, offset: const Offset(0, 2)),
              ],
            ),
            child: const Center(
              child: Icon(Icons.school, size: 17, color: Color(0xFFF2B84B)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sender label & source
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'कृष्णा AI स्टडी गुरु',
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: navy),
                    ),
                    if (msg.source != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: purple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          msg.source!,
                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: purple),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),

                // Answer Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        msg.text,
                        style: const TextStyle(
                          fontSize: 12.8,
                          color: Color(0xFF1E293B),
                          height: 1.5,
                          fontFamily: 'sans-serif',
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(height: 1),
                      const SizedBox(height: 6),

                      // Action buttons on message
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () => _copyText(msg.text),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              child: Row(
                                children: [
                                  Icon(Icons.copy, size: 13, color: Colors.blueGrey),
                                  SizedBox(width: 4),
                                  Text('कॉपी करें', style: TextStyle(fontSize: 10.5, color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: () => _shareToWhatsApp(msg.text),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              child: Row(
                                children: [
                                  Icon(Icons.chat, size: 13, color: Color(0xFF25D366)),
                                  SizedBox(width: 4),
                                  Text('व्हाट्सएप पर भेजें', style: TextStyle(fontSize: 10.5, color: Color(0xFF25D366), fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
