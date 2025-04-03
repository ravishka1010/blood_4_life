import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConfirmProfileScreen extends StatefulWidget {
  const ConfirmProfileScreen({super.key});

  @override
  State<ConfirmProfileScreen> createState() => _ConfirmProfileScreenState();
}

class _ConfirmProfileScreenState extends State<ConfirmProfileScreen> {
  String? _selectedGender;
  String? _selectedBloodType;
  final List<String> bloodTypes = ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"];
  bool _isLoading = false;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _saveProfileData() async {
    if (_selectedGender == null || _selectedBloodType == null) return;

    setState(() => _isLoading = true);

    try {
      final User? user = _auth.currentUser;
      
      if (user != null) {
        // Create or update user document in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'gender': _selectedGender,
          'bloodType': _selectedBloodType,
          'completedProfile': true,
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        // Navigate to home after successful save
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context, 
            '/home', 
            (route) => false
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Your Profile"),
        backgroundColor: colorScheme.primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            FadeInDown(
              duration: const Duration(milliseconds: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Let's complete your profile",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "This information will help us match you with those in need",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Gender Selection
            FadeInLeft(
              duration: const Duration(milliseconds: 600),
              child: const Text(
                "Select Gender",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            FadeInRight(
              duration: const Duration(milliseconds: 600),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _genderButton("Male", Icons.male),
                  _genderButton("Female", Icons.female),
                  _genderButton("Other", Icons.transgender),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Blood Type Selection
            FadeInLeft(
              duration: const Duration(milliseconds: 700),
              child: const Text(
                "Select Your Blood Type",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            FadeInRight(
              duration: const Duration(milliseconds: 700),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: bloodTypes.map((type) => _bloodTypeButton(type)).toList(),
              ),
            ),
            const SizedBox(height: 40),

            // Rh Factor Info
            FadeInUp(
              duration: const Duration(milliseconds: 800),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Rh factor is important for blood compatibility. "
                        "Positive (+) can receive both + and -, while "
                        "negative (-) can only receive -.",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Confirm Button
            FadeInUp(
              duration: const Duration(milliseconds: 900),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    elevation: 2,
                  ),
                  onPressed: _selectedGender == null || _selectedBloodType == null
                      ? null
                      : _saveProfileData,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Confirm & Continue",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _genderButton(String gender, IconData icon) {
    final isSelected = _selectedGender == gender;
    final theme = Theme.of(context);
    
    return ElasticIn(
      duration: const Duration(milliseconds: 400),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedGender = gender;
          });
        },
        child: Container(
          width: 100,
          height: 48,
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
            border: Border.all(
              color: isSelected 
                  ? theme.colorScheme.primary 
                  : theme.dividerColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, 
                  color: isSelected 
                      ? theme.colorScheme.onPrimary 
                      : theme.colorScheme.onSurface),
              const SizedBox(width: 4),
              Text(
                gender,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected 
                      ? theme.colorScheme.onPrimary 
                      : theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bloodTypeButton(String type) {
    final isSelected = _selectedBloodType == type;
    final theme = Theme.of(context);
    
    return ElasticIn(
      duration: const Duration(milliseconds: 400),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedBloodType = type;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
            border: Border.all(
              color: isSelected 
                  ? theme.colorScheme.primary 
                  : theme.dividerColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            type,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected 
                  ? theme.colorScheme.onPrimary 
                  : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}