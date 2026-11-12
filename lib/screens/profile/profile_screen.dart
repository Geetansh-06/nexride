import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../activities/my_activities_screen.dart';
import '../offer_ride/my_published_rides_screen.dart';
import '../offer_driver/my_published_driver_services_screen.dart';
import 'personal_information_screen.dart';
import 'my_vehicles_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'NexRide User';
  String userEmail = 'user@example.com';
  String userPhone = 'Not added';

  void _openScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Future<void> _openPersonalInformation() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalInformationScreen(
          initialName: userName,
          initialEmail: userEmail,
          initialPhone: userPhone,
        ),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      userName = result['name'] ?? userName;
      userEmail = result['email'] ?? userEmail;
      userPhone = result['phone'] ?? userPhone;
    });
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: AppColors.primary.withValues(alpha: 0.18),
            child: const Icon(
              Icons.person_rounded,
              size: 43,
              color: AppColors.primaryLight,
            ),
          ),
          const SizedBox(height: 13),
          Text(
            userName,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            userEmail,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userPhone,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 25),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        leading: Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryLight,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: AppColors.textSecondary,
          size: 15,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showComingSoon(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title will be available soon.'),
        backgroundColor: AppColors.surface,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),

              _buildSectionTitle('My Account'),

              _buildMenuItem(
                icon: Icons.person_outline_rounded,
                title: 'Personal Information',
                subtitle: 'View and manage your profile',
                onTap: _openPersonalInformation,
              ),

              _buildMenuItem(
                icon: Icons.directions_car_outlined,
                title: 'My Vehicles',
                subtitle: 'Manage your vehicle information',
                onTap: () => _openScreen(
                  const MyVehiclesScreen(),
                ),
              ),

              _buildSectionTitle('My Services'),

              _buildMenuItem(
                icon: Icons.event_note_outlined,
                title: 'My Activities',
                subtitle: 'View your bookings and activities',
                onTap: () => _openScreen(
                  const MyActivitiesScreen(),
                ),
              ),

              _buildMenuItem(
                icon: Icons.directions_car_filled_outlined,
                title: 'My Published Rides',
                subtitle: 'Manage your published rides',
                onTap: () => _openScreen(
                  const MyPublishedRidesScreen(),
                ),
              ),

              _buildMenuItem(
                icon: Icons.badge_outlined,
                title: 'My Driver Services',
                subtitle: 'Manage your driver services',
                onTap: () => _openScreen(
                  const MyPublishedDriverServicesScreen(),
                ),
              ),

              _buildSectionTitle('Support'),

              _buildMenuItem(
                icon: Icons.help_outline_rounded,
                title: 'Help & Support',
                subtitle: 'Get help with NexRide',
                onTap: () => _showComingSoon('Help & Support'),
              ),

              _buildMenuItem(
                icon: Icons.info_outline_rounded,
                title: 'About NexRide',
                subtitle: 'Learn more about NexRide',
                onTap: () => _showComingSoon('About NexRide'),
              ),

              _buildSectionTitle('Account'),

              _buildMenuItem(
                icon: Icons.logout_rounded,
                title: 'Logout',
                subtitle: 'Sign out of your account',
                onTap: () => _showComingSoon('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}