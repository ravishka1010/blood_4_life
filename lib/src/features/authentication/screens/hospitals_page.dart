import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:animate_do/animate_do.dart';

class HospitalsPage extends StatelessWidget {
  const HospitalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FadeInDown(
          child: const Text(
            "Hospitals",
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
                "Find hospitals",
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
                "Nearby Hospitals",
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
                child: _buildHospitalCard(context, index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHospitalCard(BuildContext context, int index) {
    final hospitals = [
      {
        "name": "National Hospital",
        "address": "Colombo 10",
        "distance": "3.2km",
        "type": "Government",
      },
      {
        "name": "Nawaloka Hospital",
        "address": "Colombo 02",
        "distance": "4.5km",
        "type": "Private",
      },
      {
        "name": "Asiri Surgical Hospital",
        "address": "Colombo 05",
        "distance": "2.8km",
        "type": "Private",
      },
      {
        "name": "Lanka Hospitals",
        "address": "Colombo 02",
        "distance": "4.7km",
        "type": "Private",
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
                color: Colors.blueAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_hospital,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hospitals[index]["name"] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hospitals[index]["address"] as String,
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
                        hospitals[index]["distance"] as String,
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
                          color: hospitals[index]["type"] == "Government"
                              ? Colors.green.withOpacity(0.1)
                              : Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          hospitals[index]["type"] as String,
                          style: TextStyle(
                            color: hospitals[index]["type"] == "Government"
                                ? Colors.green
                                : Colors.blue,
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