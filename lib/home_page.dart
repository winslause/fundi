import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models.dart';
import 'data.dart';
import 'theme.dart';
import 'auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isMobileMenuOpen = false;
  
  // Featured fundi slideshow
  int _currentFundiIndex = 0;
  late List<Fundi> _featuredFundis;
  bool _isMobile = true; // Default to true, will be updated on first build
  Timer? _slideshowTimer;
  bool _slideshowStarted = false;
  
  @override
  void initState() {
    super.initState();
    _featuredFundis = MockData.getFeaturedFundis();
  }
  
  void _startFundiSlideshow() {
    if (_slideshowStarted) return;
    _slideshowStarted = true;
    
    _slideshowTimer?.cancel();
    _slideshowTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          if (_isMobile) {
            // Mobile: show 1 fundi at a time
            _currentFundiIndex = (_currentFundiIndex + 1) % _featuredFundis.length;
          } else {
            // Desktop: show 2 fundis at a time (advance by pairs)
            int totalPairs = (_featuredFundis.length / 2).ceil();
            int currentPair = _currentFundiIndex ~/ 2;
            int nextPair = (currentPair + 1) % totalPairs;
            _currentFundiIndex = nextPair * 2;
          }
        });
      }
    });
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    _slideshowTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Determine if we're on mobile
          bool isMobile = constraints.maxWidth < 800;
          bool isTablet = constraints.maxWidth >= 800 && constraints.maxWidth < 1200;
          
          // Update _isMobile and handle slideshow
          if (_isMobile != isMobile) {
            _isMobile = isMobile;
            // Reset index when switching between mobile and desktop
            _currentFundiIndex = 0;
          }
          
          // Start slideshow on first build
          if (!_slideshowStarted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _startFundiSlideshow();
            });
          }
          
          return Stack(
            children: [
              // Background with metallic gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFE8E8E8), // Light silver
                      const Color(0xFFD0D0D0), // Medium silver
                      const Color(0xFFB8B8B8), // Dark silver
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
              
              // Main content
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Responsive Navigation Bar
                  SliverAppBar(
                    expandedHeight: isMobile ? 80 : 100,
                    floating: true,
                    pinned: true,
                    snap: true,
                    toolbarHeight: isMobile ? 80 : 100,
                    backgroundColor: const Color(0xFFC0C0C0).withOpacity(0.98),
                    elevation: 4,
                    flexibleSpace: Container(
                      height: isMobile ? 80 : 100,
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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 16 : 24,
                          ),
                          child: Row(
                            children: [
                              // Logo
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
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
                              
                              const Spacer(),
                              
                              // Desktop Navigation
                              if (!isMobile) ...[
                                ..._buildNavItems(),
                                const SizedBox(width: 24),
                                _buildNavButtons(context),
                              ],
                              
                              // Mobile Menu Button
                              if (isMobile)
                                IconButton(
                                  icon: Icon(
                                    _isMobileMenuOpen ? Icons.close : Icons.menu,
                                    color: const Color(0xFF2C2C2C),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isMobileMenuOpen = !_isMobileMenuOpen;
                                    });
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Mobile Menu Dropdown
                  if (isMobile && _isMobileMenuOpen)
                    SliverToBoxAdapter(
                      child: Container(
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
                                        setState(() {
                                          _isMobileMenuOpen = false;
                                        });
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
                                        setState(() {
                                          _isMobileMenuOpen = false;
                                        });
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
                      ),
                    ),
                  
                  // Hero Section
                  SliverToBoxAdapter(
                    child: Container(
                      height: isMobile ? 400 : 500,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1504307651254-35680f356dfd?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                              const Color(0xFFB87333).withOpacity(0.3),
                            ],
                          ),
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: EdgeInsets.all(isMobile ? 24 : 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'SKILLED ARTISANS',
                                  style: TextStyle(
                                    fontSize: isMobile ? 16 : 20,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                    letterSpacing: 4,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  isMobile
                                      ? 'Hire Trusted\nFundis'
                                      : 'Hire Trusted Fundis',
                                  style: TextStyle(
                                    fontSize: isMobile ? 40 : 64,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  width: isMobile ? double.infinity : 500,
                                  child: Text(
                                    'Connect with verified professionals for all your home improvement and repair needs.',
                                    style: TextStyle(
                                      fontSize: isMobile ? 14 : 16,
                                      color: Colors.white.withOpacity(0.9),
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                if (!isMobile)
                                  Row(
                                    children: [
                                      _buildHeroButton(
                                        text: 'POST A JOB',
                                        onTap: () => AuthModals.showRegisterModal(context),
                                        isPrimary: true,
                                      ),
                                      const SizedBox(width: 16),
                                      _buildHeroButton(
                                        text: 'FIND WORK',
                                        onTap: () => AuthModals.showRegisterModal(context),
                                        isPrimary: false,
                                      ),
                                    ],
                                  ),
                                if (isMobile)
                                  Column(
                                    children: [
                                      _buildHeroButton(
                                        text: 'POST A JOB',
                                        onTap: () => AuthModals.showRegisterModal(context),
                                        isPrimary: true,
                                      ),
                                      const SizedBox(height: 12),
                                      _buildHeroButton(
                                        text: 'FIND WORK',
                                        onTap: () => AuthModals.showRegisterModal(context),
                                        isPrimary: false,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // How It Works Section
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: isMobile ? 40 : 60,
                        horizontal: isMobile ? 20 : 40,
                      ),
                      child: Column(
                        children: [
                          _buildSectionTitle(
                            'HOW IT WORKS',
                            'Simple steps to get started',
                            isMobile,
                          ),
                          const SizedBox(height: 40),
                          
                          // Steps Grid
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                            childAspectRatio: isMobile ? 1.5 : 1.2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            children: [
                              _buildStepCard(
                                number: '01',
                                title: 'Post a Job',
                                description: 'Describe your project and set your budget',
                                icon: Icons.post_add,
                                color: const Color(0xFFB87333),
                              ),
                              _buildStepCard(
                                number: '02',
                                title: 'Get Bids',
                                description: 'Receive proposals from skilled fundis',
                                icon: Icons.assignment_turned_in,
                                color: const Color(0xFFCD7F32),
                              ),
                              _buildStepCard(
                                number: '03',
                                title: 'Hire & Relax',
                                description: 'Choose the best fundi and get the job done',
                                icon: Icons.thumb_up,
                                color: const Color(0xFF8C7853),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Featured Jobs Section
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: isMobile ? 40 : 60,
                        horizontal: isMobile ? 20 : 40,
                      ),
                      color: const Color(0xFFF5F5F5),
                      child: Column(
                        children: [
                          _buildSectionTitle(
                            'FEATURED JOBS',
                            'Latest opportunities',
                            isMobile,
                          ),
                          const SizedBox(height: 40),
                          
                          // Jobs Grid
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              childAspectRatio: isMobile ? 1.6 : 1.3,
                            ),
                            itemCount: MockData.getFeaturedJobs().length,
                            itemBuilder: (context, index) {
                              return _buildJobCard(MockData.getFeaturedJobs()[index], isMobile);
                            },
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // View All Jobs Button
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFB87333), Color(0xFFCD7F32)],
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/jobs');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'VIEW ALL JOBS',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: isMobile ? 13 : 14,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                          size: isMobile ? 18 : 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Categories Section
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: isMobile ? 40 : 60,
                        horizontal: isMobile ? 20 : 40,
                      ),
                      child: Column(
                        children: [
                          _buildSectionTitle(
                            'CATEGORIES',
                            'Browse by service type',
                            isMobile,
                          ),
                          const SizedBox(height: 40),
                          
                          // Categories Grid
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isMobile ? 2 : (isTablet ? 3 : 4),
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: isMobile ? 1.2 : 1.1,
                            ),
                            itemCount: MockData.categories.length,
                            itemBuilder: (context, index) {
                              return _buildCategoryCard(MockData.categories[index]);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Featured Fundis Section
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: isMobile ? 40 : 60,
                        horizontal: isMobile ? 20 : 40,
                      ),
                      color: const Color(0xFFF5F5F5),
                      child: Column(
                        children: [
                          _buildSectionTitle(
                            'FEATURED FUNDIS',
                            'Top-rated professionals',
                            isMobile,
                          ),
                          const SizedBox(height: 40),
                          
                          // Fundi Slideshow
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            child: Container(
                              key: ValueKey<int>(_currentFundiIndex),
                              height: isMobile ? 180 : 220,
                              child: isMobile
                                  ? _buildFeaturedFundiCard(
                                      _featuredFundis[_currentFundiIndex], 
                                      isMobile
                                    )
                                  : Row(
                                      children: [
                                        Expanded(
                                          child: _buildFeaturedFundiCard(
                                            _featuredFundis[_currentFundiIndex % _featuredFundis.length],
                                            isMobile,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: _buildFeaturedFundiCard(
                                            _featuredFundis[(_currentFundiIndex + 1) % _featuredFundis.length],
                                            isMobile,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Slideshow Indicators
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              isMobile ? _featuredFundis.length : (_featuredFundis.length / 2).ceil(),
                              (index) {
                                bool isActive;
                                if (isMobile) {
                                  isActive = index == _currentFundiIndex;
                                } else {
                                  isActive = index == (_currentFundiIndex ~/ 2);
                                }
                                return _buildSlideIndicator(isActive, isMobile);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Footer
                  SliverToBoxAdapter(
                    child: _buildFooter(isMobile, isTablet),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
  
  // Helper Methods
  
  List<Widget> _buildNavItems() {
    final items = [
      {'label': 'Home', 'route': 'home'},
      {'label': 'Fundis', 'route': 'fundis'},
      {'label': 'Jobs', 'route': 'jobs'},
      {'label': 'How It Works', 'route': 'how_it_works'},
      {'label': 'Contact', 'route': 'contact'},
    ];
    return items.map((item) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextButton(
          onPressed: () => _navigateTo(item['route'] as String),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF2C2C2C),
          ),
          child: Text(
            item['label'] as String,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }).toList();
  }
  
  void _navigateTo(String route) {
    switch (route) {
      case 'home':
        // Already on home page, scroll to top
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        break;
      case 'fundis':
        Navigator.pushNamed(context, '/fundis');
        break;
      case 'jobs':
        Navigator.pushNamed(context, '/jobs');
        break;
      case 'how_it_works':
        // Scroll to "How It Works" section
        _scrollController.animateTo(
          500, // Approximate position
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        break;
      case 'contact':
        // Scroll to footer/contact section
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        break;
    }
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
          setState(() {
            _isMobileMenuOpen = false;
          });
          _navigateTo(item['route'] as String);
        },
      );
    }).toList();
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
  
  Widget _buildHeroButton({
    required String text,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: isPrimary
            ? const LinearGradient(
                colors: [Color(0xFFB87333), Color(0xFFCD7F32)],
              )
            : null,
        color: isPrimary ? null : Colors.white.withOpacity(0.2),
        border: isPrimary ? null : Border.all(color: Colors.white),
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
                color: isPrimary ? Colors.white : Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title, String subtitle, bool isMobile) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isMobile ? 12 : 14,
            fontWeight: FontWeight.w300,
            color: const Color(0xFFB87333),
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: isMobile ? 24 : 32,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2C2C2C),
          ),
        ),
      ],
    );
  }
  
  Widget _buildStepCard({
    required String number,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            number,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color.withOpacity(0.2),
            ),
          ),
          const SizedBox(height: 8),
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
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFeaturedFundiCard(Fundi fundi, bool isMobile) {
    return Container(
      height: isMobile ? 180 : 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: isMobile
          ? Row(
              children: [
                // Image for mobile (side layout to reduce height)
                Container(
                  width: 100,
                  height: 180,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(12),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    fundi.profileImage ?? 'https://randomuser.me/api/portraits/men/1.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                // Details for mobile
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: _buildFundiDetails(fundi, isMobile),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                // Image for desktop
                Container(
                  width: 80,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(12),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                        fundi.profileImage ?? 'https://randomuser.me/api/portraits/men/1.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Details for desktop
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: _buildFundiDetails(fundi, isMobile),
                  ),
                ),
              ],
            ),
    );
  }
  
  Widget _buildFundiDetails(Fundi fundi, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                fundi.name,
                style: TextStyle(
                  fontSize: isMobile ? 14 : 13,
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
                child: Icon(Icons.check, size: isMobile ? 8 : 7, color: Colors.white),
              ),
          ],
        ),
        const SizedBox(height: 1),
        Text(
          fundi.title,
          style: TextStyle(
            fontSize: isMobile ? 10 : 9,
            color: Colors.grey.shade600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            ...List.generate(5, (index) {
              return Icon(
                index < fundi.rating.floor()
                    ? Icons.star
                    : Icons.star_border,
                color: const Color(0xFFB87333),
                size: isMobile ? 12 : 10,
              );
            }),
            const SizedBox(width: 2),
            Text(
              '(${fundi.reviewCount})',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: isMobile ? 8 : 7,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Wrap(
          spacing: 2,
          runSpacing: 2,
          children: fundi.skills.take(isMobile ? 2 : 2).map((skill) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 4 : 3, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                skill,
                style: TextStyle(
                  fontSize: isMobile ? 8 : 7,
                  color: Colors.grey.shade700,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rate', style: TextStyle(fontSize: isMobile ? 8 : 7, color: Colors.grey)),
                Text(
                  MockData.formatCurrency(fundi.hourlyRate),
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 11,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFB87333),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Jobs', style: TextStyle(fontSize: isMobile ? 8 : 7, color: Colors.grey)),
                Text(
                  '${fundi.jobsCompleted}',
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 11,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2C2C2C),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildSlideIndicator(bool isActive, bool isMobile) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? (isMobile ? 20 : 24) : (isMobile ? 6 : 8),
      height: isMobile ? 5 : 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: isActive ? const Color(0xFFB87333) : Colors.grey.shade300,
      ),
    );
  }
  
  Widget _buildCategoryCard(Category category) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  category.icon,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 8),
                Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildJobCard(Job job, bool isMobile) {
    final client = MockData.getClientById(job.clientId);
    final category = MockData.categories.firstWhere((c) => c.id == job.categoryId);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showJobDetailsModal(job, isMobile),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: category.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(category.icon, style: const TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C2C2C),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            client?.name ?? 'Unknown',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (job.isFeatured)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB87333),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'FEATURED',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  job.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Budget', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                        Text(
                          MockData.formatCurrency(job.budget),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB87333),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Posted', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                        Text(
                          MockData.formatDate(job.postedAt),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void _showJobDetailsModal(Job job, bool isMobile) {
    final client = MockData.getClientById(job.clientId);
    final category = MockData.categories.firstWhere((c) => c.id == job.categoryId);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(category.icon, style: const TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C2C2C),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: category.color.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                category.name,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: category.color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (job.isFeatured) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFB87333),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'FEATURED',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Client Info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: const Color(0xFFB87333).withOpacity(0.1),
                            child: Text(
                              client?.name.split(' ').map((e) => e[0]).take(2).join() ?? '??',
                              style: const TextStyle(
                                color: Color(0xFFB87333),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Posted by',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                Text(
                                  client?.name ?? 'Unknown',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2C2C2C),
                                  ),
                                ),
                                if (client?.isVerified ?? false)
                                  Row(
                                    children: [
                                      Icon(Icons.verified, size: 14, color: Colors.green.shade600),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Verified Client',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.green.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.star, size: 14, color: Colors.amber.shade600),
                                  const SizedBox(width: 4),
                                  Text(
                                    client?.rating.toString() ?? '0.0',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2C2C2C),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${client?.reviewCount ?? 0} reviews',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Budget and Timeline
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailCard(
                            icon: Icons.payments_outlined,
                            label: 'Budget',
                            value: MockData.formatCurrency(job.budget),
                            color: const Color(0xFFB87333),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDetailCard(
                            icon: Icons.schedule,
                            label: 'Deadline',
                            value: job.deadline != null 
                                ? '${job.deadline!.difference(DateTime.now()).inDays} days left'
                                : 'Flexible',
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailCard(
                            icon: Icons.location_on_outlined,
                            label: 'Location',
                            value: job.location,
                            color: Colors.green.shade700,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDetailCard(
                            icon: Icons.people_outline,
                            label: 'Applications',
                            value: '${job.applicationsCount} fundis',
                            color: Colors.purple.shade700,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      job.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Required Skills
                    const Text(
                      'Required Skills',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: job.requiredSkills.map((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: category.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: category.color.withOpacity(0.3)),
                          ),
                          child: Text(
                            skill,
                            style: TextStyle(
                              fontSize: 13,
                              color: category.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Posted date
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.grey.shade500),
                        const SizedBox(width: 8),
                        Text(
                          'Posted ${MockData.formatDate(job.postedAt)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Apply Button
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.bookmark_border),
                        label: const Text('Save Job'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF2C2C2C),
                          side: const BorderSide(color: Color(0xFF2C2C2C)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFB87333), Color(0xFFCD7F32)],
                          ),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            // TODO: Navigate to apply page
                          },
                          icon: const Icon(Icons.send, color: Colors.white),
                          label: const Text('Apply Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
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
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFooterLink(String label, String route) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextButton(
        onPressed: () => _navigateTo(route),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
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
  
  Widget _buildFooter(bool isMobile, bool isTablet) {
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
            crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 4),
            childAspectRatio: isMobile ? 2 : 1.5,
            mainAxisSpacing: 30,
            crossAxisSpacing: 30,
            children: [
              // About
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
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
                  _buildFooterLink('About', 'about'),
                  _buildFooterLink('How It Works', 'how_it_works'),
                  _buildFooterLink('Fundis', 'fundis'),
                  _buildFooterLink('Jobs', 'jobs'),
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
                  ...['Contact', 'FAQ', 'Privacy', 'Terms'].map((link) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          link,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }),
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
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFFB87333), size: 14),
                      const SizedBox(width: 8),
                      Text('Nairobi, Kenya', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.phone, color: Color(0xFFB87333), size: 14),
                      const SizedBox(width: 8),
                      Text('+254 700 000000', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.email, color: Color(0xFFB87333), size: 14),
                      const SizedBox(width: 8),
                      Text('info@fundi.com', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
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
                '© 2024 Fundi Marketplace',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              if (!isMobile)
                Row(
                  children: [
                    Text('Privacy', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    const SizedBox(width: 20),
                    Text('Terms', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}