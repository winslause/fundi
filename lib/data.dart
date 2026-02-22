import 'package:flutter/material.dart';
import 'models.dart';
import 'package:intl/intl.dart';

class MockData {
  // ================ CATEGORIES ================
  static List<Category> categories = [
    Category(
      id: 'cat_1',
      name: 'Plumbing',
      icon: '🚰',
      color: Colors.blue.shade700,
      jobCount: 45,
      fundiCount: 28,
    ),
    Category(
      id: 'cat_2',
      name: 'Electrical',
      icon: '⚡',
      color: Colors.amber.shade700,
      jobCount: 38,
      fundiCount: 22,
    ),
    Category(
      id: 'cat_3',
      name: 'Carpentry',
      icon: '🪚',
      color: Colors.brown.shade600,
      jobCount: 32,
      fundiCount: 19,
    ),
    Category(
      id: 'cat_4',
      name: 'Masonry',
      icon: '🧱',
      color: Colors.grey.shade700,
      jobCount: 27,
      fundiCount: 15,
    ),
    Category(
      id: 'cat_5',
      name: 'Painting',
      icon: '🎨',
      color: Colors.purple.shade600,
      jobCount: 41,
      fundiCount: 24,
    ),
    Category(
      id: 'cat_6',
      name: 'Welding',
      icon: '🔥',
      color: Colors.red.shade700,
      jobCount: 19,
      fundiCount: 12,
    ),
    Category(
      id: 'cat_7',
      name: 'Roofing',
      icon: '🏠',
      color: Colors.orange.shade800,
      jobCount: 23,
      fundiCount: 14,
    ),
    Category(
      id: 'cat_8',
      name: 'Landscaping',
      icon: '🌳',
      color: Colors.green.shade700,
      jobCount: 29,
      fundiCount: 17,
    ),
  ];

  // ================ USERS ================
  
  // Admin
  static Admin admin = Admin(
    id: 'admin_1',
    name: 'John Mwangi',
    email: 'admin@fundimarketplace.com',
    phone: '+254 700 000001',
    joinedAt: DateTime(2023, 1, 1),
    department: 'Platform Operations',
    permissions: ['full_access', 'manage_users', 'manage_jobs'],
  );

  // Clients
  static List<Client> clients = [
    Client(
      id: 'client_1',
      name: 'Sarah Johnson',
      email: 'sarah.j@example.com',
      phone: '+254 712 345 678',
      location: 'Nairobi, Kilimani',
      joinedAt: DateTime(2024, 1, 15),
      isVerified: true,
      rating: 4.8,
      reviewCount: 12,
      jobsPosted: 8,
      totalSpent: 185000,
      preferredFundis: ['fundi_1', 'fundi_3'],
    ),
    Client(
      id: 'client_2',
      name: 'Michael Omondi',
      email: 'michael.o@example.com',
      phone: '+254 722 456 789',
      location: 'Nairobi, Westlands',
      joinedAt: DateTime(2024, 2, 20),
      isVerified: true,
      rating: 4.5,
      reviewCount: 6,
      jobsPosted: 4,
      totalSpent: 92000,
      preferredFundis: ['fundi_2'],
    ),
    Client(
      id: 'client_3',
      name: 'Elizabeth Wanjiku',
      email: 'elizabeth.w@example.com',
      phone: '+254 733 567 890',
      location: 'Kiambu',
      joinedAt: DateTime(2024, 3, 5),
      isVerified: false,
      rating: 0.0,
      reviewCount: 0,
      jobsPosted: 1,
      totalSpent: 15000,
      preferredFundis: [],
    ),
  ];

