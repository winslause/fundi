import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cached_network_image/cached_network_image.dart';
import 'models.dart';
import 'data.dart';
import 'auth.dart';

// ==================== REUSABLE HEADER ====================

class AppHeader extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  final String? currentPage;
  final ScrollController? scrollController;
  final bool isMobileMenuOpen;
  final VoidCallback? onMenuToggle;

  const AppHeader({
    super.key,
    required this.isMobile,
    this.isTablet = false,
    this.currentPage,
    this.scrollController,
    this.isMobileMenuOpen = false,
    this.onMenuToggle,
  });

  @override
  Widget build(BuildContext context) {
    // Get the status bar height to properly account for it
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    // Check if running on mobile APK (not web and is mobile screen)
    final bool isMobileApk = !kIsWeb && isMobile;
    
    // Use taller height for mobile APK (120), regular mobile web (80), and desktop (100)
    final headerHeight = isMobileApk ? 120.0 : (isMobile ? 80.0 : 100.0);
    
    return Container(
      height: headerHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFE0E0E0),
            const Color(0xFFC0C0C0),
            const Color(0xFFA0A0A0),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: isMobile ? 16 : 24,
          right: isMobile ? 16 : 24,
          // Use same padding for all platforms
          top: statusBarHeight,
        ),
        child: Row(
          children: [
            // Logo
            GestureDetector(
              onTap: () => _navigateTo(context, 'home'),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFB87333),
                          Color(0xFFCD7F32),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.build,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  if (!isMobile) ...[
                    const SizedBox(width: 12),
                    const Text(
                      'FUNDI',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C2C2C),
                        letterSpacing: 1,
                      ),
                    ),
                    const Text(
                      'MP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Color(0xFF4A4A4A),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            const Spacer(),
            
            // Desktop Navigation
            if (!isMobile) ...[
              ..._buildNavItems(context),
              const SizedBox(width: 24),
              _buildNavButtons(context),
            ],
            
            // Mobile Menu Button
            if (isMobile)
              IconButton(
                icon: Icon(
                  isMobileMenuOpen ? Icons.close : Icons.menu,
                  color: const Color(0xFF2C2C2C),
                ),
                onPressed: onMenuToggle,
              ),
          ],
        ),
      ),
    );
  }
  
  List<Widget> _buildNavItems(BuildContext context) {
    final items = [
      {'label': 'Home', 'route': 'home'},
      {'label': 'Fundis', 'route': 'fundis'},
      {'label': 'Jobs', 'route': 'jobs'},
      {'label': 'How It Works', 'route': 'how_it_works'},
      {'label': 'Contact', 'route': 'contact'},
    ];
    return items.map((item) {
      final isActive = currentPage == item['route'];
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextButton(
          onPressed: () => _navigateTo(context, item['route'] as String),
          style: TextButton.styleFrom(
            foregroundColor: isActive ? const Color(0xFFB87333) : const Color(0xFF2C2C2C),
          ),
          child: Text(
            item['label'] as String,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      );
    }).toList();
  }
  
  void _navigateTo(BuildContext context, String route) {
    switch (route) {
      case 'home':
        if (currentPage == 'home' && scrollController != null) {
          scrollController!.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
        break;
      case 'fundis':
        if (currentPage != 'fundis') {
          Navigator.pushNamed(context, '/fundis');
        }
        break;
      case 'jobs':
        if (currentPage != 'jobs') {
          Navigator.pushNamed(context, '/jobs');
        }
        break;
      case 'how_it_works':
        if (currentPage == 'home' && scrollController != null) {
          scrollController!.animateTo(
            500,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          // Navigate to home and scroll to how it works
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
        break;
      case 'contact':
        if (currentPage == 'home' && scrollController != null) {
          scrollController!.animateTo(
            scrollController!.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          // Navigate to home and scroll to contact
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
        break;
    }
  }
  
  Widget _buildNavButtons(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF2C2C2C),
              width: 1,
            ),
          ),
          child: TextButton(
            onPressed: () => AuthModals.showLoginModal(context),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF2C2C2C),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('LOGIN'),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              colors: [Color(0xFFB87333), Color(0xFFCD7F32)],
            ),
          ),
          child: TextButton(
            onPressed: () => AuthModals.showRegisterModal(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('REGISTER'),
          ),
        ),
      ],
    );
  }
}

