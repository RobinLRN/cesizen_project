import 'package:flutter/material.dart';
import '../../services/diagnostic_service.dart';

class DiagnosticConfigPage extends StatefulWidget {
  const DiagnosticConfigPage({super.key});

  @override
  State<DiagnosticConfigPage> createState() => _DiagnosticConfigPageState();
}

class _DiagnosticConfigPageState extends State<DiagnosticConfigPage> {
  final DiagnosticService _service = DiagnosticService();
  List<Map<String, dynamic>> _configs = [];
  bool _loading = true;

  final List<TextEditingController> _titreControllers = [];
  final List<TextEditingController> _descControllers = [];

  static const _levelLabels = [
    'Niveau 1 — Stress modéré (score < 100)',
    'Niveau 2 — Stress élevé (score 100–300)',
    'Niveau 3 — Stress très élevé (score > 300)',
  ];

  static const _levelColors = [
    Color(0xFF006D77),
    Color(0xFFFFDDD2),
    Color(0xFF9BA08D),
  ];

  @override
  void initState() {
    super.initState();
    _loadConfigs();
  }

  Future<void> _loadConfigs() async {
    final configs = await _service.fetchConfig();
    if (!mounted) return;
    setState(() {
      _configs = configs;
      _loading = false;
      for (final config in configs) {
        _titreControllers.add(TextEditingController(text: config['titre'] as String));
        _descControllers.add(TextEditingController(text: config['description'] as String));
      }
    });
  }

  Future<void> _save(int index) async {
    final id = _configs[index]['id_config'] as int;
    final success = await _service.updateConfig(
      id,
      _titreControllers[index].text.trim(),
      _descControllers[index].text.trim(),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Niveau ${index + 1} mis à jour.' : 'Erreur lors de la sauvegarde.'),
        backgroundColor: success ? const Color(0xFF006D77) : Colors.redAccent,
      ),
    );
  }

  @override
  void dispose() {
    for (final c in _titreControllers) { c.dispose(); }
    for (final c in _descControllers) { c.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF006D77)));
    }
    if (_configs.isEmpty) {
      return const Center(child: Text('Impossible de charger la configuration.'));
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Configuration du Diagnostic', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            'Modifiez les textes affichés sur la page de résultats du diagnostic.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: _configs.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (_, index) => _buildCard(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(int index) {
    final levelColor = _levelColors[index];
    final textColor = index == 1 ? Colors.black87 : Colors.white;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: levelColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Text(
              _levelLabels[index],
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titreControllers[index],
                  decoration: const InputDecoration(
                    labelText: 'Titre',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descControllers[index],
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () => _save(index),
                    icon: const Icon(Icons.save, size: 18),
                    label: const Text('Enregistrer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006D77),
                      foregroundColor: Colors.white,
                    ),
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