  // Fundis
  static List<Fundi> fundis = [
    Fundi(
      id: 'fundi_1',
      name: 'David Kamau',
      email: 'david.k@example.com',
      phone: '+254 701 234 567',
      profileImage: 'https://randomuser.me/api/portraits/men/1.jpg',
      location: 'Nairobi, Eastlands',
      joinedAt: DateTime(2023, 6, 10),
      isVerified: true,
      isFeatured: true,
      rating: 4.9,
      reviewCount: 47,
      title: 'Master Plumber',
      bio: '10+ years experience in residential and commercial plumbing. Specialized in modern plumbing systems and water heating solutions.',
      skills: ['Pipe Installation', 'Leak Repair', 'Water Heaters', 'Drain Cleaning', 'Bathroom Plumbing'],
      certifications: ['Plumbing License - Class A', 'OSHA Certified', 'Water Quality Specialist'],
      hourlyRate: 1200,
      jobsCompleted: 156,
      earnings: 1250000,
      isAvailable: true,
      languages: ['English', 'Swahili', 'Kikuyu'],
    ),
    Fundi(
      id: 'fundi_2',
      name: 'James Odhiambo',
      email: 'james.o@example.com',
      phone: '+254 712 345 678',
      profileImage: 'https://randomuser.me/api/portraits/men/2.jpg',
      location: 'Nairobi, South B',
      joinedAt: DateTime(2023, 8, 15),
      isVerified: true,
      isFeatured: true,
      rating: 4.8,
      reviewCount: 34,
      title: 'Electrical Expert',
      bio: 'Certified electrician specializing in residential and commercial electrical systems. Safety-first approach with quality workmanship.',
      skills: ['Wiring', 'Circuit Breakers', 'Lighting Installation', 'Electrical Repairs', 'Safety Inspections'],
      certifications: ['Electrician License - Class B', 'Safety Compliance Certificate', 'Solar Installation Certified'],
      hourlyRate: 1500,
      jobsCompleted: 98,
      earnings: 890000,
      isAvailable: true,
      languages: ['English', 'Swahili', 'Luo'],
    ),
    Fundi(
      id: 'fundi_3',
      name: 'Peter Njoroge',
      email: 'peter.n@example.com',
      phone: '+254 723 456 789',
      profileImage: 'https://randomuser.me/api/portraits/men/3.jpg',
      location: 'Nairobi, Ruiru',
      joinedAt: DateTime(2023, 4, 20),
      isVerified: true,
      isFeatured: false,
      rating: 4.7,
      reviewCount: 28,
      title: 'Master Carpenter',
      bio: 'Artisan with 15 years experience in custom furniture and home renovations. Attention to detail and quality materials.',
      skills: ['Cabinet Making', 'Furniture Design', 'Wood Restoration', 'Kitchen Fitting', 'Custom Joinery'],
      certifications: ['Carpentry Master Craft', 'Furniture Design Diploma'],
      hourlyRate: 1100,
      jobsCompleted: 203,
      earnings: 1500000,
      isAvailable: true,
      languages: ['English', 'Swahili', 'Kikuyu'],
    ),
    Fundi(
      id: 'fundi_4',
      name: 'Mary Akinyi',
      email: 'mary.a@example.com',
      phone: '+254 734 567 890',
      profileImage: 'https://randomuser.me/api/portraits/women/1.jpg',
      location: 'Nairobi, Kasarani',
      joinedAt: DateTime(2024, 1, 5),
      isVerified: true,
      isFeatured: true,
      rating: 4.9,
      reviewCount: 16,
      title: 'Painting & Decor Specialist',
      bio: 'Professional painter with eye for color and design. Residential and commercial projects. Eco-friendly paints specialist.',
      skills: ['Interior Painting', 'Exterior Painting', 'Wallpaper Installation', 'Color Consulting', 'Texture Finishes'],
      certifications: ['Painting Professional', 'Color Design Certificate'],
      hourlyRate: 900,
      jobsCompleted: 45,
      earnings: 280000,
      isAvailable: true,
      languages: ['English', 'Swahili', 'Luo'],
    ),
    Fundi(
      id: 'fundi_5',
      name: 'John Mwangi',
      email: 'john.m@example.com',
      phone: '+254 745 678 901',
      profileImage: 'https://randomuser.me/api/portraits/men/4.jpg',
      location: 'Nairobi, Karen',
      joinedAt: DateTime(2023, 3, 15),
      isVerified: true,
      isFeatured: true,
      rating: 4.8,
      reviewCount: 52,
      title: 'Master Mason',
      bio: 'Expert mason with 12 years experience in building and construction. Specialized in stone work and foundation laying.',
      skills: ['Stone Masonry', 'Brick Laying', 'Foundation Work', 'Wall Construction', 'Paving'],
      certifications: ['Masonry Master Craft', 'Construction Safety Certificate'],
      hourlyRate: 1300,
      jobsCompleted: 178,
      earnings: 1650000,
      isAvailable: true,
      languages: ['English', 'Swahili', 'Kamba'],
    ),
    Fundi(
      id: 'fundi_6',
      name: 'Grace Wambui',
      email: 'grace.w@example.com',
      phone: '+254 756 789 012',
      profileImage: 'https://randomuser.me/api/portraits/women/2.jpg',
      location: 'Nairobi, Parklands',
      joinedAt: DateTime(2023, 9, 1),
      isVerified: true,
      isFeatured: true,
      rating: 4.7,
      reviewCount: 29,
      title: 'Welding Expert',
      bio: 'Certified welder specializing in metal gates, railings, and structural steel work. Quality materials guaranteed.',
      skills: ['Metal Fabrication', 'Gate Construction', 'Railings', 'Structural Welding', 'Metal Repairs'],
      certifications: ['Welding Certification Level 3', 'Metal Fabrication Diploma'],
      hourlyRate: 1400,
      jobsCompleted: 87,
      earnings: 720000,
      isAvailable: true,
      languages: ['English', 'Swahili'],
    ),
    Fundi(
      id: 'fundi_7',
      name: 'Samuel Kipchoge',
      email: 'samuel.k@example.com',
      phone: '+254 767 890 123',
      profileImage: 'https://randomuser.me/api/portraits/men/5.jpg',
      location: 'Nairobi, Langata',
      joinedAt: DateTime(2023, 5, 20),
      isVerified: true,
      isFeatured: true,
      rating: 4.9,
      reviewCount: 41,
      title: 'Roofing Specialist',
      bio: 'Expert roofer with experience in all roofing types. Installation, repair, and maintenance of residential and commercial roofs.',
      skills: ['Roof Installation', 'Roof Repair', 'Gutter Installation', 'Waterproofing', 'Roof Inspection'],
      certifications: ['Roofing Professional License', 'Height Safety Certified'],
      hourlyRate: 1600,
      jobsCompleted: 112,
      earnings: 980000,
      isAvailable: true,
      languages: ['English', 'Swahili', 'Kalenjin'],
    ),
    Fundi(
      id: 'fundi_8',
      name: 'Faith Njeri',
      email: 'faith.n@example.com',
      phone: '+254 778 901 234',
      profileImage: 'https://randomuser.me/api/portraits/women/3.jpg',
      location: 'Nairobi, Lavington',
      joinedAt: DateTime(2023, 7, 10),
      isVerified: true,
      isFeatured: true,
      rating: 4.8,
      reviewCount: 35,
      title: 'Landscaping Expert',
      bio: 'Creative landscaper transforming outdoor spaces. Garden design, lawn care, and irrigation systems specialist.',
      skills: ['Garden Design', 'Lawn Maintenance', 'Irrigation Systems', 'Tree Pruning', 'Hardscaping'],
      certifications: ['Landscape Design Certificate', 'Horticulture Diploma'],
      hourlyRate: 1000,
      jobsCompleted: 68,
      earnings: 450000,
      isAvailable: true,
      languages: ['English', 'Swahili'],
    ),
  ];

