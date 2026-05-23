/// Property Context Data for Deal Detective
///
/// Context provides background information about the property owner
/// and history - useful for understanding foreclosure circumstances
/// and x1000 potential (deceased collectors, scientists, etc.)
class PropertyContext {
  final String propertyId;

  /// Owner information
  final OwnerInfo? owner;

  /// Ownership history (chain of title)
  final List<OwnershipRecord> ownershipHistory;

  /// News articles mentioning the property or owner
  final List<NewsArticle> newsArticles;

  /// Obituaries (key for x1000 - deceased collectors)
  final List<Obituary> obituaries;

  /// Tax payment history
  final List<TaxPaymentRecord> taxHistory;

  /// Legal records (liens, judgments, permits)
  final List<LegalRecord> legalRecords;

  const PropertyContext({
    required this.propertyId,
    this.owner,
    this.ownershipHistory = const [],
    this.newsArticles = const [],
    this.obituaries = const [],
    this.taxHistory = const [],
    this.legalRecords = const [],
  });

  /// Check if owner is deceased (x1000 indicator)
  bool get ownerDeceased => obituaries.isNotEmpty || owner?.isDeceased == true;

  /// Check if there's x1000 potential based on context
  bool get hasX1000Hints {
    // Check obituaries for collector/scientist/artist mentions
    for (final obit in obituaries) {
      if (obit.mentionsCollection || obit.mentionsScience || obit.mentionsArt) {
        return true;
      }
    }
    return false;
  }

  /// Years of tax delinquency
  int get yearsDelinquent {
    int count = 0;
    for (final record in taxHistory) {
      if (!record.isPaid) count++;
    }
    return count;
  }
}

class OwnerInfo {
  final String name;
  final String? mailingAddress;
  final bool isDeceased;
  final String? occupation;
  final int? yearsOwned;

  const OwnerInfo({
    required this.name,
    this.mailingAddress,
    this.isDeceased = false,
    this.occupation,
    this.yearsOwned,
  });
}

class OwnershipRecord {
  final String ownerName;
  final DateTime? acquiredDate;
  final DateTime? soldDate;
  final double? purchasePrice;
  final String? transactionType; // sale, inheritance, gift

  const OwnershipRecord({
    required this.ownerName,
    this.acquiredDate,
    this.soldDate,
    this.purchasePrice,
    this.transactionType,
  });
}

class NewsArticle {
  final String title;
  final String? source;
  final DateTime? publishedDate;
  final String? summary;
  final String? url;
  final List<String> tags;

  const NewsArticle({
    required this.title,
    this.source,
    this.publishedDate,
    this.summary,
    this.url,
    this.tags = const [],
  });
}

class Obituary {
  final String deceasedName;
  final DateTime? deathDate;
  final String? summary;
  final String? source;
  final bool mentionsCollection;
  final bool mentionsScience;
  final bool mentionsArt;
  final List<String> interests;

  const Obituary({
    required this.deceasedName,
    this.deathDate,
    this.summary,
    this.source,
    this.mentionsCollection = false,
    this.mentionsScience = false,
    this.mentionsArt = false,
    this.interests = const [],
  });
}

class TaxPaymentRecord {
  final int year;
  final double amount;
  final bool isPaid;
  final DateTime? paidDate;
  final DateTime? dueDate;

  const TaxPaymentRecord({
    required this.year,
    required this.amount,
    required this.isPaid,
    this.paidDate,
    this.dueDate,
  });
}

class LegalRecord {
  final String type; // lien, judgment, permit, violation
  final String description;
  final DateTime? filedDate;
  final double? amount;
  final String? status; // active, resolved, pending

  const LegalRecord({
    required this.type,
    required this.description,
    this.filedDate,
    this.amount,
    this.status,
  });
}
