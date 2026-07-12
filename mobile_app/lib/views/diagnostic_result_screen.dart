import 'package:flutter/material.dart';
import '../services/diagnostic_service.dart';
import '../ui/theme.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DiagnosticResultScreen extends StatefulWidget {
  final int score;
  const DiagnosticResultScreen({super.key, required this.score});

  @override
  State<DiagnosticResultScreen> createState() => _DiagnosticResultScreenState();
}

class _DiagnosticResultScreenState extends State<DiagnosticResultScreen> {
  final DiagnosticService _diagnosticService = DiagnosticService();
  List<Map<String, dynamic>> _configs = [];

  static const _fallback = [
    {
      'titre': 'Moins de 100 points : stress modéré, risque de 30 %',
      'description': 'Avec un score inférieur à 100, le risque de développer une maladie somatique est faible.',
    },
    {
      'titre': 'Entre 100 et 300 points : stress élevé, risque de 51 %',
      'description': 'Cependant, avec un score entre 100 et 300, le risque de déclencher une maladie somatique reste statistiquement significatif.',
    },
    {
      'titre': 'Plus de 300 points : stress très élevé, risque de 80 %',
      'description': 'Si votre score de stress au cours des 24 derniers mois dépasse 300, vous êtes exposé à un risque très élevé de développer une maladie somatique prochainement.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _saveScore();
    _loadConfig();
  }

  void _saveScore() async {
    const storage = FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    if (userId != null) {
      await _diagnosticService.saveResult(widget.score);
    }
  }

  void _loadConfig() async {
    final configs = await _diagnosticService.fetchConfig();
    if (mounted && configs.isNotEmpty) {
      setState(() { _configs = configs; });
    }
  }

  Map<String, dynamic> _getResultData() {
    int configIndex;
    Color color;
    if (widget.score < 100) {
      configIndex = 0;
      color = AppColors.tropicalTeal;
    } else if (widget.score <= 300) {
      configIndex = 1;
      color = AppColors.softPeach;
    } else {
      configIndex = 2;
      color = const Color(0xFF9BA08D);
    }

    final source = _configs.isNotEmpty ? _configs[configIndex] : _fallback[configIndex];
    return {
      'title': source['titre'],
      'desc': source['description'],
      'color': color,
    };
  }

  @override
  Widget build(BuildContext context) {
    final data = _getResultData();

    return Scaffold(
      backgroundColor: data['color'],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Text(
                  'Votre score',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${widget.score}',
                      style: TextStyle(
                        color: data['color'],
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  data['title'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  data['desc'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    // 3. Renvoi vers la page activités
                    onPressed: () =>
                        Navigator.pushNamed(context, '/activities'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text('Découvrir nos activités →'),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
