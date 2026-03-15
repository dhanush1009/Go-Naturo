import 'package:flutter/material.dart';

import '../login_page.dart';
import '../services/auth_manager.dart';
import '../services/order_manager.dart';
import '../theme/app_colors.dart';
import 'cart_page.dart';
import 'contact_page.dart';
import 'orders_page.dart';
import 'wishlist_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthManager _authManager = AuthManager();
  final OrderManager _orderManager = OrderManager();

  @override
  void initState() {
    super.initState();
    _authManager.addListener(_refresh);
    _orderManager.addListener(_refresh);
  }

  @override
  void dispose() {
    _authManager.removeListener(_refresh);
    _orderManager.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  void _openLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void _requireLogin(VoidCallback action) {
    if (_authManager.isLoggedIn) {
      action();
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LoginPage(onLoginSuccess: action)),
    );
  }

  void _logout() {
    _authManager.logout();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully'),
        backgroundColor: Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = _authManager.isLoggedIn;
    final orderCount = _orderManager.orderCount;
    final userName = isLoggedIn ? _authManager.userName : 'Guest User';
    final userEmail = isLoggedIn
        ? _authManager.userEmail
        : 'Sign in to manage your orders, wishlist and cart';

    return Container(
      color: const Color(0xFFF5F7FB),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileHeader(isLoggedIn, userName, userEmail),
          const SizedBox(height: 16),
          _buildQuickStats(),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'My Account',
            children: [
              _buildMenuTile(
                icon: Icons.shopping_bag_outlined,
                title: 'My Orders',
                subtitle: orderCount > 0
                    ? '$orderCount order(s) saved'
                    : 'Track, return or reorder your products',
                onTap: () => _requireLogin(() => _openPage(const OrdersPage())),
              ),
              _buildMenuTile(
                icon: Icons.favorite_border,
                title: 'My Wishlist',
                subtitle: 'See saved products',
                onTap: () =>
                    _requireLogin(() => _openPage(const WishlistPage())),
              ),
              _buildMenuTile(
                icon: Icons.shopping_cart_outlined,
                title: 'My Cart',
                subtitle: 'Review products added to cart',
                onTap: () => _requireLogin(() => _openPage(const CartPage())),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'Support',
            children: [
              _buildMenuTile(
                icon: Icons.headset_mic_outlined,
                title: 'Help Center',
                subtitle: 'Delivery, payment and account support',
                onTap: () => _openPage(const ContactPage()),
              ),
              _buildMenuTile(
                icon: Icons.location_on_outlined,
                title: 'Saved Address',
                subtitle: 'Manage your delivery details',
                onTap: () => _requireLogin(
                  () => _showInfo('Address management can be added next.'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'Account Access',
            children: [
              if (!isLoggedIn)
                _buildActionButton(
                  label: 'Login / Sign Up',
                  icon: Icons.login,
                  color: kBrandGreen,
                  onPressed: _openLogin,
                )
              else
                _buildActionButton(
                  label: 'Logout',
                  icon: Icons.logout,
                  color: const Color(0xFFE53935),
                  onPressed: _logout,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
    bool isLoggedIn,
    String userName,
    String userEmail,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kBrandGreen, Color(0xFF4CAF50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'G',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kBrandGreen,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userEmail,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFE8F5E9),
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0x1FFFFFFF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_user, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isLoggedIn
                        ? 'Your account is ready for cart, wishlist and checkout.'
                        : 'Login to unlock cart, wishlist and faster checkout.',
                    style: const TextStyle(color: Colors.white, fontSize: 12.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: const [
        Expanded(
          child: _ProfileStatCard(
            icon: Icons.local_shipping_outlined,
            label: 'Fast Delivery',
            value: '24h',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _ProfileStatCard(
            icon: Icons.discount_outlined,
            label: 'Offers',
            value: 'Live',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _ProfileStatCard(
            icon: Icons.support_agent_outlined,
            label: 'Support',
            value: '24/7',
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: kBrandGreenLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: kBrandGreen),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12.5, height: 1.35),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _showInfo(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}

class _ProfileStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileStatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: kBrandGreen),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11.5, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
