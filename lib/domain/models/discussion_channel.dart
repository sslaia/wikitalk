import 'package:flutter/material.dart';

/// Represents a distinct discussion subpage, forum, or talk page treated as a channel/group.
class DiscussionChannel {
  final String id;
  final String pageTitle;
  final String displayName;
  final String description;
  final String iconName;
  final bool isCustom;
  final int unreadCount;
  final int? lastRevisionId;

  const DiscussionChannel({
    required this.id,
    required this.pageTitle,
    required this.displayName,
    this.description = '',
    this.iconName = 'forum',
    this.isCustom = false,
    this.unreadCount = 0,
    this.lastRevisionId,
  });

  IconData get icon => iconFromName(iconName);

  static IconData iconFromName(String name) {
    switch (name) {
      case 'gavel':
        return Icons.gavel_rounded;
      case 'lightbulb':
        return Icons.lightbulb_rounded;
      case 'build':
        return Icons.build_rounded;
      case 'translate':
        return Icons.translate_rounded;
      case 'campaign':
        return Icons.campaign_rounded;
      case 'coffee':
        return Icons.coffee_rounded;
      case 'bookmark':
        return Icons.bookmark_border_rounded;
      case 'science':
        return Icons.science_rounded;
      case 'tea':
        return Icons.emoji_food_beverage_rounded;
      default:
        return Icons.forum_rounded;
    }
  }

  DiscussionChannel copyWith({
    String? id,
    String? pageTitle,
    String? displayName,
    String? description,
    String? iconName,
    bool? isCustom,
    int? unreadCount,
    int? lastRevisionId,
  }) {
    return DiscussionChannel(
      id: id ?? this.id,
      pageTitle: pageTitle ?? this.pageTitle,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      isCustom: isCustom ?? this.isCustom,
      unreadCount: unreadCount ?? this.unreadCount,
      lastRevisionId: lastRevisionId ?? this.lastRevisionId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'page_title': pageTitle,
      'display_name': displayName,
      'description': description,
      'icon_name': iconName,
      'is_custom': isCustom ? 1 : 0,
      'unread_count': unreadCount,
      'last_revision_id': lastRevisionId,
    };
  }

  factory DiscussionChannel.fromMap(Map<String, dynamic> map) {
    return DiscussionChannel(
      id: map['id'] as String,
      pageTitle: map['page_title'] as String,
      displayName: map['display_name'] as String,
      description: map['description'] as String? ?? '',
      iconName: map['icon_name'] as String? ?? 'forum',
      isCustom: (map['is_custom'] as int? ?? 0) == 1,
      unreadCount: map['unread_count'] as int? ?? 0,
      lastRevisionId: map['last_revision_id'] as int?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiscussionChannel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
