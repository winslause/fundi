import 'package:flutter/material.dart';
import 'models.dart';
import 'data.dart';
import 'components.dart';
import 'modals.dart';
import 'auth.dart';

class FundiDashboard extends StatefulWidget {
  final Fundi fundi;

  const FundiDashboard({super.key, required this.fundi});

  @override
  State<FundiDashboard> createState() => _FundiDashboardState();
}

class _FundiDashboardState extends State<FundiDashboard> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isSidebarExpanded = true;
  bool _isMobileMenuOpen = false;
  bool _showNotifications = false;
  
  late AnimationController _sidebarController;
  late Animation<double> _sidebarAnimation;
  
  // Mock data
  late List<Job> _availableJobs;
  late List<JobApplication> _myApplications;
  late List<Job> _myJobs;
  late List<Message> _messages;
  late List<AppNotification> _notifications;
  late List<Review> _reviewsReceived;
  
  // Profile editing
  bool _isEditingProfile = false;
  bool _isEditingSkills = false;
  bool _isAddingPortfolio = false;
  
  final _profileFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _titleController = TextEditingController();
  final _bioController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  
  // Skills
  List<String> _selectedSkills = [];
  final _newSkillController = TextEditingController();
  
  // Portfolio
  List<PortfolioItem> _portfolio = [];
  final _portfolioTitleController = TextEditingController();
  final _portfolioDescriptionController = TextEditingController();
  final _portfolioImageController = TextEditingController();
  
  // Filters for available jobs
  String _selectedCategory = 'All';
  String _searchQuery = '';
  RangeValues _budgetRange = const RangeValues(0, 100000);
  
  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _sidebarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _sidebarAnimation = CurvedAnimation(
      parent: _sidebarController,
      curve: Curves.easeInOut,
    );
    _sidebarController.forward();
    
    // Load fundi data
    _loadFundiData();
    
    // Initialize profile controllers
    _nameController.text = widget.fundi.name;
    _phoneController.text = widget.fundi.phone;
    _locationController.text = widget.fundi.location ?? '';
    _titleController.text = widget.fundi.title;
    _bioController.text = widget.fundi.bio;
    _hourlyRateController.text = widget.fundi.hourlyRate.toString();
    _selectedSkills = List.from(widget.fundi.skills);
    _portfolio = List.from(widget.fundi.portfolio);
  }
  
  void _loadFundiData() {
    // Get available jobs (excluding those applied to)
    _availableJobs = MockData.jobs
        .where((job) => job.status == JobStatus.open)
        .toList();
    
    // Get fundi's applications
    _myApplications = MockData.applications
        .where((app) => app.fundiId == widget.fundi.id)
        .toList();
    
    // Get jobs assigned to fundi
    _myJobs = MockData.jobs
        .where((job) => job.assignedFundiId == widget.fundi.id)
        .toList();
    
    // Get fundi's messages
    _messages = MockData.messages
        .where((msg) => 
          msg.senderId == widget.fundi.id || 
          msg.receiverId == widget.fundi.id
        )
        .toList();
    
    // Get fundi's notifications
    _notifications = MockData.notifications
        .where((notif) => notif.userId == widget.fundi.id)
        .toList();
    
    // Get reviews received
    _reviewsReceived = MockData.reviews
        .where((review) => review.toUserId == widget.fundi.id)
        .toList();
  }
  
  @override
  void dispose() {
    _sidebarController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _titleController.dispose();
    _bioController.dispose();
    _hourlyRateController.dispose();
    _newSkillController.dispose();
    _portfolioTitleController.dispose();
    _portfolioDescriptionController.dispose();
    _portfolioImageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 800;
          bool isTablet = constraints.maxWidth >= 800 && constraints.maxWidth < 1200;
          
          // Auto collapse sidebar on mobile
          if (isMobile && _isSidebarExpanded) {
            _isSidebarExpanded = false;
          }
          
          return Row(
            children: [
              // Sidebar
              if (!isMobile || _isMobileMenuOpen)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _isSidebarExpanded ? (isTablet ? 220 : 260) : 80,
                  child: _buildSidebar(isMobile, isTablet),
                ),
              
              // Main Content
              Expanded(
                child: Container(
                  color: const Color(0xFFF5F5F5),
                  child: Column(
                    children: [
                      // Top Bar
                      _buildTopBar(isMobile),
                      
                      // Main Content Area
                      Expanded(
                        child: _buildMainContent(isMobile, isTablet),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  
  // ==================== SIDEBAR ====================
  
  Widget _buildSidebar(bool isMobile, bool isTablet) {
    // Calculate profile completion percentage
    int profileCompletion = _calculateProfileCompletion();
    
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2C2C2C),
            Color(0xFF3A3A3A),
            Color(0xFF2C2C2C),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo area
          Container(
            height: 80,
            padding: EdgeInsets.symmetric(
              horizontal: _isSidebarExpanded ? 20 : 8,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFB87333), Color(0xFFCD7F32)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.build,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                if (_isSidebarExpanded) ...[
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'FUNDI\nDASHBOARD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          const Divider(color: Colors.white24, height: 1),
          
          // Profile completion bar
          if (_isSidebarExpanded) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Profile Completion',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '$profileCompletion%',
                        style: const TextStyle(
                          color: Color(0xFFB87333),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: profileCompletion / 100,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFB87333)),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                _buildSidebarItem(
                  index: 0,
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                  isMobile: isMobile,
                ),
                _buildSidebarItem(
                  index: 1,
                  icon: Icons.work,
                  label: 'Available Jobs',
                  badge: _availableJobs.length,
                  isMobile: isMobile,
                ),
                _buildSidebarItem(
                  index: 2,
                  icon: Icons.assignment,
                  label: 'My Applications',
                  badge: _myApplications.length,
                  isMobile: isMobile,
                ),
                _buildSidebarItem(
                  index: 3,
                  icon: Icons.build_circle,
                  label: 'My Jobs',
                  badge: _myJobs.length,
                  isMobile: isMobile,
                ),
                _buildSidebarItem(
                  index: 4,
                  icon: Icons.message,
                  label: 'Messages',
                  badge: _messages.length,
                  isMobile: isMobile,
                ),
                _buildSidebarItem(
                  index: 5,
                  icon: Icons.star,
                  label: 'Reviews',
                  badge: _reviewsReceived.length,
                  isMobile: isMobile,
                ),
                _buildSidebarItem(
                  index: 6,
                  icon: Icons.person,
                  label: 'Profile',
                  isMobile: isMobile,
                ),
                _buildSidebarItem(
                  index: 7,
                  icon: Icons.settings,
                  label: 'Settings',
                  isMobile: isMobile,
                ),
              ],
            ),
          ),
          
          // Expand/Collapse button (desktop only)
          if (!isMobile)
            Container(
              padding: const EdgeInsets.all(16),
              child: IconButton(
                icon: Icon(
                  _isSidebarExpanded ? Icons.chevron_left : Icons.chevron_right,
                  color: Colors.white54,
                ),
                onPressed: () {
                  setState(() {
                    _isSidebarExpanded = !_isSidebarExpanded;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildSidebarItem({
    required int index,
    required IconData icon,
    required String label,
    int? badge,
    required bool isMobile,
  }) {
    bool isSelected = _selectedIndex == index;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
            if (isMobile) {
              _isMobileMenuOpen = false;
            }
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _isSidebarExpanded ? 20 : 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFB87333).withOpacity(0.2)
                : Colors.transparent,
            border: Border(
              left: isSelected
                  ? const BorderSide(color: Color(0xFFB87333), width: 3)
                  : BorderSide.none,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFFB87333) : Colors.white54,
                size: 20,
              ),
              if (_isSidebarExpanded) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ),
                if (badge != null && badge > 0)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFB87333),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      badge.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  // ==================== TOP BAR ====================
  
  Widget _buildTopBar(bool isMobile) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Mobile menu button
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                setState(() {
                  _isMobileMenuOpen = !_isMobileMenuOpen;
                });
              },
            ),
          
          const SizedBox(width: 16),
          
          // Page title
          Text(
            _getPageTitle(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          
          const Spacer(),
          
          // Availability toggle
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: widget.fundi.isAvailable 
                  ? Colors.green.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.fundi.isAvailable ? Colors.green : Colors.grey,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  widget.fundi.isAvailable ? 'Available' : 'Unavailable',
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.fundi.isAvailable ? Colors.green : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Notifications
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  setState(() {
                    _showNotifications = !_showNotifications;
                  });
                },
              ),
              if (_notifications.where((n) => !n.isRead).isNotEmpty)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _notifications.where((n) => !n.isRead).length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          
          // User avatar
          PopupMenuButton(
            offset: const Offset(0, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person, size: 18),
                    SizedBox(width: 8),
                    Text('My Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, size: 18),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 18),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'profile') {
                setState(() => _selectedIndex = 6);
              } else if (value == 'settings') {
                setState(() => _selectedIndex = 7);
              } else if (value == 'logout') {
                _showLogoutConfirmation();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFB87333), width: 2),
              ),
              child: CircleAvatar(
                radius: 18,
                backgroundImage: widget.fundi.profileImage != null
                    ? NetworkImage(widget.fundi.profileImage!)
                    : null,
                child: widget.fundi.profileImage == null
                    ? Text(widget.fundi.name[0])
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // ==================== MAIN CONTENT ====================
  
  Widget _buildMainContent(bool isMobile, bool isTablet) {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard(isMobile, isTablet);
      case 1:
        return _buildAvailableJobs(isMobile, isTablet);
      case 2:
        return _buildMyApplications(isMobile);
      case 3:
        return _buildMyJobs(isMobile);
      case 4:
        return _buildMessages(isMobile);
      case 5:
        return _buildReviews(isMobile);
      case 6:
        return _buildProfile(isMobile);
      case 7:
        return _buildSettings(isMobile);
      default:
        return _buildDashboard(isMobile, isTablet);
    }
  }
  
  // ==================== DASHBOARD ====================
  
  Widget _buildDashboard(bool isMobile, bool isTablet) {
    // Calculate stats
    int pendingApplications = _myApplications
        .where((a) => a.status == ApplicationStatus.pending)
        .length;
    int activeJobs = _myJobs.where((j) => j.status == JobStatus.inProgress).length;
    int completedJobs = _myJobs.where((j) => j.status == JobStatus.completed).length;
    double totalEarnings = widget.fundi.earnings;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome message
          Text(
            'Welcome back, ${widget.fundi.name.split(' ')[0]}!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Here\'s your work summary',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Stats Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 2 : (isTablet ? 3 : 4),
            childAspectRatio: 1.5,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              StatsCard(
                title: 'Available Jobs',
                value: _availableJobs.length.toString(),
                icon: Icons.work,
                color: Colors.blue,
              ),
              StatsCard(
                title: 'Applications',
                value: pendingApplications.toString(),
                icon: Icons.assignment,
                color: Colors.orange,
              ),
              StatsCard(
                title: 'Active Jobs',
                value: activeJobs.toString(),
                icon: Icons.build,
                color: Colors.green,
              ),
              StatsCard(
                title: 'Completed',
                value: completedJobs.toString(),
                icon: Icons.check_circle,
                color: Colors.purple,
              ),
              StatsCard(
                title: 'Total Earnings',
                value: MockData.formatCurrency(totalEarnings),
                icon: Icons.attach_money,
                color: const Color(0xFFB87333),
              ),
              StatsCard(
                title: 'Rating',
                value: widget.fundi.rating.toStringAsFixed(1),
                icon: Icons.star,
                color: Colors.amber,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Recent Activity
          if (_myApplications.isNotEmpty) ...[
            const Text(
              'Recent Applications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C2C2C),
              ),
            ),
            const SizedBox(height: 16),
            
            ..._myApplications.take(3).map((app) => _buildApplicationTile(app)),
          ],
          
          if (_reviewsReceived.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Text(
              'Recent Reviews',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C2C2C),
              ),
            ),
            const SizedBox(height: 16),
            
            ..._reviewsReceived.take(2).map((review) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ReviewCard(review: review),
            )),
          ],
        ],
      ),
    );
  }
  
  // ==================== AVAILABLE JOBS ====================
  
  Widget _buildAvailableJobs(bool isMobile, bool isTablet) {
    // Apply filters
    var filteredJobs = _availableJobs.where((job) {
      // Category filter
      if (_selectedCategory != 'All' && job.categoryId != _selectedCategory) {
        return false;
      }
      
      // Budget filter
      if (job.budget < _budgetRange.start || job.budget > _budgetRange.end) {
        return false;
      }
      
      // Search query
      if (_searchQuery.isNotEmpty) {
        return job.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               job.description.toLowerCase().contains(_searchQuery.toLowerCase());
      }
      
      return true;
    }).toList();

    return Column(
      children: [
        // Filters bar
        Container(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          color: Colors.white,
          child: Column(
            children: [
              // Search
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search jobs...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // Category chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Text('Category: ', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 8),
                    ..._buildCategoryChips(),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Budget range
              Row(
                children: [
                  const Text('Budget Range: ', style: TextStyle(fontSize: 12)),
                  Expanded(
                    child: RangeSlider(
                      values: _budgetRange,
                      min: 0,
                      max: 100000,
                      divisions: 10,
                      labels: RangeLabels(
                        MockData.formatCurrency(_budgetRange.start),
                        MockData.formatCurrency(_budgetRange.end),
                      ),
                      onChanged: (values) {
                        setState(() {
                          _budgetRange = values;
                        });
                      },
                      activeColor: const Color(0xFFB87333),
                    ),
                  ),
                ],
              ),
              
              // Results count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${filteredJobs.length} jobs found',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'All';
                        _searchQuery = '';
                        _budgetRange = const RangeValues(0, 100000);
                      });
                    },
                    child: const Text('Clear Filters'),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const Divider(height: 1),
        
        // Jobs list
        Expanded(
          child: filteredJobs.isEmpty
              ? _buildEmptyState(
                  icon: Icons.work_outline,
                  title: 'No Jobs Found',
                  message: 'Try adjusting your filters',
                )
              : GridView.builder(
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                    childAspectRatio: 1.3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemCount: filteredJobs.length,
                  itemBuilder: (context, index) {
                    final job = filteredJobs[index];
                    final hasApplied = _myApplications.any((app) => app.jobId == job.id);
                    
                    return Stack(
                      children: [
                        JobCard(
                          job: job,
                          onTap: () => context.showJobDetails(job),
                        ),
                        if (hasApplied)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'APPLIED',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
  
  List<Widget> _buildCategoryChips() {
    final categories = ['All', ...MockData.categories.map((c) => c.id)];
    return categories.map((category) {
      bool isSelected = _selectedCategory == category;
      String label = category == 'All' ? 'All' : 
          MockData.categories.firstWhere((c) => c.id == category).name;
      
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: FilterChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedCategory = category;
            });
          },
          backgroundColor: Colors.white,
          selectedColor: const Color(0xFFB87333).withOpacity(0.2),
          checkmarkColor: const Color(0xFFB87333),
        ),
      );
    }).toList();
  }
  
  // ==================== MY APPLICATIONS ====================
  
  Widget _buildMyApplications(bool isMobile) {
    if (_myApplications.isEmpty) {
      return _buildEmptyState(
        icon: Icons.assignment_outlined,
        title: 'No Applications',
        message: 'You haven\'t applied to any jobs yet',
        buttonText: 'Browse Jobs',
        onPressed: () => setState(() => _selectedIndex = 1),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      itemCount: _myApplications.length,
      itemBuilder: (context, index) {
        final application = _myApplications[index];
        final job = MockData.jobs.firstWhere((j) => j.id == application.jobId);
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // Job icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB87333).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.work, color: Color(0xFFB87333), size: 20),
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
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Bid: ${MockData.formatCurrency(application.proposedBid)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getApplicationStatusColor(application.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getApplicationStatusText(application.status),
                      style: TextStyle(
                        fontSize: 11,
                        color: _getApplicationStatusColor(application.status),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Cover letter preview
              Text(
                application.coverLetter,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              
              // Applied date
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.access_time, size: 12, color: Colors.grey.shade400),
                  const SizedBox(width: 4),
                  Text(
                    'Applied ${MockData.formatDate(application.appliedAt)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  
  // ==================== MY JOBS ====================
  
  Widget _buildMyJobs(bool isMobile) {
    if (_myJobs.isEmpty) {
      return _buildEmptyState(
        icon: Icons.build_outlined,
        title: 'No Jobs Assigned',
        message: 'You don\'t have any active or completed jobs',
        buttonText: 'Browse Jobs',
        onPressed: () => setState(() => _selectedIndex = 1),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          // Tabs
          Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: Color(0xFFB87333),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFFB87333),
              tabs: [
                Tab(text: 'Active'),
                Tab(text: 'Completed'),
                Tab(text: 'All'),
              ],
            ),
          ),
          
          Expanded(
            child: TabBarView(
              children: [
                // Active jobs
                _buildJobList(_myJobs.where((j) => j.status == JobStatus.inProgress).toList(), isMobile),
                // Completed jobs
                _buildJobList(_myJobs.where((j) => j.status == JobStatus.completed).toList(), isMobile),
                // All jobs
                _buildJobList(_myJobs, isMobile),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildJobList(List<Job> jobs, bool isMobile) {
    if (jobs.isEmpty) {
      return Center(
        child: EmptyState(
          icon: Icons.work_outline,
          title: 'No Jobs',
          message: 'No jobs in this category',
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        final client = MockData.getClientById(job.clientId);
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: client?.profileImage != null
                        ? NetworkImage(client!.profileImage!)
                        : null,
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
                        ),
                        const SizedBox(height: 2),
                        Text(
                          client?.name ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getJobStatusColor(job.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getJobStatusText(job.status),
                      style: TextStyle(
                        fontSize: 11,
                        color: _getJobStatusColor(job.status),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Budget
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Budget: ${MockData.formatCurrency(job.budget)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB87333),
                    ),
                  ),
                  if (job.status == JobStatus.inProgress)
                    PrimaryButton(
                      text: 'Mark Complete',
                      onPressed: () {
                        _showCompleteConfirmation(job);
                      },
                      height: 36,
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  
  // ==================== MESSAGES ====================
  
  Widget _buildMessages(bool isMobile) {
    if (_messages.isEmpty) {
      return _buildEmptyState(
        icon: Icons.message_outlined,
        title: 'No Messages',
        message: 'Your conversations will appear here',
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final otherUser = MockData.getUserById(
          message.senderId == widget.fundi.id
              ? message.receiverId
              : message.senderId
        );
        
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: otherUser?.profileImage != null
                  ? NetworkImage(otherUser!.profileImage!)
                  : null,
            ),
            title: Text(
              otherUser?.name ?? 'Unknown',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C2C2C),
              ),
            ),
            subtitle: Text(
              message.content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              MockData.formatDate(message.timestamp),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
            ),
            onTap: () {
              context.showMessageModal(
                otherUser!.id,
                jobId: message.jobId,
              );
            },
          ),
        );
      },
    );
  }
  
  // ==================== REVIEWS ====================
  
  Widget _buildReviews(bool isMobile) {
    if (_reviewsReceived.isEmpty) {
      return _buildEmptyState(
        icon: Icons.star_outline,
        title: 'No Reviews Yet',
        message: 'Complete jobs to receive reviews from clients',
      );
    }

    // Calculate average rating
    double avgRating = _reviewsReceived.isEmpty 
        ? 0 
        : _reviewsReceived.map((r) => r.rating).reduce((a, b) => a + b) / _reviewsReceived.length;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating summary
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      avgRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB87333),
                      ),
                    ),
                    const Text(
                      'out of 5',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RatingStars(rating: avgRating, size: 20),
                      const SizedBox(height: 8),
                      Text(
                        'Based on ${_reviewsReceived.length} reviews',
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
          
          const SizedBox(height: 24),
          
          // Reviews list
          const Text(
            'Client Reviews',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 16),
          
          ..._reviewsReceived.map((review) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ReviewCard(review: review, showJobInfo: true),
          )),
        ],
      ),
    );
  }
  
  // ==================== PROFILE ====================
  
  Widget _buildProfile(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with edit button
            Row(
              children: [
                const Text(
                  'My Profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const Spacer(),
                if (!_isEditingProfile && !_isEditingSkills && !_isAddingPortfolio)
                  Row(
                    children: [
                      SecondaryButton(
                        text: 'Edit Profile',
                        onPressed: () {
                          setState(() {
                            _isEditingProfile = true;
                          });
                        },
                        icon: Icons.edit,
                        height: 40,
                      ),
                      const SizedBox(width: 8),
                      SecondaryButton(
                        text: 'Manage Skills',
                        onPressed: () {
                          setState(() {
                            _isEditingSkills = true;
                          });
                        },
                        icon: Icons.build,
                        height: 40,
                      ),
                    ],
                  ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Profile sections
            if (_isEditingProfile)
              _buildProfileEdit()
            else if (_isEditingSkills)
              _buildSkillsEdit()
            else if (_isAddingPortfolio)
              _buildPortfolioAdd()
            else
              _buildProfileView(),
            
            const SizedBox(height: 24),
            
            // Portfolio section
            if (!_isEditingProfile && !_isEditingSkills && !_isAddingPortfolio) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Portfolio',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _isAddingPortfolio = true;
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Item'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              if (_portfolio.isEmpty)
                Center(
                  child: EmptyState(
                    icon: Icons.work,
                    title: 'No Portfolio Items',
                    message: 'Add your work samples to attract more clients',
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 1 : (isMobile ? 2 : 3),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: _portfolio.length,
                  itemBuilder: (context, index) {
                    final item = _portfolio[index];
                    return _buildPortfolioItem(item);
                  },
                ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildProfileView() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          // Avatar
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: widget.fundi.profileImage != null
                      ? NetworkImage(widget.fundi.profileImage!)
                      : null,
                  child: widget.fundi.profileImage == null
                      ? Text(
                          widget.fundi.name[0],
                          style: const TextStyle(fontSize: 40),
                        )
                      : null,
                ),
                if (widget.fundi.isVerified)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Info rows
          _buildInfoRow(Icons.person, 'Full Name', widget.fundi.name),
          _buildInfoRow(Icons.work, 'Title', widget.fundi.title),
          _buildInfoRow(Icons.email, 'Email', widget.fundi.email),
          _buildInfoRow(Icons.phone, 'Phone', widget.fundi.phone),
          if (widget.fundi.location != null)
            _buildInfoRow(Icons.location_on, 'Location', widget.fundi.location!),
          _buildInfoRow(Icons.attach_money, 'Hourly Rate', 
              MockData.formatCurrency(widget.fundi.hourlyRate)),
          _buildInfoRow(Icons.calendar_today, 'Member Since', 
              '${widget.fundi.joinedAt.day}/${widget.fundi.joinedAt.month}/${widget.fundi.joinedAt.year}'),
          
          const SizedBox(height: 16),
          
          // Bio
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'About Me',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.fundi.bio,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
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
  
  Widget _buildProfileEdit() {
    return Form(
      key: _profileFormKey,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
            // Avatar edit
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: widget.fundi.profileImage != null
                        ? NetworkImage(widget.fundi.profileImage!)
                        : null,
                    child: widget.fundi.profileImage == null
                        ? Text(
                            widget.fundi.name[0],
                            style: const TextStyle(fontSize: 40),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB87333),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Edit fields
            CustomTextField(
              controller: _nameController,
              label: 'Full Name',
              prefixIcon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            CustomTextField(
              controller: _titleController,
              label: 'Professional Title',
              prefixIcon: Icons.work,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your title';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            CustomTextField(
              controller: _phoneController,
              label: 'Phone Number',
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            CustomTextField(
              controller: _locationController,
              label: 'Location',
              prefixIcon: Icons.location_on,
            ),
            
            const SizedBox(height: 16),
            
            CustomTextField(
              controller: _hourlyRateController,
              label: 'Hourly Rate (KSh)',
              prefixIcon: Icons.attach_money,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your hourly rate';
                }
                if (double.tryParse(value) == null) {
                  return 'Invalid amount';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            CustomTextField(
              controller: _bioController,
              label: 'Bio',
              prefixIcon: Icons.description,
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your bio';
                }
                if (value.length < 20) {
                  return 'Bio must be at least 20 characters';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 24),
            
            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlineButton(
                    text: 'Cancel',
                    onPressed: () {
                      setState(() {
                        _isEditingProfile = false;
                        // Reset controllers
                        _nameController.text = widget.fundi.name;
                        _titleController.text = widget.fundi.title;
                        _phoneController.text = widget.fundi.phone;
                        _locationController.text = widget.fundi.location ?? '';
                        _hourlyRateController.text = widget.fundi.hourlyRate.toString();
                        _bioController.text = widget.fundi.bio;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    text: 'Save Changes',
                    onPressed: () {
                      if (_profileFormKey.currentState!.validate()) {
                        // Simulate save
                        setState(() {
                          _isEditingProfile = false;
                        });
                        
                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profile updated successfully'),
                            backgroundColor: Color(0xFFB87333),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSkillsEdit() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            'Your Skills',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 16),
          
          // Current skills
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedSkills.map((skill) {
              return Chip(
                label: Text(skill),
                onDeleted: () {
                  setState(() {
                    _selectedSkills.remove(skill);
                  });
                },
                deleteIconColor: const Color(0xFFB87333),
                backgroundColor: const Color(0xFFB87333).withOpacity(0.1),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 20),
          
          // Add new skill
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _newSkillController,
                  decoration: InputDecoration(
                    hintText: 'Enter a new skill',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add, color: Color(0xFFB87333)),
                onPressed: () {
                  if (_newSkillController.text.isNotEmpty) {
                    setState(() {
                      _selectedSkills.add(_newSkillController.text);
                      _newSkillController.clear();
                    });
                  }
                },
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlineButton(
                  text: 'Cancel',
                  onPressed: () {
                    setState(() {
                      _isEditingSkills = false;
                      _selectedSkills = List.from(widget.fundi.skills);
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  text: 'Save Skills',
                  onPressed: () {
                    setState(() {
                      _isEditingSkills = false;
                    });
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Skills updated successfully'),
                        backgroundColor: Color(0xFFB87333),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildPortfolioAdd() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            'Add Portfolio Item',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 20),
          
          CustomTextField(
            controller: _portfolioTitleController,
            label: 'Project Title',
            prefixIcon: Icons.title,
          ),
          
          const SizedBox(height: 16),
          
          CustomTextField(
            controller: _portfolioDescriptionController,
            label: 'Description',
            prefixIcon: Icons.description,
            maxLines: 3,
          ),
          
          const SizedBox(height: 16),
          
          CustomTextField(
            controller: _portfolioImageController,
            label: 'Image URL',
            prefixIcon: Icons.image,
          ),
          
          const SizedBox(height: 24),
          
          Row(
            children: [
              Expanded(
                child: OutlineButton(
                  text: 'Cancel',
                  onPressed: () {
                    setState(() {
                      _isAddingPortfolio = false;
                      _portfolioTitleController.clear();
                      _portfolioDescriptionController.clear();
                      _portfolioImageController.clear();
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  text: 'Add Item',
                  onPressed: () {
                    // Create new portfolio item
                    final newItem = PortfolioItem(
                      id: 'portfolio_${DateTime.now().millisecondsSinceEpoch}',
                      title: _portfolioTitleController.text,
                      description: _portfolioDescriptionController.text,
                      imageUrl: _portfolioImageController.text,
                      completedAt: DateTime.now(),
                    );
                    
                    setState(() {
                      _portfolio.add(newItem);
                      _isAddingPortfolio = false;
                      _portfolioTitleController.clear();
                      _portfolioDescriptionController.clear();
                      _portfolioImageController.clear();
                    });
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Portfolio item added'),
                        backgroundColor: Color(0xFFB87333),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildPortfolioItem(PortfolioItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.network(
              item.imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image, color: Colors.grey),
                );
              },
            ),
          ),
          
          // Details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // ==================== SETTINGS ====================
  
  Widget _buildSettings(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C2C2C),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Manage your account preferences',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Settings sections
            _buildSettingsSection(
              'Notifications',
              [
                _buildSettingSwitch(
                  'Email Notifications',
                  'Receive job updates via email',
                  true,
                ),
                _buildSettingSwitch(
                  'Push Notifications',
                  'Get instant alerts on your device',
                  true,
                ),
                _buildSettingSwitch(
                  'Application Alerts',
                  'Get notified when your applications are viewed',
                  true,
                ),
                _buildSettingSwitch(
                  'Marketing Emails',
                  'Receive promotional offers',
                  false,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            _buildSettingsSection(
              'Availability',
              [
                _buildSettingSwitch(
                  'Available for Work',
                  'Show your profile in search results',
                  widget.fundi.isAvailable,
                ),
                ListTile(
                  leading: const Icon(Icons.timer, color: Color(0xFFB87333)),
                  title: const Text('Working Hours'),
                  subtitle: const Text('Set your availability schedule'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Show working hours modal
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            _buildSettingsSection(
              'Account',
              [
                ListTile(
                  leading: const Icon(Icons.lock, color: Color(0xFFB87333)),
                  title: const Text('Change Password'),
                  subtitle: const Text('Update your password regularly'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Show change password modal
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Delete Account'),
                  subtitle: const Text('Permanently remove your account'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showDeleteConfirmation();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSettingsSection(String title, List<Widget> children) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C2C2C),
              ),
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }
  
  Widget _buildSettingSwitch(String title, String subtitle, bool value) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: (newValue) {
        // Handle change
      },
      activeColor: const Color(0xFFB87333),
    );
  }
  
  // ==================== HELPER WIDGETS ====================
  
  Widget _buildApplicationTile(JobApplication application) {
    final job = MockData.jobs.firstWhere((j) => j.id == application.jobId);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFB87333).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.work, color: Color(0xFFB87333), size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                Text(
                  'Bid: ${MockData.formatCurrency(application.proposedBid)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getApplicationStatusColor(application.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getApplicationStatusText(application.status),
              style: TextStyle(
                fontSize: 10,
                color: _getApplicationStatusColor(application.status),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade400),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2C2C2C),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return Center(
      child: EmptyState(
        icon: icon,
        title: title,
        message: message,
        buttonText: buttonText,
        onButtonPressed: onPressed,
      ),
    );
  }
  
  // ==================== HELPER METHODS ====================
  
  int _calculateProfileCompletion() {
    int total = 0;
    if (widget.fundi.name.isNotEmpty) total += 20;
    if (widget.fundi.title.isNotEmpty) total += 15;
    if (widget.fundi.bio.isNotEmpty) total += 20;
    if (widget.fundi.skills.isNotEmpty) total += 15;
    if (widget.fundi.portfolio.isNotEmpty) total += 15;
    if (widget.fundi.profileImage != null) total += 15;
    return total;
  }
  
  String _getPageTitle() {
    const titles = [
      'Dashboard',
      'Available Jobs',
      'My Applications',
      'My Jobs',
      'Messages',
      'Reviews',
      'Profile',
      'Settings',
    ];
    return titles[_selectedIndex];
  }
  
  void _showLogoutConfirmation() {
    context.showConfirmationModal(
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'LOGOUT',
      cancelText: 'CANCEL',
      onConfirm: () {
        // Navigate to home page
        Navigator.pushReplacementNamed(context, '/');
      },
    );
  }
  
  void _showDeleteConfirmation() {
    context.showConfirmationModal(
      title: 'Delete Account',
      message: 'This action cannot be undone. All your data will be permanently removed.',
      confirmText: 'DELETE',
      cancelText: 'CANCEL',
      onConfirm: () {
        // Handle delete
      },
      isDestructive: true,
    );
  }
  
  void _showCompleteConfirmation(Job job) {
    context.showConfirmationModal(
      title: 'Mark Job Complete',
      message: 'Are you sure you want to mark this job as complete?',
      confirmText: 'COMPLETE',
      cancelText: 'CANCEL',
      onConfirm: () {
        setState(() {
          // Update job status
        });
        
        // Show review modal
        Future.delayed(const Duration(milliseconds: 500), () {
          context.showReviewModal(job.id, widget.fundi.id);
        });
      },
    );
  }
  
  Color _getApplicationStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return Colors.orange;
      case ApplicationStatus.accepted:
        return Colors.green;
      case ApplicationStatus.rejected:
        return Colors.red;
      case ApplicationStatus.withdrawn:
        return Colors.grey;
    }
  }
  
  String _getApplicationStatusText(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return 'Pending';
      case ApplicationStatus.accepted:
        return 'Accepted';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.withdrawn:
        return 'Withdrawn';
    }
  }
  
  Color _getJobStatusColor(JobStatus status) {
    switch (status) {
      case JobStatus.open:
        return Colors.green;
      case JobStatus.inProgress:
        return Colors.blue;
      case JobStatus.completed:
        return Colors.purple;
      case JobStatus.cancelled:
        return Colors.red;
    }
  }
  
  String _getJobStatusText(JobStatus status) {
    switch (status) {
      case JobStatus.open:
        return 'Open';
      case JobStatus.inProgress:
        return 'In Progress';
      case JobStatus.completed:
        return 'Completed';
      case JobStatus.cancelled:
        return 'Cancelled';
    }
  }
}