  // ================ JOBS ================
  static List<Job> jobs = [
    Job(
      id: 'job_1',
      title: 'Fix leaking bathroom pipes',
      description: 'Master bedroom bathroom has leaking pipes behind the wall. Need urgent repair and wall restoration.',
      categoryId: 'cat_1',
      clientId: 'client_1',
      budget: 8000,
      location: 'Nairobi, Kilimani',
      postedAt: DateTime.now().subtract(const Duration(days: 2)),
      deadline: DateTime.now().add(const Duration(days: 5)),
      status: JobStatus.open,
      requiredSkills: ['Leak Repair', 'Pipe Installation'],
      isFeatured: true,
      applicationsCount: 3,
    ),
    Job(
      id: 'job_2',
      title: 'Install new electrical wiring for extension',
      description: 'Need complete electrical wiring for house extension (2 rooms). Include lighting and power outlets.',
      categoryId: 'cat_2',
      clientId: 'client_2',
      budget: 25000,
      location: 'Nairobi, Westlands',
      postedAt: DateTime.now().subtract(const Duration(days: 1)),
      deadline: DateTime.now().add(const Duration(days: 7)),
      status: JobStatus.open,
      requiredSkills: ['Wiring', 'Circuit Breakers', 'Lighting Installation'],
      isFeatured: true,
      applicationsCount: 5,
    ),
    Job(
      id: 'job_3',
      title: 'Custom kitchen cabinets',
      description: 'Need 8 kitchen cabinets with soft-close hinges. Modern design with dark wood finish.',
      categoryId: 'cat_3',
      clientId: 'client_1',
      budget: 45000,
      location: 'Nairobi, Kilimani',
      postedAt: DateTime.now().subtract(const Duration(days: 3)),
      deadline: DateTime.now().add(const Duration(days: 14)),
      status: JobStatus.open,
      requiredSkills: ['Cabinet Making', 'Custom Joinery'],
      isFeatured: false,
      applicationsCount: 2,
    ),
    Job(
      id: 'job_4',
      title: 'House painting - 3 bedroom',
      description: 'Complete interior painting for 3-bedroom house. Neutral colors, quality paint required.',
      categoryId: 'cat_5',
      clientId: 'client_3',
      budget: 35000,
      location: 'Kiambu',
      postedAt: DateTime.now().subtract(const Duration(hours: 12)),
      deadline: DateTime.now().add(const Duration(days: 10)),
      status: JobStatus.open,
      requiredSkills: ['Interior Painting'],
      isFeatured: false,
      applicationsCount: 1,
    ),
  ];

