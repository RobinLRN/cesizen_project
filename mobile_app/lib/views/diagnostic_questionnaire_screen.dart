import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/diagnostic_service.dart';
import '../ui/theme.dart';
import 'diagnostic_result_screen.dart';

class DiagnosticQuestionnaireScreen extends StatefulWidget {
  const DiagnosticQuestionnaireScreen({super.key});

  @override
  State<DiagnosticQuestionnaireScreen> createState() => _DiagnosticQuestionnaireScreenState();
}

class _DiagnosticQuestionnaireScreenState extends State<DiagnosticQuestionnaireScreen> {
  final DiagnosticService _diagnosticService = DiagnosticService();
  List<Question> _allQuestions = [];
  bool _isLoading = true;
  int _currentPage = 0;
  final int _questionsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() async {
    final questions = await _diagnosticService.fetchQuestions();
    if (mounted) {
      setState(() {
        _allQuestions = questions;
        _isLoading = false;
      });
    }
  }

  int get _totalPages => _allQuestions.isEmpty ? 1 : (_allQuestions.length / _questionsPerPage).ceil();

  List<Question> get _currentQuestions {
    if (_allQuestions.isEmpty) return [];
    int start = _currentPage * _questionsPerPage;
    int end = start + _questionsPerPage;
    if (end > _allQuestions.length) end = _allQuestions.length;
    return _allQuestions.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tropicalTeal,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => _currentPage > 0 ? setState(() => _currentPage--) : Navigator.pop(context),
        ),
        title: Text(
          '${_currentPage + 1} / $_totalPages',
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Événements',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sélectionnez les événements vécus ces 12 derniers mois.',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 25),

                  // La liste prend tout l'espace central
                  Expanded(
                    child: ListView.builder(
                      itemCount: _currentQuestions.length,
                      itemBuilder: (context, index) {
                        final question = _currentQuestions[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: question.isSelected ? AppColors.softPeach.withOpacity(0.3) : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: question.isSelected ? AppColors.softPeach : Colors.white10),
                          ),
                          child: CheckboxListTile(
                            title: Text(question.contenu, style: const TextStyle(color: Colors.white, fontSize: 15)),
                            subtitle: Text("${question.valScore} pts", style: const TextStyle(color: Colors.white38)),
                            value: question.isSelected,
                            activeColor: AppColors.softPeach,
                            checkColor: AppColors.tropicalTeal,
                            onChanged: (val) => setState(() => question.isSelected = val ?? false),
                          ),
                        );
                      },
                    ),
                  ),

                  // Bloc Bouton en bas
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < _totalPages - 1) {
                          setState(() => _currentPage++);
                        } else {
                          int score = _allQuestions.where((q) => q.isSelected).fold(0, (sum, q) => sum + q.valScore);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DiagnosticResultScreen(score: score)));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.softPeach,
                        foregroundColor: AppColors.tropicalTeal,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text(_currentPage == _totalPages - 1 ? 'Terminer' : 'Suivant'),
                    ),
                  ),
                  const SizedBox(height: 50), 
                ],
              ),
      ),
    );
  }
}