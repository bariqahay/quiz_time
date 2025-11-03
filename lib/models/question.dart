class Question {
  final String question;
  final List<String> options;
  int correctAnswerIndex; 
  final String? imageUrl;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.imageUrl,
  });

  // Shuffle opsi jawaban dan update index jawaban benar
  void shuffleOptions() {
    final correctAnswer = options[correctAnswerIndex];
    options.shuffle();
    correctAnswerIndex = options.indexOf(correctAnswer);
  }
}

List<Question> getQuestions() {
  return [
    Question(
      question: 'Apa nama ibu kota Indonesia?',
      options: ['Bandung', 'Jakarta', 'Surabaya', 'Medan'],
      correctAnswerIndex: 1,
    ),
    Question(
      question: 'Berapa hasil dari 15 + 27?',
      options: ['40', '42', '43', '45'],
      correctAnswerIndex: 1,
    ),
    Question(
      question: 'Siapa presiden pertama Indonesia?',
      options: ['Soekarno', 'Soeharto', 'BJ Habibie', 'Megawati'],
      correctAnswerIndex: 0,
    ),
    Question(
      question: 'Bahasa pemrograman apa yang digunakan Flutter?',
      options: ['Java', 'Kotlin', 'Dart', 'Swift'],
      correctAnswerIndex: 2,
    ),
    Question(
      question: 'Planet terbesar dalam tata surya adalah?',
      options: ['Mars', 'Saturnus', 'Jupiter', 'Uranus'],
      correctAnswerIndex: 2,
    ),
    Question(
      question: 'Berapa jumlah provinsi di Indonesia?',
      options: ['34', '35', '37', '38'],
      correctAnswerIndex: 3,
    ),
    Question(
      question: 'Apa singkatan dari CPU?',
      options: [
        'Central Processing Unit',
        'Computer Personal Unit',
        'Central Program Utility',
        'Core Processing Unit'
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      question: 'Tahun berapa Indonesia merdeka?',
      options: ['1942', '1943', '1944', '1945'],
      correctAnswerIndex: 3,
    ),
    Question(
      question: 'Warna dari kombinasi merah dan biru adalah?',
      options: ['Hijau', 'Ungu', 'Orange', 'Coklat'],
      correctAnswerIndex: 1,
    ),
    Question(
      question: 'Berapa lama waktu dalam satu hari?',
      options: ['12 jam', '24 jam', '48 jam', '36 jam'],
      correctAnswerIndex: 1,
    ),
  ];
}
