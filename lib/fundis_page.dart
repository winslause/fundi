import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cached_network_image/cached_network_image.dart';
import 'models.dart';
import 'data.dart';
import 'components.dart';
import 'modals.dart';

class FundisPage extends StatefulWidget {
  const FundisPage({super.key});

  @override
  State<FundisPage> createState() => _FundisPageState();
}

class _FundisPageState extends State<FundisPage> with TickerProviderStateMixin {
  // Search and filters
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  String? _selectedSkill;
  String? _selectedSortBy;
  RangeValues _ratingRange = const RangeValues(0, 5);
  bool _showVerifiedOnly = false;
  bool _showAvailableOnly = false;
  bool _showFilters = false;
  bool _isMobileMenuOpen = false;
  
  // Animation for filters
  late AnimationController _filtersController;
  late Animation<double> _filtersAnimation;
  
  // Fundi data
  late List<Fundi> _allFundis;
  late List<Fundi> _filteredFundis;
  
  // All unique skills for filter
  late List<String> _allSkills;
  
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
    
    // Load fundis
    _allFundis = MockData.fundis;
    _filteredFundis = _allFundis;
    
    // Extract all unique skills
    _allSkills = _allFundis
        .expand((fundi) => fundi.skills)
        .toSet()
        .toList()
      ..sort();
    
