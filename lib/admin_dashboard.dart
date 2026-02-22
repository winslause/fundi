import 'package:flutter/material.dart';
import 'models.dart';
import 'data.dart';
import 'components.dart';
import 'modals.dart';

class AdminDashboard extends StatefulWidget {
  final Admin admin;

  const AdminDashboard({super.key, required this.admin});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isSidebarExpanded = true;
  bool _isMobileMenuOpen = false;
  bool _showNotifications = false;
  
  late AnimationController _sidebarController;
  late Animation<double> _sidebarAnimation;
  
  // Data
  late List<User> _allUsers;
  late List<Fundi> _allFundis;
  late List<Client> _allClients;
  late List<Job> _allJobs;
  late List<Fundi> _pendingFundis;
  late List<AppNotification> _notifications;
  
  // Search and filters
  String _searchQuery = '';
  String _userFilter = 'all';
  String _jobFilter = 'all';
  
  // Profile editing
  bool _isEditingProfile = false;
  final _profileFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _departmentController = TextEditingController();
  
  // Password change
  bool _isChangingPassword = false;
  final _passwordFormKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  
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
    
    // Load data
    _loadData();
    
    // Initialize profile controllers
    _nameController.text = widget.admin.name;
    _emailController.text = widget.admin.email;
    _phoneController.text = widget.admin.phone;
    _departmentController.text = widget.admin.department;
  }
  
  void _loadData() {
    _allUsers = [
      widget.admin,
      ...MockData.clients,
      ...MockData.fundis,
    ];
    
    _allFundis = MockData.fundis;
    _allClients = MockData.clients;
    _allJobs = MockData.jobs;
    
    // Get pending fundis (not verified)
    _pendingFundis = MockData.fundis.where((f) => !f.isVerified).toList();
    
    _notifications = MockData.notifications;
  }
  
  @override
  void dispose() {
    _sidebarController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
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
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1A1A),
            Color(0xFF2A2A2A),
            Color(0xFF1A1A1A),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
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
                      colors: [Color(0xFFB87333), Color(0xFF8B4513)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                if (_isSidebarExpanded) ...[
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'ADMIN\nPANEL',
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
          
          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                _buildSidebarItem(
                  index: 0,
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                ),
                _buildSidebarItem(
                  index: 1,
                  icon: Icons.people,
                  label: 'User Management',
                  badge: _pendingFundis.length,
                ),
                _buildSidebarItem(
                  index: 2,
                  icon: Icons.work,
                  label: 'Job Management',
                  badge: _allJobs.length,
                ),
                _buildSidebarItem(
                  index: 3,
                  icon: Icons.pending_actions,
                  label: 'Fundi Approval',
                  badge: _pendingFundis.length,
                ),
                _buildSidebarItem(
                  index: 4,
                  icon: Icons.star,
                  label: 'Featured Content',
                ),
                _buildSidebarItem(
                  index: 5,
                  icon: Icons.category,
                  label: 'Categories',
                ),
                _buildSidebarItem(
                  index: 6,
                  icon: Icons.analytics,
                  label: 'Analytics',
                ),
                _buildSidebarItem(
                  index: 7,
                  icon: Icons.person,
                  label: 'Profile',
                ),
                _buildSidebarItem(
                  index: 8,
                  icon: Icons.settings,
                  label: 'Settings',
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
  }) {
    bool isSelected = _selectedIndex == index;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
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
          
          // Search bar (desktop only)
          if (!isMobile)
            Container(
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search users, jobs...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
          
          const SizedBox(width: 16),
          
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
          
          // Admin avatar
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
                setState(() => _selectedIndex = 7);
              } else if (value == 'settings') {
                setState(() => _selectedIndex = 8);
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
                backgroundImage: widget.admin.profileImage != null
                    ? NetworkImage(widget.admin.profileImage!)
                    : null,
                child: widget.admin.profileImage == null
                    ? Text(widget.admin.name[0])
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
        return _buildUserManagement(isMobile, isTablet);
      case 2:
        return _buildJobManagement(isMobile, isTablet);
      case 3:
        return _buildFundiApproval(isMobile);
      case 4:
        return _buildFeaturedContent(isMobile);
      case 5:
        return _buildCategoryManagement(isMobile);
      case 6:
        return _buildAnalytics(isMobile, isTablet);
      case 7:
        return _buildProfile(isMobile);
      case 8:
        return _buildSettings(isMobile);
      default:
        return _buildDashboard(isMobile, isTablet);
    }
  }
  
  // ==================== DASHBOARD ====================
  
  Widget _buildDashboard(bool isMobile, bool isTablet) {
    // Calculate stats
    int totalUsers = _allUsers.length;
    int totalFundis = _allFundis.length;
    int totalClients = _allClients.length;
    int totalJobs = _allJobs.length;
    int activeJobs = _allJobs.where((j) => j.status == JobStatus.inProgress).length;
    int completedJobs = _allJobs.where((j) => j.status == JobStatus.completed).length;
    double totalRevenue = _allJobs
        .where((j) => j.status == JobStatus.completed)
        .fold(0, (sum, job) => sum + job.budget);

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome message
          Text(
            'Welcome back, ${widget.admin.name}!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Here\'s what\'s happening on your platform',
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
                title: 'Total Users',
                value: totalUsers.toString(),
                icon: Icons.people,
                color: Colors.blue,
                change: 12.5,
                isPositive: true,
              ),
              StatsCard(
                title: 'Total Fundis',
                value: totalFundis.toString(),
                icon: Icons.build,
                color: const Color(0xFFB87333),
                change: 8.3,
                isPositive: true,
              ),
              StatsCard(
                title: 'Total Clients',
                value: totalClients.toString(),
                icon: Icons.person,
                color: Colors.green,
                change: 15.2,
                isPositive: true,
              ),
              StatsCard(
                title: 'Total Jobs',
                value: totalJobs.toString(),
                icon: Icons.work,
                color: Colors.purple,
                change: 5.7,
                isPositive: true,
              ),
              StatsCard(
                title: 'Active Jobs',
                value: activeJobs.toString(),
                icon: Icons.trending_up,
                color: Colors.orange,
              ),
              StatsCard(
                title: 'Completed',
                value: completedJobs.toString(),
                icon: Icons.check_circle,
                color: Colors.teal,
              ),
              StatsCard(
                title: 'Pending Fundis',
                value: _pendingFundis.length.toString(),
                icon: Icons.pending_actions,
                color: Colors.red,
              ),
              StatsCard(
                title: 'Revenue',
                value: MockData.formatCurrency(totalRevenue),
                icon: Icons.attach_money,
                color: Colors.indigo,
                change: 22.8,
                isPositive: true,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Recent Activity
          Row(
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C2C2C),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(20),
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
                _buildActivityItem(
                  'New fundi registered',
                  'James Odhiambo just joined as an Electrician',
                  '5 min ago',
                  Icons.person_add,
                ),
                const Divider(),
                _buildActivityItem(
                  'Job posted',
                  'New plumbing job in Kilimani',
                  '15 min ago',
                  Icons.work,
                ),
                const Divider(),
                _buildActivityItem(
                  'Application received',
                  'David Kamau applied for a plumbing job',
                  '1 hour ago',
                  Icons.assignment,
                ),
                const Divider(),
                _buildActivityItem(
                  'Job completed',
                  'Electrical job in Westlands marked completed',
                  '2 hours ago',
                  Icons.check_circle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActivityItem(String title, String subtitle, String time, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFB87333).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFFB87333), size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2C2C2C),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        Text(
          time,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }
  
  // ==================== USER MANAGEMENT ====================
  
  Widget _buildUserManagement(bool isMobile, bool isTablet) {
    // Filter users based on search and role filter
    List<User> filteredUsers = _allUsers.where((user) {
      bool matchesSearch = _searchQuery.isEmpty ||
          user.name.toLowerCase().contains(_searchQuery) ||
          user.email.toLowerCase().contains(_searchQuery);
      
      bool matchesFilter = _userFilter == 'all' ||
          (_userFilter == 'fundis' && user.role == UserRole.fundi) ||
          (_userFilter == 'clients' && user.role == UserRole.client) ||
          (_userFilter == 'admin' && user.role == UserRole.admin);
      
      return matchesSearch && matchesFilter;
    }).toList();

    return Column(
      children: [
        // Filters
        Container(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Row(
            children: [
              const Text(
                'Filter:',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2C2C2C),
                ),
              ),
              const SizedBox(width: 16),
              _buildFilterChip('All', _userFilter == 'all', () {
                setState(() => _userFilter = 'all');
              }),
              _buildFilterChip('Fundis', _userFilter == 'fundis', () {
                setState(() => _userFilter = 'fundis');
              }),
              _buildFilterChip('Clients', _userFilter == 'clients', () {
                setState(() => _userFilter = 'clients');
              }),
              _buildFilterChip('Admins', _userFilter == 'admin', () {
                setState(() => _userFilter = 'admin');
              }),
            ],
          ),
        ),
        
        // Users table/list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
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
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.profileImage != null
                        ? NetworkImage(user.profileImage!)
                        : null,
                    child: user.profileImage == null
                        ? Text(user.name[0])
                        : null,
                  ),
                  title: Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                  subtitle: Text(user.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RoleBadge(role: user.role),
                      const SizedBox(width: 8),
                      if (user.isVerified)
                        const Icon(Icons.verified, color: Colors.green, size: 16),
                      PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'view',
                            child: Text('View Details'),
                          ),
                          if (user.role != UserRole.admin) ...[
                            const PopupMenuItem(
                              value: 'suspend',
                              child: Text('Suspend User'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete User'),
                            ),
                          ],
                        ],
                        onSelected: (value) {
                          if (value == 'suspend') {
                            _showSuspendConfirmation(user);
                          } else if (value == 'delete') {
                            _showDeleteUserConfirmation(user);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  // ==================== JOB MANAGEMENT ====================
  
  Widget _buildJobManagement(bool isMobile, bool isTablet) {
    // Filter jobs
    List<Job> filteredJobs = _allJobs.where((job) {
      bool matchesSearch = _searchQuery.isEmpty ||
          job.title.toLowerCase().contains(_searchQuery);
      
      bool matchesFilter = _jobFilter == 'all' ||
          (_jobFilter == 'open' && job.status == JobStatus.open) ||
          (_jobFilter == 'inprogress' && job.status == JobStatus.inProgress) ||
          (_jobFilter == 'completed' && job.status == JobStatus.completed);
      
      return matchesSearch && matchesFilter;
    }).toList();

    return Column(
      children: [
        // Filters
        Container(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const Text(
                  'Filter:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(width: 16),
                _buildFilterChip('All', _jobFilter == 'all', () {
                  setState(() => _jobFilter = 'all');
                }),
                _buildFilterChip('Open', _jobFilter == 'open', () {
                  setState(() => _jobFilter = 'open');
                }),
                _buildFilterChip('In Progress', _jobFilter == 'inprogress', () {
                  setState(() => _jobFilter = 'inprogress');
                }),
                _buildFilterChip('Completed', _jobFilter == 'completed', () {
                  setState(() => _jobFilter = 'completed');
                }),
              ],
            ),
          ),
        ),
        
        // Jobs grid
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
              childAspectRatio: 1.3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: filteredJobs.length,
            itemBuilder: (context, index) {
              return JobCard(
                job: filteredJobs[index],
                onTap: () => _showJobDetails(filteredJobs[index]),
              );
            },
          ),
        ),
      ],
    );
  }
  
  // ==================== FUNDI APPROVAL ====================
  
  Widget _buildFundiApproval(bool isMobile) {
    if (_pendingFundis.isEmpty) {
      return _buildEmptyState(
        icon: Icons.check_circle,
        title: 'No Pending Approvals',
        message: 'All fundis have been verified',
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      itemCount: _pendingFundis.length,
      itemBuilder: (context, index) {
        final fundi = _pendingFundis[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
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
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: fundi.profileImage != null
                        ? NetworkImage(fundi.profileImage!)
                        : null,
                    child: fundi.profileImage == null
                        ? Text(fundi.name[0])
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fundi.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C2C2C),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          fundi.title,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          children: fundi.skills.take(3).map((skill) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                skill,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Documents
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Documents:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildDocumentTile('ID Card', Icons.badge),
                        const SizedBox(width: 12),
                        _buildDocumentTile('Certificate', Icons.card_membership),
                        const SizedBox(width: 12),
                        _buildDocumentTile('License', Icons.verified),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlineButton(
                      text: 'View Profile',
                      onPressed: () {
                        context.showFundiProfile(fundi);
                      },
                      icon: Icons.person,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Approve',
                      onPressed: () {
                        _showApproveConfirmation(fundi);
                      },
                      icon: Icons.check,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlineButton(
                      text: 'Reject',
                      onPressed: () {
                        _showRejectConfirmation(fundi);
                      },
                      icon: Icons.close,
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
  
  Widget _buildDocumentTile(String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFFB87333), size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // ==================== FEATURED CONTENT ====================
  
  Widget _buildFeaturedContent(bool isMobile) {
    List<Fundi> featuredFundis = MockData.fundis.where((f) => f.isFeatured).toList();
    List<Job> featuredJobs = MockData.jobs.where((j) => j.isFeatured).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured Fundis
          const Text(
            'Featured Fundis',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 16),
          
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 3,
              childAspectRatio: 1.2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: featuredFundis.length + 1, // +1 for add button
            itemBuilder: (context, index) {
              if (index == featuredFundis.length) {
                return _buildAddFeaturedCard(
                  'Add Featured Fundi',
                  Icons.person_add,
                  () {
                    // Show fundi selection modal
                  },
                );
              }
              return _buildFeaturedFundiCard(featuredFundis[index]);
            },
          ),
          
          const SizedBox(height: 24),
          
          // Featured Jobs
          const Text(
            'Featured Jobs',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 16),
          
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 3,
              childAspectRatio: 1.2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: featuredJobs.length + 1, // +1 for add button
            itemBuilder: (context, index) {
              if (index == featuredJobs.length) {
                return _buildAddFeaturedCard(
                  'Add Featured Job',
                  Icons.work_add,
                  () {
                    // Show job selection modal
                  },
                );
              }
              return _buildFeaturedJobCard(featuredJobs[index]);
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildFeaturedFundiCard(Fundi fundi) {
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
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  fundi.profileImage ?? 'https://randomuser.me/api/portraits/men/1.jpg',
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Details
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fundi.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fundi.title,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Remove button
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.close, size: 16),
                onPressed: () {
                  _showRemoveFeaturedConfirmation('fundi', fundi.name);
                },
              ),
            ),
          ),
          // Featured badge
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          ),
        ],
      ),
    );
  }
  
  Widget _buildFeaturedJobCard(Job job) {
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
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  job.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      MockData.formatCurrency(job.budget),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB87333),
                      ),
                    ),
                    Text(
                      job.location,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Remove button
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.close, size: 16),
                onPressed: () {
                  _showRemoveFeaturedConfirmation('job', job.title);
                },
              ),
            ),
          ),
          // Featured badge
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          ),
        ],
      ),
    );
  }
  
  Widget _buildAddFeaturedCard(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.grey.shade400, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  // ==================== CATEGORY MANAGEMENT ====================
  
  Widget _buildCategoryManagement(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        children: [
          // Add category button
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Row(
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const Spacer(),
                PrimaryButton(
                  text: 'Add Category',
                  onPressed: () {
                    _showAddCategoryModal();
                  },
                  icon: Icons.add,
                  height: 40,
                ),
              ],
            ),
          ),
          
          // Categories list
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: MockData.categories.length,
            itemBuilder: (context, index) {
              final category = MockData.categories[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
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
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: category.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      category.icon,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  title: Text(
                    category.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                  subtitle: Text('${category.jobCount} jobs • ${category.fundiCount} fundis'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xFFB87333)),
                        onPressed: () {
                          _showEditCategoryModal(category);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteCategoryConfirmation(category);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  // ==================== ANALYTICS ====================
  
  Widget _buildAnalytics(bool isMobile, bool isTablet) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Platform Analytics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Detailed insights about your platform',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Charts placeholder
          Container(
            height: 300,
            padding: const EdgeInsets.all(20),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.show_chart,
                  size: 60,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'Analytics Dashboard',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'User growth, job trends, and revenue charts will be displayed here',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Top categories
          const Text(
            'Top Categories',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 16),
          
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
            childAspectRatio: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: MockData.categories.take(6).map((category) {
              return Container(
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
                        color: category.color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Text(category.icon, style: const TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            category.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2C2C2C),
                            ),
                          ),
                          Text(
                            '${category.jobCount} jobs',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
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
            // Header
            Row(
              children: [
                const Text(
                  'Admin Profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const Spacer(),
                if (!_isEditingProfile && !_isChangingPassword)
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
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Profile content
            if (!_isEditingProfile && !_isChangingPassword)
              _buildProfileView()
            else if (_isEditingProfile)
              _buildProfileEdit()
            else
              _buildPasswordChange(),
            
            const SizedBox(height: 24),
            
            // Change password button (when not editing)
            if (!_isEditingProfile && !_isChangingPassword)
              Center(
                child: OutlineButton(
                  text: 'Change Password',
                  onPressed: () {
                    setState(() {
                      _isChangingPassword = true;
                    });
                  },
                  icon: Icons.lock,
                  width: 200,
                ),
              ),
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
                  radius: 50,
                  backgroundImage: widget.admin.profileImage != null
                      ? NetworkImage(widget.admin.profileImage!)
                      : null,
                  child: widget.admin.profileImage == null
                      ? Text(
                          widget.admin.name[0],
                          style: const TextStyle(fontSize: 40),
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.purple,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Info rows
          _buildInfoRow(Icons.person, 'Full Name', widget.admin.name),
          _buildInfoRow(Icons.email, 'Email', widget.admin.email),
          _buildInfoRow(Icons.phone, 'Phone', widget.admin.phone),
          _buildInfoRow(Icons.business, 'Department', widget.admin.department),
          _buildInfoRow(Icons.calendar_today, 'Joined', 
              '${widget.admin.joinedAt.day}/${widget.admin.joinedAt.month}/${widget.admin.joinedAt.year}'),
          _buildInfoRow(Icons.security, 'Permissions', widget.admin.permissions.join(', ')),
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
                    radius: 50,
                    backgroundImage: widget.admin.profileImage != null
                        ? NetworkImage(widget.admin.profileImage!)
                        : null,
                    child: widget.admin.profileImage == null
                        ? Text(
                            widget.admin.name[0],
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
                        size: 16,
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
              controller: _emailController,
              label: 'Email',
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Invalid email';
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
              controller: _departmentController,
              label: 'Department',
              prefixIcon: Icons.business,
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
                        _nameController.text = widget.admin.name;
                        _emailController.text = widget.admin.email;
                        _phoneController.text = widget.admin.phone;
                        _departmentController.text = widget.admin.department;
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
  
  Widget _buildPasswordChange() {
    return Form(
      key: _passwordFormKey,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Change Password',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C2C2C),
              ),
            ),
            const SizedBox(height: 20),
            
            // Current Password
            TextFormField(
              controller: _currentPasswordController,
              obscureText: !_showCurrentPassword,
              decoration: InputDecoration(
                labelText: 'Current Password',
                prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFB87333)),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showCurrentPassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _showCurrentPassword = !_showCurrentPassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter current password';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // New Password
            TextFormField(
              controller: _newPasswordController,
              obscureText: !_showNewPassword,
              decoration: InputDecoration(
                labelText: 'New Password',
                prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFB87333)),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showNewPassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _showNewPassword = !_showNewPassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter new password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Confirm Password
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: !_showConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFB87333)),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _showConfirmPassword = !_showConfirmPassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm new password';
                }
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
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
                        _isChangingPassword = false;
                        _currentPasswordController.clear();
                        _newPasswordController.clear();
                        _confirmPasswordController.clear();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    text: 'Update Password',
                    onPressed: () {
                      if (_passwordFormKey.currentState!.validate()) {
                        // Simulate password change
                        setState(() {
                          _isChangingPassword = false;
                        });
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password updated successfully'),
                            backgroundColor: Color(0xFFB87333),
                          ),
                        );
                        
                        // Clear fields
                        _currentPasswordController.clear();
                        _newPasswordController.clear();
                        _confirmPasswordController.clear();
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
              'Configure platform settings',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Platform Settings
            _buildSettingsSection(
              'Platform Settings',
              [
                _buildSettingSwitch(
                  'Maintenance Mode',
                  'Put platform under maintenance',
                  false,
                ),
                _buildSettingSwitch(
                  'New Registrations',
                  'Allow new users to register',
                  true,
                ),
                _buildSettingSwitch(
                  'Auto-verify Fundis',
                  'Automatically verify new fundis',
                  false,
                ),
                ListTile(
                  leading: const Icon(Icons.attach_money, color: Color(0xFFB87333)),
                  title: const Text('Commission Rate'),
                  subtitle: const Text('Platform fee percentage'),
                  trailing: const Text('10%', style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    // Show commission edit
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Notification Settings
            _buildSettingsSection(
              'Notifications',
              [
                _buildSettingSwitch(
                  'Email Notifications',
                  'Receive system alerts via email',
                  true,
                ),
                _buildSettingSwitch(
                  'New User Alerts',
                  'Get notified when new users register',
                  true,
                ),
                _buildSettingSwitch(
                  'Job Reports',
                  'Receive daily job reports',
                  false,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Security Settings
            _buildSettingsSection(
              'Security',
              [
                _buildSettingSwitch(
                  'Two-Factor Auth',
                  'Require 2FA for admin accounts',
                  true,
                ),
                _buildSettingSwitch(
                  'Login Alerts',
                  'Email on new admin logins',
                  true,
                ),
                ListTile(
                  leading: const Icon(Icons.timer, color: Color(0xFFB87333)),
                  title: const Text('Session Timeout'),
                  subtitle: const Text('Auto logout after inactivity'),
                  trailing: const Text('30 min', style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    // Show timeout options
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // ==================== HELPER WIDGETS ====================
  
  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFFB87333).withOpacity(0.2),
        checkmarkColor: const Color(0xFFB87333),
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
  
  String _getPageTitle() {
    const titles = [
      'Dashboard',
      'User Management',
      'Job Management',
      'Fundi Approval',
      'Featured Content',
      'Categories',
      'Analytics',
      'Profile',
      'Settings',
    ];
    return titles[_selectedIndex];
  }
  
  void _showJobDetails(Job job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => JobDetailsModal(job: job),
    );
  }
  
  void _showAddCategoryModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Category Name',
                hintText: 'e.g., Plumbing',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Icon',
                hintText: 'Enter emoji',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            text: 'Add',
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Category added successfully'),
                  backgroundColor: Color(0xFFB87333),
                ),
              );
            },
            height: 40,
          ),
        ],
      ),
    );
  }
  
  void _showEditCategoryModal(Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Category Name',
              ),
              controller: TextEditingController(text: category.name),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Icon',
              ),
              controller: TextEditingController(text: category.icon),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            text: 'Save',
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Category updated successfully'),
                  backgroundColor: Color(0xFFB87333),
                ),
              );
            },
            height: 40,
          ),
        ],
      ),
    );
  }
  
  void _showDeleteCategoryConfirmation(Category category) {
    context.showConfirmationModal(
      title: 'Delete Category',
      message: 'Are you sure you want to delete ${category.name}? This action cannot be undone.',
      confirmText: 'DELETE',
      cancelText: 'CANCEL',
      onConfirm: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${category.name} deleted successfully'),
            backgroundColor: const Color(0xFFB87333),
          ),
        );
      },
      isDestructive: true,
    );
  }
  
  void _showApproveConfirmation(Fundi fundi) {
    context.showConfirmationModal(
      title: 'Approve Fundi',
      message: 'Are you sure you want to approve ${fundi.name}?',
      confirmText: 'APPROVE',
      cancelText: 'CANCEL',
      onConfirm: () {
        setState(() {
          _pendingFundis.remove(fundi);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${fundi.name} has been approved'),
            backgroundColor: const Color(0xFFB87333),
          ),
        );
      },
    );
  }
  
  void _showRejectConfirmation(Fundi fundi) {
    context.showConfirmationModal(
      title: 'Reject Fundi',
      message: 'Are you sure you want to reject ${fundi.name}?',
      confirmText: 'REJECT',
      cancelText: 'CANCEL',
      onConfirm: () {
        setState(() {
          _pendingFundis.remove(fundi);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${fundi.name} has been rejected'),
            backgroundColor: Colors.red,
          ),
        );
      },
      isDestructive: true,
    );
  }
  
  void _showRemoveFeaturedConfirmation(String type, String name) {
    context.showConfirmationModal(
      title: 'Remove Featured',
      message: 'Are you sure you want to remove this $type from featured?',
      confirmText: 'REMOVE',
      cancelText: 'CANCEL',
      onConfirm: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$name removed from featured'),
            backgroundColor: const Color(0xFFB87333),
          ),
        );
      },
    );
  }
  
  void _showSuspendConfirmation(User user) {
    context.showConfirmationModal(
      title: 'Suspend User',
      message: 'Are you sure you want to suspend ${user.name}?',
      confirmText: 'SUSPEND',
      cancelText: 'CANCEL',
      onConfirm: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${user.name} has been suspended'),
            backgroundColor: Colors.orange,
          ),
        );
      },
    );
  }
  
  void _showDeleteUserConfirmation(User user) {
    context.showConfirmationModal(
      title: 'Delete User',
      message: 'Are you sure you want to delete ${user.name}? This action cannot be undone.',
      confirmText: 'DELETE',
      cancelText: 'CANCEL',
      onConfirm: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${user.name} has been deleted'),
            backgroundColor: Colors.red,
          ),
        );
      },
      isDestructive: true,
    );
  }
  
  void _showLogoutConfirmation() {
    context.showConfirmationModal(
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'LOGOUT',
      cancelText: 'CANCEL',
      onConfirm: () {
        Navigator.pushReplacementNamed(context, '/');
      },
    );
  }
}