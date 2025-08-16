class Answer {
  final String text;
  final bool isCorrect; 

  Answer({
    required this.text,
    required this.isCorrect, 
  });

  factory Answer.fromMap(Map<String, dynamic> map) {
    return Answer(
      text: map['text'] ?? '',
      isCorrect: map['isCorrect'] ?? false,  // في حال كنت تجلب من Realtime مباشرة
    );
  }
}
