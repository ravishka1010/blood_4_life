import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:animate_do/animate_do.dart';

class FindDonorPage extends StatelessWidget {
  const FindDonorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FadeInDown(
          child: const Text(
            "Find a Donor",
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
                "Search for donors",
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
                  hintText: "Search by blood type or location...",
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
                "Filter by Blood Type",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              child: SizedBox(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    BloodTypeChip(type: "A+"),
                    SizedBox(width: 8),
                    BloodTypeChip(type: "A-"),
                    SizedBox(width: 8),
                    BloodTypeChip(type: "B+"),
                    SizedBox(width: 8),
                    BloodTypeChip(type: "B-"),
                    SizedBox(width: 8),
                    BloodTypeChip(type: "AB+"),
                    SizedBox(width: 8),
                    BloodTypeChip(type: "AB-"),
                    SizedBox(width: 8),
                    BloodTypeChip(type: "O+"),
                    SizedBox(width: 8),
                    BloodTypeChip(type: "O-"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeInLeft(
              delay: const Duration(milliseconds: 600),
              child: const Text(
                "Available Donors",
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
                delay: Duration(milliseconds: 700 + (index * 100)),
                child: _buildDonorCard(context, index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonorCard(BuildContext context, int index) {
    final donors = [
      {"name": "John D.", "blood": "A+", "distance": "2.5km", "last": "2 weeks ago"},
      {"name": "Sarah M.", "blood": "B-", "distance": "3.1km", "last": "1 month ago"},
      {"name": "Robert L.", "blood": "O+", "distance": "1.8km", "last": "3 weeks ago"},
      {"name": "Emma S.", "blood": "AB+", "distance": "4.2km", "last": "2 months ago"},
      {"name": "David K.", "blood": "A-", "distance": "5.0km", "last": "1 week ago"},
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
                LucideIcons.user,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    donors[index]["name"] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          donors[index]["blood"] as String,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${donors[index]["distance"]} away",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Last donated ${donors[index]["last"]}",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(LucideIcons.messageSquare),
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}

class BloodTypeChip extends StatelessWidget {
  final String type;

  const BloodTypeChip({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(type),
      selected: type == "A+",
      selectedColor: Colors.redAccent,
      labelStyle: TextStyle(
        color: type == "A+" ? Colors.white : Colors.black,
      ),
      onSelected: (bool selected) {},
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}