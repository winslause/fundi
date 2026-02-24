import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

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
              // Header Section
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
                    // Icon
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
                        Icons.headset_mic,
                        color: Color(0xFFB87333),
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Title
                    const Text(
                      'Get in Touch',
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
                        'Have questions? We\'d love to hear from you. Send us a message and we\'ll respond as soon as possible.',
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

              // Contact Info & Form Section
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 48,
                  vertical: 40,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Contact Information Cards
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          _buildContactCard(
                            icon: Icons.location_on,
                            title: 'Visit Us',
                            content: '123 Kimathi Street\nNairobi, Kenya\nPO Box 12345-00100',
                            color: const Color(0xFFB87333),
                          ),
                          const SizedBox(height: 20),
                          _buildContactCard(
                            icon: Icons.phone,
                            title: 'Call Us',
                            content: '+254 700 123 456\n+254 733 789 012',
                            color: const Color(0xFFCD7F32),
                          ),
                          const SizedBox(height: 20),
                          _buildContactCard(
                            icon: Icons.email,
                            title: 'Email Us',
                            content: 'info@fundimarketplace.com\nsupport@fundimarketplace.com',
                            color: const Color(0xFF8B4513),
                          ),
                          const SizedBox(height: 20),
                          _buildContactCard(
                            icon: Icons.access_time,
                            title: 'Working Hours',
                            content: 'Monday - Friday: 8:00 AM - 6:00 PM\nSaturday: 9:00 AM - 2:00 PM\nSunday: Closed',
                            color: const Color(0xFF2C2C2C),
                          ),
                        ],
                      ),
                    ),
                    
                    if (!isMobile) const SizedBox(width: 30),
                    
                    // Contact Form
                    Expanded(
                      flex: 7,
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
                            const Text(
                              'Send a Message',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C2C2C),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'We\'ll get back to you within 24 hours',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Name Field
                            _buildFormField(
                              label: 'Full Name',
                              hint: 'Enter your full name',
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: 20),
                            
                            // Email Field
                            _buildFormField(
                              label: 'Email Address',
                              hint: 'Enter your email',
                              icon: Icons.email_outlined,
                            ),
                            const SizedBox(height: 20),
                            
                            // Phone Field
                            _buildFormField(
                              label: 'Phone Number (Optional)',
                              hint: 'Enter your phone number',
                              icon: Icons.phone_outlined,
                            ),
                            const SizedBox(height: 20),
                            
                            // Subject Dropdown
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Subject',
                                  prefixIcon: const Icon(Icons.topic, color: Color(0xFFB87333)),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                ),
                                items: [
                                  'General Inquiry',
                                  'Technical Support',
                                  'Billing Question',
                                  'Partnership Opportunity',
                                  'Report an Issue',
                                  'Other'
                                ].map((subject) {
                                  return DropdownMenuItem(
                                    value: subject,
                                    child: Text(subject),
                                  );
                                }).toList(),
                                onChanged: (value) {},
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            // Message Field
                            TextFormField(
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: 'Message',
                                hintText: 'Type your message here...',
                                prefixIcon: const Icon(Icons.message_outlined, color: Color(0xFFB87333)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFB87333), width: 2),
                                ),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Submit Button
                            Container(
                              width: double.infinity,
                              height: 55,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFB87333), Color(0xFFCD7F32)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFB87333).withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Handle form submission
                                  _showSuccessDialog(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'SEND MESSAGE',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Mobile Form (for mobile)
              if (isMobile)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
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
                        const Text(
                          'Send a Message',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C2C2C),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'We\'ll get back to you within 24 hours',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Mobile Form Fields
                        _buildFormField(
                          label: 'Full Name',
                          hint: 'Enter your full name',
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),
                        _buildFormField(
                          label: 'Email Address',
                          hint: 'Enter your email',
                          icon: Icons.email_outlined,
                        ),
                        const SizedBox(height: 16),
                        _buildFormField(
                          label: 'Phone Number (Optional)',
                          hint: 'Enter your phone number',
                          icon: Icons.phone_outlined,
                        ),
                        const SizedBox(height: 16),
                        
                        // Subject Dropdown
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Subject',
                              prefixIcon: const Icon(Icons.topic, color: Color(0xFFB87333)),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            ),
                            items: [
                              'General Inquiry',
                              'Technical Support',
                              'Billing Question',
                              'Partnership Opportunity',
                              'Other'
                            ].map((subject) {
                              return DropdownMenuItem(
                                value: subject,
                                child: Text(subject),
                              );
                            }).toList(),
                            onChanged: (value) {},
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Message Field
                        TextFormField(
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: 'Message',
                            hintText: 'Type your message...',
                            prefixIcon: const Icon(Icons.message_outlined, color: Color(0xFFB87333)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Submit Button
                        Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFB87333), Color(0xFFCD7F32)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ElevatedButton(
                            onPressed: () => _showSuccessDialog(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'SEND MESSAGE',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Map Section
              Container(
                width: double.infinity,
                height: isMobile ? 250 : 350,
                color: Colors.grey.shade300,
                child: Stack(
                  children: [
                    // Placeholder for map (in real app, you'd embed a Google Map or similar)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map,
                            size: isMobile ? 48 : 64,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Interactive Map',
                            style: TextStyle(
                              fontSize: isMobile ? 14 : 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            '123 Kimathi Street, Nairobi',
                            style: TextStyle(
                              fontSize: isMobile ? 12 : 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // FAQ Section
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 48,
                  vertical: 60,
                ),
                child: Column(
                  children: [
                    const Text(
                      'Frequently Asked Questions',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Quick answers to common questions',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // FAQ Grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 2),
                      childAspectRatio: 1.3,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      children: [
                        _buildFAQItem(
                          question: 'How do I hire a fundi?',
                          answer: 'Simply browse fundis by category, view their profiles, and send a job request. You\'ll receive quotes and can choose the best fit.',
                        ),
                        _buildFAQItem(
                          question: 'Is my payment secure?',
                          answer: 'Yes! We use an escrow system. Funds are released to the fundi only after you confirm the job is complete.',
                        ),
                        _buildFAQItem(
                          question: 'How are fundis verified?',
                          answer: 'All fundis undergo ID verification, skill assessments, and background checks before they can start accepting jobs.',
                        ),
                        _buildFAQItem(
                          question: 'What if I\'m not satisfied?',
                          answer: 'We have a satisfaction guarantee. If you\'re not happy, we\'ll work with you and the fundi to resolve the issue.',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Social Media Section
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
                      'Connect With Us',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton(
                          icon: Icons.facebook,
                          color: const Color(0xFF1877F2),
                          label: 'Facebook',
                        ),
                        const SizedBox(width: 16),
                        _buildSocialButton(
                          icon: Icons.camera_alt,
                          color: const Color(0xFFE4405F),
                          label: 'Instagram',
                        ),
                        const SizedBox(width: 16),
                        _buildSocialButton(
                          icon: Icons.chat,
                          color: const Color(0xFF25D366),
                          label: 'WhatsApp',
                        ),
                        const SizedBox(width: 16),
                        _buildSocialButton(
                          icon: Icons.alternate_email,
                          color: const Color(0xFF1DA1F2),
                          label: 'Twitter',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Emergency Support Banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isMobile ? 20 : 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFB87333).withOpacity(0.1),
                      const Color(0xFFCD7F32).withOpacity(0.1),
                    ],
                  ),
                  border: Border(
                    top: BorderSide(color: const Color(0xFFB87333).withOpacity(0.2)),
                    bottom: BorderSide(color: const Color(0xFFB87333).withOpacity(0.2)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.emergency,
                        color: Colors.red,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Emergency Support',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C2C2C),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'For urgent issues, call our 24/7 emergency line',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '+254 700 000 999',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Business Hours Card (Mobile)
              if (isMobile)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB87333).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.access_time,
                            color: Color(0xFFB87333),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Business Hours',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C2C2C),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Mon-Fri: 8AM-6PM | Sat: 9AM-2PM',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFFB87333)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB87333), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFB87333).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.help,
                  color: Color(0xFFB87333),
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  question,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: color.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Message Sent!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C2C2C),
              ),
            ),
          ],
        ),
        content: const Text(
          'Thank you for contacting us. We\'ll get back to you within 24 hours.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFB87333),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: const Text('OK'),
            ),
          ),
        ],
      ),
    );
  }
}