import 'package:flutter/material.dart';

void main() {
  runApp(const EnhancedNotificationsApp());
}

class EnhancedNotificationsApp extends StatelessWidget {
  const EnhancedNotificationsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notifications',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const EnhancedNotificationsScreen(),
    );
  }
}

class EnhancedNotificationsScreen extends StatefulWidget {
  const EnhancedNotificationsScreen({super.key});

  @override
  State<EnhancedNotificationsScreen> createState() => _EnhancedNotificationsScreenState();
}

class _EnhancedNotificationsScreenState extends State<EnhancedNotificationsScreen> {
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
    final unreadCount = _allNotifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          if (unreadCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Badge(
                label: Text(unreadCount.toString()),
                backgroundColor: Colors.orange,
                child: Icon(
                  Icons.notifications,
                  color: Colors.grey[600],
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Header with filter options
          _buildHeaderSection(),
          
          // Notifications List
          Expanded(
            child: _buildNotificationsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'View History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list, color: Colors.grey[600]),
            onSelected: (value) {
              // Handle filter selection
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All Notifications')),
              const PopupMenuItem(value: 'unread', child: Text('Unread Only')),
              const PopupMenuItem(value: 'today', child: Text('Today Only')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return ListView.builder(
      itemCount: _allNotifications.length,
      itemBuilder: (context, index) {
        final notification = _allNotifications[index];
        return Dismissible(
          key: Key('${notification.karinderia}-${notification.menu}-${notification.time}'),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          secondaryBackground: Container(
            color: Colors.orange,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.archive, color: Colors.white),
          ),
          onDismissed: (direction) {
            // Handle dismiss actions
          },
          child: _buildNotificationItem(notification),
        );
      },
    );
  }

  Widget _buildNotificationItem(NotificationItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: item.isRead ? Colors.transparent : Colors.orange.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: item.isRead ? Colors.grey[100] : Colors.orange[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.restaurant,
            color: item.isRead ? Colors.grey[400] : Colors.orange[500],
            size: 20,
          ),
        ),
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              fontWeight: item.isRead ? FontWeight.normal : FontWeight.w600,
            ),
            children: [
              TextSpan(
                text: item.karinderia,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const TextSpan(text: ' has '),
              TextSpan(
                text: item.menu,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.orange[600],
                ),
              ),
              const TextSpan(text: ' available'),
            ],
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Icon(
                Icons.access_time,
                size: 12,
                color: Colors.grey[400],
              ),
              const SizedBox(width: 4),
              Text(
                item.time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              if (!item.isRead) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange[500],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'New',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.grey[400],
          size: 20,
        ),
        onTap: () {
          // Mark as read and show details
          _showNotificationDetails(context, item);
        },
      ),
    );
  }

  void _showNotificationDetails(BuildContext context, NotificationItem item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.restaurant,
                    color: Colors.orange[500],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.karinderia,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Updated at ${item.time}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'New Menu Available',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange[100]!),
              ),
              child: Text(
                item.menu,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to order page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[500],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Order Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
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