import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:animate_do/animate_do.dart';

class BloodBanksPage extends StatelessWidget {
  const BloodBanksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FadeInDown(
          child: const Text(
            "Blood Banks",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInLeft(
              delay: const Duration(milliseconds: 200),
              child: const Text(
                "Find blood banks",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            FadeInRight(
              delay: const Duration(milliseconds: 300),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search by location...",
                  prefixIcon: const Icon(LucideIcons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeInLeft(
              delay: const Duration(milliseconds: 400),
              child: const Text(
                "Nearby Blood Banks",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              4,
              (index) => FadeInUp(
                delay: Duration(milliseconds: 500 + (index * 100)),
                child: _buildBloodBankCard(context, index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBloodBankCard(BuildContext context, int index) {
    final banks = [
      {
        "name": "National Blood Center",
        "address": "Colombo 05",
        "distance": "2.5km",
        "status": "Open",
        "statusColor": Colors.green,
      },
      {
        "name": "Red Cross Blood Bank",
        "address": "Narahenpita",
        "distance": "3.1km",
        "status": "Open",
        "statusColor": Colors.green,
      },
      {
        "name": "Lanka Hospitals Blood Bank",
        "address": "Colombo 02",
        "distance": "4.7km",
        "status": "Closed",
        "statusColor": Colors.red,
      },
      {
        "name": "Asiri Central Blood Bank",
        "address": "Colombo 05",
        "distance": "2.8km",
        "status": "Open until 6PM",
        "statusColor": Colors.orange,
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
                color: Colors.redAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.droplet,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    banks[index]["name"] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    banks[index]["address"] as String,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.mapPin,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        banks[index]["distance"] as String,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (banks[index]["statusColor"] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          banks[index]["status"] as String,
                          style: TextStyle(
                            color: banks[index]["statusColor"] as Color,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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