// ==================== MOBILE MENU ====================

class MobileMenu extends StatelessWidget {
  final String? currentPage;
  final ScrollController? scrollController;
  final VoidCallback? onClose;

  const MobileMenu({
    super.key,
    this.currentPage,
    this.scrollController,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFC0C0C0).withOpacity(0.95),
      child: Column(
        children: [
          ..._buildMobileNavItems(context),
          const Divider(color: Color(0xFFA0A0A0)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: _buildMobileNavButton(
                    text: 'LOGIN',
                    onTap: () {
                      onClose?.call();
                      AuthModals.showLoginModal(context);
                    },
                    isPrimary: false,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMobileNavButton(
                    text: 'REGISTER',
                    onTap: () {
                      onClose?.call();
                      AuthModals.showRegisterModal(context);
                    },
                    isPrimary: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMobileNavItems(BuildContext context) {
    final items = [
      {'label': 'Home', 'route': 'home'},
      {'label': 'Browse Fundis', 'route': 'fundis'},
      {'label': 'Browse Jobs', 'route': 'jobs'},
      {'label': 'How It Works', 'route': 'how_it_works'},
      {'label': 'Contact', 'route': 'contact'},
    ];
    return items.map((item) {
      return ListTile(
        title: Text(
          item['label'] as String,
          style: const TextStyle(
            color: Color(0xFF2C2C2C),
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () {
          onClose?.call();
          _navigateTo(context, item['route'] as String);
        },
      );
    }).toList();
  }

  void _navigateTo(BuildContext context, String route) {
    switch (route) {
      case 'home':
        if (currentPage == 'home' && scrollController != null) {
          scrollController!.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
        break;
      case 'fundis':
        if (currentPage != 'fundis') {
          Navigator.pushNamed(context, '/fundis');
        }
        break;
      case 'jobs':
        if (currentPage != 'jobs') {
          Navigator.pushNamed(context, '/jobs');
        }
        break;
      case 'how_it_works':
        if (currentPage == 'home' && scrollController != null) {
          scrollController!.animateTo(
            500,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
        break;
      case 'contact':
        if (currentPage == 'home' && scrollController != null) {
          scrollController!.animateTo(
            scrollController!.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
        break;
    }
  }

  Widget _buildMobileNavButton({
    required String text,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isPrimary ? const Color(0xFFB87333) : Colors.transparent,
        border: isPrimary ? null : Border.all(color: const Color(0xFF2C2C2C)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isPrimary ? Colors.white : const Color(0xFF2C2C2C),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== REUSABLE FOOTER ====================

class AppFooter extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;

  const AppFooter({
    super.key,
    required this.isMobile,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 60,
        horizontal: isMobile ? 20 : 40,
      ),
      color: const Color(0xFF2C2C2C),
      child: Column(
        children: [
          // Footer grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 5),
            childAspectRatio: isMobile ? 2 : 1.5,
            mainAxisSpacing: 30,
            crossAxisSpacing: 30,
            children: [
              // About
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
                    child: const Row(
                      children: [
                        Icon(Icons.build, color: Color(0xFFB87333), size: 24),
                        SizedBox(width: 8),
                        Text(
                          'FUNDI MP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Connecting clients with skilled artisans for quality workmanship.',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
              
              // Quick Links
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'QUICK LINKS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFooterLink(context, 'Home', 'home'),
                  _buildFooterLink(context, 'Fundis', 'fundis'),
                  _buildFooterLink(context, 'Jobs', 'jobs'),
                  _buildFooterLink(context, 'How It Works', 'how_it_works'),
                ],
              ),
              
              // Support
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SUPPORT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFooterLink(context, 'Contact', 'contact'),
                  _buildFooterLink(context, 'FAQ', 'faq'),
                  _buildFooterLink(context, 'Privacy', 'privacy'),
                  _buildFooterLink(context, 'Terms', 'terms'),
                ],
              ),
              
              // Testing Links (for testing purposes)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TESTING',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFooterLink(context, 'Client Dashboard', 'client_dashboard'),
                  _buildFooterLink(context, 'Fundi Dashboard', 'fundi_dashboard'),
                  _buildFooterLink(context, 'Admin Dashboard', 'admin_dashboard'),
                ],
              ),
              
              // Contact
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CONTACT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Icon(Icons.location_on, color: Color(0xFFB87333), size: 14),
                      SizedBox(width: 8),
                      Text('Nairobi, Kenya', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.phone, color: Color(0xFFB87333), size: 14),
                      SizedBox(width: 8),
                      Text('+254 700 000000', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.email, color: Color(0xFFB87333), size: 14),
                      SizedBox(width: 8),
                      Text('info@fundi.com', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 40),
          Divider(color: Colors.grey.shade800),
          const SizedBox(height: 20),
          
          // Bottom bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© 2026 Fundi Marketplace',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              if (!isMobile)
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _navigateTo(context, 'privacy'),
                      child: Text('Privacy', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => _navigateTo(context, 'terms'),
                      child: Text('Terms', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(BuildContext context, String label, String route) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => _navigateTo(context, route),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, String route) {
    switch (route) {
      case 'home':
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        break;
      case 'fundis':
        Navigator.pushNamed(context, '/fundis');
        break;
      case 'jobs':
        Navigator.pushNamed(context, '/jobs');
        break;
      case 'client_dashboard':
        Navigator.pushNamed(context, '/client_dashboard');
        break;
      case 'fundi_dashboard':
        Navigator.pushNamed(context, '/fundi_dashboard');
        break;
      case 'admin_dashboard':
        Navigator.pushNamed(context, '/admin_dashboard');
        break;
      case 'how_it_works':
      case 'contact':
      case 'faq':
      case 'privacy':
      case 'terms':
        // For now, navigate to home for these
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        break;
    }
  }
}

// ==================== CUSTOM BUTTONS ====================

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double height;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height = 50,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFB87333), Color(0xFFCD7F32)],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB87333).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double height;
  final IconData? icon;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height = 50,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFB87333), width: 1.5),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFB87333),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: const Color(0xFFB87333), size: 18),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double height;
  final IconData? icon;

  const OutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height = 50,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.grey.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.grey.shade700, size: 18),
              const SizedBox(width: 8),
            ],
            Text(text, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

// ==================== CUSTOM INPUT FIELDS ====================

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: const Color(0xFFB87333), size: 20)
            : null,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFB87333), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: validator,
    );
  }
}

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String label;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.label,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFB87333), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      validator: validator,
    );
  }
}

// ==================== JOB CARD ====================

class JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;

