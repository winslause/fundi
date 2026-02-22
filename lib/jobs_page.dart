import 'package:flutter/material.dart';
import 'models.dart';
import 'data.dart';
import 'components.dart';
import 'modals.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> with TickerProviderStateMixin {
  // Search and filters
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  String? _selectedSortBy;
  RangeValues _budgetRange = const RangeValues(0, 100000);
  bool _showFeaturedOnly = false;
  bool _showFilters = false;
  bool _isMobileMenuOpen = false;
  
  // Animation for filters
  late AnimationController _filtersController;
  late Animation<double> _filtersAnimation;
  
  // Job data
  late List<Job> _allJobs;
  late List<Job> _filteredJobs;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _filtersController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _filtersAnimation = CurvedAnimation(
      parent: _filtersController,
      curve: Curves.easeInOut,
    );
    
    // Load jobs
    _allJobs = MockData.jobs;
    _filteredJobs = _allJobs;
    
    // Add listener to search
    _searchController.addListener(_filterJobs);
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _filtersController.dispose();
    super.dispose();
  }
  
  void _filterJobs() {
    setState(() {
      _filteredJobs = _allJobs.where((job) {
        // Search filter
        if (_searchController.text.isNotEmpty) {
          final query = _searchController.text.toLowerCase();
          if (!job.title.toLowerCase().contains(query) &&
              !job.description.toLowerCase().contains(query)) {
            return false;
          }
        }
        
        // Category filter
        if (_selectedCategory != null && job.categoryId != _selectedCategory) {
          return false;
        }
        
        // Budget filter
        if (job.budget < _budgetRange.start || job.budget > _budgetRange.end) {
          return false;
        }
        
        // Featured filter
        if (_showFeaturedOnly && !job.isFeatured) {
          return false;
        }
        
        // Only show open jobs
        if (job.status != JobStatus.open) {
          return false;
        }
        
        return true;
      }).toList();
    });
  }
  
  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategory = null;
      _selectedSortBy = null;
      _budgetRange = const RangeValues(0, 100000);
      _showFeaturedOnly = false;
      _filteredJobs = _allJobs.where((job) => job.status == JobStatus.open).toList();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 800;
          final bool isTablet = constraints.maxWidth >= 800 && constraints.maxWidth < 1200;
          
          return Stack(
            children: [
              // Background with metallic gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFE8E8E8),
                      const Color(0xFFD0D0D0),
                      const Color(0xFFB8B8B8),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
              
              CustomScrollView(
                slivers: [
                  // Header
                  SliverAppBar(
                    expandedHeight: isMobile ? 80 : 100,
                    floating: true,
                    pinned: true,
                    snap: true,
                    toolbarHeight: isMobile ? 80 : 100,
                    backgroundColor: const Color(0xFFC0C0C0).withOpacity(0.98),
                    elevation: 4,
                    flexibleSpace: AppHeader(
                      isMobile: isMobile,
                      isTablet: isTablet,
                      currentPage: 'jobs',
                      isMobileMenuOpen: _isMobileMenuOpen,
                      onMenuToggle: () {
                        setState(() {
                          _isMobileMenuOpen = !_isMobileMenuOpen;
                        });
                      },
                    ),
                  ),
                  
                  // Mobile Menu Dropdown
                  if (isMobile && _isMobileMenuOpen)
                    SliverToBoxAdapter(
                      child: MobileMenu(
                        currentPage: 'jobs',
                        onClose: () {
                          setState(() {
                            _isMobileMenuOpen = false;
                          });
                        },
                      ),
                    ),
                  
                  // Page Title Bar
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                              gradient: const LinearGradient(
                                colors: [Color(0xFFB87333), Color(0xFFCD7F32)],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.work,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Browse Jobs',
                            style: TextStyle(
                              color: Color(0xFF2C2C2C),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          // Filter toggle button
                          IconButton(
                            icon: Icon(
                              _showFilters ? Icons.filter_alt_off : Icons.filter_alt,
                              color: _showFilters ? const Color(0xFFB87333) : const Color(0xFF2C2C2C),
                            ),
                            onPressed: () {
                              setState(() {
                                _showFilters = !_showFilters;
                                if (_showFilters) {
                                  _filtersController.forward();
                                } else {
                                  _filtersController.reverse();
                                }
                              });
                            },
                          ),
                          // Search field (desktop)
                          if (!isMobile)
                            Container(
                              width: 250,
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Search jobs...',
                                  prefixIcon: const Icon(Icons.search, size: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
              
              // Mobile search bar
              if (isMobile)
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search jobs...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                  ),
                ),
              
              // Filters Panel
              if (_showFilters)
                SliverToBoxAdapter(
                  child: SizeTransition(
                    axisAlignment: -1.0,
                    sizeFactor: _filtersAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            children: [
                              const Text(
                                'Filters',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C2C2C),
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: _resetFilters,
                                child: const Text('Reset All'),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Category filter
                          const Text(
                            'Category',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2C2C2C),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildCategoryChip(null, 'All', Icons.all_inclusive),
                                ...MockData.categories.map((category) {
                                  return _buildCategoryChip(
                                    category.id,
                                    category.name,
                                    null,
                                    iconText: category.icon,
                                  );
                                }),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Budget range
                          const Text(
                            'Budget Range',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2C2C2C),
                            ),
                          ),
                          const SizedBox(height: 8),
                          RangeSlider(
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
                              _filterJobs();
                            },
                            activeColor: const Color(0xFFB87333),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                MockData.formatCurrency(_budgetRange.start),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFB87333),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                MockData.formatCurrency(_budgetRange.end),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFB87333),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Sort by
                          const Text(
                            'Sort By',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2C2C2C),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: [
                              _buildSortChip('Newest', 'newest'),
                              _buildSortChip('Budget: High to Low', 'budget_high'),
                              _buildSortChip('Budget: Low to High', 'budget_low'),
                              _buildSortChip('Most Applied', 'popular'),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Featured only
                          Row(
                            children: [
                              Switch(
                                value: _showFeaturedOnly,
                                onChanged: (value) {
                                  setState(() {
                                    _showFeaturedOnly = value;
                                  });
                                  _filterJobs();
                                },
                                activeColor: const Color(0xFFB87333),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Show featured jobs only',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF2C2C2C),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Results count
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Found ${_filteredJobs.length} jobs',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              
              // Jobs Grid
              SliverPadding(
                padding: EdgeInsets.all(isMobile ? 16 : 24),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                    childAspectRatio: isMobile ? 1.4 : 1.3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final job = _filteredJobs[index];
                      return JobCard(
                        job: job,
                        onTap: () => _showJobDetailsModal(job),
                      );
                    },
                    childCount: _filteredJobs.length,
                  ),
                ),
              ),
              
              // Empty state
              if (_filteredJobs.isEmpty)
                SliverFillRemaining(
                  child: EmptyState(
                    icon: Icons.search_off,
                    title: 'No Jobs Found',
                    message: 'Try adjusting your filters or search criteria',
                    buttonText: 'Clear Filters',
                    onButtonPressed: _resetFilters,
                  ),
                ),
              
              // Footer
              SliverToBoxAdapter(
                child: AppFooter(isMobile: isMobile, isTablet: isTablet),
              ),
            ],
          ),
        ],
      );
    },
  ),
);
  }
  
  // ==================== FILTER WIDGETS ====================
  
  Widget _buildCategoryChip(String? categoryId, String label, IconData? icon, {String? iconText}) {
    bool isSelected = _selectedCategory == categoryId;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconText != null)
              Text(iconText, style: const TextStyle(fontSize: 14))
            else if (icon != null)
              Icon(icon, size: 14),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = selected ? categoryId : null;
          });
          _filterJobs();
        },
        backgroundColor: Colors.grey.shade100,
        selectedColor: const Color(0xFFB87333).withOpacity(0.2),
        checkmarkColor: const Color(0xFFB87333),
      ),
    );
  }
  
  Widget _buildSortChip(String label, String value) {
    bool isSelected = _selectedSortBy == value;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedSortBy = selected ? value : null;
          });
          _sortJobs();
        },
        backgroundColor: Colors.grey.shade100,
        selectedColor: const Color(0xFFB87333).withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected ? const Color(0xFFB87333) : const Color(0xFF2C2C2C),
        ),
      ),
    );
  }
  
  // ==================== JOB DETAILS MODAL ====================
  
  void _showJobDetailsModal(Job job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _JobDetailsModal(job: job),
    );
  }
  
  // ==================== SORTING ====================
  
  void _sortJobs() {
    if (_selectedSortBy == null) return;
    
    setState(() {
      switch (_selectedSortBy) {
        case 'newest':
          _filteredJobs.sort((a, b) => b.postedAt.compareTo(a.postedAt));
          break;
        case 'budget_high':
          _filteredJobs.sort((a, b) => b.budget.compareTo(a.budget));
          break;
        case 'budget_low':
          _filteredJobs.sort((a, b) => a.budget.compareTo(b.budget));
          break;
        case 'popular':
          _filteredJobs.sort((a, b) => b.applicationsCount.compareTo(a.applicationsCount));
          break;
      }
    });
  }
}

