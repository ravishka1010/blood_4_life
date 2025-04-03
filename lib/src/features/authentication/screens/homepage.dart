import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:blood4life/src/features/authentication/screens/donation_page.dart';
import 'package:blood4life/src/features/authentication/screens/find_donor_page.dart';
import 'package:blood4life/src/features/authentication/screens/bloodbanks_page.dart';
import 'package:blood4life/src/features/authentication/screens/hospitals_page.dart';
import 'package:blood4life/src/features/authentication/screens/notifications_page.dart';
import 'package:blood4life/src/features/authentication/screens/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final DocumentSnapshot doc = 
            await _firestore.collection('users').doc(user.uid).get();
        
        if (doc.exists) {
          setState(() {
            _userData = doc.data() as Map<String, dynamic>;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading profile: ${e.toString()}")),
        );
      }
    }
  }

  String _getNextDonationDate() {
    if (_userData?['lastDonation'] == null) return "Now eligible";
    
    final lastDonation = DateTime.parse(_userData!['lastDonation']);
    final nextDonation = lastDonation.add(const Duration(days: 56)); // 8 weeks
    final now = DateTime.now();
    
    if (nextDonation.isBefore(now)) return "Now eligible";
    
    final difference = nextDonation.difference(now).inDays;
    return "Due in $difference days";
  }

  double _getDonationProgress() {
    if (_userData?['lastDonation'] == null) return 0.0;
    
    final lastDonation = DateTime.parse(_userData!['lastDonation']);
    final nextDonation = lastDonation.add(const Duration(days: 56));
    final now = DateTime.now();
    
    if (nextDonation.isBefore(now)) return 1.0;
    
    final totalDays = 56;
    final daysPassed = now.difference(lastDonation).inDays;
    return daysPassed / totalDays;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: FadeInDown(
          duration: const Duration(milliseconds: 500),
          child: const Text(
            "Home", 
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              FadeInLeft(
                duration: const Duration(milliseconds: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, ${_userData?['name'] ?? 'User'}!", 
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "What would you like to do today?",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Main Grid
              Expanded(
                child: AnimationLimiter(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 500),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                      children: [
                        _buildModernActionCard(
                          context,
                          title: "Donate Blood",
                          icon: LucideIcons.droplet,
                          color: Colors.redAccent,
                          onTap: () => _navigateWithTransition(context, '/donate'),
                        ),
                        _buildModernActionCard(
                          context,
                          title: "Find Donor",
                          icon: LucideIcons.search,
                          color: Colors.blueAccent,
                          onTap: () => _navigateWithTransition(context, '/findDonor'),
                        ),
                        _buildModernActionCard(
                          context,
                          title: "Blood Banks",
                          icon: LucideIcons.heartPulse,
                          color: Colors.orangeAccent,
                          onTap: () => _navigateWithTransition(context, '/bloodBanks'),
                        ),
                        _buildModernActionCard(
                          context,
                          title: "Hospitals",
                          icon: LucideIcons.building,
                          color: Colors.greenAccent,
                          onTap: () => _navigateWithTransition(context, '/hospitals'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Donation Progress Card
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                child: _buildModernDonationCard(context),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildModernBottomNavBar(context),
    );
  }

  Widget _buildModernBottomNavBar(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 700),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        child: BottomNavigationBar(
          currentIndex: 0,
          selectedItemColor: Colors.redAccent,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 8,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.heartHandshake),
              label: "Donations",
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.users),
              label: "Find Donors",
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.bell),
              label: "Notifications",
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.user),
              label: "Profile",
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushNamedAndRemoveUntil(
                  context, 
                  '/home', 
                  (route) => false
                );
                break;
              case 1:
                _navigateWithTransition(context, '/donate');
                break;
              case 2:
                _navigateWithTransition(context, '/findDonor');
                break;
              case 3:
                _navigateWithTransition(context, '/notifications');
                break;
              case 4:
                _navigateWithTransition(context, '/profile');
                break;
            }
          },
        ),
      ),
    );
  }

  Widget _buildModernActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernDonationCard(BuildContext context) {
    final nextDonationText = _getNextDonationDate();
    final progress = _getDonationProgress();
    final daysLeft = progress == 1.0 
        ? "Eligible now" 
        : "${(56 * (1 - progress)).round()} days left";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Next Donation",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  nextDonationText,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(8),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                daysLeft,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
              Text(
                "56 days total",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateWithTransition(BuildContext context, String routeName) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          switch (routeName) {
            case '/donate':
              return const DonationPage();
            case '/findDonor':
              return const FindDonorPage();
            case '/bloodBanks':
              return const BloodBanksPage();
            case '/hospitals':
              return const HospitalsPage();
            case '/notifications':
              return const NotificationsPage();
            case '/profile':
              return const ProfilePage();
            default:
              return const HomePage();
          }
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }
}