class Question {
  final int idQuestion;
  final String contenu;
  final int valScore;
  bool isSelected;

  Question({
    required this.idQuestion,
    required this.contenu,
    required this.valScore,
    this.isSelected = false,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      idQuestion: json['id_question'],
      contenu: json['contenu'],
      valScore: json['val_score'],
    );
  }
}
