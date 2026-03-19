import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
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
  // Le contrôleur qui va gérer la vidéo
  YoutubePlayerController? _youtubeController;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();

    // Si l'activité a une URL, on prépare le lecteur
    if (widget.activity.activityUrl != null && widget.activity.activityUrl!.isNotEmpty) {
      // 1. On essaie d'extraire l'ID
      final videoId = YoutubePlayer.convertUrlToId(widget.activity.activityUrl!);

      if (videoId != null) {
        // 2. On configure le contrôleur avec l'ID trouvé
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false, // Ne pas lancer automatiquement
            mute: false,
            isLive: false,
          ),
        )..addListener(_listener); // On ajoute un écouteur pour gérer les états
      }
    }
  }

  // Petite fonction pour écouter si le lecteur est prêt à s'afficher
  void _listener() {
    
  }

  @override
  void deactivate() {
    // Pauser la vidéo si on quitte la page
    _youtubeController?.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    // Libérer la mémoire du contrôleur quand on ferme définitivement la page
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // On vérifie si on doit afficher une image ou une vidéo
    final bool hasVideo = _youtubeController != null;

    return Scaffold(
      appBar: CustomFullAppBar(
        title: widget.activity.title,
      ),
      body: PageLayout(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 200, 
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.16),
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: Offset(0, 1),
                    )
                  ]
                ),
                // On utilise ClipRRect pour forcer la vidéo à avoir les bords arrondis
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: hasVideo
                      ? YoutubePlayer(
                          controller: _youtubeController!,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: AppColors.softPeach,
                          onReady: () {
                            _isPlayerReady = true;
                          },
                          // Personnalisation des couleurs des contrôles
                          progressColors: const ProgressBarColors(
                            playedColor: AppColors.softPeach,
                            handleColor: AppColors.drySage,
                          ),
                        )
                      : (widget.activity.imageUrl != null
                          ? Image.network(
                              widget.activity.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Image de secours si le lien est mort
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported, size: 50),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, size: 50, color: Colors.grey),
                            )),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Description :',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),

              // Conteneur de la description sans le Padding externe
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  widget.activity.content,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.black87,
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