  // ================ APPLICATIONS ================
  static List<JobApplication> applications = [
    JobApplication(
      id: 'app_1',
      jobId: 'job_1',
      fundiId: 'fundi_1',
      proposedBid: 7500,
      coverLetter: 'I have 10 years experience fixing leaks. Can do this job perfectly and restore the wall.',
      appliedAt: DateTime.now().subtract(const Duration(hours: 20)),
      status: ApplicationStatus.pending,
    ),
    JobApplication(
      id: 'app_2',
      jobId: 'job_1',
      fundiId: 'fundi_2',
      proposedBid: 8000,
      coverLetter: 'Expert plumber here. I can fix this today and guarantee my work for 6 months.',
      appliedAt: DateTime.now().subtract(const Duration(hours: 15)),
      status: ApplicationStatus.pending,
    ),
    JobApplication(
      id: 'app_3',
      jobId: 'job_2',
      fundiId: 'fundi_2',
      proposedBid: 23000,
      coverLetter: 'Certified electrician. I have done many similar extensions and can provide references.',
      appliedAt: DateTime.now().subtract(const Duration(hours: 10)),
      status: ApplicationStatus.pending,
    ),
    JobApplication(
      id: 'app_4',
      jobId: 'job_3',
      fundiId: 'fundi_3',
      proposedBid: 42000,
      coverLetter: 'Master carpenter here. I specialize in custom kitchen cabinets. Check my portfolio.',
      appliedAt: DateTime.now().subtract(const Duration(hours: 48)),
      status: ApplicationStatus.accepted,
    ),
  ];

