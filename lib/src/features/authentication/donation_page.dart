import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:animate_do/animate_do.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _centers = [];
  List<Map<String, dynamic>> _filteredCenters = [];
  bool _isLoading = true;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchDonationCenters();
    _searchController.addListener(_filterCenters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _fetchDonationCenters() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('donationCenters')
          .orderBy('name')
          .get();

      List<Map<String, dynamic>> centers = [];
      for (var doc in querySnapshot.docs) {
        centers.add({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }

      if (mounted) {
        setState(() {
          _centers = centers;
          _filteredCenters = centers;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading centers: ${e.toString()}')),
        );
      }
    }
  }

  void _filterCenters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCenters = _centers.where((center) {
        final name = center['name'].toString().toLowerCase();
        final address = center['address'].toString().toLowerCase();
        return name.contains(query) || address.contains(query);
      }).toList();
    });
  }

  Future<void> _launchMaps(double lat, double lng) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch maps')),
        );
      }
    }
  }

  Future<void> _launchPhone(String phone) async {
    final url = 'tel:$phone';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch phone')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FadeInDown(
          child: const Text(
            "Donate Blood",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInLeft(
                    delay: const Duration(milliseconds: 200),
                    child: const Text(
                      "Find a donation center",
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
                      controller: _searchController,
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
                      "Nearby Centers",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_filteredCenters.isEmpty)
                    FadeInUp(
                      child: const Center(
                        child: Text("No centers found"),
                      ),
                    ),
                  ...List.generate(
                    _filteredCenters.length,
                    (index) => FadeInUp(
                      delay: Duration(milliseconds: 500 + (index * 100)),
                      child: _buildDonationCenterCard(context, index),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDonationCenterCard(BuildContext context, int index) {
    final center = _filteredCenters[index];
    final distance = _currentPosition != null && center['location'] != null
        ? _calculateDistance(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            center['location'].latitude,
            center['location'].longitude,
          )
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
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
                        center['name'] ?? 'Unknown Center',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        center['address'] ?? 'Address not available',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (distance != null)
                        Row(
                          children: [
                            Icon(
                              LucideIcons.mapPin,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${distance.toStringAsFixed(1)} km away',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 4),
                      Text(
                        _getOpeningHours(center),
                        style: TextStyle(
                          color: _isOpenNow(center) 
                              ? Colors.green.shade600 
                              : Colors.red.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _showCenterDetails(center),
                  icon: const Icon(LucideIcons.chevronRight),
                ),
              ],
            ),
            if (center['phone'] != null || center['location'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (center['phone'] != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(LucideIcons.phone, size: 16),
                          label: const Text('Call'),
                          onPressed: () => _launchPhone(center['phone']),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    if (center['location'] != null)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: OutlinedButton.icon(
                            icon: const Icon(LucideIcons.map, size: 16),
                            label: const Text('Directions'),
                            onPressed: () => _launchMaps(
                              center['location'].latitude,
                              center['location'].longitude,
                            ),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
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

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  String _getOpeningHours(Map<String, dynamic> center) {
    if (center['openingHours'] == null) return 'Hours not available';
    
    final now = DateTime.now();
    final weekday = now.weekday - 1; // Monday = 0, Sunday = 6
    final hours = center['openingHours'][weekday];
    
    if (hours == null || hours['open'] == null || hours['close'] == null) {
      return 'Closed today';
    }
    
    return 'Open ${hours['open']} - ${hours['close']}';
  }

  bool _isOpenNow(Map<String, dynamic> center) {
    if (center['openingHours'] == null) return false;
    
    final now = DateTime.now();
    final weekday = now.weekday - 1; // Monday = 0, Sunday = 6
    final time = TimeOfDay.fromDateTime(now);
    final hours = center['openingHours'][weekday];
    
    if (hours == null || hours['open'] == null || hours['close'] == null) {
      return false;
    }
    
    final openTime = _parseTime(hours['open']);
    final closeTime = _parseTime(hours['close']);
    
    return (time.hour > openTime.hour || 
            (time.hour == openTime.hour && time.minute >= openTime.minute)) &&
           (time.hour < closeTime.hour || 
            (time.hour == closeTime.hour && time.minute <= closeTime.minute));
  }

  TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  void _showCenterDetails(Map<String, dynamic> center) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                center['name'] ?? 'Unknown Center',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (center['address'] != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.mapPin, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          center['address'],
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    ],
                  ),
                ),
              if (center['phone'] != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.phone, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          center['phone'],
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    ],
                  ),
                ),
              if (center['website'] != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: InkWell(
                    onTap: () => launchUrl(Uri.parse(center['website'])),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.globe, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            center['website'],
                            style: TextStyle(
                              color: Colors.blue.shade600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              const Text(
                "Opening Hours",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              ...List.generate(7, (index) {
                final days = [
                  'Monday',
                  'Tuesday',
                  'Wednesday',
                  'Thursday',
                  'Friday',
                  'Saturday',
                  'Sunday'
                ];
                final hours = center['openingHours']?[index];
                final isToday = DateTime.now().weekday - 1 == index;
                
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          days[index],
                          style: TextStyle(
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                            color: isToday ? Colors.redAccent : Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          hours != null 
                              ? '${hours['open']} - ${hours['close']}'
                              : 'Closed',
                          style: TextStyle(
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                            color: isToday ? Colors.redAccent : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    if (center['location'] != null) {
                      _launchMaps(
                        center['location'].latitude,
                        center['location'].longitude,
                      );
                    }
                  },
                  child: const Text(
                    "Get Directions",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}