    // Add listener to search
    _searchController.addListener(_filterFundis);
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _filtersController.dispose();
    super.dispose();
  }
  
  void _filterFundis() {
    setState(() {
      _filteredFundis = _allFundis.where((fundi) {
        // Search filter
        if (_searchController.text.isNotEmpty) {
          final query = _searchController.text.toLowerCase();
          if (!fundi.name.toLowerCase().contains(query) &&
              !fundi.title.toLowerCase().contains(query) &&
              !fundi.bio.toLowerCase().contains(query) &&
              !fundi.skills.any((skill) => skill.toLowerCase().contains(query))) {
            return false;
          }
        }
        
        // Category filter (based on job categories they work in)
        if (_selectedCategory != null) {
          // This is simplified - in real app, fundis would have category associations
          final categoryJobs = MockData.jobs
              .where((job) => job.categoryId == _selectedCategory)
              .expand((job) => job.requiredSkills)
              .toList();
          if (!fundi.skills.any((skill) => categoryJobs.contains(skill))) {
            return false;
          }
        }
        
        // Skill filter
        if (_selectedSkill != null && !fundi.skills.contains(_selectedSkill)) {
          return false;
        }
        
        // Rating filter
        if (fundi.rating < _ratingRange.start || fundi.rating > _ratingRange.end) {
          return false;
        }
        
        // Verified only
        if (_showVerifiedOnly && !fundi.isVerified) {
          return false;
        }
        
        // Available only
        if (_showAvailableOnly && !fundi.isAvailable) {
          return false;
        }
        
        return true;
      }).toList();
      
      // Apply sorting
      _sortFundis();
    });
  }
  
  void _sortFundis() {
    if (_selectedSortBy == null) return;
    
    switch (_selectedSortBy) {
      case 'rating':
        _filteredFundis.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'jobs':
        _filteredFundis.sort((a, b) => b.jobsCompleted.compareTo(a.jobsCompleted));
        break;
      case 'rate_high':
        _filteredFundis.sort((a, b) => b.hourlyRate.compareTo(a.hourlyRate));
        break;
      case 'rate_low':
        _filteredFundis.sort((a, b) => a.hourlyRate.compareTo(b.hourlyRate));
        break;
      case 'experience':
        _filteredFundis.sort((a, b) => b.joinedAt.compareTo(a.joinedAt));
        break;
    }
  }
  
  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategory = null;
      _selectedSkill = null;
      _selectedSortBy = null;
      _ratingRange = const RangeValues(0, 5);
      _showVerifiedOnly = false;
      _showAvailableOnly = false;
      _filteredFundis = _allFundis;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 800;
          final bool isTablet = constraints.maxWidth >= 800 && constraints.maxWidth < 1200;
          
          // Check if running on mobile APK (not web and is mobile screen)
          final bool isMobileApk = !kIsWeb && isMobile;
          
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
                    expandedHeight: isMobileApk ? 120 : (isMobile ? 80 : 100),
                    floating: true,
                    pinned: true,
                    snap: true,
                    toolbarHeight: isMobileApk ? 120 : (isMobile ? 80 : 100),
                    backgroundColor: const Color(0xFFC0C0C0),
                    elevation: 0,
                    primary: false, // AppHeader handles status bar padding
                    flexibleSpace: AppHeader(
                      isMobile: isMobile,
                      isTablet: isTablet,
                      currentPage: 'fundis',
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
                        currentPage: 'fundis',
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
                              Icons.handyman,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Browse Fundis',
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
                                  hintText: 'Search fundis...',
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
                        hintText: 'Search fundis by name, skill...',
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
                                'Filter Fundis',
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
                          
                          // Skills filter
                          const Text(
                            'Skills',
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
                              _buildSkillChip(null, 'All'),
                              ..._allSkills.take(10).map((skill) => _buildSkillChip(skill, skill)),
                              if (_allSkills.length > 10)
                                _buildSkillChip('more', '+${_allSkills.length - 10} more', enabled: false),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Rating range
                          const Text(
                            'Minimum Rating',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2C2C2C),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Slider(
                                  value: _ratingRange.start,
                                  min: 0,
                                  max: 5,
                                  divisions: 10,
                                  onChanged: (value) {
                                    setState(() {
                                      _ratingRange = RangeValues(value, _ratingRange.end);
                                    });
                                    _filterFundis();
                                  },
                                  activeColor: const Color(0xFFB87333),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFB87333).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star, color: Color(0xFFB87333), size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      _ratingRange.start.toStringAsFixed(1),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFB87333),
                                      ),
                                    ),
                                  ],
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
                              _buildSortChip('Top Rated', 'rating'),
                              _buildSortChip('Most Jobs', 'jobs'),
                              _buildSortChip('Rate: High to Low', 'rate_high'),
                              _buildSortChip('Rate: Low to High', 'rate_low'),
                              _buildSortChip('Newest', 'experience'),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Toggle filters
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Switch(
                                      value: _showVerifiedOnly,
                                      onChanged: (value) {
                                        setState(() {
                                          _showVerifiedOnly = value;
                                        });
                                        _filterFundis();
                                      },
                                      activeColor: const Color(0xFFB87333),
                                    ),
                                    const SizedBox(width: 4),
                                    const Expanded(
                                      child: Text(
                                        'Verified only',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF2C2C2C),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Switch(
                                      value: _showAvailableOnly,
                                      onChanged: (value) {
                                        setState(() {
                                          _showAvailableOnly = value;
                                        });
                                        _filterFundis();
                                      },
                                      activeColor: const Color(0xFFB87333),
                                    ),
                                    const SizedBox(width: 4),
                                    const Expanded(
                                      child: Text(
                                        'Available only',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF2C2C2C),
                                        ),
                                      ),
                                    ),
                                  ],
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
                                  Icons.people,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Found ${_filteredFundis.length} fundis',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
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
              
              // Fundis Grid
              SliverPadding(
                padding: EdgeInsets.all(isMobile ? 12 : 24),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 2 : (isTablet ? 2 : 3),
                    childAspectRatio: isMobile ? 1.0 : 0.9,
                    mainAxisSpacing: isMobile ? 12 : 16,
                    crossAxisSpacing: isMobile ? 12 : 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final fundi = _filteredFundis[index];
                      return FundiCard(
                        fundi: fundi,
                        onTap: () => _showFundiProfileModal(fundi),
                        compact: isMobile,
                      );
                    },
                    childCount: _filteredFundis.length,
                  ),
                ),
              ),
              
              // Empty state
              if (_filteredFundis.isEmpty)
                SliverFillRemaining(
                  child: EmptyState(
                    icon: Icons.person_search,
                    title: 'No Fundis Found',
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
          _filterFundis();
        },
        backgroundColor: Colors.grey.shade100,
        selectedColor: const Color(0xFFB87333).withOpacity(0.2),
        checkmarkColor: const Color(0xFFB87333),
      ),
    );
  }
  
  Widget _buildSkillChip(String? skill, String label, {bool enabled = true}) {
    bool isSelected = _selectedSkill == skill;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 4),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: enabled ? (selected) {
          setState(() {
            _selectedSkill = selected ? skill : null;
          });
          _filterFundis();
        } : null,
        backgroundColor: Colors.grey.shade100,
        selectedColor: const Color(0xFFB87333).withOpacity(0.2),
        checkmarkColor: const Color(0xFFB87333),
      ),
    );
  }
  
  Widget _buildSortChip(String label, String value) {
    bool isSelected = _selectedSortBy == value;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedSortBy = selected ? value : null;
          });
          _sortFundis();
        },
        backgroundColor: Colors.grey.shade100,
        selectedColor: const Color(0xFFB87333).withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected ? const Color(0xFFB87333) : const Color(0xFF2C2C2C),
          fontSize: 12,
        ),
      ),
    );
  }
  
  // ==================== FUNDI PROFILE MODAL ====================
  
  void _showFundiProfileModal(Fundi fundi) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FundiProfileModal(fundi: fundi),
    );
  }
}

// ==================== FUNDI PROFILE MODAL ====================

class _FundiProfileModal extends StatefulWidget {
  final Fundi fundi;

  const _FundiProfileModal({required this.fundi});

  @override
  State<_FundiProfileModal> createState() => _FundiProfileModalState();
}

