import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:animate_do/animate_do.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FadeInDown(
          child: const Text(
            "Notifications",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          FadeInRight(
            child: IconButton(
              onPressed: () {},
              icon: const Icon(LucideIcons.bellOff),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FadeInLeft(
              delay: const Duration(milliseconds: 200),
              child: const Text(
                "Recent Activities",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              5,
              (index) => FadeInUp(
                delay: Duration(milliseconds: 300 + (index * 100)),
                child: _buildNotificationCard(context, index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, int index) {
    final notifications = [
      {
        "title": "Blood Donation Reminder",
        "message": "You're eligible to donate blood again in 3 days",
        "time": "2 hours ago",
        "icon": LucideIcons.droplet,
        "color": Colors.redAccent,
      },
      {
        "title": "New Blood Request",
        "message": "Urgent need for B+ blood at National Hospital",
        "time": "5 hours ago",
        "icon": LucideIcons.alertCircle,
        "color": Colors.orangeAccent,
      },
      {
        "title": "Donation Approved",
        "message": "Your last donation has been processed successfully",
        "time": "1 day ago",
        "icon": LucideIcons.checkCircle,
        "color": Colors.green,
      },
      {
        "title": "Campaign Update",
        "message": "New blood donation camp in your area next week",
        "time": "2 days ago",
        "icon": LucideIcons.megaphone,
        "color": Colors.blueAccent,
      },
      {
        "title": "Profile Updated",
        "message": "Your health information has been successfully updated",
        "time": "3 days ago",
        "icon": LucideIcons.userCheck,
        "color": Colors.purpleAccent,
      },
    ];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: notifications[index]["color"] as Color? ?? Colors.redAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                notifications[index]["icon"] as IconData? ?? LucideIcons.bell,
                color: notifications[index]["color"] as Color? ?? Colors.redAccent,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notifications[index]["title"] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notifications[index]["message"] as String,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notifications[index]["time"] as String,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}