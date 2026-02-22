import 'package:flutter/material.dart';
import 'models.dart';
import 'data.dart';
import 'components.dart';

// Base Modal Wrapper
class BaseModal extends StatelessWidget {
  final String title;
 final Widget child;
  final double? height;

  const BaseModal({
    super.key,
    required this.title,
    required this.child,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    
    return Container(
      height: height ?? (isMobile ? MediaQuery.of(context).size.height * 0.9 : 600),
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
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  splashRadius: 20,
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== JOB DETAILS MODAL ====================

class JobDetailsModal extends StatefulWidget {
  final Job job;

  const JobDetailsModal({super.key, required this.job});

  @override
  State<JobDetailsModal> createState() => _JobDetailsModalState();
}

class _JobDetailsModalState extends State<JobDetailsModal> {
  bool _isApplying = false;
  
  @override
  Widget build(BuildContext context) {
    final category = MockData.categories.firstWhere(
      (c) => c.id == widget.job.categoryId,
      orElse: () => MockData.categories.first,
    );
    final client = MockData.getClientById(widget.job.clientId);
    final applications = MockData.getApplicationsForJob(widget.job.id);

    return BaseModal(
      title: 'Job Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category and status
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: category.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(category.icon, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      category.name,
                      style: TextStyle(
                        fontSize: 12,
                        color: category.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(widget.job.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getStatusText(widget.job.status),
                  style: TextStyle(
                    fontSize: 12,
                    color: _getStatusColor(widget.job.status),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Title
          Text(
            widget.job.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Client info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
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
                          Icon(
                            Icons.star,
                            color: const Color(0xFFB87333),
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
          
          // Budget and location
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
                  icon: Icons.location_on,
                  label: 'Location',
                  value: widget.job.location,
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
                  icon: Icons.access_time,
                  label: 'Posted',
                  value: MockData.formatDate(widget.job.postedAt),
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
              height: 1.5,
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
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  skill,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 20),
          
          // Applications list (if any)
          if (applications.isNotEmpty) ...[
            const Text(
              'Current Applications',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C2C2C),
              ),
            ),
            const SizedBox(height: 12),
            ...applications.map((app) => _buildApplicationTile(app)).toList(),
          ],
          
          const SizedBox(height: 24),
          
          // Action buttons
          if (widget.job.status == JobStatus.open) ...[
            Row(
              children: [
                Expanded(
                  child: OutlineButton(
                    text: 'Message Client',
                    onPressed: () {
                      Navigator.pop(context);
                      // Show message modal
                    },
                    icon: Icons.message,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    text: _isApplying ? 'Applying...' : 'Apply Now',
                    onPressed: _isApplying
                        ? null
                        : () {
                            setState(() => _isApplying = true);
                            Future.delayed(const Duration(seconds: 1), () {
                              if (!mounted) return;
                              Navigator.pop(context);
                              _showApplicationModal(widget.job);
                            });
                          },
                    isLoading: _isApplying,
                  ),
                ),
              ],
            ),
          ],
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

  Widget _buildApplicationTile(JobApplication application) {
    final fundi = MockData.getFundiById(application.fundiId);
    
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
          CircleAvatar(
            radius: 16,
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

  void _showApplicationModal(Job job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ApplicationModal(job: job),
    );
  }

  Color _getStatusColor(JobStatus status) {
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

  String _getStatusText(JobStatus status) {
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

// ==================== FUNDI PROFILE MODAL ====================

class FundiProfileModal extends StatelessWidget {
  final Fundi fundi;

  const FundiProfileModal({super.key, required this.fundi});

  @override
  Widget build(BuildContext context) {
    final reviews = MockData.getReviewsForFundi(fundi.id);

    return BaseModal(
      title: 'Fundi Profile',
      height: 700,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with image
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: fundi.profileImage != null
                    ? NetworkImage(fundi.profileImage!)
                    : null,
                child: fundi.profileImage == null
                    ? Text(
                        fundi.name[0],
                        style: const TextStyle(fontSize: 30),
                      )
                    : null,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            fundi.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C2C2C),
                            ),
                          ),
                        ),
                        if (fundi.isVerified)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            child: const Icon(Icons.check, size: 12, color: Colors.white),
                          ),
                        if (fundi.isFeatured) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB87333),
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
                      fundi.title,
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
                          '${fundi.rating} (${fundi.reviewCount} reviews)',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Stats
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.work,
                  label: 'Jobs Done',
                  value: '${fundi.jobsCompleted}',
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.access_time,
                  label: 'Member Since',
                  value: '${DateTime.now().year - fundi.joinedAt.year} yrs',
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.attach_money,
                  label: 'Hourly Rate',
                  value: MockData.formatCurrency(fundi.hourlyRate),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
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
            fundi.bio,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
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
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: fundi.skills.map((skill) {
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
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: fundi.languages.map((lang) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
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
          
          const SizedBox(height: 20),
          
          // Reviews
          if (reviews.isNotEmpty) ...[
            const Text(
              'Recent Reviews',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C2C2C),
              ),
            ),
            const SizedBox(height: 12),
            ...reviews.take(3).map((review) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ReviewCard(review: review),
            )),
          ],
          
          const SizedBox(height: 24),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlineButton(
                  text: 'View Portfolio',
                  onPressed: () {
                    // TODO: Show portfolio modal
                  },
                  icon: Icons.work,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  text: 'Hire Now',
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: Show hire/application modal
                  },
                  icon: Icons.handshake,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
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
}

// ==================== APPLICATION MODAL ====================

class ApplicationModal extends StatefulWidget {
  final Job job;

  const ApplicationModal({super.key, required this.job});

  @override
  State<ApplicationModal> createState() => _ApplicationModalState();
}

class _ApplicationModalState extends State<ApplicationModal> {
  final _formKey = GlobalKey<FormState>();
  final _bidController = TextEditingController();
  final _coverLetterController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _bidController.dispose();
    _coverLetterController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      
      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        
        Navigator.pop(context); // Close application modal
        
        // Show success message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Icon(
              Icons.check_circle,
              color: Color(0xFFB87333),
              size: 60,
            ),
            content: const Text(
              'Application submitted successfully!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF2C2C2C),
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseModal(
      title: 'Apply for Job',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.job.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.job.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.attach_money, size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(
                        'Budget: ${MockData.formatCurrency(widget.job.budget)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Bid amount
            TextFormField(
              controller: _bidController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Your Bid (KSh)',
                hintText: 'Enter your proposed amount',
                prefixIcon: const Icon(Icons.attach_money, color: Color(0xFFB87333)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your bid amount';
                }
                final bid = double.tryParse(value);
                if (bid == null) {
                  return 'Please enter a valid number';
                }
                if (bid <= 0) {
                  return 'Bid amount must be greater than 0';
                }
                if (bid > widget.job.budget * 1.5) {
                  return 'Bid is too high (max ${MockData.formatCurrency(widget.job.budget * 1.5)})';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Cover letter
            TextFormField(
              controller: _coverLetterController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Cover Letter',
                hintText: 'Explain why you\'re the best candidate for this job...',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please write a cover letter';
                }
                if (value.length < 20) {
                  return 'Cover letter must be at least 20 characters';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 24),
            
            // Submit button
            PrimaryButton(
              text: 'SUBMIT APPLICATION',
              onPressed: _isSubmitting ? null : _handleSubmit,
              isLoading: _isSubmitting,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== REVIEW MODAL ====================

class ReviewModal extends StatefulWidget {
  final String jobId;
  final String fundiId;

  const ReviewModal({
    super.key,
    required this.jobId,
    required this.fundiId,
  });

  @override
  State<ReviewModal> createState() => _ReviewModalState();
}

class _ReviewModalState extends State<ReviewModal> {
  double _rating = 0;
  final _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseModal(
      title: 'Write a Review',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rate your experience',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 12),
          
          // Rating stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _rating = index + 1;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: const Color(0xFFB87333),
                    size: 40,
                  ),
                ),
              );
            }),
          ),
          
          const SizedBox(height: 20),
          
          // Comment
          TextFormField(
            controller: _commentController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Your Review',
              hintText: 'Share your experience working with this fundi...',
              alignLabelWithHint: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Submit button
          PrimaryButton(
            text: 'SUBMIT REVIEW',
            onPressed: _rating == 0 || _isSubmitting
                ? null
                : () {
                    setState(() => _isSubmitting = true);
                    Future.delayed(const Duration(seconds: 1), () {
                      if (!mounted) return;
                      Navigator.pop(context);
                      // Show success message
                    });
                  },
            isLoading: _isSubmitting,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}

// ==================== CONFIRMATION MODAL ====================

class ConfirmationModal extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final bool isDestructive;

  const ConfirmationModal({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return BaseModal(
      title: title,
      child: Column(
        children: [
          const SizedBox(height: 20),
          
          // Icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: (isDestructive ? Colors.red : const Color(0xFFB87333))
                  .withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDestructive ? Icons.warning : Icons.help,
              color: isDestructive ? Colors.red : const Color(0xFFB87333),
              size: 40,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Message
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF2C2C2C),
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlineButton(
                  text: cancelText,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  text: confirmText,
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================== MESSAGE MODAL ====================

class MessageModal extends StatefulWidget {
  final String recipientId;
  final String? jobId;

  const MessageModal({
    super.key,
    required this.recipientId,
    this.jobId,
  });

  @override
  State<MessageModal> createState() => _MessageModalState();
}

class _MessageModalState extends State<MessageModal> {
  final _messageController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipient = MockData.getUserById(widget.recipientId);

    return BaseModal(
      title: 'Send Message',
      child: Column(
        children: [
          // Recipient info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: recipient?.profileImage != null
                      ? NetworkImage(recipient!.profileImage!)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipient?.name ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C2C2C),
                        ),
                      ),
                      if (widget.jobId != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Regarding: Job #${widget.jobId}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Message input
          TextFormField(
            controller: _messageController,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Message',
              hintText: 'Type your message here...',
              alignLabelWithHint: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Send button
          PrimaryButton(
            text: 'SEND MESSAGE',
            onPressed: _isSending || _messageController.text.isEmpty
                ? null
                : () {
                    setState(() => _isSending = true);
                    Future.delayed(const Duration(seconds: 1), () {
                      if (!mounted) return;
                      Navigator.pop(context);
                      // Show success message
                    });
                  },
            isLoading: _isSending,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}

// Extension for easy modal access
extension ModalExtensions on BuildContext {
  void showJobDetails(Job job) {
    showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => JobDetailsModal(job: job),
    );
  }

  void showFundiProfile(Fundi fundi) {
    showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FundiProfileModal(fundi: fundi),
    );
  }

  void showApplicationModal(Job job) {
    showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ApplicationModal(job: job),
    );
  }

  void showReviewModal(String jobId, String fundiId) {
    showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReviewModal(jobId: jobId, fundiId: fundiId),
    );
  }

  void showConfirmationModal({
    required String title,
    required String message,
    required String confirmText,
    required String cancelText,
    required VoidCallback onConfirm,
    bool isDestructive = false,
  }) {
    showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ConfirmationModal(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        isDestructive: isDestructive,
      ),
    );
  }

  void showMessageModal(String recipientId, {String? jobId}) {
    showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MessageModal(
        recipientId: recipientId,
        jobId: jobId,
      ),
    );
  }
}