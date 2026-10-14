class QuizQuestion {
  final String id;
  final String subject;
  final String questionHindi;
  final String questionEnglish;
  final List<String> optionsHindi;
  final List<String> optionsEnglish;
  final int correctAnswerIndex;
  final String explanationHindi;
  final String explanationEnglish;

  QuizQuestion({
    required this.id,
    required this.subject,
    required this.questionHindi,
    required this.questionEnglish,
    required this.optionsHindi,
    required this.optionsEnglish,
    required this.correctAnswerIndex,
    required this.explanationHindi,
    required this.explanationEnglish,
  });
}

class HallRanker {
  final int rank;
  final String name;
  final int seatNo;
  final int score;
  final String timeTaken;
  final String exam;

  HallRanker({
    required this.rank,
    required this.name,
    required this.seatNo,
    required this.score,
    required this.timeTaken,
    required this.exam,
  });
}

class QuizRepository {
  static const String quizDate = '14 October 2026';
  static const String quizTitle = 'Krishna Library Daily 10-Min Booster (GK, Maths, Polity & Vyakaran)';
  static const int durationMinutes = 10;

  static int? lastScore;
  static String? lastTimeTaken;
  static bool hasAttemptedToday = false;

  static final List<QuizQuestion> questions = [
    // 1. Polity
    QuizQuestion(
      id: 'Q-01',
      subject: 'Polity & Constitution',
      questionHindi: 'भारतीय संविधान का कौन सा अनुच्छेद "समानता का अधिकार" (Right to Equality) प्रदान करता है?',
      questionEnglish: 'Which Article of the Indian Constitution provides the "Right to Equality"?',
      optionsHindi: ['अनुच्छेद 14 से 18', 'अनुच्छेद 19 से 22', 'अनुच्छेद 23 से 24', 'अनुच्छेद 25 से 28'],
      optionsEnglish: ['Articles 14 to 18', 'Articles 19 to 22', 'Articles 23 to 24', 'Articles 25 to 28'],
      correctAnswerIndex: 0,
      explanationHindi: 'संविधान के भाग III में अनुच्छेद 14 से 18 तक समानता के अधिकार का उल्लेख है। अनुच्छेद 14 कानून के समक्ष समानता की गारंटी देता है।',
      explanationEnglish: 'Part III of the Constitution covers Right to Equality in Articles 14 to 18. Article 14 guarantees equality before law.',
    ),

    // 2. Maths
    QuizQuestion(
      id: 'Q-02',
      subject: 'Quantitative Aptitude',
      questionHindi: 'साधारण ब्याज पर कोई मूलधन 5 वर्षों में दोगुना हो जाता है, तो ब्याज की वार्षिक दर क्या होगी?',
      questionEnglish: 'A sum of money doubles itself in 5 years at simple interest. What is the annual rate of interest?',
      optionsHindi: ['15%', '20%', '25%', '10%'],
      optionsEnglish: ['15%', '20%', '25%', '10%'],
      correctAnswerIndex: 1,
      explanationHindi: 'SI = P. इसलिए R = (SI × 100) / (P × T) = (P × 100) / (P × 5) = 20% प्रति वर्ष।',
      explanationEnglish: 'Simple Interest = P. Hence Rate R = (P × 100) / (P × 5) = 20% per annum.',
    ),

    // 3. Current Affairs & Science
    QuizQuestion(
      id: 'Q-03',
      subject: 'Science & Tech',
      questionHindi: 'इसरो (ISRO) के ऐतिहासिक चंद्रयान-3 मिशन को किस रॉकेट/प्रक्षेपण यान से लॉन्च किया गया था?',
      questionEnglish: 'Which launch vehicle was used by ISRO for the historic Chandrayaan-3 mission?',
      optionsHindi: ['PSLV-C52', 'GSLV-F10', 'LVM3-M4 (बाहुबली)', 'SSLV-D2'],
      optionsEnglish: ['PSLV-C52', 'GSLV-F10', 'LVM3-M4 (Bahubali)', 'SSLV-D2'],
      correctAnswerIndex: 2,
      explanationHindi: 'चंद्रयान-3 को 14 जुलाई 2023 को श्रीहरिकोटा से LVM3-M4 रॉकेट (Fat Boy/बाहुबली) द्वारा सफलतापूर्वक प्रक्षेपित किया गया था।',
      explanationEnglish: 'Chandrayaan-3 was successfully launched on 14 July 2023 from Sriharikota via the LVM3-M4 rocket.',
    ),

    // 4. Geography
    QuizQuestion(
      id: 'Q-04',
      subject: 'Indian Geography',
      questionHindi: 'कर्क रेखा (Tropic of Cancer - 23.5° N) भारत के कितने राज्यों से होकर गुजरती है?',
      questionEnglish: 'Through how many Indian states does the Tropic of Cancer pass?',
      optionsHindi: ['6 राज्य', '7 राज्य', '8 राज्य', '9 राज्य'],
      optionsEnglish: ['6 States', '7 States', '8 States', '9 States'],
      correctAnswerIndex: 2,
      explanationHindi: 'कर्क रेखा 8 राज्यों से गुजरती है: गुजरात, राजस्थान, मध्य प्रदेश, छत्तीसगढ़, झारखंड, पश्चिम बंगाल, त्रिपुरा और मिजोरम।',
      explanationEnglish: 'The Tropic of Cancer passes through 8 states: Gujarat, Rajasthan, MP, Chhattisgarh, Jharkhand, West Bengal, Tripura, and Mizoram.',
    ),

    // 5. History
    QuizQuestion(
      id: 'Q-05',
      subject: 'Modern History',
      questionHindi: 'महात्मा गांधी जी द्वारा प्रसिद्ध "दांडी मार्च" (नमक सत्याग्रह) किस वर्ष शुरू किया गया था?',
      questionEnglish: 'In which year was the famous "Dandi March" (Salt Satyagraha) initiated by Mahatma Gandhi?',
      optionsHindi: ['1928 ई.', '1930 ई.', '1932 ई.', '1942 ई.'],
      optionsEnglish: ['1928', '1930', '1932', '1942'],
      correctAnswerIndex: 1,
      explanationHindi: 'दांडी मार्च 12 मार्च 1930 को साबरमती आश्रम से शुरू होकर 6 अप्रैल 1930 को दांडी में नमक कानून तोड़कर समाप्त हुआ।',
      explanationEnglish: 'Dandi March began on 12 March 1930 from Sabarmati Ashram and ended on 6 April 1930 breaking the Salt Law.',
    ),

    // 6. Reasoning
    QuizQuestion(
      id: 'Q-06',
      subject: 'Reasoning Ability',
      questionHindi: 'दी गई संख्या श्रृंखला में लुप्त पद ज्ञात कीजिए: 2, 6, 12, 20, 30, ?',
      questionEnglish: 'Find the missing number in the given series: 2, 6, 12, 20, 30, ?',
      optionsHindi: ['36', '40', '42', '44'],
      optionsEnglish: ['36', '40', '42', '44'],
      correctAnswerIndex: 2,
      explanationHindi: 'पैटर्न: n(n+1) -> 1×2=2, 2×3=6, 3×4=12, 4×5=20, 5×6=30, अगला 6×7 = 42 होगा।',
      explanationEnglish: 'Pattern: n(n+1) -> 1×2=2, 2×3=6, 3×4=12, 4×5=20, 5×6=30, next is 6×7 = 42.',
    ),

    // 7. Hindi Vyakaran
    QuizQuestion(
      id: 'Q-07',
      subject: 'हिन्दी व्याकरण',
      questionHindi: '"सूर्योदय" शब्द का सही संधि-विच्छेद और संधि का प्रकार क्या है?',
      questionEnglish: 'What is the correct Sandhi-Vichhed for the Hindi word "Suryoday"?',
      optionsHindi: [
        'सूर्य + उदय (गुण स्वर संधि)',
        'सूर्यो + दय (दीर्घ संधि)',
        'सूर्य + दय (वृद्धि संधि)',
        'सूरि + उदय (यण संधि)'
      ],
      optionsEnglish: [
        'Surya + Uday (Gun Sandhi)',
        'Suryo + Day (Dirgh Sandhi)',
        'Surya + Day (Vriddhi Sandhi)',
        'Suri + Uday (Yan Sandhi)'
      ],
      correctAnswerIndex: 0,
      explanationHindi: 'सूर्य + उदय = सूर्योदय। अ/आ के बाद उ/ऊ आने पर "ओ" बन जाता है, इसे गुण स्वर संधि कहते हैं।',
      explanationEnglish: 'Surya + Uday = Suryoday. When a/aa is followed by u/oo, it turns into "o" (Gun Sandhi).',
    ),

    // 8. General Knowledge
    QuizQuestion(
      id: 'Q-08',
      subject: 'General Knowledge',
      questionHindi: 'भारत में "संविधान दिवस" (Constitution Day) प्रतिवर्ष किस तिथि को मनाया जाता है?',
      questionEnglish: 'On which date is "Constitution Day" celebrated every year in India?',
      optionsHindi: ['15 अगस्त', '26 जनवरी', '26 नवंबर', '2 अक्टूबर'],
      optionsEnglish: ['15 August', '26 January', '26 November', '2 October'],
      correctAnswerIndex: 2,
      explanationHindi: '26 नवंबर 1949 को भारत की संविधान सभा द्वारा संविधान को विधिवत अंगीकृत किया गया था, इसलिए हर वर्ष 26 नवंबर को संविधान दिवस मनाया जाता है।',
      explanationEnglish: 'On 26 November 1949, the Constituent Assembly adopted the Indian Constitution, hence celebrated as Constitution Day.',
    ),

    // 9. Computer Knowledge
    QuizQuestion(
      id: 'Q-09',
      subject: 'Computer Knowledge',
      questionHindi: 'विंडोज (Windows OS) में किसी फाइल को रीसायकल बिन में भेजे बिना स्थायी रूप से हटाने की शॉर्टकट की क्या है?',
      questionEnglish: 'In Windows OS, what is the shortcut key to permanently delete a file without moving it to Recycle Bin?',
      optionsHindi: ['Delete', 'Ctrl + Delete', 'Shift + Delete', 'Alt + Delete'],
      optionsEnglish: ['Delete', 'Ctrl + Delete', 'Shift + Delete', 'Alt + Delete'],
      correctAnswerIndex: 2,
      explanationHindi: 'Shift + Delete दबाने पर फाइल सीधे स्थायी रूप से हट जाती है और रीसायकल बिन में नहीं जाती।',
      explanationEnglish: 'Shift + Delete permanently deletes the selected item without sending it to the Recycle Bin.',
    ),

    // 10. Economics
    QuizQuestion(
      id: 'Q-10',
      subject: 'Indian Economy',
      questionHindi: 'भारतीय संसद में केंद्रीय आम बजट (Union Budget) किसके द्वारा प्रस्तुत किया जाता है?',
      questionEnglish: 'Who presents the Union Budget in the Indian Parliament?',
      optionsHindi: ['प्रधानमंत्री', 'वित्त मंत्री', 'आरबीआई गवर्नर', 'राष्ट्रपति'],
      optionsEnglish: ['Prime Minister', 'Finance Minister', 'RBI Governor', 'President'],
      correctAnswerIndex: 1,
      explanationHindi: 'संविधान के अनुच्छेद 112 (वार्षिक वित्तीय विवरण) के तहत भारत के केंद्रीय वित्त मंत्री द्वारा बजट पेश किया जाता है।',
      explanationEnglish: 'Under Article 112 (Annual Financial Statement), the Union Budget is presented by the Finance Minister.',
    ),
  ];