  // ================ REVIEWS ================
  static List<Review> reviews = [
    Review(
      id: 'rev_1',
      jobId: 'job_3',
      fromUserId: 'client_1',
      toUserId: 'fundi_3',
      rating: 5.0,
      comment: 'Excellent work on the cabinets! Peter is professional and skilled. Highly recommend.',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Review(
      id: 'rev_2',
      jobId: 'job_1',
      fromUserId: 'client_2',
      toUserId: 'fundi_1',
      rating: 4.8,
      comment: 'David fixed our plumbing quickly and cleaned up after. Very satisfied.',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    Review(
      id: 'rev_3',
      jobId: 'job_2',
      fromUserId: 'client_1',
      toUserId: 'fundi_2',
      rating: 5.0,
      comment: 'James did excellent electrical work for our office. Safety-conscious and thorough.',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];

  // ================ MESSAGES ================
  static List<Message> messages = [
    Message(
      id: 'msg_1',
      senderId: 'client_1',
      receiverId: 'fundi_1',
      content: 'Hi David, when can you come check the leak?',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
      jobId: 'job_1',
    ),
    Message(
      id: 'msg_2',
      senderId: 'fundi_1',
      receiverId: 'client_1',
      content: 'I can come tomorrow morning at 9am. Will that work?',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      isRead: false,
      jobId: 'job_1',
    ),
  ];

  // ================ NOTIFICATIONS ================
  // At the end of data.dart, change Notification to AppNotification
static List<AppNotification> notifications = [
  AppNotification(
    id: 'notif_1',
    userId: 'client_1',
    title: 'New Application',
    body: 'David Kamau applied for your plumbing job',
    timestamp: DateTime.now().subtract(const Duration(hours: 20)),
    isRead: false,
    actionId: 'job_1',
    actionType: 'job',
  ),
  AppNotification(
    id: 'notif_2',
    userId: 'fundi_1',
    title: 'Application Accepted',
    body: 'Your application for the plumbing job was accepted',
    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    isRead: false,
    actionId: 'job_1',
    actionType: 'application',
  ),
];

  // ================ HELPER METHODS ================
  
  // Get user by ID
  static User? getUserById(String userId) {
    // Check admin
    if (admin.id == userId) return admin;
    
    // Check clients
    try {
      return clients.firstWhere((c) => c.id == userId);
    } catch (_) {}
    
    // Check fundis
    try {
      return fundis.firstWhere((f) => f.id == userId);
    } catch (_) {}
    
    return null;
  }

  // Get fundi by ID
  static Fundi? getFundiById(String fundiId) {
    try {
      return fundis.firstWhere((f) => f.id == fundiId);
    } catch (_) {
      return null;
    }
  }

  // Get client by ID
  static Client? getClientById(String clientId) {
    try {
      return clients.firstWhere((c) => c.id == clientId);
    } catch (_) {
      return null;
    }
  }

  // Get jobs by category
  static List<Job> getJobsByCategory(String categoryId) {
    return jobs.where((j) => j.categoryId == categoryId).toList();
  }

  // Get featured fundis
  static List<Fundi> getFeaturedFundis() {
    return fundis.where((f) => f.isFeatured).toList();
  }

  // Get featured jobs
  static List<Job> getFeaturedJobs() {
    return jobs.where((j) => j.isFeatured).toList();
  }

  // Get applications for a job
  static List<JobApplication> getApplicationsForJob(String jobId) {
    return applications.where((a) => a.jobId == jobId).toList();
  }

  // Get reviews for a fundi
  static List<Review> getReviewsForFundi(String fundiId) {
    return reviews.where((r) => r.toUserId == fundiId).toList();
  }

  // Format currency
  static String formatCurrency(double amount) {
    final formatter = NumberFormat('#,###', 'en_US');
    return 'KSh ${formatter.format(amount)}';
  }

  // Format date
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return DateFormat('MMM d, y').format(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}