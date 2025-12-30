import 'package:flutter/material.dart';

class EnhancedNotificationsScreen extends StatelessWidget {
  const EnhancedNotificationsScreen({super.key});

  final List<NotificationItem> _allNotifications = const [
    NotificationItem(
      karinderia: 'Maria Lopez',
      menu: 'Menudo',
      time: '6:40AM',
      isRead: false,
    ),
    NotificationItem(
      karinderia: 'Ibarado',
      menu: 'Adobo',
      time: '6:40AM',
      isRead: true,
    ),
    NotificationItem(
      karinderia: 'Maria Lopez',
      menu: 'Bihon',
      time: '6:40AM',
      isRead: true,
    ),
    NotificationItem(
      karinderia: 'Nora',
      menu: 'Linaga',
      time: '6:40AM',
      isRead: true,
    ),
    NotificationItem(
      karinderia: 'Nora',
      menu: 'Tinola',
      time: '6:40AM',
      isRead: true,
    ),
    NotificationItem(
      karinderia: 'Maria Lopez',
      menu: 'Pochero',
      time: '6:40AM',
      isRead: true,
    ),
    NotificationItem(
      karinderia: 'Maria Lopez',
      menu: 'Mongo',
      time: '6:40AM',
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        titleSpacing: 0,
        title: const Text('Notifications', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          _buildHeaderRow(),
          const SizedBox(height: 8),
          Expanded(child: _buildNotificationsList()),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('View History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text('Read All', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return ListView.builder(
      itemCount: _allNotifications.length,
      itemBuilder: (context, index) {
        final notification = _allNotifications[index];
        final isUnread = !notification.isRead;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUnread ? const Color(0xFFFFF9E6) : const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=120&q=80',
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.2),
                        children: [
                          TextSpan(text: '${notification.karinderia} has '),
                          TextSpan(
                            text: notification.menu,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const TextSpan(text: ' available'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification.time,
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.close, size: 22, color: Colors.black87),
              ),
            ],
          ),
        );
      },
    );
  }
}

class NotificationItem {
  final String karinderia;
  final String menu;
  final String time;
  final bool isRead;

  const NotificationItem({
    required this.karinderia,
    required this.menu,
    required this.time,
    this.isRead = false,
  });
}