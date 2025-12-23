import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/workshop.dart';
import '../../services/workshop_experience_service.dart';
import '../../services/workshop_review_service.dart';

class WorkshopDetailScreen extends StatefulWidget {
  final Workshop workshop;

  const WorkshopDetailScreen({
    super.key,
    required this.workshop,
  });

  @override
  State<WorkshopDetailScreen> createState() =>
      _WorkshopDetailScreenState();
}

class _WorkshopDetailScreenState
    extends State<WorkshopDetailScreen> {
  final _experienceService = WorkshopExperienceService();
  final _reviewService = WorkshopReviewService();

  final Map<String, String> workshopTags = {
    'ja_usei': '🔧 Já usei',
    'orcamento_justo': '🧾 Orçamento justo',
    'cumpre_prazo': '🕒 Cumpre prazo',
    'confianca': '🤝 Confiança',
  };

  Map<String, int> tagCounts = {};
  Set<String> userTags = {};

  double avgRating = 0.0;
  int reviewsCount = 0;
  List<Map<String, dynamic>> reviews = [];

  bool get isLogged =>
      Supabase.instance.client.auth.currentUser != null;

  String? get userId =>
      Supabase.instance.client.auth.currentUser?.id;

  @override
  void initState() {
    super.initState();
    _loadTags();
    _loadRating();
    _loadReviews();
  }

  // ================= TAGS =================

  Future<void> _loadTags() async {
    final data =
        await _experienceService.fetchTags(widget.workshop.id);

    final counts = <String, int>{};
    final mine = <String>{};

    for (final row in data) {
      final tag = row['tag'] as String;
      counts[tag] = (counts[tag] ?? 0) + 1;

      if (row['user_id'] == userId) {
        mine.add(tag);
      }
    }

    setState(() {
      tagCounts = counts;
      userTags = mine;
    });
  }

  Future<void> _toggleTag(String tag) async {
    if (!isLogged || userId == null) {
      _openLoginCTA();
      return;
    }

    if (userTags.contains(tag)) {
      await _experienceService.removeTag(
        workshopId: widget.workshop.id,
        tag: tag,
        userId: userId!,
      );
    } else {
      await _experienceService.addTag(
        workshopId: widget.workshop.id,
        tag: tag,
        userId: userId!,
      );
    }

    _loadTags();
  }

  // ================= RATING =================

  Future<void> _loadRating() async {
    final data = await _reviewService
        .fetchRatingSummary(widget.workshop.id);

    if (data != null) {
      setState(() {
        avgRating = (data['avg_rating'] as num).toDouble();
        reviewsCount = data['total_reviews'] as int;
      });
    } else {
      setState(() {
        avgRating = 0.0;
        reviewsCount = 0;
      });
    }
  }

  Future<void> _loadReviews() async {
    final data =
        await _reviewService.fetchReviews(widget.workshop.id);

    setState(() {
      reviews = data;
    });
  }

  // ================= REVIEW MODAL =================

  void _openReviewSheet() {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      _openLoginCTA();
      return;
    }

    int selectedRating = 5;
    final commentCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom:
                  MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Avaliar oficina',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    return IconButton(
                      icon: Icon(
                        i < selectedRating
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.orange,
                      ),
                      onPressed: () {
                        setModalState(() {
                          selectedRating = i + 1;
                        });
                      },
                    );
                  }),
                ),

                TextField(
                  controller: commentCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Comentário (opcional)',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () async {
                    await _reviewService.upsertReview(
                      workshopId: widget.workshop.id,
                      userId: user.id,
                      rating: selectedRating,
                      comment: commentCtrl.text.trim().isEmpty
                          ? null
                          : commentCtrl.text.trim(),
                    );

                    Navigator.pop(context);
                    await _loadRating();
                    await _loadReviews();
                  },
                  child: const Text('Salvar avaliação'),
                ),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  // ================= CTA =================

  void _openLoginCTA() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Entre para interagir',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Avalie e compartilhe sua experiência.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text('Entrar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                          context, '/register');
                    },
                    child: const Text('Criar conta'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.workshop.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              widget.workshop.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.workshop.type} • ${widget.workshop.neighborhood}',
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange),
                const SizedBox(width: 4),
                Text(avgRating.toStringAsFixed(1)),
                const SizedBox(width: 8),
                Text('($reviewsCount avaliações)'),
                const Spacer(),
                TextButton(
                  onPressed: _openReviewSheet,
                  child: const Text('Avaliar'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Experiência dos usuários',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: workshopTags.entries.map((e) {
                final tag = e.key;
                final label = e.value;
                final count = tagCounts[tag] ?? 0;

                return ChoiceChip(
                  label: Text('$label ($count)'),
                  selected: userTags.contains(tag),
                  selectedColor: Colors.green.shade300,
                  onSelected: (_) => _toggleTag(tag),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            if (reviews.isNotEmpty) ...[
              const Text(
                'Comentários',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              for (final r in reviews)
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.star,
                      color: Colors.orange,
                    ),
                    title: Text('${r['rating']} estrelas'),
                    subtitle: Text(r['comment'] ?? ''),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
