import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../ui/widgets/page_layout.dart';
import '../ui/widgets/widgets.dart';

class ActivityDetailScreen extends StatefulWidget {
  final Activity activity;

  const ActivityDetailScreen({
    super.key,
    required this.activity,
  });

  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    // On vérifie si l'activité a une url
    final bool hasVideo = widget.activity.activityUrl != null &&
        widget.activity.activityUrl!.isNotEmpty;

    return Scaffold(
      // J'ai dû enlever le 'const' car le titre est dynamique
      appBar: CustomFullAppBar(
        title: widget.activity.title,
      ),
      body: PageLayout(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image ou vidéo
              Padding(
                padding: const EdgeInsets.all(25),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[300], // Fond si pas de contenu à afficher
                    image: widget.activity.imageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(widget.activity.imageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: hasVideo
                      ? const Center(
                          // Espace réservé pour le lecteur vidéo
                          child: Text('Lecteur vidéo à venir'),
                        )
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Description',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.12),
                        blurRadius: 3,
                        spreadRadius: 0,
                        offset: Offset(0, 1),
                      ),
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.24),
                        blurRadius: 2,
                        spreadRadius: 0,
                        offset: Offset(0, 1),
                      )
                    ],
                  ),
                  child: Text(
                    widget.activity.content,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}