  const JobCard({
    super.key,
    required this.job,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final category = MockData.categories.firstWhere(
      (c) => c.id == job.categoryId,
      orElse: () => MockData.categories.first,
    );
    final client = MockData.getClientById(job.clientId);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    // Responsive sizing
    final padding = isMobile ? 10.0 : 16.0;
    final iconSize = isMobile ? 12.0 : 16.0;
    final iconPadding = isMobile ? 6.0 : 8.0;
    final titleSize = isMobile ? 12.0 : 14.0;
    final clientSize = isMobile ? 9.0 : 11.0;
    final descSize = isMobile ? 10.0 : 12.0;
    final budgetSize = isMobile ? 11.0 : 14.0;
    final labelSize = isMobile ? 8.0 : 10.0;
    final dateSize = isMobile ? 9.0 : 11.0;
    final spacing = isMobile ? 8.0 : 12.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(iconPadding),
                    decoration: BoxDecoration(
                      color: category.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      category.icon,
                      style: TextStyle(fontSize: iconSize),
                    ),
                  ),
                  SizedBox(width: isMobile ? 6 : 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: TextStyle(
                            fontSize: titleSize,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2C2C2C),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          client?.name ?? 'Unknown',
                          style: TextStyle(
                            fontSize: clientSize,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (job.isFeatured)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: isMobile ? 4 : 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB87333),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'FEATURED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 6 : 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: isMobile ? 6 : spacing),
              // Description
              Flexible(
                child: Text(
                  job.description,
                  maxLines: isMobile ? 2 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: descSize,
                    color: Colors.grey.shade700,
                    height: 1.3,
                  ),
                ),
              ),
              SizedBox(height: isMobile ? 4 : 8),
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Budget',
                          style: TextStyle(fontSize: labelSize, color: Colors.grey.shade500),
                        ),
                        Text(
                          MockData.formatCurrency(job.budget),
                          style: TextStyle(
                            fontSize: budgetSize,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFB87333),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Posted',
                          style: TextStyle(fontSize: labelSize, color: Colors.grey.shade500),
                        ),
                        Text(
                          MockData.formatDate(job.postedAt),
                          style: TextStyle(
                            fontSize: dateSize,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Applications count - hide on very small screens
              if (job.applicationsCount > 0 && !isMobile)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 10,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${job.applicationsCount} applications',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey.shade400,
                        ),
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
}

// ==================== FUNDI CARD ====================

class FundiCard extends StatelessWidget {
  final Fundi fundi;
  final VoidCallback onTap;
  final bool compact; // For grid/list views

