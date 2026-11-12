import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/driver_booking_store.dart';
import '../../services/driver_service_store.dart';
import '../../services/ride_store.dart';
import '../../services/ride_booking_store.dart';

import '../find_ride/find_ride_form_screen.dart';
import '../activities/my_activities_screen.dart';
import '../offer_ride/offer_ride_form_screen.dart';
import '../offer_ride/my_published_rides_screen.dart';
import '../offer_ride/incoming_ride_requests_screen.dart';
import '../offer_driver/offer_driver_form_screen.dart';
import '../offer_driver/incoming_driver_requests_screen.dart';
import '../offer_driver/my_published_driver_services_screen.dart';
import '../hire_driver/hire_driver_form_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> services = [
    {
      'title': 'Find a Ride',
      'subtitle': 'Travel together',
      'icon': Icons.search_rounded,
    },
    {
      'title': 'Offer a Ride',
      'subtitle': 'Share your seats',
      'icon': Icons.directions_car_rounded,
    },
    {
      'title': 'Offer Driver Service',
      'subtitle': 'Drive for customers',
      'icon': Icons.badge_outlined,
    },
    {
      'title': 'Hire a Driver',
      'subtitle': 'Book a personal driver',
      'icon': Icons.person_pin_circle_outlined,
    },
  ];

  // Open Services
  void _openService(String serviceName) {
    if (serviceName == 'Find a Ride') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FindRideFormScreen(),
        ),
      );
    } else if (serviceName == 'Offer a Ride') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OfferRideFormScreen(),
        ),
      );
    } else if (serviceName == 'Offer Driver Service') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OfferDriverFormScreen(),
        ),
      );
    } else if (serviceName == 'Hire a Driver') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HireDriverFormScreen(),
        ),
      );
    }
  }

  // Open Incoming Driver Requests
  void _openIncomingRequests() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const IncomingDriverRequestsScreen(),
      ),
    );
  }

  // Open Incoming Ride Requests
  void _openIncomingRideRequests() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const IncomingRideRequestsScreen(),
      ),
    );
  }

  // Open My Published Driver Services
  void _openMyPublishedServices() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyPublishedDriverServicesScreen(),
      ),
    );
  }

  // Open My Published Rides
  void _openMyPublishedRides() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyPublishedRidesScreen(),
      ),
    );
  }

  // Service Card
  Widget _buildServiceCard(Map<String, dynamic> service) {
    return InkWell(
      onTap: () => _openService(service['title'] as String),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                service['icon'] as IconData,
                color: AppColors.primaryLight,
                size: 25,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              service['title'] as String,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              service['subtitle'] as String,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Incoming Driver Requests Card
  Widget _buildIncomingRequestsCard() {
    return AnimatedBuilder(
      animation: DriverBookingStore.bookings,
      builder: (context, child) {
        final bookings = DriverBookingStore.bookings.value;

        final pendingCount = bookings
            .where((booking) => booking['status'] == 'Pending')
            .length;

        final acceptedCount = bookings
            .where((booking) => booking['status'] == 'Accepted')
            .length;

        final rejectedCount = bookings
            .where((booking) => booking['status'] == 'Rejected')
            .length;

        return InkWell(
          onTap: _openIncomingRequests,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.assignment_outlined,
                        color: AppColors.primaryLight,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Incoming Driver Requests',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'View and manage customer bookings',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.primaryLight,
                      size: 17,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    _buildRequestCount(
                      'Pending',
                      pendingCount,
                      Colors.orange,
                    ),
                    const SizedBox(width: 10),
                    _buildRequestCount(
                      'Accepted',
                      acceptedCount,
                      Colors.green,
                    ),
                    const SizedBox(width: 10),
                    _buildRequestCount(
                      'Rejected',
                      rejectedCount,
                      AppColors.error,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Incoming Ride Requests Card
  Widget _buildIncomingRideRequestsCard() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        RideBookingStore.bookings,
        RideStore.publishedRides,
      ]),
      builder: (context, child) {
        final bookings = RideBookingStore.bookings.value;

        final publishedRideIds = RideStore.publishedRides.value
            .map((ride) => ride['id'])
            .toSet();

        final incomingBookings = bookings.where((booking) {
          return publishedRideIds.contains(booking['rideId']);
        }).toList();

        final pendingCount = incomingBookings
            .where((booking) => booking['status'] == 'Pending')
            .length;

        final acceptedCount = incomingBookings
            .where((booking) => booking['status'] == 'Accepted')
            .length;

        final rejectedCount = incomingBookings
            .where((booking) => booking['status'] == 'Rejected')
            .length;

        return InkWell(
          onTap: _openIncomingRideRequests,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.directions_car_filled_outlined,
                        color: AppColors.primaryLight,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Incoming Ride Requests',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Manage requests for your published rides',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.primaryLight,
                      size: 17,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    _buildRequestCount(
                      'Pending',
                      pendingCount,
                      Colors.orange,
                    ),
                    const SizedBox(width: 10),
                    _buildRequestCount(
                      'Accepted',
                      acceptedCount,
                      Colors.green,
                    ),
                    const SizedBox(width: 10),
                    _buildRequestCount(
                      'Rejected',
                      rejectedCount,
                      AppColors.error,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // My Published Rides Card
  Widget _buildMyPublishedRidesCard() {
    return AnimatedBuilder(
      animation: RideStore.publishedRides,
      builder: (context, child) {
        final rides = RideStore.publishedRides.value;

        final activeCount = rides
            .where((ride) => ride['isActive'] == true)
            .length;

        final inactiveCount = rides.length - activeCount;

        return InkWell(
          onTap: _openMyPublishedRides,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.directions_car_outlined,
                        color: AppColors.primaryLight,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Published Rides',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Manage your published rides',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.primaryLight,
                      size: 17,
                    ),
                  ],
                ),
                const SizedBox(height: 17),
                Row(
                  children: [
                    _buildRequestCount(
                      'Total',
                      rides.length,
                      AppColors.primaryLight,
                    ),
                    const SizedBox(width: 10),
                    _buildRequestCount(
                      'Active',
                      activeCount,
                      Colors.green,
                    ),
                    const SizedBox(width: 10),
                    _buildRequestCount(
                      'Inactive',
                      inactiveCount,
                      Colors.orange,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // My Published Driver Services Card
  Widget _buildMyPublishedServicesCard() {
    return AnimatedBuilder(
      animation: DriverServiceStore.publishedServices,
      builder: (context, child) {
        final services = DriverServiceStore.publishedServices.value;

        final activeCount = services
            .where((service) => service['isActive'] == true)
            .length;

        final inactiveCount = services.length - activeCount;

        return InkWell(
          onTap: _openMyPublishedServices,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.badge_outlined,
                        color: AppColors.primaryLight,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Published Driver Services',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Manage your published services',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.primaryLight,
                      size: 17,
                    ),
                  ],
                ),
                const SizedBox(height: 17),
                Row(
                  children: [
                    _buildRequestCount(
                      'Total',
                      services.length,
                      AppColors.primaryLight,
                    ),
                    const SizedBox(width: 10),
                    _buildRequestCount(
                      'Active',
                      activeCount,
                      Colors.green,
                    ),
                    const SizedBox(width: 10),
                    _buildRequestCount(
                      'Inactive',
                      inactiveCount,
                      Colors.orange,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Request Count Widget
  Widget _buildRequestCount(
      String title,
      int count,
      Color color,
      ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 6,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                color: color,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Home Content
  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NexRide',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Your journey, your way.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 30),

          const Text(
            'Where are you going?',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Choose a service to get started.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 13,
              mainAxisSpacing: 13,
              childAspectRatio: 0.90,
            ),
            itemBuilder: (context, index) {
              return _buildServiceCard(services[index]);
            },
          ),

          const SizedBox(height: 30),

          const Text(
            'Driver Dashboard',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),

          _buildIncomingRequestsCard(),

          const SizedBox(height: 14),

          _buildIncomingRideRequestsCard(),

          const SizedBox(height: 14),

          _buildMyPublishedRidesCard(),

          const SizedBox(height: 14),

          _buildMyPublishedServicesCard(),

          const SizedBox(height: 30),

          const Text(
            'Upcoming Activities',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.event_available_outlined,
                  color: AppColors.textSecondary,
                  size: 38,
                ),
                SizedBox(height: 12),
                Text(
                  'No upcoming activities',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Your rides and bookings will appear here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Other Pages
  Widget _buildOtherPage(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 45,
            color: AppColors.primaryLight,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'This section will be developed soon.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeContent(),
      _buildOtherPage('Explore', Icons.explore_outlined),
      const MyActivitiesScreen(),

      // Updated Profile Tab
      const ProfileScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        child: pages[selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: AppColors.textSecondary,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}