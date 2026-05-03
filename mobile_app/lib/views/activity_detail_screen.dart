import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Nouvel import pour le coffre-fort
import '../models/activity.dart';
import '../services/favorite_service.dart';
import '../ui/widgets/page_layout.dart';
import '../ui/widgets/widgets.dart';
import '../ui/theme.dart';

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

  // Variables pour les favoris et l'utilisateur
  final FavoriteService _favoriteService = FavoriteService();
  bool _isFavorite = false;
  bool _isLoadingFavorite = true;
  
  final _storage = const FlutterSecureStorage(); // Instance du coffre-fort
  int? _userId; // Variable dynamique, vide au départ

  @override
  void initState() {
    super.initState();

    // 1. On cherche d'abord qui est l'utilisateur connecté
    _initializeUserData();

    // 2. Préparation du lecteur vidéo
    if (widget.activity.activityUrl != null &&
        widget.activity.activityUrl!.isNotEmpty) {
      final videoId = YoutubePlayer.convertUrlToId(widget.activity.activityUrl!);

      if (videoId != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            isLive: false,
          ),
        )..addListener(_listener);
      }
    }
  }

  // Nouvelle fonction pour lire le coffre-fort
  void _initializeUserData() async {
    // ⚠️ ATTENTION ICI : Assure-toi que 'userId' est bien la clé que tu utilises lors du login
    String? storedId = await _storage.read(key: 'userId'); 

    if (storedId != null && mounted) {
      setState(() {
        _userId = int.tryParse(storedId);
      });
      // Maintenant que nous avons le vrai ID, on charge le statut
      if (_userId != null) {
        _loadFavoriteStatus();
      }
    } else {
      // Personne n'est connecté
      if (mounted) {
        setState(() => _isLoadingFavorite = false);
      }
    }
  }

  // Fonction pour vérifier le statut de favori
  void _loadFavoriteStatus() async {
    // _userId est garanti non nul ici grâce à la vérification précédente
    final isFav = await _favoriteService.checkIsFavorite(_userId!, widget.activity.idActivity);
    
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
        _isLoadingFavorite = false;
      });
    }
  }

  // Fonction pour gérer le clic
  void _toggleFavorite() async {
    // Sécurité : on bloque si l'utilisateur n'est pas identifié
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez vous connecter pour ajouter aux favoris')),
      );
      return;
    }

    setState(() {
      _isFavorite = !_isFavorite;
    });

    final result = await _favoriteService.toggleFavorite(_userId!, widget.activity.idActivity);

    if (mounted && result != _isFavorite) {
      setState(() {
        _isFavorite = result;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur réseau')),
      );
    }
  }

  void _listener() {}

  @override
  void deactivate() {
    _youtubeController?.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasVideo = _youtubeController != null;

    return Scaffold(
      appBar: CustomFullAppBar(
        title: widget.activity.title,
        trailingIcon: _isLoadingFavorite
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.softPeach),
              )
            : GestureDetector(
                onTap: _toggleFavorite,
                child: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: AppColors.softPeach,
                  size: 26,
                ),
              ),
      ),
      body: PageLayout(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
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
                    ]),
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
                'Description',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 15),
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