  const FundiCard({
    super.key,
    required this.fundi,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    if (compact) {
      return _buildCompactCard(isMobile);
    }
    return _buildFullCard(isMobile);
  }

  Widget _buildFullCard(bool isMobile) {
    // Responsive sizing
    final borderRadius = isMobile ? 8.0 : 12.0;
    final imageHeight = isMobile ? 80.0 : 120.0;
    final padding = isMobile ? 8.0 : 12.0;
    final nameSize = isMobile ? 12.0 : 14.0;
    final titleSize = isMobile ? 9.0 : 11.0;
    final starSize = isMobile ? 10.0 : 12.0;
    final reviewCountSize = isMobile ? 7.0 : 9.0;
    final skillFontSize = isMobile ? 6.0 : 8.0;
    final skillPaddingH = isMobile ? 4.0 : 6.0;
    final skillPaddingV = isMobile ? 1.0 : 2.0;
    final labelSize = isMobile ? 7.0 : 9.0;
    final valueSize = isMobile ? 10.0 : 12.0;
    final checkIconSize = isMobile ? 8.0 : 10.0;
    final spacing = isMobile ? 4.0 : 8.0;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
              child: CachedNetworkImage(
                imageUrl: fundi.profileImage ?? 'https://randomuser.me/api/portraits/men/1.jpg',
                height: imageHeight,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: imageHeight,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: imageHeight,
                  color: Colors.grey.shade200,
                  child: Icon(Icons.person, size: isMobile ? 30 : 40, color: Colors.grey),
                ),
              ),
            ),
            // Details
            Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          fundi.name,
                          style: TextStyle(
                            fontSize: nameSize,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2C2C2C),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (fundi.isVerified)
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: Icon(Icons.check, size: checkIconSize, color: Colors.white),
                        ),
                    ],
                  ),
                  SizedBox(height: isMobile ? 2 : 4),
                  Text(
                    fundi.title,
                    style: TextStyle(
                      fontSize: titleSize,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: spacing),
                  // Rating
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          index < fundi.rating.floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: const Color(0xFFB87333),
                          size: starSize,
                        );
                      }),
                      SizedBox(width: 2),
                      Text(
                        '(${fundi.reviewCount})',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: reviewCountSize,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing),
                  // Skills
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: fundi.skills.take(isMobile ? 2 : 2).map((skill) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: skillPaddingH, vertical: skillPaddingV),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          skill,
                          style: TextStyle(
                            fontSize: skillFontSize,
                            color: Colors.grey.shade700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: spacing),
                  // Rate
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Rate', style: TextStyle(fontSize: labelSize, color: Colors.grey.shade500)),
                          Text(
                            MockData.formatCurrency(fundi.hourlyRate),
                            style: TextStyle(
                              fontSize: valueSize,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFB87333),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Jobs', style: TextStyle(fontSize: labelSize, color: Colors.grey.shade500)),
                          Text(
                            '${fundi.jobsCompleted}',
                            style: TextStyle(
                              fontSize: valueSize,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2C2C2C),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactCard(bool isMobile) {
    // Responsive sizing
    final imageWidth = isMobile ? 50.0 : 60.0;
    final imageHeight = isMobile ? 50.0 : 60.0;
    final padding = isMobile ? 6.0 : 8.0;
    final nameSize = isMobile ? 10.0 : 12.0;
    final titleSize = isMobile ? 8.0 : 10.0;
    final starSize = isMobile ? 8.0 : 10.0;
    final reviewCountSize = isMobile ? 6.0 : 8.0;
    final checkIconSize = isMobile ? 6.0 : 8.0;
    final personIconSize = isMobile ? 24.0 : 30.0;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(isMobile ? 6 : 8)),
              child: CachedNetworkImage(
                imageUrl: fundi.profileImage ?? 'https://randomuser.me/api/portraits/men/1.jpg',
                width: imageWidth,
                height: imageHeight,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: imageWidth,
                  height: imageHeight,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: imageWidth,
                  height: imageHeight,
                  color: Colors.grey.shade200,
                  child: Icon(Icons.person, size: personIconSize, color: Colors.grey),
                ),
              ),
            ),
            // Details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            fundi.name,
                            style: TextStyle(
                              fontSize: nameSize,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2C2C2C),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (fundi.isVerified)
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            child: Icon(Icons.check, size: checkIconSize, color: Colors.white),
                          ),
                      ],
                    ),
                    Text(
                      fundi.title,
                      style: TextStyle(
                        fontSize: titleSize,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < fundi.rating.floor()
                                ? Icons.star
                                : Icons.star_border,
                            color: const Color(0xFFB87333),
                            size: starSize,
                          );
                        }),
                        SizedBox(width: 2),
                        Text(
                          '(${fundi.reviewCount})',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: reviewCountSize,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== REVIEW CARD ====================

class ReviewCard extends StatelessWidget {
  final Review review;
  final bool showJobInfo;

  const ReviewCard({
    super.key,
    required this.review,
    this.showJobInfo = false,
  });

  @override
  Widget build(BuildContext context) {
    final reviewer = MockData.getUserById(review.fromUserId);
    final job = MockData.jobs.firstWhere((j) => j.id == review.jobId);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    // Responsive sizing
    final padding = isMobile ? 12.0 : 16.0;
    final avatarRadius = isMobile ? 16.0 : 20.0;
    final nameSize = isMobile ? 12.0 : 14.0;
    final jobTitleSize = isMobile ? 10.0 : 11.0;
    final ratingIconSize = isMobile ? 10.0 : 12.0;
    final ratingTextSize = isMobile ? 9.0 : 11.0;
    final ratingPaddingH = isMobile ? 6.0 : 8.0;
    final ratingPaddingV = isMobile ? 3.0 : 4.0;
    final commentSize = isMobile ? 11.0 : 13.0;
    final dateSize = isMobile ? 9.0 : 10.0;
    final spacing = isMobile ? 8.0 : 12.0;
    final smallSpacing = isMobile ? 6.0 : 8.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: avatarRadius,
                backgroundImage: reviewer?.profileImage != null
                    ? CachedNetworkImageProvider(reviewer!.profileImage!)
                    : null,
                child: reviewer?.profileImage == null
                    ? Text(
                        reviewer?.name[0] ?? '?',
                        style: TextStyle(color: Colors.grey, fontSize: avatarRadius * 0.8),
                      )
                    : null,
              ),
              SizedBox(width: isMobile ? 8 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      reviewer?.name ?? 'Unknown',
                      style: TextStyle(
                        fontSize: nameSize,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2C2C2C),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (showJobInfo) ...[
                      SizedBox(height: 2),
                      Text(
                        job.title,
                        style: TextStyle(
                          fontSize: jobTitleSize,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 4),
              // Rating
              Container(
                padding: EdgeInsets.symmetric(horizontal: ratingPaddingH, vertical: ratingPaddingV),
                decoration: BoxDecoration(
                  color: const Color(0xFFB87333).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: const Color(0xFFB87333), size: ratingIconSize),
                    SizedBox(width: 2),
                    Text(
                      review.rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: ratingTextSize,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFB87333),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: spacing),
          // Comment
          Text(
            review.comment,
            style: TextStyle(
              fontSize: commentSize,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
            maxLines: isMobile ? 3 : null,
            overflow: isMobile ? TextOverflow.ellipsis : null,
          ),
          SizedBox(height: smallSpacing),
          // Date
          Text(
            MockData.formatDate(review.createdAt),
            style: TextStyle(
              fontSize: dateSize,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== STATS CARD ====================

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final double? change;
  final bool isPositive;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.change,
    this.isPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    // Responsive sizing
    final padding = isMobile ? 12.0 : 20.0;
    final iconContainerPadding = isMobile ? 8.0 : 10.0;
    final iconSize = isMobile ? 16.0 : 20.0;
    final titleSize = isMobile ? 10.0 : 13.0;
    final valueSize = isMobile ? 16.0 : 24.0;
    final changeIconSize = isMobile ? 12.0 : 16.0;
    final changeTextSize = isMobile ? 9.0 : 12.0;
    final changeLabelSize = isMobile ? 8.0 : 10.0;
    final spacing = isMobile ? 8.0 : 16.0;
    final smallSpacing = isMobile ? 4.0 : 8.0;
    
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            padding: EdgeInsets.all(iconContainerPadding),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: iconSize),
          ),
          SizedBox(height: spacing),
          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: titleSize,
              color: Colors.grey.shade600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: smallSpacing),
          // Value
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: valueSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2C2C2C),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (change != null) ...[
            SizedBox(height: smallSpacing),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  color: isPositive ? Colors.green : Colors.red,
                  size: changeIconSize,
                ),
                SizedBox(width: 2),
                Flexible(
                  child: Text(
                    '${change!.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: changeTextSize,
                      color: isPositive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!isMobile) ...[
                  SizedBox(width: 4),
                  Text(
                    'vs last month',
                    style: TextStyle(
                      fontSize: changeLabelSize,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ==================== RATING STARS ====================

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color color;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 16,
    this.color = const Color(0xFFB87333),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star, color: color, size: size);
        } else if (index < rating && rating % 1 > 0) {
          return Icon(Icons.star_half, color: color, size: size);
        } else {
          return Icon(Icons.star_border, color: color, size: size);
        }
      }),
    );
  }
}

// ==================== ROLE BADGE ====================

class RoleBadge extends StatelessWidget {
  final UserRole role;
  final bool compact;

  const RoleBadge({
    super.key,
    required this.role,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    String label;

    switch (role) {
      case UserRole.client:
        color = Colors.blue;
        icon = Icons.person_outline;
        label = 'Client';
        break;
      case UserRole.fundi:
        color = const Color(0xFFB87333);
        icon = Icons.build;
        label = 'Fundi';
        break;
      case UserRole.admin:
        color = Colors.purple;
        icon = Icons.admin_panel_settings;
        label = 'Admin';
        break;
    }

    if (compact) {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 12),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== LOADING INDICATORS ====================

class FullScreenLoader extends StatelessWidget {
  final String? message;

  const FullScreenLoader({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.9),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                color: Color(0xFFB87333),
                strokeWidth: 3,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2C2C2C),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: const ShimmerEffect(),
    );
  }
}

class ShimmerEffect extends StatefulWidget {
  const ShimmerEffect({super.key});

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                Colors.white.withOpacity(0.3),
                Colors.white.withOpacity(0.8),
                Colors.white.withOpacity(0.3),
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + _controller.value * 2, 0.0),
              end: Alignment(1.0 + _controller.value * 2, 0.0),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
      ),
    );
  }
}

// ==================== EMPTY STATES ====================

class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: Colors.grey.shade400,
              ),
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
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 24),
              PrimaryButton(
                text: buttonText!,
                onPressed: onButtonPressed!,
                width: 200,
              ),
            ],
          ],
        ),
      ),
    );
  }
}