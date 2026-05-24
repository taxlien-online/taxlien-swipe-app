import 'package:flutter/material.dart';

/// Categories of commands in the palette.
enum CommandCategory {
  navigation('Navigation'),
  filter('Filter'),
  action('Action'),
  view('View'),
  export('Export');

  const CommandCategory(this.label);
  final String label;
}

/// Access level required for a command.
enum CommandAccess {
  /// Available to all users
  free,

  /// Requires premium subscription
  premium,

  /// Requires admin access
  admin,
}

/// A command available in the command palette.
class PaletteCommand {
  const PaletteCommand({
    required this.id,
    required this.label,
    required this.icon,
    required this.category,
    this.description,
    this.shortcut,
    this.access = CommandAccess.free,
    this.keywords = const [],
  });

  final String id;
  final String label;
  final IconData icon;
  final CommandCategory category;
  final String? description;
  final String? shortcut;
  final CommandAccess access;
  final List<String> keywords;

  bool get isPremium => access == CommandAccess.premium;
  bool get isAdmin => access == CommandAccess.admin;

  /// Check if command matches search query.
  bool matchesQuery(String query) {
    final lowerQuery = query.toLowerCase();
    if (label.toLowerCase().contains(lowerQuery)) return true;
    if (description?.toLowerCase().contains(lowerQuery) ?? false) return true;
    if (keywords.any((k) => k.toLowerCase().contains(lowerQuery))) return true;
    return false;
  }
}

/// Default commands available in the palette.
class DefaultCommands {
  static const List<PaletteCommand> all = [
    // Navigation
    PaletteCommand(
      id: 'nav_galaxy',
      label: 'Go to Galaxy View',
      icon: Icons.blur_on,
      category: CommandCategory.navigation,
      shortcut: 'G',
      keywords: ['galaxy', 'map', 'overview'],
    ),
    PaletteCommand(
      id: 'nav_swipe',
      label: 'Go to Swipe Mode',
      icon: Icons.swipe,
      category: CommandCategory.navigation,
      shortcut: 'S',
      keywords: ['swipe', 'cards', 'browse'],
    ),
    PaletteCommand(
      id: 'nav_favorites',
      label: 'View Favorites',
      icon: Icons.star,
      category: CommandCategory.navigation,
      shortcut: 'F',
      keywords: ['favorites', 'saved', 'liked'],
    ),
    PaletteCommand(
      id: 'nav_map',
      label: 'Open Map View',
      icon: Icons.map,
      category: CommandCategory.navigation,
      keywords: ['map', 'location', 'geographic'],
    ),

    // Filters
    PaletteCommand(
      id: 'filter_county',
      label: 'Filter by County',
      icon: Icons.location_city,
      category: CommandCategory.filter,
      keywords: ['county', 'location', 'area'],
    ),
    PaletteCommand(
      id: 'filter_price',
      label: 'Filter by Price Range',
      icon: Icons.attach_money,
      category: CommandCategory.filter,
      keywords: ['price', 'value', 'cost', 'range'],
    ),
    PaletteCommand(
      id: 'filter_fvi',
      label: 'Filter by FVI Score',
      icon: Icons.speed,
      category: CommandCategory.filter,
      keywords: ['fvi', 'score', 'rating'],
    ),
    PaletteCommand(
      id: 'filter_auction',
      label: 'Filter by Auction Date',
      icon: Icons.event,
      category: CommandCategory.filter,
      keywords: ['auction', 'date', 'upcoming'],
    ),

    // Actions
    PaletteCommand(
      id: 'action_share',
      label: 'Share Selection',
      icon: Icons.share,
      category: CommandCategory.action,
      shortcut: 'Cmd+Shift+S',
      keywords: ['share', 'send', 'export'],
    ),
    PaletteCommand(
      id: 'action_compare',
      label: 'Compare Properties',
      icon: Icons.compare_arrows,
      category: CommandCategory.action,
      keywords: ['compare', 'side by side', 'versus'],
      access: CommandAccess.premium,
    ),
    PaletteCommand(
      id: 'action_export',
      label: 'Export to CSV',
      icon: Icons.download,
      category: CommandCategory.export,
      keywords: ['export', 'download', 'csv', 'spreadsheet'],
      access: CommandAccess.premium,
    ),
    PaletteCommand(
      id: 'action_report',
      label: 'Generate Report',
      icon: Icons.description,
      category: CommandCategory.export,
      keywords: ['report', 'pdf', 'document'],
      access: CommandAccess.premium,
    ),

    // Views
    PaletteCommand(
      id: 'view_xray',
      label: 'Toggle X-Ray Mode',
      icon: Icons.filter_center_focus,
      category: CommandCategory.view,
      shortcut: 'X',
      keywords: ['xray', 'details', 'deep', 'inspect'],
    ),
    PaletteCommand(
      id: 'view_clusters',
      label: 'Show Magnetic Groups',
      icon: Icons.group_work,
      category: CommandCategory.view,
      keywords: ['clusters', 'groups', 'magnetic', 'related'],
    ),
    PaletteCommand(
      id: 'view_radar',
      label: 'Open Tax Radar',
      icon: Icons.radar,
      category: CommandCategory.view,
      keywords: ['radar', 'portfolio', 'hub'],
      access: CommandAccess.premium,
    ),
    PaletteCommand(
      id: 'view_graph',
      label: 'Show Connection Graph',
      icon: Icons.hub,
      category: CommandCategory.view,
      keywords: ['graph', 'network', 'connections'],
      access: CommandAccess.premium,
    ),
  ];

  static List<PaletteCommand> search(String query) {
    if (query.isEmpty) return all;
    return all.where((cmd) => cmd.matchesQuery(query)).toList();
  }

  static List<PaletteCommand> byCategory(CommandCategory category) {
    return all.where((cmd) => cmd.category == category).toList();
  }
}

/// State for the command palette.
class CommandPaletteState {
  const CommandPaletteState({
    this.isOpen = false,
    this.query = '',
    this.selectedIndex = 0,
    this.filteredCommands = const [],
  });

  final bool isOpen;
  final String query;
  final int selectedIndex;
  final List<PaletteCommand> filteredCommands;

  PaletteCommand? get selectedCommand =>
      selectedIndex < filteredCommands.length
          ? filteredCommands[selectedIndex]
          : null;

  CommandPaletteState copyWith({
    bool? isOpen,
    String? query,
    int? selectedIndex,
    List<PaletteCommand>? filteredCommands,
  }) {
    return CommandPaletteState(
      isOpen: isOpen ?? this.isOpen,
      query: query ?? this.query,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      filteredCommands: filteredCommands ?? this.filteredCommands,
    );
  }
}
