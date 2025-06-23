import 'package:flutter/material.dart';

class NotificationStatsWidget extends StatelessWidget {
  final dynamic stats;
  final DateTime? lastUpdated;
  final List<String>? recommendations;
  final String? periodDescription;
  final (
  dynamic,
  dynamic,
  dynamic
  )? comparison;

  const NotificationStatsWidget({
    super.key,
    required this.stats,
    this.lastUpdated,
    this.recommendations,
    this.periodDescription,
    this.comparison,
  });

  @override
  Widget build(BuildContext context) {
    // You can adjust this widget structure to match your stats model.
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (periodDescription != null)
            Text(
              periodDescription!,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          if (lastUpdated != null)
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 14),
              child: Text(
                'Last updated: ${_friendlyTime(lastUpdated!)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          _StatTiles(stats: stats, comparison: comparison),
          if (recommendations != null && recommendations!.isNotEmpty) ...[
            const Divider(height: 32),
            const Text(
              "Recommendations",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            ...recommendations!.map((r) => Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(r, style: const TextStyle(fontSize: 14))),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  String _friendlyTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _StatTiles extends StatelessWidget {
  final dynamic stats;
  final (
  dynamic,
  dynamic,
  dynamic
  )? comparison;

  const _StatTiles({
    required this.stats,
    this.comparison,
  });

  @override
  Widget build(BuildContext context) {
    // You should adapt these to your actual stats structure.
    final total = stats?['total'] ?? 0;
    final unread = stats?['unread'] ?? 0;
    final urgent = stats?['urgent'] ?? 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _statCard('Total', total, Icons.notifications_active_outlined, Colors.blue),
        _statCard('Unread', unread, Icons.mark_email_unread_outlined, Colors.orange),
        _statCard('Urgent', urgent, Icons.priority_high, Colors.redAccent),
        if (comparison != null)
          _statCard(
            'Δ',
            comparison!.$3 ?? '-',
            Icons.trending_up,
            Colors.green,
            comparison: true,
          ),
      ],
    );
  }

  Widget _statCard(
      String label,
      dynamic value,
      IconData icon,
      Color color, {
        bool comparison = false,
      }) {
    return Card(
      color: comparison ? Colors.green[50] : null,
      child: SizedBox(
        width: 80,
        height: 76,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 27),
            const SizedBox(height: 6),
            Text(
              value.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}