import 'package:flutter/material.dart';
import '../../../core/models/property_context.dart';

/// Context View for Advanced Mode (left swipe)
///
/// Shows background information about the property owner and history:
/// - Owner information (occupation, deceased status)
/// - Ownership history (chain of title)
/// - News articles mentioning property/owner
/// - Obituaries (key for x1000 potential!)
/// - Tax payment history
/// - Legal records
class ContextView extends StatelessWidget {
  final String propertyId;
  final PropertyContext? context;

  const ContextView({
    super.key,
    required this.propertyId,
    this.context,
  });

  @override
  Widget build(BuildContext context) {
    final ctx = this.context ?? _getMockContext();

    return Container(
      color: const Color(0xFF1A237E), // Deep blue for context
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: _buildHeader(context, ctx),
            ),

            // x1000 Alert (if deceased owner with collection hints)
            if (ctx.hasX1000Hints)
              SliverToBoxAdapter(
                child: _buildX1000Alert(context, ctx),
              ),

            // Owner Info
            if (ctx.owner != null)
              SliverToBoxAdapter(
                child: _buildSection(
                  context,
                  title: 'Owner Information',
                  icon: Icons.person,
                  child: _buildOwnerInfo(context, ctx.owner!),
                ),
              ),

            // Obituaries (important for x1000!)
            if (ctx.obituaries.isNotEmpty)
              SliverToBoxAdapter(
                child: _buildSection(
                  context,
                  title: 'Obituaries',
                  icon: Icons.article,
                  iconColor: Colors.amber,
                  child: _buildObituaries(context, ctx.obituaries),
                ),
              ),

            // Tax History
            if (ctx.taxHistory.isNotEmpty)
              SliverToBoxAdapter(
                child: _buildSection(
                  context,
                  title: 'Tax Payment History',
                  icon: Icons.account_balance,
                  child: _buildTaxHistory(context, ctx.taxHistory),
                ),
              ),

            // Ownership History
            if (ctx.ownershipHistory.isNotEmpty)
              SliverToBoxAdapter(
                child: _buildSection(
                  context,
                  title: 'Ownership History',
                  icon: Icons.history,
                  child: _buildOwnershipHistory(context, ctx.ownershipHistory),
                ),
              ),

            // News Articles
            if (ctx.newsArticles.isNotEmpty)
              SliverToBoxAdapter(
                child: _buildSection(
                  context,
                  title: 'News & Articles',
                  icon: Icons.newspaper,
                  child: _buildNewsArticles(context, ctx.newsArticles),
                ),
              ),

            // Legal Records
            if (ctx.legalRecords.isNotEmpty)
              SliverToBoxAdapter(
                child: _buildSection(
                  context,
                  title: 'Legal Records',
                  icon: Icons.gavel,
                  child: _buildLegalRecords(context, ctx.legalRecords),
                ),
              ),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 40),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PropertyContext ctx) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.white70, size: 28),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Property Context',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              if (ctx.ownerDeceased)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning_amber, color: Colors.orange, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Estate',
                        style: TextStyle(color: Colors.orange, fontSize: 12),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Background information about the property and owner',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildX1000Alert(BuildContext context, PropertyContext ctx) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7B1FA2), Color(0xFF4A148C)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.diamond, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'x1000 POTENTIAL DETECTED',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Owner may have been a collector, scientist, or artist',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: iconColor ?? Colors.white70, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildOwnerInfo(BuildContext context, OwnerInfo owner) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          _buildInfoRow('Name', owner.name),
          if (owner.occupation != null)
            _buildInfoRow('Occupation', owner.occupation!),
          if (owner.yearsOwned != null)
            _buildInfoRow('Years Owned', '${owner.yearsOwned} years'),
          if (owner.isDeceased)
            _buildInfoRow('Status', 'Deceased', valueColor: Colors.orange),
        ],
      ),
    );
  }

  Widget _buildObituaries(BuildContext context, List<Obituary> obituaries) {
    return Column(
      children: obituaries.map((obit) {
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                obit.deceasedName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (obit.deathDate != null)
                Text(
                  'Passed: ${_formatDate(obit.deathDate!)}',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                ),
              if (obit.summary != null) ...[
                const SizedBox(height: 8),
                Text(
                  obit.summary!,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13),
                ),
              ],
              if (obit.interests.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: obit.interests.map((interest) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        interest,
                        style: const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTaxHistory(BuildContext context, List<TaxPaymentRecord> history) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: history.take(5).map((record) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(
                  record.isPaid ? Icons.check_circle : Icons.cancel,
                  color: record.isPaid ? Colors.green : Colors.red,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  '${record.year}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  '\$${record.amount.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(width: 12),
                Text(
                  record.isPaid ? 'Paid' : 'UNPAID',
                  style: TextStyle(
                    color: record.isPaid ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOwnershipHistory(BuildContext context, List<OwnershipRecord> history) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: history.map((record) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.ownerName,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      if (record.acquiredDate != null)
                        Text(
                          'Acquired: ${_formatDate(record.acquiredDate!)}',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                        ),
                      if (record.purchasePrice != null)
                        Text(
                          'Price: \$${_formatNumber(record.purchasePrice!)}',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNewsArticles(BuildContext context, List<NewsArticle> articles) {
    return Column(
      children: articles.map((article) {
        return ListTile(
          leading: const Icon(Icons.article, color: Colors.white54),
          title: Text(
            article.title,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: article.source != null
              ? Text(
                  article.source!,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                )
              : null,
          trailing: const Icon(Icons.open_in_new, color: Colors.white54, size: 18),
          onTap: () {
            // Open article URL
          },
        );
      }).toList(),
    );
  }

  Widget _buildLegalRecords(BuildContext context, List<LegalRecord> records) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: records.map((record) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  _getLegalIcon(record.type),
                  color: _getLegalColor(record.type),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.type.toUpperCase(),
                        style: TextStyle(
                          color: _getLegalColor(record.type),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        record.description,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                if (record.amount != null)
                  Text(
                    '\$${_formatNumber(record.amount!)}',
                    style: const TextStyle(color: Colors.white70),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.7))),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getLegalIcon(String type) {
    switch (type.toLowerCase()) {
      case 'lien':
        return Icons.link;
      case 'judgment':
        return Icons.gavel;
      case 'permit':
        return Icons.description;
      case 'violation':
        return Icons.warning;
      default:
        return Icons.folder;
    }
  }

  Color _getLegalColor(String type) {
    switch (type.toLowerCase()) {
      case 'lien':
        return Colors.orange;
      case 'judgment':
        return Colors.red;
      case 'permit':
        return Colors.green;
      case 'violation':
        return Colors.amber;
      default:
        return Colors.white70;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  String _formatNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }

  /// Mock context data for development
  PropertyContext _getMockContext() {
    return PropertyContext(
      propertyId: propertyId,
      owner: const OwnerInfo(
        name: 'Harold Richardson',
        occupation: 'Retired Physics Professor',
        isDeceased: true,
        yearsOwned: 35,
      ),
      obituaries: [
        Obituary(
          deceasedName: 'Harold Richardson',
          deathDate: DateTime(2025, 8, 15),
          summary: 'Dr. Harold Richardson, 78, passed away peacefully. He was a professor of physics at ASU for 30 years and an avid collector of scientific instruments and vintage electronics.',
          mentionsScience: true,
          mentionsCollection: true,
          interests: ['Physics', 'Scientific Instruments', 'Ham Radio', 'Tesla Research'],
        ),
      ],
      taxHistory: [
        const TaxPaymentRecord(year: 2025, amount: 2800, isPaid: false),
        const TaxPaymentRecord(year: 2024, amount: 2750, isPaid: false),
        const TaxPaymentRecord(year: 2023, amount: 2700, isPaid: false),
        const TaxPaymentRecord(year: 2022, amount: 2650, isPaid: true),
        const TaxPaymentRecord(year: 2021, amount: 2600, isPaid: true),
      ],
      ownershipHistory: [
        OwnershipRecord(
          ownerName: 'Harold Richardson',
          acquiredDate: DateTime(1990, 3, 15),
          purchasePrice: 85000,
          transactionType: 'sale',
        ),
        OwnershipRecord(
          ownerName: 'James & Martha Thompson',
          acquiredDate: DateTime(1975, 7, 1),
          soldDate: DateTime(1990, 3, 15),
          purchasePrice: 42000,
          transactionType: 'sale',
        ),
      ],
      legalRecords: [
        LegalRecord(
          type: 'lien',
          description: 'Property tax lien - 3 years delinquent',
          filedDate: DateTime(2025, 1, 15),
          amount: 8250,
          status: 'active',
        ),
      ],
    );
  }
}
