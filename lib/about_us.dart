import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    final isTablet = MediaQuery.of(context).size.width >= 800 && MediaQuery.of(context).size.width < 1200;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hero Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 48,
                  vertical: isMobile ? 40 : 60,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFB87333).withOpacity(0.1),
                      const Color(0xFFCD7F32).withOpacity(0.05),
                      Colors.white,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    // Logo/Badge
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFB87333).withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.handshake,
                        color: Color(0xFFB87333),
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Title
                    const Text(
                      'About Fundi Marketplace',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C2C2C),
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    
                    // Subtitle
                    Container(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: Text(
                        'Bridging the gap between skilled artisans and those who need them, creating opportunities and building communities.',
                        style: TextStyle(
                          fontSize: isMobile ? 16 : 18,
                          color: Colors.grey.shade600,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              // Mission & Vision Section
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 48,
                  vertical: 40,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFB87333).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.rocket_launch,
                                color: Color(0xFFB87333),
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Our Mission',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C2C2C),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'To empower skilled artisans (fundis) by connecting them with clients who need their expertise, while providing a seamless, trustworthy platform that ensures quality workmanship and fair compensation for all.',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade600,
                                height: 1.7,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!isMobile) const SizedBox(width: 24),
                    if (!isMobile)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFCD7F32).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.visibility,
                                  color: Color(0xFFCD7F32),
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Our Vision',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C2C2C),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'To become Africa\'s most trusted marketplace for skilled labor, creating economic opportunities for millions of artisans and delivering peace of mind to countless households and businesses.',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey.shade600,
                                  height: 1.7,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Mobile Mission/Vision (for mobile)
              if (isMobile)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFCD7F32).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.visibility,
                                color: Color(0xFFCD7F32),
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Our Vision',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C2C2C),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'To become Africa\'s most trusted marketplace for skilled labor, creating economic opportunities for millions of artisans and delivering peace of mind to countless households and businesses.',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade600,
                                height: 1.7,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              // Values Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 48,
                  vertical: 40,
                ),
                color: Colors.white,
                child: Column(
                  children: [
                    const Text(
                      'Our Core Values',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'The principles that guide everything we do',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Values Grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                      childAspectRatio: 1.2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      children: [
                        _buildValueCard(
                          icon: Icons.verified,
                          title: 'Trust & Verification',
                          description: 'Every fundi on our platform is verified to ensure quality and reliability.',
                          color: const Color(0xFFB87333),
                        ),
                        _buildValueCard(
                          icon: Icons.handshake,
                          title: 'Fair Compensation',
                          description: 'Ensuring fundis receive 90% of every payment, with transparent pricing.',
                          color: const Color(0xFFCD7F32),
                        ),
                        _buildValueCard(
                          icon: Icons.quality,
                          title: 'Quality Workmanship',
                          description: 'We maintain high standards through reviews and ratings.',
                          color: const Color(0xFF8B4513),
                        ),
                        _buildValueCard(
                          icon: Icons.people,
                          title: 'Community First',
                          description: 'Building a community where everyone thrives together.',
                          color: const Color(0xFF2C2C2C),
                        ),
                        _buildValueCard(
                          icon: Icons.security,
                          title: 'Secure Payments',
                          description: 'Safe, escrow-protected payments for peace of mind.',
                          color: const Color(0xFF228B22),
                        ),
                        _buildValueCard(
                          icon: Icons.support_agent,
                          title: '24/7 Support',
                          description: 'Dedicated support team always ready to help.',
                          color: const Color(0xFF4169E1),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Story Section
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 48,
                  vertical: 60,
                ),
                child: Row(
                  children: [
                    if (!isMobile)
                      Expanded(
                        flex: 5,
                        child: Container(
                          height: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            image: const DecorationImage(
                              image: NetworkImage(
                                'https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    if (!isMobile) const SizedBox(width: 40),
                    Expanded(
                      flex: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB87333).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text(
                              'OUR STORY',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB87333),
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'From a Simple Idea to a Movement',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C2C2C),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Fundi Marketplace was born from a simple observation: skilled artisans (fundis) struggled to find consistent work, while homeowners and businesses struggled to find reliable, vetted professionals for their projects.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                              height: 1.7,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'What started as a small WhatsApp group in Nairobi has grown into a platform connecting thousands of fundis with clients across Kenya. We\'ve facilitated over 10,000 jobs, with millions in earnings going directly to skilled workers who deserve fair compensation.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                              height: 1.7,
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Stats
                          Row(
                            children: [
                              _buildStatItem('10K+', 'Jobs Completed'),
                              Container(
                                height: 30,
                                width: 1,
                                color: Colors.grey.shade300,
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                              ),
                              _buildStatItem('5K+', 'Verified Fundis'),
                              Container(
                                height: 30,
                                width: 1,
                                color: Colors.grey.shade300,
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                              ),
                              _buildStatItem('50K+', 'Happy Clients'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Team Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 48,
                  vertical: 60,
                ),
                color: const Color(0xFFF5F5F5),
                child: Column(
                  children: [
                    const Text(
                      'Meet Our Team',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'The passionate people behind Fundi Marketplace',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Team Grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                      childAspectRatio: 1.1,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 24,
                      children: [
                        _buildTeamMember(
                          name: 'John Mwangi',
                          role: 'Founder & CEO',
                          bio: 'Former carpenter with a vision to digitize the informal sector.',
                          imageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
                        ),
                        _buildTeamMember(
                          name: 'Sarah Akinyi',
                          role: 'Head of Operations',
                          bio: '10+ years experience in community organizing and operations.',
                          imageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
                        ),
                        _buildTeamMember(
                          name: 'David Omondi',
                          role: 'Lead Developer',
                          bio: 'Tech enthusiast building solutions for local challenges.',
                          imageUrl: 'https://randomuser.me/api/portraits/men/46.jpg',
                        ),
                        _buildTeamMember(
                          name: 'Grace Wanjiku',
                          role: 'Community Manager',
                          bio: 'Connecting fundis with opportunities and building relationships.',
                          imageUrl: 'https://randomuser.me/api/portraits/women/63.jpg',
                        ),
                        _buildTeamMember(
                          name: 'Peter Kamau',
                          role: 'Quality Assurance',
                          bio: 'Ensuring every fundi meets our high standards.',
                          imageUrl: 'https://randomuser.me/api/portraits/men/22.jpg',
                        ),
                        _buildTeamMember(
                          name: 'Lucy Njeri',
                          role: 'Client Support',
                          bio: 'Dedicated to providing exceptional support to all users.',
                          imageUrl: 'https://randomuser.me/api/portraits/women/50.jpg',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Testimonials Section
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 48,
                  vertical: 60,
                ),
                child: Column(
                  children: [
                    const Text(
                      'What People Say',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Real stories from our community',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Testimonials Grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                      childAspectRatio: 1.1,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      children: [
                        _buildTestimonialCard(
                          quote: 'Fundi Marketplace helped me find a skilled plumber within hours. The quality of work was exceptional!',
                          name: 'Michael Johnson',
                          role: 'Homeowner',
                          rating: 5,
                        ),
                        _buildTestimonialCard(
                          quote: 'As a carpenter, this platform has transformed my business. I now have steady work and fair pay.',
                          name: 'James Odhiambo',
                          role: 'Fundi (Carpenter)',
                          rating: 5,
                        ),
                        _buildTestimonialCard(
                          quote: 'The verification process gives me confidence when hiring. Every fundi I\'ve worked with has been professional.',
                          name: 'Elizabeth Wanjiku',
                          role: 'Property Manager',
                          rating: 5,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // CTA Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 48,
                  vertical: 60,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFB87333),
                      const Color(0xFFCD7F32),
                      const Color(0xFF8B4513),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Join Our Community',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: const Text(
                        'Whether you\'re a skilled fundi looking for work or a client needing quality service, we\'re here for you.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text(
                            'Become a Fundi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB87333),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text(
                            'Hire a Fundi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
      ),
    );
  }

  Widget _buildValueCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember({
    required String name,
    required String role,
    required String bio,
    required String imageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            role,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFFB87333),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            bio,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard({
    required String quote,
    required String name,
    required String role,
    required int rating,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.format_quote,
            color: Color(0xFFB87333),
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            '"$quote"',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: const Color(0xFFB87333),
                size: 16,
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          Text(
            role,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFB87333),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}