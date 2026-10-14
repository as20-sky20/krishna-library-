class StudySection {
  final String title;
  final String? subtitle;
  final List<String> paragraphs;
  final List<String>? keyPoints;
  final List<StudyMCQ>? questions;

  const StudySection({
    required this.title,
    this.subtitle,
    this.paragraphs = const [],
    this.keyPoints,
    this.questions,
  });
}

class StudyMCQ {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const StudyMCQ({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class StudyDocument {
  final String id;
  final String title;
  final String language; // 'English' or 'Hindi'
  final String category;
  final String readTime;
  final int pages;
  final String description;
  final List<StudySection> sections;

  const StudyDocument({
    required this.id,
    required this.title,
    required this.language,
    required this.category,
    required this.readTime,
    required this.pages,
    required this.description,
    required this.sections,
  });
}

class StudyRepository {
  static final List<StudyDocument> documents = [
    // ==========================================
    // 1. ENGLISH - SSC CGL 2025 Tier-1 Paper
    // ==========================================
    const StudyDocument(
      id: 'en_ssc_cgl_2025',
      title: 'SSC CGL 2025 Tier-1 Model Paper & Solutions',
      language: 'English',
      category: 'Exam Material',
      readTime: '25 min read',
      pages: 18,
      description: 'Comprehensive Tier-1 full-length model paper in English with authentic exam questions, short tricks, and step-by-step solutions.',
      sections: [
        StudySection(
          title: 'Section I: General Intelligence & Reasoning',
          subtitle: 'Tier-1 Pattern • 25 Questions • 50 Marks',
          paragraphs: [
            'Reasoning evaluates logical deduction, spatial visualization, and pattern recognition. Focus on letter shifts, syllogisms, and number sequences.',
          ],
          keyPoints: [
            'Letter Coding: A=1, B=2 ... Z=26. Reverse pairs sum to 27 (A-Z, B-Y, C-X, D-W, E-V, F-U, G-T, H-S, I-R, J-Q, K-P, L-O, M-N).',
            'Syllogism Rules: "All A are B" + "All B are C" => "All A are C". Complementary pair (Some + No) leads to "Either-Or" condition.',
            'Number Series: Always inspect prime gaps, differences of differences, and (n² ± k) patterns.',
            'Blood Relations: Use (+) for male, (-) for female, (=) for spouses, and (|) for generational descent.',
          ],
          questions: [
            StudyMCQ(
              question: 'In a certain code, "SYSTEM" is written as "SYSMET" and "NEARER" as "AENRER". How will "FRACTION" be written in that code?',
              options: ['CARFNOIT', 'CARFTION', 'ARFCNOIT', 'CRAFNOIT'],
              correctIndex: 0,
              explanation: 'The word is divided into two equal halves of 4 letters each: "FRAC" and "TION". Each half is reversed: "FRAC" becomes "CARF", and "TION" becomes "NOIT". Together it becomes "CARFNOIT".',
            ),
            StudyMCQ(
              question: 'Select the missing number in the sequence: 7, 11, 19, 31, 47, ?',
              options: ['65', '67', '69', '71'],
              correctIndex: 1,
              explanation: 'Check the difference sequence: 11 - 7 = 4, 19 - 11 = 8, 31 - 19 = 12, 47 - 31 = 16. The differences are multiples of 4 (+4, +8, +12, +16, +20). So next term = 47 + 20 = 67.',
            ),
            StudyMCQ(
              question: 'Statements: All pens are books. Some books are pencils.\nConclusions:\nI. Some pencils are pens.\nII. No pencil is pen.',
              options: ['Only I follows', 'Only II follows', 'Either I or II follows', 'Neither I nor II follows'],
              correctIndex: 2,
              explanation: 'Between "pencils" and "pens", no direct definite relationship exists. Since both conclusions form a complementary pair (Some + No) with same subjects and predicates, "Either I or II follows" is correct.',
            ),
          ],
        ),
        StudySection(
          title: 'Section II: General Awareness & Science',
          subtitle: 'Static GK + High-Yield Science & Polity',
          paragraphs: [
            'General Awareness evaluates your knowledge of historical events, constitutional frameworks, physical geography, and daily scientific principles.',
          ],
          keyPoints: [
            'Harappan Civilization: Mohenjodaro is on the Indus; the Great Bath, Granary, and Bronze Dancing Girl were discovered here.',
            'Indian Constitution: Fundamental Rights are in Part III (Articles 12 to 35). Referred to as the Magna Carta of India.',
            'Optics & Physics: Total Internal Reflection (TIR) occurs when light travels from denser to rarer medium at an angle greater than the critical angle (Optical Fibres, Mirages, Diamond brilliance).',
            'Enzymes & Digestion: Pepsin breaks proteins in acidic stomach medium; Trypsin breaks proteins in alkaline intestine medium.',
          ],
          questions: [
            StudyMCQ(
              question: 'Which Constitutional Amendment Act added the Tenth Schedule (Anti-Defection Law) to the Indian Constitution?',
              options: ['42nd Amendment Act, 1976', '44th Amendment Act, 1978', '52nd Amendment Act, 1985', '61st Amendment Act, 1988'],
              correctIndex: 2,
              explanation: 'The 52nd Constitutional Amendment Act of 1985 added the Tenth Schedule, introducing disqualification provisions on grounds of political defection.',
            ),
            StudyMCQ(
              question: 'In which Buddhist Council was the Buddhist canon finalized and divided into Sutta Pitaka and Vinaya Pitaka?',
              options: ['First Buddhist Council (Rajgriha)', 'Second Council (Vaishali)', 'Third Council (Pataliputra)', 'Fourth Council (Kundalvana)'],
              correctIndex: 0,
              explanation: 'The First Buddhist Council was held in 483 BC at Rajgriha under King Ajatashatru. Ananda recited the Sutta Pitaka and Upali recited the Vinaya Pitaka.',
            ),
          ],
        ),
        StudySection(
          title: 'Section III: Quantitative Aptitude',
          subtitle: 'Arithmetic & Advanced Mathematics Formulas and Shortcuts',
          paragraphs: [
            'Speed and accuracy in Quantitative Aptitude depend on formulaic shortcuts for Algebra, Geometry, Trigonometry, and Arithmetic.',
          ],
          keyPoints: [
            'Algebraic Identity: If a + b + c = 0, then a³ + b³ + c³ = 3abc.',
            'Trigonometry Identity: sec²θ - tan²θ = 1, so (secθ + tanθ) = 1 / (secθ - tanθ).',
            'Circle Geometry: Angle subtended by a chord at the center is double the angle subtended at the circumference.',
            'Divisibility Rule of 11: The difference between the sum of digits at odd places and even places must be 0 or a multiple of 11.',
          ],
          questions: [
            StudyMCQ(
              question: 'If x + (1/x) = 5, what is the value of x³ + (1/x³)?',
              options: ['110', '120', '125', '140'],
              correctIndex: 0,
              explanation: 'Formula shortcut: If x + 1/x = k, then x³ + 1/x³ = k³ - 3k. Here k = 5, so 5³ - 3(5) = 125 - 15 = 110.',
            ),
            StudyMCQ(
              question: 'A shopkeeper marks his goods 40% above the cost price and allows a discount of 25% on the marked price. Find his net profit or loss percentage.',
              options: ['5% Profit', '10% Profit', '5% Loss', '8% Profit'],
              correctIndex: 0,
              explanation: 'Let CP = 100. Marked Price (MP) = 140. Discount = 25% of 140 = 35. Selling Price (SP) = 140 - 35 = 105. Net Profit = 105 - 100 = 5%.',
            ),
          ],
        ),
        StudySection(
          title: 'Section IV: English Comprehension',
          subtitle: 'Grammar Rules, Synonyms, Antonyms & One-Word Substitution',
          paragraphs: [
            'English Comprehension tests command over standard grammar rules, vocabulary breadth, and sentence structure accuracy.',
          ],
          keyPoints: [
            'Subject-Verb Agreement: Phrases like "as well as", "along with", "together with" do not change the number of the subject.',
            'Conditionals: "If + Past Perfect (had + V3) ... would have + V3". Example: "If he had studied, he would have passed."',
            'Inversion Rule: When sentences begin with negative adverbs (Hardly, Scarcely, Seldom, Never), auxiliary verbs precede the subject.',
          ],
          questions: [
            StudyMCQ(
              question: 'Choose the most appropriate synonym for the word "OBDURATE":',
              options: ['Stubborn', 'Flexible', 'Merciful', 'Deceitful'],
              correctIndex: 0,
              explanation: '"Obdurate" means stubbornly refusing to change one\'s opinion or course of action. Synonym: Stubborn, Inflexible, Intransigent.',
            ),
            StudyMCQ(
              question: 'Select the option that corrects the underlined segment: "No sooner did the bell rang than the students ran out."',
              options: ['did the bell ring', 'had the bell ring', 'does the bell rang', 'No correction required'],
              correctIndex: 0,
              explanation: 'Auxiliary "did" takes the base form of the verb (V1). Therefore, "did the bell ring" is grammatically correct.',
            ),
          ],
        ),
      ],
    ),

    // ==========================================
    // 2. HINDI - SSC CGL 2025 मॉडल प्रश्न पत्र
    // ==========================================
    const StudyDocument(
      id: 'hi_ssc_cgl_2025',
      title: 'SSC CGL 2025 मॉडल प्रश्न पत्र व सम्पूर्ण हल (हिन्दी)',
      language: 'Hindi',
      category: 'Exam Material',
      readTime: '25 min read',
      pages: 18,
      description: 'एसएससी सीजीएल 2025 टियर-1 के लिए हिन्दी माध्यम में प्रामाणिक प्रश्न पत्र, शॉर्टकट विधियाँ एवं विस्तृत व्याख्या।',
      sections: [
        StudySection(
          title: 'खण्ड १: सामान्य बुद्धिमत्ता एवं तर्कशक्ति (रीजनिंग)',
          subtitle: '२५ प्रश्न • ५० अंक • परीक्षा स्तर के प्रश्न',
          paragraphs: [
            'रीजनिंग में समय की बचत के लिए कोडिंग-डिकोडिंग, वेन आरेख, श्रृंखला और दिशा परीक्षण के नियमों का नियमित अभ्यास अनिवार्य है।',
          ],
          keyPoints: [
            'विपरीत अक्षर नियम: वर्णमाला में विपरीत अक्षरों का योग 27 होता है (A=1 + Z=26 = 27, B=2 + Y=25 = 27)।',
            'न्याय निगमन (सिलोगिज्म): दिए गए कथनों को 100% सत्य मानकर न्यूनतम वेन आरेख बनाएँ।',
            'संख्या श्रृंखला: सबसे पहले क्रमागत पदों का अंतर (Difference) जाँचें।',
            'रक्त संबंध: पुरुष हेतु (+), महिला हेतु (-), और वैवाहिक संबंध हेतु द्वि-तीर (<->) का प्रयोग करें।',
          ],
          questions: [
            StudyMCQ(
              question: 'यदि किसी सांकेतिक भाषा में "EARTH" को "FCUXM" लिखा जाता है, तो उसी भाषा में "VENUS" को क्या लिखा जाएगा?',
              options: ['WGPXW', 'WHPXW', 'WGPYX', 'VGPYW'],
              correctIndex: 0,
              explanation: 'पैटर्न: E(+1)=F, A(+2)=C, R(+3)=U, T(+4)=X, H(+5)=M. अतः V(+1)=W, E(+2)=G, N(+3)=Q (अथवा +1,+2,+3,+4,+5 क्रम अनुसार WGPXW)।',
            ),
            StudyMCQ(
              question: 'श्रृंखला में लुप्त संख्या ज्ञात करें: 6, 12, 21, 33, ?',
              options: ['48', '45', '46', '50'],
              correctIndex: 0,
              explanation: 'अंतर: 12-6 = 6, 21-12 = 9, 33-21 = 12. अंतर में +3 की वृद्धि हो रही है. अगला अंतर = 15. अतः 33 + 15 = 48.',
            ),
            StudyMCQ(
              question: 'एक महिला की ओर इशारा करते हुए अमित ने कहा, "वह मेरे दादाजी के एकमात्र पुत्र की पुत्री है।" वह महिला अमित से किस प्रकार संबंधित है?',
              options: ['माता', 'बहन', 'चाची', 'पुत्री'],
              correctIndex: 1,
              explanation: 'अमित के दादाजी का एकमात्र पुत्र = अमित का पिता। पिता की पुत्री = अमित की बहन। अतः वह महिला अमित की बहन है।',
            ),
          ],
        ),
        StudySection(
          title: 'खण्ड २: संख्यात्मक अभियोग्यता (गणित)',
          subtitle: 'अंकगणित व अग्रिम गणित के शॉर्टकट सूत्र',
          paragraphs: [
            'प्रतियोगी परीक्षाओं में समय बचाने हेतु सीधे सूत्रों का प्रयोग करें।',
          ],
          keyPoints: [
            'प्रतिशत से भिन्न मान: 1/4 = 25%, 1/5 = 20%, 1/8 = 12.5%, 1/6 = 16.66%.',
            'साधारण ब्याज और चक्रवृद्धि ब्याज में 2 वर्ष का अंतर: D = P × (R / 100)²',
            'कार्य और समय: कुल कार्य = दिनों की संख्या का ल.स. (LCM); दक्षता (Efficiency) = कुल कार्य / दिन।',
            'औसत चाल सूत्र (समान दूरी हेतु): २xy / (x + y).',
          ],
          questions: [
            StudyMCQ(
              question: 'एक दुकानदार किसी वस्तु पर 20% और 10% की दो क्रमिक छूट देता है। कुल समतुल्य छूट प्रतिशत क्या होगा?',
              options: ['30%', '28%', '25%', '27%'],
              correctIndex: 1,
              explanation: 'समतुल्य छूट सूत्र = x + y - (xy/100) = 20 + 10 - (200/100) = 30 - 2 = 28%.',
            ),
            StudyMCQ(
              question: 'एक ७२ किमी/घंटे की गति से चल रही १८० मीटर लम्बी रेलगाड़ी एक सिग्नल पोल को पार करने में कितना समय लेगी?',
              options: ['९ सेकंड', '१० सेकंड', '१२ सेकंड', '१५ सेकंड'],
              correctIndex: 0,
              explanation: 'चाल = ७२ × (५/१८) = २० मीटर/सेकंड. समय = दूरी / चाल = १८० / २० = ९ सेकंड।',
            ),
          ],
        ),
      ],
    ),

    // ==========================================
    // 3. ENGLISH - Current Affairs 2026
    // ==========================================
    const StudyDocument(
      id: 'en_current_affairs',
      title: 'Daily Current Affairs 2026 (English)',
      language: 'English',
      category: 'Current Affairs',
      readTime: '20 min read',
      pages: 14,
      description: 'Comprehensive month-wise compilation of National Schemes, RBI Monetary Policy, Science & Defense Milestones, and Global Summits in English.',
      sections: [
        StudySection(
          title: '1. National Schemes & Governance',
          subtitle: 'Infrastructure, Clean Energy & Digital India',
          paragraphs: [
            'Key government policies driving the Viksit Bharat 2047 economic roadmap with capital investments in green energy and semiconductor chipmaking.',
          ],
          keyPoints: [
            'PM Surya Ghar Muft Bijli Yojana: Provides up to 300 units of free power per month to 10 million households via rooftop solar panels (Outlay: ₹75,000 crore).',
            'India Semiconductor Mission: Setting up commercial chip fabrication units in Dholera, Gujarat and packaging hubs in Morigaon, Assam.',
            'Bharat 6G Mission: R&D program accelerated by the Ministry of Communications for next-generation telecommunications IP.',
            'PM MITRA Mega Textile Parks: Integrated industrial parks across 7 states to generate scale and jobs.',
          ],
          questions: [
            StudyMCQ(
              question: 'Under the PM Surya Ghar Muft Bijli Yojana, how many units of free solar power per month are targeted for households?',
              options: ['100 units', '200 units', '300 units', '500 units'],
              correctIndex: 2,
              explanation: 'The scheme provides up to 300 units of free electricity every month to 1 crore beneficiary households across the nation.',
            ),
          ],
        ),
        StudySection(
          title: '2. Defense & Space Technology',
          subtitle: 'ISRO & DRDO Strategic Achievements',
          paragraphs: [
            'Milestones achieved in strategic deterrence, indigenous defense manufacturing, and human spaceflight missions.',
          ],
          keyPoints: [
            'Mission Divyastra: First flight test of indigenous Agni-5 missile equipped with Multiple Independently Targetable Re-entry Vehicle (MIRV) technology.',
            'INS Jatayu: Second commissioned naval base in Lakshadweep (Minicoy) enhancing maritime surveillance in the Indian Ocean.',
            'Gaganyaan Mission: Four astronaut-designates undergoing rigorous spaceflight training; crew module sea-recovery trials completed.',
            'Exercise DUSTLIK: Joint military training exercise between the Indian Army and the Uzbekistan Armed Forces.',
          ],
          questions: [
            StudyMCQ(
              question: 'Under what code name did DRDO conduct the flight test of the Agni-5 missile with MIRV technology?',
              options: ['Mission Shakti', 'Mission Divyastra', 'Operation Sankalp', 'Mission Sudarshan'],
              correctIndex: 1,
              explanation: '"Mission Divyastra" was the code name for the first successful test of the indigenously developed Agni-5 missile with Multiple Independently Targetable Re-entry Vehicle (MIRV) capability.',
            ),
          ],
        ),
      ],
    ),

    // ==========================================
    // 4. HINDI - दैनिक समसामयिकी (करंट अफेयर्स)
    // ==========================================
    const StudyDocument(
      id: 'hi_current_affairs',
      title: 'दैनिक समसामयिकी (करंट अफेयर्स) 2026 (हिन्दी)',
      language: 'Hindi',
      category: 'Current Affairs',
      readTime: '20 min read',
      pages: 14,
      description: 'राष्ट्रीय योजनाएँ, आर्थिक परिदृश्य, विज्ञान एवं प्रौद्योगिकी, रक्षा समझौते एवं खेल पुरस्कारों का सम्पूर्ण हिन्दी संकलन।',
      sections: [
        StudySection(
          title: '१. राष्ट्रीय योजनाएँ एवं नीतियां (हिन्दी)',
          subtitle: 'प्रमुख सरकारी योजनाएँ एवं आर्थिक निर्णय',
          paragraphs: [
            'विकसित भारत विजन के अंतर्गत सौर ऊर्जा, सेमीकंडक्टर निर्माण और डिजिटल सार्वजनिक बुनियादी ढांचे पर विशेष बल दिया गया है।',
          ],
          keyPoints: [
            'प्रधानमंत्री सूर्य घर मुफ्त बिजली योजना: 1 करोड़ परिवारों को हर महीने 300 यूनिट तक मुफ्त बिजली देने का लक्ष्य; ₹75,000 करोड़ का कुल परिव्यय।',
            'भारत सेमीकंडक्टर मिशन: धोलेरा (गुजरात) और मोरीगांव (असम) में देश के पहले वाणिज्यिक सेमीकंडक्टर फैब और पैकेजिंग प्लांट स्वीकृत।',
            'मिशन दिव्यास्त्र: DRDO द्वारा MIRV तकनीक से युक्त स्वदेशी अग्नि-5 मिसाइल का सफल प्रथम उड़ान परीक्षण।',
            'आईएनएस जटायु: मिनिकॉय द्वीप (लक्षद्वीप) पर नया नौसैनिक अड्डा कमीशन किया गया।',
          ],
          questions: [
            StudyMCQ(
              question: 'स्वदेशी तकनीक से विकसित अग्नि-5 मिसाइल के सफल MIRV परीक्षण को क्या नाम दिया गया?',
              options: ['मिशन शक्ति', 'मिशन दिव्यास्त्र', 'ऑपरेशन विजय', 'मिशन गगन'],
              correctIndex: 1,
              explanation: 'डीआरडीओ (DRDO) द्वारा अग्नि-5 के मल्टीपल इंडिपेंडेंटली टार्गेटेबल री-एंट्री व्हीकल (MIRV) परीक्षण का कोड नाम "मिशन दिव्यास्त्र" रखा गया था।',
            ),
            StudyMCQ(
              question: 'भारतीय नौसेना ने हाल ही में लक्षद्वीप के किस द्वीप पर "आईएनएस जटायु" नामक नया नौसैनिक अड्डा कमीशन किया?',
              options: ['कवरत्ती', 'अगाती', 'मिनिकॉय द्वीप', 'अमीनी'],
              correctIndex: 2,
              explanation: 'आईएनएस जटायु मिनिकॉय द्वीप पर स्थापित किया गया है, जो रणनीतिक समुद्री व्यापार मार्गों की सुरक्षा हेतु अत्यंत महत्वपूर्ण है।',
            ),
          ],
        ),
      ],
    ),

    // ==========================================
    // 5. ENGLISH - Indian Polity Notes
    // ==========================================
    const StudyDocument(
      id: 'en_polity_notes',
      title: 'Indian Polity & Constitution Master Notes (English)',
      language: 'English',
      category: 'GK',
      readTime: '30 min read',
      pages: 22,
      description: 'Exam-focused comprehensive notes on Indian Constitution: Preamble, Fundamental Rights, Directive Principles, Parliament, Executive, and Landmark Supreme Court Verdicts in English.',
      sections: [
        StudySection(
          title: '1. Preamble & Constitutional Foundation',
          subtitle: 'Adoption, Philosophy & Key Precedents',
          paragraphs: [
            'The Indian Constitution was adopted on 26 November 1949 and came into force on 26 January 1950. Dr. B.R. Ambedkar was Chairman of the Drafting Committee.',
          ],
          keyPoints: [
            'Preamble: Declares India a "SOVEREIGN, SOCIALIST, SECULAR, DEMOCRATIC, REPUBLIC".',
            '42nd Amendment Act (1976): Inserted "Socialist", "Secular", and "Integrity" into the Preamble.',
            'Kesavananda Bharati Case (1973): Supreme Court established that the Preamble is an integral part of the Constitution and formulated the Basic Structure Doctrine.',
            'Borrowed Features: Parliamentary System (UK), Fundamental Rights & Judicial Review (USA), DPSP (Ireland), Concurrent List (Australia), Emergency Powers (GoI Act 1935 / Germany).',
          ],
          questions: [
            StudyMCQ(
              question: 'Which landmark Supreme Court case established the "Basic Structure Doctrine" limiting constitutional amendments?',
              options: ['Golaknath Case (1967)', 'Kesavananda Bharati Case (1973)', 'Minerva Mills Case (1980)', 'Maneka Gandhi Case (1978)'],
              correctIndex: 1,
              explanation: 'The 13-judge constitutional bench in Kesavananda Bharati v. State of Kerala (1973) held that Parliament cannot alter the basic structure of the Constitution under Article 368.',
            ),
          ],
        ),
        StudySection(
          title: '2. Fundamental Rights (Articles 12 to 35)',
          subtitle: 'Part III • Magna Carta of India',
          paragraphs: [
            'Fundamental Rights are enforceable against the State. Under Article 32, citizens can directly approach the Supreme Court for their enforcement via five prerogative writs.',
          ],
          keyPoints: [
            'Article 14: Equality before law and equal protection of the laws.',
            'Article 17: Abolition of untouchability (Absolute right).',
            'Article 19: Protection of 6 democratic freedoms (Speech, Assembly, Association, Movement, Residence, Profession).',
            'Article 21: Protection of life and personal liberty (Includes right to privacy as ruled in Puttaswamy case).',
            'Article 21A: Right to free and compulsory education for children (6-14 years) added by 86th Amendment 2002.',
            'Five Writs: Habeas Corpus, Mandamus, Prohibition, Certiorari, and Quo-Warranto.',
          ],
          questions: [
            StudyMCQ(
              question: 'Which Fundamental Right cannot be suspended even during a National Emergency under Article 352?',
              options: ['Articles 19 and 20', 'Articles 20 and 21', 'Articles 21 and 22', 'Articles 14 and 19'],
              correctIndex: 1,
              explanation: 'Following the 44th Amendment of 1978, Articles 20 (Protection in respect of conviction for offences) and 21 (Protection of life and personal liberty) remain inviolable during emergencies.',
            ),
          ],
        ),
      ],
    ),

    // ==========================================
    // 6. HINDI - भारतीय राजव्यवस्था एवं संविधान
    // ==========================================
    const StudyDocument(
      id: 'hi_polity_notes',
      title: 'भारतीय राजव्यवस्था एवं संविधान सम्पूर्ण नोट्स (हिन्दी)',
      language: 'Hindi',
      category: 'GK',
      readTime: '30 min read',
      pages: 22,
      description: 'प्रतियोगी परीक्षाओं के लिए भारतीय संविधान: प्रस्तावना, मौलिक अधिकार, नीति निदेशक तत्व, संसद एवं प्रमुख अनुच्छेदों का सारगर्भित संकलन।',
      sections: [
        StudySection(
          title: '१. संविधान सभा एवं प्रस्तावना',
          subtitle: 'ऐतिहासिक पृष्ठभूमि एवं दार्शनिक आधार',
          paragraphs: [
            'भारतीय संविधान 26 नवम्बर 1949 को अंगीकृत किया गया तथा 26 जनवरी 1950 को पूर्णतः लागू हुआ। डॉ. भीमराव अंबेडकर प्रारूप समिति (Drafting Committee) के अध्यक्ष थे।',
          ],
          keyPoints: [
            'प्रस्तावना के मुख्य शब्द: "संपूर्ण प्रभुत्व-संपन्न, समाजवादी, पंथनिरपेक्ष, लोकतंत्रात्मक गणराज्य"।',
            '42वाँ संविधान संशोधन (1976): प्रस्तावना में तीन शब्द जोड़े गए - "समाजवादी", "पंथनिरपेक्ष" और "अखंडता"।',
            'केशवानंद भारती वाद (1973): सर्वोच्च न्यायालय ने माना कि प्रस्तावना संविधान का अभिन्न अंग है तथा मूल ढांचा (Basic Structure) परिवर्तनीय नहीं है।',
          ],
          questions: [
            StudyMCQ(
              question: 'संविधान के किस अनुच्छेद को डॉ. बी.आर. अंबेडकर ने "संविधान का हृदय और आत्मा" कहा था?',
              options: ['अनुच्छेद 14', 'अनुच्छेद 19', 'अनुच्छेद 21', 'अनुच्छेद 32'],
              correctIndex: 3,
              explanation: 'अनुच्छेद 32 (संवैधानिक उपचारों का अधिकार) को डॉ. अंबेडकर ने संविधान की आत्मा व हृदय कहा क्योंकि यह सभी अधिकारों का वास्तविक रक्षक है।',
            ),
          ],
        ),
        StudySection(
          title: '२. मौलिक अधिकार (अनुच्छेद 12 से 35)',
          subtitle: 'भाग-३ • भारत का मैग्नाकार्टा',
          paragraphs: [
            'मौलिक अधिकार न्यायालय में वाद योग्य (Justiciable) हैं। इनके हनन पर नागरिक अनुच्छेद 32 के तहत सर्वोच्च न्यायालय और अनुच्छेद 226 के तहत उच्च न्यायालय जा सकते हैं।',
          ],
          keyPoints: [
            'अनुच्छेद 14: विधि के समक्ष समता और विधियों का समान संरक्षण।',
            'अनुच्छेद 17: अस्पृश्यता (छुआछूत) का उन्मूलन - यह एक पूर्ण अधिकार है।',
            'अनुच्छेद 21: प्राण एवं दैहिक स्वतंत्रता का संरक्षण (निजता का अधिकार भी सम्मिलित)।',
            'अनुच्छेद 21A: 6 से 14 वर्ष के बच्चों के लिए निःशुल्क व अनिवार्य शिक्षा (86वें संशोधन 2002 द्वारा)।',
            'अनुच्छेद 32 के तहत 5 रिट: बन्दी प्रत्यक्षीकरण, परमादेश, प्रतिषेध, उत्प्रेषण, अधिकार पृच्छा।',
          ],
        ),
      ],
    ),

    // ==========================================
    // 7. ENGLISH - Quantitative Aptitude Shortcuts
    // ==========================================
    const StudyDocument(
      id: 'en_quant_shortcuts',
      title: 'Quantitative Aptitude Shortcuts & Formulas (English)',
      language: 'English',
      category: 'Maths',
      readTime: '22 min read',
      pages: 16,
      description: 'High-speed mental math shortcuts: percentage-to-fraction conversions, SI vs CI difference rules, relative speed, and time & work efficiency methods in English.',
      sections: [
        StudySection(
          title: '1. Fast Arithmetic & Fraction Table',
          subtitle: 'Fraction to Percentage Equivalents',
          paragraphs: [
            'Commit these fractions to memory to solve percentage, profit & loss, and data interpretation questions mentally in seconds.',
          ],
          keyPoints: [
            '1/2 = 50%  |  1/3 = 33.33%  |  1/4 = 25%  |  1/5 = 20%',
            '1/6 = 16.67% | 1/7 = 14.28% | 1/8 = 12.5% | 1/9 = 11.11%',
            '1/11 = 9.09% | 1/12 = 8.33% | 1/16 = 6.25%',
            'Trick: To find 62.5% of 480: 62.5% = 5/8. So, (5/8) × 480 = 5 × 60 = 300.',
          ],
          questions: [
            StudyMCQ(
              question: 'Find the single equivalent discount for successive discounts of 20% and 10%.',
              options: ['30%', '28%', '25%', '27%'],
              correctIndex: 1,
              explanation: 'Using formula: x + y - (xy/100) = 20 + 10 - (20 × 10 / 100) = 30 - 2 = 28%.',
            ),
          ],
        ),
        StudySection(
          title: '2. SI & CI Direct Difference Formulas',
          subtitle: 'Solve in Under 30 Seconds',
          paragraphs: [
            'Avoid multi-step compound interest calculations using direct difference formulas.',
          ],
          keyPoints: [
            '2-Year CI - SI Difference: D = P × (R / 100)²',
            '3-Year CI - SI Difference: D = P × (R / 100)² × [3 + (R / 100)]',
            'Rule of 72: Money doubles in approximately (72 / R) years at compound interest.',
          ],
          questions: [
            StudyMCQ(
              question: 'The difference between CI and SI on ₹5,000 for 2 years at 12% p.a. is:',
              options: ['₹72', '₹60', '₹84', '₹96'],
              correctIndex: 0,
              explanation: 'D = P × (R/100)² = 5000 × (12/100)² = 5000 × (144 / 10000) = 5 × 14.4 = ₹72.',
            ),
          ],
        ),
      ],
    ),

    // ==========================================
    // 8. HINDI - संख्यात्मक अभियोग्यता (गणित शॉर्टकट)
    // ==========================================
    const StudyDocument(
      id: 'hi_quant_shortcuts',
      title: 'संख्यात्मक अभियोग्यता (गणित शॉर्टकट व सूत्र) (हिन्दी)',
      language: 'Hindi',
      category: 'Maths',
      readTime: '22 min read',
      pages: 16,
      description: 'गणित के अचूक शॉर्टकट: प्रतिशत-भिन्न तालिका, लाभ-हानि व बट्टा, साधारण व चक्रवृद्धि ब्याज में अंतर सूत्र और समय-दूरी ट्रिक्स।',
      sections: [
        StudySection(
          title: '१. प्रतिशत और भिन्न रूपांतरण तालिका',
          subtitle: 'मौखिक गणना करने की वैज्ञानिक विधि',
          paragraphs: [
            'प्रतियोगी परीक्षाओं में प्रश्नों को 10-15 सेकंड में हल करने के लिए भिन्न मानों को याद रखना अत्यंत आवश्यक है।',
          ],
          keyPoints: [
            '१/२ = ५०% | १/३ = ३३.३३% | १/४ = २५% | १/५ = २०%',
            '१/६ = १६.६६% | १/७ = १४.२८% | १/८ = १२.५% | १/९ = ११.११%',
            '१/११ = ९.०९% | १/१२ = ८.३३% | १/१६ = ६.२५%',
            'उदाहरण: ८०० का ३७.५% ज्ञात करना = ३७.५% = ३/८. अतः (३/८) × ८०० = ३०० (मात्र २ सेकंड में)।',
          ],
        ),
        StudySection(
          title: '२. समय, चाल और दूरी के मुख्य सूत्र',
          subtitle: 'सापेक्ष चाल एवं रेलगाड़ी संबंधी प्रश्न',
          paragraphs: [
            'गति को किमी/घंटे से मीटर/सेकंड में बदलने के लिए ५/१८ से गुणा करें, तथा मीटर/सेकंड से किमी/घंटा में बदलने हेतु १८/५ से गुणा करें।',
          ],
          keyPoints: [
            'औसत चाल (जब दूरियाँ समान हों): २xy / (x + y).',
            'सापेक्ष चाल (समान दिशा में): (u - v) किमी/घंटा।',
            'सापेक्ष चाल (विपरीत दिशा में): (u + v) किमी/घंटा।',
            'खम्भे या व्यक्ति को पार करने में रेलगाड़ी द्वारा चली गई दूरी = रेलगाड़ी की अपनी लम्बाई।',
          ],
          questions: [
            StudyMCQ(
              question: 'एक ७२ किमी/घंटे की गति से चल रही १८० मीटर लम्बी रेलगाड़ी एक सिग्नल पोल को पार करने में कितना समय लेगी?',
              options: ['९ सेकंड', '१० सेकंड', '१२ सेकंड', '१५ सेकंड'],
              correctIndex: 0,
              explanation: 'चाल = ७२ × (५/१८) = २० मीटर/सेकंड. समय = दूरी / चाल = १८० / २० = ९ सेकंड।',
            ),
          ],
        ),
      ],
    ),

    // ==========================================
    // 9. ENGLISH - Reasoning Set 04
    // ==========================================
    const StudyDocument(
      id: 'en_reasoning_set',
      title: 'Reasoning Ability Practice Set 04 (English)',
      language: 'English',
      category: 'Reasoning',
      readTime: '24 min read',
      pages: 15,
      description: 'Targeted practice set in English covering Syllogisms, Direction and Distance Sense, Circular Seating Arrangements, and Blood Relations with diagrams.',
      sections: [
        StudySection(
          title: '1. Direction & Compass Logic',
          subtitle: 'Pythagoras Applications & Sun Shadows',
          paragraphs: [
            'Standard clockwise compass layout: North (0°), East (90°), South (180°), West (270°). Use displacement vectors for multi-turn movements.',
          ],
          keyPoints: [
            'Morning Shadow: Sun rises in the East, so all shadows point towards WEST.',
            'Evening Shadow: Sun sets in the West, so all shadows point towards EAST.',
            'Shortest Distance: √[(Δx)² + (Δy)²]',
          ],
          questions: [
            StudyMCQ(
              question: 'A man travels 8 km East, turns right and walks 6 km. What is his straight-line distance from the start?',
              options: ['10 km', '14 km', '12 km', '16 km'],
              correctIndex: 0,
              explanation: 'By Pythagoras theorem: Hypotenuse = √(8² + 6²) = √(64 + 36) = √100 = 10 km.',
            ),
          ],
        ),
      ],
    ),

    // ==========================================
    // 10. HINDI - तर्कशक्ति (रीजनिंग) अभ्यास सेट
    // ==========================================
    const StudyDocument(
      id: 'hi_reasoning_set',
      title: 'तर्कशक्ति (रीजनिंग) अभ्यास सेट 04 (हिन्दी)',
      language: 'Hindi',
      category: 'Reasoning',
      readTime: '24 min read',
      pages: 15,
      description: 'हिन्दी माध्यम में तर्कशक्ति अभ्यास: न्याय-निगमन (सिलोगिज्म), दिशा व दूरी, रक्त संबंध और बैठक व्यवस्था के व्याख्या सहित हल।',
      sections: [
        StudySection(
          title: '१. रक्त संबंध (Blood Relations) के नियम',
          subtitle: 'पारिवारिक वृक्ष (Family Tree) बनाने की आसान विधि',
          paragraphs: [
            'रक्त संबंध के प्रश्नों में पीढ़ियों (Generations) को अलग-अलग स्तरों पर दर्शाने से उत्तर शत-प्रतिशत सटीक निकलता है।',
          ],
          keyPoints: [
            'प्रतीक चिह्न: पुरुष के लिए (+) और महिला के लिए (-) का प्रयोग करें।',
            'वैवाहिक संबंध हेतु दोहरे तीर (A <-> B) का प्रयोग करें।',
            'सहोदर (भाई/बहन) हेतु एकल क्षैतिज रेखा (A - B) का प्रयोग करें।',
            'माता-पिता व संतान हेतु ऊर्ध्वाधर रेखा का प्रयोग करें।',
          ],
          questions: [
            StudyMCQ(
              question: 'एक महिला की ओर इशारा करते हुए अमित ने कहा, "वह मेरे दादाजी के एकमात्र पुत्र की पुत्री है।" वह महिला अमित से किस प्रकार संबंधित है?',
              options: ['माता', 'बहन', 'चाची', 'पुत्री'],
              correctIndex: 1,
              explanation: 'अमित के दादाजी का एकमात्र पुत्र = अमित का पिता। पिता की पुत्री = अमित की बहन। अतः वह महिला अमित की बहन है।',
            ),
          ],
        ),
      ],
    ),

    // ==========================================
    // 11. ENGLISH - English Vocabulary Builder
    // ==========================================
    const StudyDocument(
      id: 'en_vocab_builder',
      title: 'English Vocabulary & Grammar Builder (English)',
      language: 'English',
      category: 'English',
      readTime: '25 min read',
      pages: 20,
      description: 'Master 100+ high-frequency vocabulary words through Greek and Latin root words, essential one-word substitutions, and frequently tested idioms in English.',
      sections: [
        StudySection(
          title: '1. Root Words Methodology',
          subtitle: 'Prefix, Root and Suffix Logic',
          paragraphs: [
            'Deconstruct complex academic words into their core Latin or Greek roots to deduce meaning instantly.',
          ],
          keyPoints: [
            'Root "BENE" (Good): Benevolent (kind), Benefactor (patron), Benign (harmless).',
            'Root "MAL" (Bad): Malevolent (hostile), Malicious (harmful), Malady (illness).',
            'Root "CHRON" (Time): Chronological (ordered in time), Synchronize (coincide), Chronic (long-lasting).',
            'Root "LOQU / LOCUT" (Speak): Loquacious (chatty), Eloquent (persuasive), Soliloquy (monologue).',
            'Root "OMNI" (All): Omniscient (all-knowing), Omnipotent (all-powerful), Omnipresent (present everywhere).',
          ],
          questions: [
            StudyMCQ(
              question: 'Choose the correct synonym for the word "EPHEMERAL":',
              options: ['Transient', 'Enduring', 'Permanent', 'Monumental'],
              correctIndex: 0,
              explanation: '"Ephemeral" means lasting for a very brief duration. Synonym: Transient, Fleeting, Evancent.',
            ),
            StudyMCQ(
              question: 'One who abandons his religious faith is called an:',
              options: ['Apostate', 'Agnostic', 'Atheist', 'Ascetic'],
              correctIndex: 0,
              explanation: 'An "Apostate" is someone who renounces a religious belief or political allegiance.',
            ),
          ],
        ),
        StudySection(
          title: '2. High-Yield One-Word Substitutions',
          subtitle: 'Most Frequently Tested in Competitive Exams',
          paragraphs: [
            'One-word substitutions test lexical precision and appear regularly in SSC CGL, CHSL, and CDS exams.',
          ],
          keyPoints: [
            'Philanthropist: A person who seeks to promote the welfare of others (lover of mankind).',
            'Misogynist: A person who dislikes, despises, or is strongly prejudiced against women.',
            'Somnambulist: A person who walks in sleep.',
            'Incorrigible: A person or habit that cannot be corrected or reformed.',
            'Altruist: One who shows unselfish concern for the welfare of others.',
          ],
          questions: [
            StudyMCQ(
              question: 'A speech delivered without any previous preparation is called:',
              options: ['Extempore', 'Maiden speech', 'Eulogy', 'Soliloquy'],
              correctIndex: 0,
              explanation: 'An "Extempore" (or Impromptu) speech is spoken without prior preparation or notes.',
            ),
          ],
        ),
      ],
    ),

    // ==========================================
    // 12. HINDI - सम्पूर्ण हिन्दी व्याकरण
    // ==========================================
    const StudyDocument(
      id: 'hi_vyakaran_notes',
      title: 'सम्पूर्ण हिन्दी व्याकरण नोट्स (वर्ण, संधि, समास) (हिन्दी)',
      language: 'Hindi',
      category: 'Hindi',
      readTime: '25 min read',
      pages: 20,
      description: 'सम्पूर्ण हिन्दी व्याकरण: वर्ण विचार, स्वर व व्यंजन संधि, समास के 6 भेद, तत्सम-तद्भव पहचान की ट्रिक और प्रमुख मुहावरे परीक्षा के लिए।',
      sections: [
        StudySection(
          title: '१. वर्ण विचार एवं वर्गीकरण',
          subtitle: 'स्वर, व्यंजन एवं उच्चारण स्थान',
          paragraphs: [
            'हिन्दी वर्णमाला में कुल 52 वर्ण होते हैं। इसमें 11 स्वर, 33 मुख्य व्यंजन और 4 संयुक्त व्यंजन सम्मिलित हैं।',
          ],
          keyPoints: [
            'स्वर (11): अ, आ, इ, ई, उ, ऊ, ऋ, ए, ऐ, ओ, औ।',
            'स्पर्श व्यंजन (25): क-वर्ग (कंठ्य), च-वर्ग (तालव्य), ट-वर्ग (मूर्धन्य), त-वर्ग (दंत्य), प-वर्ग (ओष्ठ्य)।',
            'संयुक्त व्यंजन (4): क्ष (क्+ष्), त्र (त्+र्), ज्ञ (ज्+ञ्), श्र (श्+र्)।',
            'प्राण वायु के आधार पर: अल्पप्राण (प्रत्येक वर्ग का पहला, तीसरा, पाँचवाँ वर्ण) एवं महाप्राण (दूसरा, चौथा वर्ण + ऊष्म व्यंजन)।',
          ],
        ),
        StudySection(
          title: '२. संधि के नियम एवं उदाहरण',
          subtitle: 'स्वर, व्यंजन एवं विसर्ग संधि',
          paragraphs: [
            'दो वर्णों के मेल से उत्पन्न होने वाले विकार को संधि कहते हैं।',
          ],
          keyPoints: [
            'दीर्घ संधि: हिम + आलय = हिमालय, विद्या + अर्थी = विद्यार्थी।',
            'गुण संधि: नर + ईश = नरेश, महा + उत्सव = महोत्सव, देव + ऋषि = देवर्षि।',
            'वृद्धि संधि: एक + एक = एकैक, महा + ऐश्वर्य = महैश्वर्य।',
            'यण संधि: यदि + अपि = यद्यपि, सु + आगत = स्वागत।',
            'अयादि संधि: ने + अन = नयन, पो + अन = पवन, पौ + अक = पावक।',
          ],
          questions: [
            StudyMCQ(
              question: '"पवन" शब्द का सही संधि विच्छेद क्या है?',
              options: ['पो + अन', 'पौ + अन', 'पव + न', 'प + वन'],
              correctIndex: 0,
              explanation: 'अयादि संधि के नियमानुसार ओ + अ = अव् होता है। अतः पो + अन = पवन।',
            ),
            StudyMCQ(
              question: '"नीलकंठ" शब्द में कौन सा समास है?',
              options: ['बहुव्रीहि समास', 'तत्पुरुष समास', 'द्विगु समास', 'द्वंद्व समास'],
              correctIndex: 0,
              explanation: 'नीलकंठ का विग्रह है "नीला है कंठ जिसका अर्थात् भगवान शिव"। यह तीसरे अर्थ की ओर संकेत करता है, अतः यह बहुव्रीहि समास है।',
            ),
          ],
        ),
      ],
    ),

    // ==========================================
    // 13. ENGLISH - Computer Fundamentals
    // ==========================================
    const StudyDocument(
      id: 'en_computer_notes',
      title: 'Computer Fundamentals & Networking (English)',
      language: 'English',
      category: 'Computer',
      readTime: '22 min read',
      pages: 16,
      description: 'Core concepts in English: CPU Architecture, Memory Hierarchy, OSI 7-Layer Model, TCP/IP, Cybersecurity threats, and essential Windows shortcut keys.',
      sections: [
        StudySection(
          title: '1. Architecture & Memory Hierarchy',
          subtitle: 'Registers, Cache, RAM and Storage Units',
          paragraphs: [
            'The central processing unit (CPU) executes instructions using the Arithmetic Logic Unit (ALU), Control Unit (CU), and internal registers.',
          ],
          keyPoints: [
            'Speed Order: Registers > L1 Cache > L2 Cache > L3 Cache > RAM > NVMe SSD > SATA SSD > HDD.',
            'Memory Units:',
            '• 1 Nibble = 4 bits',
            '• 1 Byte = 8 bits',
            '• 1 Kilobyte (KB) = 1,024 Bytes',
            '• 1 Megabyte (MB) = 1,024 KB',
            '• 1 Gigabyte (GB) = 1,024 MB',
            '• 1 Terabyte (TB) = 1,024 GB',
          ],
          questions: [
            StudyMCQ(
              question: 'Which of the following is the fastest memory inside a computer?',
              options: ['L3 Cache', 'RAM', 'CPU Registers', 'Magnetic Disk'],
              correctIndex: 2,
              explanation: 'Registers are ultra-fast memory units located directly inside the CPU core.',
            ),
          ],
        ),
        StudySection(
          title: '2. Networking & OSI 7-Layer Model',
          subtitle: 'Standard Protocols and Data Encapsulation',
          paragraphs: [
            'The Open Systems Interconnection model separates network communication into 7 distinct functional layers.',
          ],
          keyPoints: [
            'Layer 7 (Application): HTTP, HTTPS, FTP, SMTP, DNS.',
            'Layer 6 (Presentation): SSL/TLS, Encryption, Data compression.',
            'Layer 5 (Session): Session establishment and checkpointing.',
            'Layer 4 (Transport): TCP (connection-oriented, reliable) and UDP (connectionless, fast).',
            'Layer 3 (Network): Logical IP routing and addressing (Routers).',
            'Layer 2 (Data Link): Physical MAC framing and switching (Switches).',
            'Layer 1 (Physical): Raw binary bits over cables/radio waves (Hubs, Cables).',
          ],
          questions: [
            StudyMCQ(
              question: 'Which layer of the OSI model is responsible for routing packets based on IP addresses?',
              options: ['Transport Layer', 'Network Layer', 'Data Link Layer', 'Physical Layer'],
              correctIndex: 1,
              explanation: 'The Network Layer (Layer 3) handles packet routing, forwarding, and logical addressing using IP addresses.',
            ),
          ],
        ),
      ],
    ),

    // ==========================================
    // 14. HINDI - कंप्यूटर सामान्य ज्ञान एवं इंटरनेट
    // ==========================================
    const StudyDocument(
      id: 'hi_computer_notes',
      title: 'कंप्यूटर सामान्य ज्ञान एवं इंटरनेट नोट्स (हिन्दी)',
      language: 'Hindi',
      category: 'Computer',
      readTime: '22 min read',
      pages: 16,
      description: 'प्रतियोगी परीक्षाओं के लिए कंप्यूटर ज्ञान: सीपीयू, मेमोरी पदानुक्रम, इंटरनेट व ओएसआई मॉडल, साइबर सुरक्षा और महत्वपूर्ण शॉर्टकट कुंजियाँ।',
      sections: [
        StudySection(
          title: '१. कंप्यूटर संरचना एवं मेमोरी',
          subtitle: 'सीपीयू के भाग एवं मेमोरी की इकाइयाँ',
          paragraphs: [
            'कंप्यूटर का मस्तिष्क CPU (Central Processing Unit) होता है, जिसके तीन मुख्य अंग हैं: ALU (अंकगणितीय तार्किक इकाई), CU (नियंत्रण इकाई) और रजिस्टर्स।',
          ],
          keyPoints: [
            'मेमोरी गति का क्रम: रजिस्टर्स > कैश मेमोरी > रैम (RAM) > एसएसडी (SSD) > हार्ड डिस्क (HDD)।',
            'रैम (RAM) एक अस्थिर (Volatile) मेमोरी है, जबकि रोम (ROM) एक स्थायी (Non-volatile) मेमोरी है।',
            'मेमोरी मापन: 1 निबल = 4 बिट्स; 1 बाइट = 8 बिट्स; 1 किलोबाइट (KB) = 1024 बाइट्स; 1 मेगाबाइट (MB) = 1024 KB।',
          ],
          questions: [
            StudyMCQ(
              question: 'कंप्यूटर के संदर्भ में RAM का पूर्ण रूप (Full Form) क्या है?',
              options: ['Random Access Memory', 'Read Access Memory', 'Rapid Action Memory', 'Real Application Memory'],
              correctIndex: 0,
              explanation: 'RAM का पूर्ण रूप Random Access Memory होता है, जो कंप्यूटर की मुख्य कार्यशील प्राथमिक मेमोरी है।',
            ),
            StudyMCQ(
              question: 'इंटरनेट पर किसी वेबसाइट का अनूठा पता (Unique Address) क्या कहलाता है?',
              options: ['URL', 'IP Address', 'MAC Address', 'HTML'],
              correctIndex: 0,
              explanation: 'वेबसाइट के पते को URL (Uniform Resource Locator) कहा जाता है, जैसे https://www.example.com।',
            ),
          ],
        ),
        StudySection(
          title: '२. साइबर सुरक्षा एवं शॉर्टकट कुंजियाँ',
          subtitle: 'मैलवेयर के प्रकार और महत्वपूर्ण शॉर्टकट',
          paragraphs: [
            'प्रतियोगी परीक्षाओं में अक्सर पूछे जाने वाले वायरस, वॉर्म, ट्रोजन और विंडोज शॉर्टकट।',
          ],
          keyPoints: [
            'रैनसमवेयर (Ransomware): फाइलों को लॉक (एन्क्रिप्ट) कर फिरौती माँगने वाला खतरनाक मैलवेयर।',
            'फिशिंग (Phishing): नकली ईमेल या वेबसाइट बनाकर पासवर्ड या ओटीपी चुराना।',
            'महत्वपूर्ण शॉर्टकट:',
            '• Ctrl + C = कॉपी | Ctrl + V = पेस्ट | Ctrl + Z = अनडू',
            '• Win + D = डेस्कटॉप देखना | Ctrl + Shift + Esc = टास्क मैनेजर',
            '• Alt + Tab = खुली हुई ऍप्लिकेशन्स बदलना | F5 = रिफ्रेश',
          ],
        ),
      ],
    ),
  ];

  static List<StudyDocument> filter({String? language, String? category, String? search}) {
    return documents.where((doc) {
      if (language != null && language != 'All' && doc.language != language) {
        return false;
      }
      if (category != null && category != 'All' && doc.category != category) {
        return false;
      }
      if (search != null && search.trim().isNotEmpty) {
        final query = search.trim().toLowerCase();
        final inTitle = doc.title.toLowerCase().contains(query);
        final inDesc = doc.description.toLowerCase().contains(query);
        final inCat = doc.category.toLowerCase().contains(query);
        if (!inTitle && !inDesc && !inCat) return false;
      }
      return true;
    }).toList();
  }

  static StudyDocument getById(String id) {
    try {
      return documents.firstWhere((doc) => doc.id == id);
    } catch (_) {
      return documents.first;
    }
  }

  static StudyDocument getByTitle(String title) {
    try {
      return documents.firstWhere((doc) => doc.title.toLowerCase() == title.toLowerCase());
    } catch (_) {
      return documents.first;
    }
  }
}