class _FundiProfileModalState extends State<_FundiProfileModal> with TickerProviderStateMixin {
  late TabController _tabController;
  late List<Review> _fundiReviews;
  late List<PortfolioItem> _portfolio;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fundiReviews = MockData.getReviewsForFundi(widget.fundi.id);
    _portfolio = widget.fundi.portfolio;
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          
          // Header with close button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Fundi Profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  splashRadius: 20,
                ),
              ],
            ),
          ),
          
          // Profile Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Profile image
                CircleAvatar(
                  radius: 50,
                  backgroundImage: widget.fundi.profileImage != null
                      ? CachedNetworkImageProvider(widget.fundi.profileImage!)
                      : null,
                  child: widget.fundi.profileImage == null
                      ? Text(
                          widget.fundi.name[0],
                          style: const TextStyle(fontSize: 40),
                        )
                      : null,
                ),
                const SizedBox(width: 20),
                // Basic info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.fundi.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C2C2C),
                              ),
                            ),
                          ),
                          if (widget.fundi.isVerified)
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check, size: 14, color: Colors.white),
                            ),
                          if (widget.fundi.isFeatured) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFB87333), Color(0xFFCD7F32)],
                                ),
                                borderRadius: BorderRadius.circular(12),
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
                      const SizedBox(height: 4),
                      Text(
                        widget.fundi.title,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Color(0xFFB87333), size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.fundi.rating} (${widget.fundi.reviewCount} reviews)',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(
                            widget.fundi.location ?? 'Location not specified',
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
          
          // Stats Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn('Jobs Done', '${widget.fundi.jobsCompleted}'),
                _buildStatColumn('Years Exp', '${DateTime.now().year - widget.fundi.joinedAt.year}'),
                _buildStatColumn('Hourly Rate', MockData.formatCurrency(widget.fundi.hourlyRate)),
                _buildStatColumn('Response', '< 1hr'),
              ],
            ),
          ),
          
          // Tab Bar
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFFB87333),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFFB87333),
            tabs: const [
              Tab(text: 'About'),
              Tab(text: 'Portfolio'),
              Tab(text: 'Reviews'),
            ],
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // About Tab
                _buildAboutTab(),
                
                // Portfolio Tab
                _buildPortfolioTab(),
                
                // Reviews Tab
                _buildReviewsTab(),
              ],
            ),
          ),
          
          // Action Buttons
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
                        Navigator.pop(context);
                        context.showMessageModal(widget.fundi.id);
                      },
                      icon: Icons.message,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Hire Now',
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigate to post job or show hire modal
                      },
                      icon: Icons.handshake,
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
  
  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C2C2C),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
  
  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bio
          const Text(
            'About',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.fundi.bio,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Skills
          const Text(
            'Skills',
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
            children: widget.fundi.skills.map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFB87333).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFB87333).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  skill,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFFB87333),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 20),
          
          // Certifications
          if (widget.fundi.certifications.isNotEmpty) ...[
            const Text(
              'Certifications',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C2C2C),
              ),
            ),
            const SizedBox(height: 12),
            ...widget.fundi.certifications.map((cert) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.verified,
                      color: const Color(0xFFB87333),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        cert,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
          
          const SizedBox(height: 20),
          
          // Languages
          const Text(
            'Languages',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: widget.fundi.languages.map((lang) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  lang,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPortfolioTab() {
    if (_portfolio.isEmpty) {
      return Center(
        child: EmptyState(
          icon: Icons.photo_library,
          title: 'No Portfolio Items',
          message: 'This fundi hasn\'t added any portfolio items yet',
          buttonText: 'Request Portfolio',
          onButtonPressed: () {
            Navigator.pop(context);
            context.showMessageModal(widget.fundi.id);
          },
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _portfolio.length,
      itemBuilder: (context, index) {
        final item = _portfolio[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  image: item.imageUrl.isNotEmpty
                      ? DecorationImage(
                          image: CachedNetworkImageProvider(item.imageUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: item.imageUrl.isEmpty
                    ? const Icon(Icons.image, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Completed: ${MockData.formatDate(item.completedAt)}',
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
      },
    );
  }
  
  Widget _buildReviewsTab() {
    if (_fundiReviews.isEmpty) {
      return Center(
        child: EmptyState(
          icon: Icons.reviews,
          title: 'No Reviews Yet',
          message: 'This fundi hasn\'t received any reviews',
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _fundiReviews.length,
      itemBuilder: (context, index) {
        final review = _fundiReviews[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: ReviewCard(review: review, showJobInfo: true),
        );
      },
    );
  }
}

// Extension for easy navigation
extension FundisPageExtensions on BuildContext {
  void goToFundisPage() {
    Navigator.push(
      this,
      MaterialPageRoute(builder: (context) => const FundisPage()),
    );
  }
}