// ==================== JOB DETAILS MODAL ====================

class _JobDetailsModal extends StatefulWidget {
  final Job job;

  const _JobDetailsModal({required this.job});

  @override
  State<_JobDetailsModal> createState() => _JobDetailsModalState();
}

class _JobDetailsModalState extends State<_JobDetailsModal> {
  bool _isApplying = false;
  bool _isSaved = false;

  @override
  Widget build(BuildContext context) {
    final category = MockData.categories.firstWhere(
      (c) => c.id == widget.job.categoryId,
      orElse: () => MockData.categories.first,
    );
    final client = MockData.getClientById(widget.job.clientId);
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      height: MediaQuery.of(context).size.height * (isMobile ? 0.95 : 0.9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
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
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.job.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C2C2C),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.job.location,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: _isSaved ? const Color(0xFFB87333) : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isSaved = !_isSaved;
                    });
                  },
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Client info
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
                          backgroundImage: client?.profileImage != null
                              ? NetworkImage(client!.profileImage!)
                              : null,
                          child: client?.profileImage == null
                              ? Text(client?.name[0] ?? '?')
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                client?.name ?? 'Unknown',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C2C2C),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Color(0xFFB87333),
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${client?.rating ?? 0} (${client?.reviewCount ?? 0} reviews)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
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
                  
                  const SizedBox(height: 20),
                  
                  // Budget and posted date
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.attach_money,
                          label: 'Budget',
                          value: MockData.formatCurrency(widget.job.budget),
                          color: const Color(0xFFB87333),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.access_time,
                          label: 'Posted',
                          value: MockData.formatDate(widget.job.postedAt),
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.category,
                          label: 'Category',
                          value: category.name,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.people,
                          label: 'Applications',
                          value: '${widget.job.applicationsCount}',
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
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
                    widget.job.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.6,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Required skills
                  const Text(
                    'Required Skills',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.job.requiredSkills.map((skill) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB87333).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          skill,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFB87333),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  // Similar jobs (mock)
                  if (MockData.getJobsByCategory(widget.job.categoryId).length > 1) ...[
                    const SizedBox(height: 30),
                    const Text(
                      'Similar Jobs',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          final similarJob = MockData.getJobsByCategory(widget.job.categoryId)
                              .where((j) => j.id != widget.job.id)
                              .take(3)
                              .toList()[index];
                          return Container(
                            width: 250,
                            margin: const EdgeInsets.only(right: 12),
                            child: JobCard(
                              job: similarJob,
                              onTap: () {
                                Navigator.pop(context);
                                _showJobDetailsModal(similarJob);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // Bottom action bar
          Container(
            padding: const EdgeInsets.all(20),
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
                    child: OutlineButton(
                      text: 'Message',
                      onPressed: () {
                        if (client != null) {
                          Navigator.pop(context);
                          context.showMessageModal(client.id, jobId: widget.job.id);
                        }
                      },
                      icon: Icons.message,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      text: _isApplying ? 'Applying...' : 'Apply Now',
                      onPressed: _isApplying ? () {} : () => _showApplicationModal(),
                      isLoading: _isApplying,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
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

  void _showJobDetailsModal(Job job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _JobDetailsModal(job: job),
    );
  }

  void _showApplicationModal() {
    setState(() => _isApplying = true);
    
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      
      Navigator.pop(context); // Close job details modal
      
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => ApplicationModal(job: widget.job),
      );
    });
  }
}

// Extension for easy navigation
extension JobsPageExtensions on BuildContext {
  void goToJobsPage() {
    Navigator.push(
      this,
      MaterialPageRoute(builder: (context) => const JobsPage()),
    );
  }
}