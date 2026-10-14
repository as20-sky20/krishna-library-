class YouTubeVideoLecture {
  final String id;
  final String youtubeVideoId;
  final String title;
  final String channel;
  final String channelAvatar;
  final String category;
  final String duration;
  final String views;
  final String language;
  final String description;
  final List<String> keyTimestamps;
  final List<String> revisionNotes;
  final String? relatedPdfId;

  const YouTubeVideoLecture({
    required this.id,
    required this.youtubeVideoId,
    required this.title,
    required this.channel,
    required this.channelAvatar,
    required this.category,
    required this.duration,
    required this.views,
    required this.language,
    required this.description,
    required this.keyTimestamps,
    required this.revisionNotes,
    this.relatedPdfId,
  });

  String get thumbnailUrl =>
      'https://img.youtube.com/vi/$youtubeVideoId/hqdefault.jpg';

  String get watchUrl =>
      'https://www.youtube.com/watch?v=$youtubeVideoId';

  String get embedUrl =>
      'https://www.youtube-nocookie.com/embed/$youtubeVideoId?rel=0&modestbranding=1&controls=1';
}

class VideoLibraryData {
  static const List<YouTubeVideoLecture> lectures = [
    // 1. Indian Polity & Constitution - Khan GS Research Centre
    YouTubeVideoLecture(
      id: 'vid-polity-01',
      youtubeVideoId: '_CfahRz8vvw',
      title: 'राज्य पुनर्गठन आयोग | Article 1 to 4 | Part 1 of Constitution | Khan Sir',
      channel: 'Khan GS Research Centre',
      channelAvatar: '🏛️',
      category: 'Polity & GS',
      duration: '42 min',
      views: '6.4M views',
      language: 'Hindi',
      description: 'खान सर द्वारा भारतीय संविधान के भाग-1 (अनुच्छेद 1 से 4), राज्यों का पुनर्गठन (फजल अली आयोग, जेवीपी समिति) और राज्य निर्माण की प्रक्रिया की पूरी व्याख्या।',
      keyTimestamps: [
        '00:00 - संविधान के भाग 1 की प्रस्तावना',
        '08:30 - अनुच्छेद 1: भारत राज्यों का संघ (Union of States)',
        '18:45 - अनुच्छेद 2: नए राज्यों का प्रवेश एवं स्थापना',
        '28:00 - अनुच्छेद 3: राज्यों के नाम, सीमा एवं क्षेत्र में परिवर्तन',
        '36:10 - फजल अली आयोग एवं 1956 का राज्य पुनर्गठन अधिनियम',
      ],
      revisionNotes: [
        'अनुच्छेद 1 स्पष्ट करता है कि "भारत अर्थात इंडिया, राज्यों का संघ होगा"।',
        'संसद साधारण बहुमत (Simple Majority) से किसी राज्य का नाम, क्षेत्र या सीमा बदल सकती है।',
        'भाषा के आधार पर बनने वाला पहला राज्य आंध्र प्रदेश (1953) था।',
        'फजल अली आयोग की सिफारिश पर 14 राज्य और 6 केंद्र शासित प्रदेश बने थे।',
      ],
      relatedPdfId: 'ssc-polity-hi',
    ),

    // 2. Quantitative Aptitude - Dear Sir
    YouTubeVideoLecture(
      id: 'vid-maths-01',
      youtubeVideoId: 'FqCW9rS1zi0',
      title: 'Multiplication Short Trick in Hindi | Maths Fast Calculation | Dear Sir',
      channel: 'Dear Sir',
      channelAvatar: '📐',
      category: 'Maths',
      duration: '18 min',
      views: '12M views',
      language: 'Hindi',
      description: 'SSC CGL, Banking और Railway के लिए कैलकुलेशन स्पीड 3x करने के वैदिक मैथ्स मल्टीप्लिकेशन शॉर्टकट। बड़ी संख्याओं का गुणा सेकंडों में हल करें।',
      keyTimestamps: [
        '00:00 - 2-Digit Multiplication Universal Cross Method',
        '05:20 - Numbers near 100 Multiplication (Base Trick)',
        '10:15 - Multiplying with 11, 99 and 999 Fast Trick',
        '14:30 - Exam Questions Application & Speed Practice',
      ],
      revisionNotes: [
        'Base 100 Method: 98 × 97 = (-2) × (-3) = 06, 98 - 3 = 95 -> Ans: 9506.',
        'Multiply by 11: 45 × 11 = 4 _ 5 -> (4+5=9) -> 495.',
        'Digital Sum technique eliminates wrong options within 3 seconds in exam hall.',
      ],
      relatedPdfId: 'maths-shortcuts-en',
    ),

    // 3. Current Affairs & Annual Yearbook - Utkarsh Classes
    YouTubeVideoLecture(
      id: 'vid-ca-01',
      youtubeVideoId: 'V2ksW2O6odw',
      title: 'Current Affairs Complete Revision | Kumar Gaurav Sir | Utkarsh Classes',
      channel: 'Utkarsh Classes',
      channelAvatar: '🌍',
      category: 'Current Affairs',
      duration: '3 hr 15 min',
      views: '5.2M views',
      language: 'Hindi',
      description: 'कुमार गौरव सर द्वारा सभी राष्ट्रीय एवं अंतर्राष्ट्रीय घटनाक्रम, G20, खेलकूद, पुरस्कार, नियुक्तियां और नई योजनाओं का सम्पूर्ण मैराथन रिवीजन।',
      keyTimestamps: [
        '00:00 - प्रमुख राष्ट्रीय एवं अंतर्राष्ट्रीय नियुक्तियां',
        '35:10 - भारत रत्न, पद्म पुरस्कार एवं खेल रत्न 2026',
        '01:15:00 - सैन्य अभ्यास (Malabar, Yudh Abhyas, Garuda)',
        '01:50:00 - बजट, आर्थिक सर्वेक्षण एवं नई सरकारी योजनाएं',
        '02:40:00 - Top 100 Most Important Current Affairs MCQs',
      ],
      revisionNotes: [
        'ISRO गगनयान और चंद्रयान मिशन के मुख्य वैज्ञानिक लक्ष्य।',
        'भारत की 2026 आर्थिक विकास दर 7.2% अनुमानित की गई है।',
        'नवीनतम ग्रैंड स्लैम विजेता और ICC रैंकिंग में भारत का प्रदर्शन।',
      ],
      relatedPdfId: 'current-affairs-2026-hi',
    ),

    // 4. Reasoning Ability - Piyush Varshney
    YouTubeVideoLecture(
      id: 'vid-reasoning-01',
      youtubeVideoId: 'rakKZFIe9EM',
      title: 'Syllogism in One Shot | Syllogism Reasoning 100-50 Rules | Piyush Sir',
      channel: 'Reasoning By Piyush Varshney',
      channelAvatar: '🧩',
      category: 'Reasoning',
      duration: '1 hr 10 min',
      views: '3.8M views',
      language: 'Hindi',
      description: 'बिना वेन आरेख (Venn Diagram) बनाए 100-50 नियम से न्याय निगमन (Syllogism) के सभी कठिन प्रश्न 10 सेकंड में हल करें।',
      keyTimestamps: [
        '00:00 - 100-50 Method Introduction',
        '15:20 - Positive Statements: All (100, 50), Some (50, 50)',
        '32:40 - Negative Statements: No (100, 100), Some Not (50, 100)',
        '48:15 - Either-Or Cases & Complementary Rules',
        '01:00:00 - Possibility Cases & PYQ Practice',
      ],
      revisionNotes: [
        'Positive + Positive = Positive Conclusion. Positive + Negative = Negative.',
        'Income >= Expenditure: 50 income wala conclusion me 100 nahi ho sakta.',
        'Either-Or: Dono conclusion false hon, elements same hon, ek positive aur ek negative ho.',
      ],
      relatedPdfId: 'reasoning-mastery-en',
    ),

    // 5. General Science Biology - Khan GS Research Centre
    YouTubeVideoLecture(
      id: 'vid-science-01',
      youtubeVideoId: 'XebUIVfQC3o',
      title: 'मानव कोशिका (Human Cell) Complete Biology | Khan GS Research Centre',
      channel: 'Khan GS Research Centre',
      channelAvatar: '🔬',
      category: 'General Science',
      duration: '48 min',
      views: '7.5M views',
      language: 'Hindi',
      description: 'कोशिका संरचना, माइटोकॉन्ड्रिया, केंद्रक, राइबोसोम, लाइसोसोम, पादप व जंतु कोशिका में अंतर - खान सर द्वारा सरल देसी अंदाज में समझें।',
      keyTimestamps: [
        '00:00 - कोशिका की खोज (रॉबर्ट हुक एवं ल्यूवेनहॉक)',
        '10:30 - कोशिका झिल्ली एवं कोशिका भित्ति में अंतर',
        '20:15 - माइटोकॉन्ड्रिया एवं ATP निर्माण (Powerhouse of Cell)',
        '32:00 - लाइसोसोम (आत्मघाती थैली / Suicidal Bag)',
        '41:20 - केंद्रक, DNA, RNA और क्रोमोसोम',
      ],
      revisionNotes: [
        'सर्वप्रथम जीवित कोशिका की खोज एंटोनी वॉन ल्यूवेनहॉक ने 1674 में की थी।',
        'माइटोकॉन्ड्रिया में क्रेब्स चक्र द्वारा ATP के रूप में ऊर्जा बनती है।',
        'लाइसोसोम में हाइड्रोलाइटिक एंजाइम होते हैं जो कोशिका को पचा लेते हैं।',
        'मानव शरीर में 23 जोड़े (46) गुणसूत्र पाए जाते हैं।',
      ],
      relatedPdfId: 'ssc-science-hi',
    ),

    // 6. English Grammar - Nimisha Bansal
    YouTubeVideoLecture(
      id: 'vid-english-01',
      youtubeVideoId: 'OBGS4We9Ybw',
      title: '120 RULES OF GRAMMAR | सम्पूर्ण English Grammar | Nimisha Bansal',
      channel: 'NIMISHA BANSAL',
      channelAvatar: '📖',
      category: 'English',
      duration: '4 hr 20 min',
      views: '9.8M views',
      language: 'Bilingual',
      description: 'SSC CGL, CHSL, Bank PO और सभी प्रतियोगी परीक्षाओं में एरर डिटेक्शन के 120 गोल्डन ग्रामर रूल्स का सम्पूर्ण मास्टरक्लास।',
      keyTimestamps: [
        '00:00 - Rule 1 to 15: Subject-Verb Agreement',
        '45:00 - Rule 16 to 35: Relative Pronouns (Who, Whom, Which, That)',
        '01:30:00 - Rule 36 to 60: Conditional Sentences',
        '02:25:00 - Rule 61 to 90: Preposition & Fixed Prepositions',
        '03:20:00 - Rule 91 to 120: Inversion & Subjunctive Mood',
      ],
      revisionNotes: [
        'Rule: "Each of / Either of / Neither of" takes Plural Noun + Singular Verb.',
        'Rule: "No sooner" takes "than", "Hardly / Scarcely" takes "when".',
        'Rule: "Lest" is always followed by "should" or bare infinitive.',
        'Rule: "As well as, with, along with, together with" verb agrees with FIRST subject.',
      ],
      relatedPdfId: 'english-vocab-en',
    ),

    // 7. Hindi Vyakaran - Vivek Sir (Examपुर)
    YouTubeVideoLecture(
      id: 'vid-hindi-01',
      youtubeVideoId: 'Qofgxs-XJog',
      title: 'सम्पूर्ण हिंदी व्याकरण मैराथन क्लास (संधि, समास, रस, छंद) | Vivek Sir Examपुर',
      channel: 'Examपुर',
      channelAvatar: '✍️',
      category: 'Hindi Vyakaran',
      duration: '3 hr 40 min',
      views: '4.6M views',
      language: 'Hindi',
      description: 'UP Police, SI, State CET, Teaching व अन्य परीक्षाओं हेतु हिंदी व्याकरण के नियम, स्वर संधि, व्यंजन संधि, समास और मुहावरों का संपूर्ण रिवीजन।',
      keyTimestamps: [
        '00:00 - वर्णमाला: स्वर, व्यंजन और उच्चारण स्थान',
        '42:10 - संधि के भेद: दीर्घ, गुण, वृद्धि, यण, अयादि',
        '01:25:00 - समास के 6 भेद एवं विग्रह करने की ट्रिक',
        '02:10:00 - तत्सम, तद्भव, देशज एवं विदेशज शब्द',
        '03:00:00 - रस, छंद और अलंकार के प्रमुख उदाहरण',
      ],
      revisionNotes: [
        'स्वर संधि के 5 भेद हैं: दीर्घ, गुण, वृद्धि, यण और अयादि।',
        'अव्ययीभाव समास में प्रथम पद अव्यय और प्रधान होता है (यथाशक्ति = शक्ति के अनुसार)।',
        'तत्सम शब्द संस्कृत के मूल शब्द होते हैं, तद्भव उनका परिवर्तित रूप है (अग्नि -> आग)।',
      ],
      relatedPdfId: 'hindi-vyakaran-hi',
    ),

    // 8. Indian Polity & Constitution PYQ - Drishti IAS
    YouTubeVideoLecture(
      id: 'vid-history-01',
      youtubeVideoId: 'KGrKn_Rsz5g',
      title: 'Indian Polity | Last 5 Years PYQ Analysis with Concepts | Drishti IAS',
      channel: 'Drishti IAS',
      channelAvatar: '🏛️',
      category: 'Polity & GS',
      duration: '2 hr 10 min',
      views: '3.1M views',
      language: 'Hindi',
      description: 'दृष्टि आईएएस द्वारा विगत 5 वर्षों के भारतीय राजव्यवस्था और संविधान के महत्वपूर्ण प्रश्नों का विस्तृत विश्लेषण और अवधारणात्मक समझ।',
      keyTimestamps: [
        '00:00 - प्रस्तावना एवं संवैधानिक ढांचा',
        '28:40 - मौलिक अधिकार एवं न्यायिक पुनरावलोकन (Article 13, 32)',
        '55:00 - कार्यपालिका एवं न्यायपालिका संबंध (कॉलेजियम व्यवस्था)',
        '01:25:00 - केंद्र-राज्य संबंध एवं अंतरराज्यीय परिषद',
        '01:50:00 - पंचायती राज एवं 73वां/74वां संविधान संशोधन',
      ],
      revisionNotes: [
        'केशवानंद भारती केस (1973) में सर्वोच्च न्यायालय ने मूल ढांचे का सिद्धांत (Basic Structure Doctrine) दिया।',
        'अनुच्छेद 21 में जीवन और व्यक्तिगत स्वतंत्रता का अधिकार शामिल है (Right to Privacy - पुट्टास्वामी केस)।',
        '73वें संविधान संशोधन (1992) द्वारा 11वीं अनुसूची और 29 विषय पंचायतों को सौंपे गए।',
      ],
      relatedPdfId: 'ssc-history-hi',
    ),
  ];

  static List<String> get categories => [
    'All Subjects',
    'Maths',
    'Reasoning',
    'Polity & GS',
    'Current Affairs',
    'General Science',
    'English',
    'Hindi Vyakaran',
  ];

  static List<YouTubeVideoLecture> getByCategory(String category) {
    if (category == 'All Subjects') return lectures;
    return lectures.where((v) => v.category == category).toList();
  }

  static YouTubeVideoLecture? getByRelatedPdfId(String pdfId) {
    try {
      return lectures.firstWhere((v) => v.relatedPdfId == pdfId);
    } catch (_) {
      return null;
    }
  }
}
