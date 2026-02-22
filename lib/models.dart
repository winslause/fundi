import 'package:flutter/material.dart';

// Enums for role-based access
enum UserRole {
  client,
  fundi,
  admin
}

enum JobStatus {
  open,
  inProgress,
  completed,
  cancelled
}

enum ApplicationStatus {
  pending,
  accepted,
  rejected,
  withdrawn
}

// Base User Model
class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String? profileImage;
  final String? location;
  final DateTime joinedAt;
  final bool isVerified;
  final double rating;
  final int reviewCount;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.profileImage,
    this.location,
    required this.joinedAt,
    this.isVerified = false,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  // Helper method to check role
  bool get isClient => role == UserRole.client;
  bool get isFundi => role == UserRole.fundi;
  bool get isAdmin => role == UserRole.admin;

  // Create a copy with updated fields
  User copyWith({
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    String? location,
    bool? isVerified,
    double? rating,
    int? reviewCount,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role,
      profileImage: profileImage ?? this.profileImage,
      location: location ?? this.location,
      joinedAt: joinedAt,
      isVerified: isVerified ?? this.isVerified,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }
}

// Client Model (extends User)
class Client extends User {
  final int jobsPosted;
  final int totalSpent;
  final List<String> preferredFundis;

  Client({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.profileImage,
    super.location,
    required super.joinedAt,
    super.isVerified,
    super.rating,
    super.reviewCount,
    this.jobsPosted = 0,
    this.totalSpent = 0,
    this.preferredFundis = const [],
  }) : super(role: UserRole.client);
}

// Fundi Model (extends User)
class Fundi extends User {
  final String title; // e.g., "Master Plumber", "Electrician"
  final String bio;
  final List<String> skills;
  final List<String> certifications;
  final List<PortfolioItem> portfolio;
  final double hourlyRate;
  final int jobsCompleted;
  final double earnings;
  final bool isAvailable;
  final bool isFeatured;
  final List<String> languages;

  Fundi({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.profileImage,
    super.location,
    required super.joinedAt,
    super.isVerified,
    super.rating,
    super.reviewCount,
    required this.title,
    required this.bio,
    required this.skills,
    this.certifications = const [],
    this.portfolio = const [],
    required this.hourlyRate,
    this.jobsCompleted = 0,
    this.earnings = 0,
    this.isAvailable = true,
    this.isFeatured = false,
    this.languages = const ['English'],
  }) : super(role: UserRole.fundi);
}

// Portfolio Item for Fundi
class PortfolioItem {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime completedAt;

  PortfolioItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.completedAt,
  });
}

// Admin Model (extends User)
class Admin extends User {
  final String department;
  final List<String> permissions;

  Admin({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.profileImage,
    super.location,
    required super.joinedAt,
    super.isVerified = true,
    this.department = 'Operations',
    this.permissions = const ['full_access'],
  }) : super(role: UserRole.admin);
}

// Category Model
class Category {
  final String id;
  final String name;
  final String icon; // Icon name or emoji
  final Color color;
  final int jobCount;
  final int fundiCount;
  final bool isActive;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.jobCount = 0,
    this.fundiCount = 0,
    this.isActive = true,
  });
}

// Job Model
class Job {
  final String id;
  final String title;
  final String description;
  final String categoryId;
  final String clientId;
  final String? assignedFundiId;
  final double budget;
  final String location;
  final DateTime postedAt;
  final DateTime? deadline;
  final JobStatus status;
  final List<String> requiredSkills;
  final List<String> attachments;
  final bool isFeatured;
  final int applicationsCount;

  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.clientId,
    this.assignedFundiId,
    required this.budget,
    required this.location,
    required this.postedAt,
    this.deadline,
    required this.status,
    this.requiredSkills = const [],
    this.attachments = const [],
    this.isFeatured = false,
    this.applicationsCount = 0,
  });

  // Helper getters
  bool get isOpen => status == JobStatus.open;
  bool get isInProgress => status == JobStatus.inProgress;
  bool get isCompleted => status == JobStatus.completed;
}

// Job Application Model
class JobApplication {
  final String id;
  final String jobId;
  final String fundiId;
  final double proposedBid;
  final String coverLetter;
  final DateTime appliedAt;
  final ApplicationStatus status;
  final DateTime? respondedAt;
  final String? clientFeedback;

  JobApplication({
    required this.id,
    required this.jobId,
    required this.fundiId,
    required this.proposedBid,
    required this.coverLetter,
    required this.appliedAt,
    required this.status,
    this.respondedAt,
    this.clientFeedback,
  });

  bool get isPending => status == ApplicationStatus.pending;
  bool get isAccepted => status == ApplicationStatus.accepted;
  bool get isRejected => status == ApplicationStatus.rejected;
}

// Review Model
class Review {
  final String id;
  final String jobId;
  final String fromUserId;
  final String toUserId;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final List<String>? images;

  Review({
    required this.id,
    required this.jobId,
    required this.fromUserId,
    required this.toUserId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.images,
  });
}

// Message Model
class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  final String? jobId; // Optional job context

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.isRead = false,
    this.jobId,
  });
}

// At the end of models.dart, rename Notification to AppNotification
class AppNotification {
  final String id;
  final String userId;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  final String? actionId; // e.g., jobId, applicationId
  final String? actionType; // e.g., 'job', 'application', 'message'

  AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.actionId,
    this.actionType,
  });
}