  static final List<HallRanker> leaderboard = [
    HallRanker(
      rank: 1,
      name: 'Aarav Sharma',
      seatNo: 12,
      score: 10,
      timeTaken: '04m 15s',
      exam: 'SSC CGL 2025',
    ),
    HallRanker(
      rank: 2,
      name: 'Vikram Singh',
      seatNo: 2,
      score: 10,
      timeTaken: '05m 02s',
      exam: 'UPSC CSE 2026',
    ),
    HallRanker(
      rank: 3,
      name: 'Priya Verma',
      seatNo: 4,
      score: 9,
      timeTaken: '04m 48s',
      exam: 'Banking PO',
    ),
    HallRanker(
      rank: 4,
      name: 'Sneha Sharma',
      seatNo: 18,
      score: 9,
      timeTaken: '06m 12s',
      exam: 'SSC CHSL 2025',
    ),
    HallRanker(
      rank: 5,
      name: 'Rahul Yadav',
      seatNo: 6,
      score: 8,
      timeTaken: '05m 30s',
      exam: 'Railway NTPC',
    ),
    HallRanker(
      rank: 6,
      name: 'Rohan Gupta',
      seatNo: 25,
      score: 8,
      timeTaken: '07m 10s',
      exam: 'State PCS 2025',
    ),
    HallRanker(
      rank: 7,
      name: 'Neha Rani',
      seatNo: 8,
      score: 7,
      timeTaken: '06m 45s',
      exam: 'Delhi Police SI',
    ),
  ];

  static void recordAttempt({required int score, required String timeTaken}) {
    lastScore = score;
    lastTimeTaken = timeTaken;
    hasAttemptedToday = true;

    // Update Aarav's rank entry or insert
    final existingIdx = leaderboard.indexWhere((r) => r.name.contains('Aarav'));
    if (existingIdx != -1) {
      leaderboard[existingIdx] = HallRanker(
        rank: existingIdx + 1,
        name: 'Aarav Sharma (You)',
        seatNo: 12,
        score: score,
        timeTaken: timeTaken,
        exam: 'SSC CGL 2025',
      );
    }
  }
}
