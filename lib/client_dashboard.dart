import 'package:flutter/material.dart';
import 'models.dart';
import 'data.dart';
import 'components.dart';
import 'modals.dart';
import 'auth.dart';

class ClientDashboard extends StatefulWidget {
  final Client client;

  const ClientDashboard({super.key, required this.client});

  @override
  State<ClientDashboard> createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isSidebarExpanded = true;
  bool _isMobileMenuOpen = false;
  bool _showNotifications = false;
  
  late AnimationController _sidebarController;
  late Animation<double> _sidebarAnimation;
  
  // Mock data
  late List<Job> _clientJobs;
  late List<JobApplication> _receivedApplications;
  late List<Message> _messages;
  late List<AppNotification> _notifications;
  late List<Review> _reviewsGiven;
  
  // Profile editing
  bool _isEditingProfile = false;
  final _profileFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _sidebarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds 300),
    );
    _sidebarAnimation = CurvedAnimation(
      parent: _sidebarController,
      curve: Curves.easeInOut,
    );
    _sidebarController.forward();
    
    // Load client data
    _loadClientData();
    
    // Initialize profile controllers
    _nameController.text = widget.client.name;
    _phoneController.text = widget.client.phone;
    _locationController.text = widget.client.location ?? '';
  }
  
  void _loadClientData() {
    // Get client's jobs
    _clientJobs = MockData.jobs
        .where((job) => job.clientId == widget.client.id)
        .toList();
    
    // Get applications for client's jobs
    _receivedApplications = MockData.applications
        .where((app) => 
          _clientJobs.any((job) => job.id == app.jobId)
        )
        .toList();
    
    // Get client's messages
    _messages = MockData.messages
        .where((msg) => 
          msg.senderId == widget.client.id || 
          msg.receiverId == widget.client.id
        )
        .toList();
    
    // Get client's notifications
    _notifications = MockData.notifications
        .where((notif) => notif.userId == widget.client.id)
        .toList();
    
    // Get reviews given by client
    _reviewsGiven = MockData.reviews
        .where((review) => review.fromUserId == widget.client.id)
        .toList();
  }
  
  @override
  void dispose() {
    _sidebarController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
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
                      'FUNDI\nCLIENT',
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
                  isMobile: isMobile,
                ),
                _buildSidebarItem(
                  index: 1,
                  icon: Icons.post_add,
                  label: 'Post Job',
                  isMobile: isMobile,
                ),
                _buildSidebarItem(
                  index: 2,
                  icon: Icons.work,
                  label: 'My Jobs',
                  badge: _clientJobs.length,
                  isMobile: isMobile,
                ),
                _buildSidebarItem(
                  index: 3,
                  icon: Icons.assignment_turned_in,
                  label: 'Applications',
                  badge: _receivedApplications.length,
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
                  icon: Icons.reviews,
                  label: 'Reviews',
                  badge: _reviewsGiven.length,
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
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
                onSubmitted: (value) {
                  // Handle search
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
                backgroundImage: widget.client.profileImage != null
                    ? NetworkImage(widget.client.profileImage!)
                    : null,
                child: widget.client.profileImage == null
                    ? Text(widget.client.name[0])
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
        return _buildPostJob(isMobile);
      case 2:
        return _buildMyJobs(isMobile, isTablet);
      case 3:
        return _buildApplications(isMobile, isTablet);
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
    int activeJobs = _clientJobs.where((j) => j.status == JobStatus.inProgress).length;
    int completedJobs = _clientJobs.where((j) => j.status == JobStatus.completed).length;
    double totalSpent = _clientJobs
        .where((j) => j.status == JobStatus.completed)
        .fold(0, (sum, job) => sum + job.budget);
    int pendingApplications = _receivedApplications
        .where((a) => a.status == ApplicationStatus.pending)
        .length;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome message
          Text(
            'Welcome back, ${widget.client.name.split(' ')[0]}!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Here\'s what\'s happening with your projects',
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
                title: 'Active Jobs',
                value: activeJobs.toString(),
                icon: Icons.work,
                color: Colors.blue,
              ),
              StatsCard(
                title: 'Completed',
                value: completedJobs.toString(),
                icon: Icons.check_circle,
                color: Colors.green,
              ),
              StatsCard(
                title: 'Total Spent',
                value: MockData.formatCurrency(totalSpent),
                icon: Icons.attach_money,
                color: const Color(0xFFB87333),
              ),
              StatsCard(
                title: 'Applications',
                value: pendingApplications.toString(),
                icon: Icons.people,
                color: Colors.purple,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Recent Activity
          if (_clientJobs.isNotEmpty) ...[
            const Text(
              'Recent Jobs',
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
                crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                childAspectRatio: 1.3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: _clientJobs.take(3).length,
              itemBuilder: (context, index) {
                return JobCard(
                  job: _clientJobs[index],
                  onTap: () => context.showJobDetails(_clientJobs[index]),
                );
              },
            ),
          ] else ...[
            _buildEmptyState(
              icon: Icons.work_outline,
              title: 'No Jobs Yet',
              message: 'Post your first job to get started',
              buttonText: 'Post a Job',
              onPressed: () => setState(() => _selectedIndex = 1),
            ),
          ],
        ],
      ),
    );
  }
  
  // ==================== POST JOB ====================
  
  Widget _buildPostJob(bool isMobile) {
    final _formKey = GlobalKey<FormState>();
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _budgetController = TextEditingController();
    final _locationController = TextEditingController();
    String? _selectedCategory;
    List<String> _selectedSkills = [];
    bool _isPosting = false;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Post a New Job',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C2C2C),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Fill in the details to find the perfect fundi',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Job Title
              CustomTextField(
                controller: _titleController,
                label: 'Job Title',
                hint: 'e.g., Fix leaking bathroom pipes',
                prefixIcon: Icons.title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a job title';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Category
              CustomDropdown<String>(
                value: _selectedCategory,
                label: 'Category',
                items: MockData.categories.map((category) {
                  return DropdownMenuItem(
                    value: category.id,
                    child: Row(
                      children: [
                        Text(category.icon),
                        const SizedBox(width: 8),
                        Text(category.name),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                    // Update skills based on category
                    _selectedSkills = [];
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Description
              CustomTextField(
                controller: _descriptionController,
                label: 'Job Description',
                hint: 'Describe the job in detail...',
                prefixIcon: Icons.description,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a job description';
                  }
                  if (value.length < 20) {
                    return 'Description must be at least 20 characters';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Budget and Location row
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _budgetController,
                      label: 'Budget (KSh)',
                      hint: 'e.g., 5000',
                      prefixIcon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter budget';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid amount';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _locationController,
                      label: 'Location',
                      hint: 'e.g., Nairobi',
                      prefixIcon: Icons.location_on,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter location';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Required Skills (mock)
              const Text(
                'Required Skills (Optional)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2C2C2C),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Plumbing', 'Electrical', 'Carpentry', 'Painting',
                  'Welding', 'Masonry', 'Roofing', 'Landscaping'
                ].map((skill) {
                  bool isSelected = _selectedSkills.contains(skill);
                  return FilterChip(
                    label: Text(skill),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedSkills.add(skill);
                        } else {
                          _selectedSkills.remove(skill);
                        }
                      });
                    },
                    selectedColor: const Color(0xFFB87333).withOpacity(0.2),
                    checkmarkColor: const Color(0xFFB87333),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 24),
              
              // Post button
              PrimaryButton(
                text: 'POST JOB',
                onPressed: _isPosting ? null : () {
                  if (_formKey.currentState!.validate()) {
                    setState(() => _isPosting = true);
                    
                    // Simulate API call
                    Future.delayed(const Duration(seconds: 2), () {
                      if (!mounted) return;
                      setState(() => _isPosting = false);
                      
                      // Show success message
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Icon(Icons.check_circle, color: Color(0xFFB87333), size: 60),
                          content: const Text(
                            'Job posted successfully!',
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() => _selectedIndex = 2);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: const Color(0xFFB87333),
                                ),
                                child: const Text('View My Jobs'),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
                  }
                },
                isLoading: _isPosting,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // ==================== MY JOBS ====================
  
  Widget _buildMyJobs(bool isMobile, bool isTablet) {
    if (_clientJobs.isEmpty) {
      return _buildEmptyState(
        icon: Icons.work_outline,
        title: 'No Jobs Posted',
        message: 'You haven\'t posted any jobs yet',
        buttonText: 'Post a Job',
        onPressed: () => setState(() => _selectedIndex = 1),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filters
          Row(
            children: [
              const Text(
                'Filter:',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2C2C2C),
                ),
              ),
              const SizedBox(width: 16),
              _buildFilterChip('All', true),
              _buildFilterChip('Open', false),
              _buildFilterChip('In Progress', false),
              _buildFilterChip('Completed', false),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Jobs grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
              childAspectRatio: 1.3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: _clientJobs.length,
            itemBuilder: (context, index) {
              return JobCard(
                job: _clientJobs[index],
                onTap: () => context.showJobDetails(_clientJobs[index]),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {},
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFFB87333).withOpacity(0.2),
        checkmarkColor: const Color(0xFFB87333),
      ),
    );
  }
  
  // ==================== APPLICATIONS ====================
  
  Widget _buildApplications(bool isMobile, bool isTablet) {
    if (_receivedApplications.isEmpty) {
      return _buildEmptyState(
        icon: Icons.assignment_turned_in_outlined,
        title: 'No Applications',
        message: 'You haven\'t received any applications yet',
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Applications Received',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 20),
          
          // Applications list
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _receivedApplications.length,
            itemBuilder: (context, index) {
              final application = _receivedApplications[index];
              final job = _clientJobs.firstWhere((j) => j.id == application.jobId);
              final fundi = MockData.getFundiById(application.fundiId);
              
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
                        // Fundi info
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: fundi?.profileImage != null
                              ? NetworkImage(fundi!.profileImage!)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fundi?.name ?? 'Unknown',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C2C2C),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                job.title,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Bid
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Bid:',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            Text(
                              MockData.formatCurrency(application.proposedBid),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB87333),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Cover letter
                    Text(
                      application.coverLetter,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (application.status == ApplicationStatus.pending) ...[
                          OutlineButton(
                            text: 'View Profile',
                            onPressed: () {
                              if (fundi != null) {
                                context.showFundiProfile(fundi);
                              }
                            },
                            height: 40,
                          ),
                          const SizedBox(width: 8),
                          PrimaryButton(
                            text: 'Accept',
                            onPressed: () {
                              _showAcceptConfirmation(application);
                            },
                            height: 40,
                          ),
                        ] else ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getApplicationStatusColor(application.status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _getApplicationStatusText(application.status),
                              style: TextStyle(
                                color: _getApplicationStatusColor(application.status),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
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
          message.senderId == widget.client.id
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
    if (_reviewsGiven.isEmpty) {
      return _buildEmptyState(
        icon: Icons.reviews_outlined,
        title: 'No Reviews',
        message: 'You haven\'t written any reviews yet',
        buttonText: 'Browse Jobs',
        onPressed: () => setState(() => _selectedIndex = 2),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      itemCount: _reviewsGiven.length,
      itemBuilder: (context, index) {
        final review = _reviewsGiven[index];
        final fundi = MockData.getFundiById(review.toUserId);
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: ReviewCard(
            review: review,
            showJobInfo: true,
          ),
        );
      },
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
                  'My Profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const Spacer(),
                if (!_isEditingProfile)
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
            if (!_isEditingProfile)
              _buildProfileView()
            else
              _buildProfileEdit(),
            
            const SizedBox(height: 24),
            
            // Stats
            const Text(
              'Account Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C2C2C),
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isMobile ? 2 : 4,
              childAspectRatio: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildProfileStat(
                  label: 'Member Since',
                  value: '${DateTime.now().year - widget.client.joinedAt.year} years',
                  icon: Icons.calendar_today,
                ),
                _buildProfileStat(
                  label: 'Jobs Posted',
                  value: '${widget.client.jobsPosted}',
                  icon: Icons.work,
                ),
                _buildProfileStat(
                  label: 'Total Spent',
                  value: MockData.formatCurrency(widget.client.totalSpent),
                  icon: Icons.attach_money,
                ),
                _buildProfileStat(
                  label: 'Reviews Given',
                  value: '${widget.client.reviewCount}',
                  icon: Icons.reviews,
                ),
              ],
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
                  backgroundImage: widget.client.profileImage != null
                      ? NetworkImage(widget.client.profileImage!)
                      : null,
                  child: widget.client.profileImage == null
                      ? Text(
                          widget.client.name[0],
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
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified,
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
          _buildInfoRow(Icons.person, 'Full Name', widget.client.name),
          _buildInfoRow(Icons.email, 'Email', widget.client.email),
          _buildInfoRow(Icons.phone, 'Phone', widget.client.phone),
          if (widget.client.location != null)
            _buildInfoRow(Icons.location_on, 'Location', widget.client.location!),
          _buildInfoRow(Icons.calendar_today, 'Joined', 
              '${widget.client.joinedAt.day}/${widget.client.joinedAt.month}/${widget.client.joinedAt.year}'),
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
                    backgroundImage: widget.client.profileImage != null
                        ? NetworkImage(widget.client.profileImage!)
                        : null,
                    child: widget.client.profileImage == null
                        ? Text(
                            widget.client.name[0],
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
                        _nameController.text = widget.client.name;
                        _phoneController.text = widget.client.phone;
                        _locationController.text = widget.client.location ?? '';
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
  
  Widget _buildProfileStat({
    required String label,
    required String value,
    required IconData icon,
  }) {
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFFB87333), size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade500,
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
                  'Get notified when fundis apply',
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
              'Privacy',
              [
                _buildSettingSwitch(
                  'Public Profile',
                  'Allow others to see your profile',
                  true,
                ),
                _buildSettingSwitch(
                  'Show Contact Info',
                  'Display phone number on jobs',
                  false,
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
  
  // ==================== NOTIFICATIONS ====================
  
  Widget _buildNotificationsPanel() {
    return Positioned(
      top: 70,
      right: 100,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 300,
          constraints: const BoxConstraints(maxHeight: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Mark all as read
                      },
                      child: const Text('Mark all read'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    return ListTile(
                      leading: Icon(
                        _getNotificationIcon(notification.type ?? ''),
                        color: notification.isRead ? Colors.grey : const Color(0xFFB87333),
                      ),
                      title: Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(notification.body),
                      trailing: Text(
                        MockData.formatDate(notification.timestamp),
                        style: const TextStyle(fontSize: 10),
                      ),
                      onTap: () {
                        // Mark as read and navigate
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // ==================== HELPER METHODS ====================
  
  String _getPageTitle() {
    const titles = [
      'Dashboard',
      'Post Job',
      'My Jobs',
      'Applications',
      'Messages',
      'Reviews',
      'Profile',
      'Settings',
    ];
    return titles[_selectedIndex];
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
  
  void _showAcceptConfirmation(JobApplication application) {
    context.showConfirmationModal(
      title: 'Accept Application',
      message: 'Are you sure you want to accept this application?',
      confirmText: 'ACCEPT',
      cancelText: 'CANCEL',
      onConfirm: () {
        setState(() {
          // Update application status
        });
      },
    );
  }
  
  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'job':
        return Icons.work;
      case 'application':
        return Icons.assignment;
      case 'message':
        return Icons.message;
      default:
        return Icons.notifications;
    }
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
}