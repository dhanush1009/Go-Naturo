import 'package:flutter/material.dart';

class BrandsPage extends StatelessWidget {
  const BrandsPage({super.key});

  final List<Map<String, dynamic>> brands = const [
    {
      'name': 'GoNaturo',
      'logo':
          'https://gonaturo.in/wp-content/uploads/2020/10/gonaturo-logo.png',
      'description': 'Premium natural and organic products',
      'products': 24,
      'specialty': 'Traditional Foods',
    },
    {
      'name': 'Marutham Herbal',
      'logo': 'https://via.placeholder.com/150?text=Marutham',
      'description': 'Authentic herbal beauty products',
      'products': 15,
      'specialty': 'Herbal Beauty',
    },
    {
      'name': 'Patanjali',
      'logo': 'https://via.placeholder.com/150?text=Patanjali',
      'description': 'Ayurvedic and natural wellness',
      'products': 12,
      'specialty': 'Ayurvedic',
    },
    {
      'name': 'Haiocare',
      'logo': 'https://via.placeholder.com/150?text=Haiocare',
      'description': 'Natural hair and skin care',
      'products': 8,
      'specialty': 'Hair Care',
    },
    {
      'name': 'Magil Herbal',
      'logo': 'https://via.placeholder.com/150?text=Magil',
      'description': 'Traditional herbal formulations',
      'products': 10,
      'specialty': 'Traditional',
    },
    {
      'name': 'Sibre Rich',
      'logo': 'https://via.placeholder.com/150?text=Sibre',
      'description': 'Millet-based health foods',
      'products': 6,
      'specialty': 'Millets',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Our Brands',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFF4CAF50), Colors.green.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.verified, color: Colors.white, size: 48),
                  const SizedBox(height: 12),
                  const Text(
                    'Trusted Brands',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We partner with the best natural & organic brands',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Stats Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.store,
                      count: '${brands.length}',
                      label: 'Brands',
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.inventory,
                      count: '75+',
                      label: 'Products',
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.verified_user,
                      count: '100%',
                      label: 'Certified',
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            // Brands List
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Featured Brands',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...brands.map((brand) => _buildBrandCard(context, brand)),
                ],
              ),
            ),

            // Why Choose These Brands Section
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Why Choose Our Brands?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildFeature(Icons.eco, '100% Natural & Organic'),
                  _buildFeature(Icons.verified, 'Quality Certified'),
                  _buildFeature(
                    Icons.local_shipping,
                    'Direct from Manufacturers',
                  ),
                  _buildFeature(Icons.thumb_up, 'Customer Trusted'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String count,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandCard(BuildContext context, Map<String, dynamic> brand) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Center(
                child: Icon(
                  Icons.storefront,
                  size: 40,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brand['name'] as String,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    brand['description'] as String,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${brand['products']} Products',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF4CAF50),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          brand['specialty'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4CAF50), size: 20),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
