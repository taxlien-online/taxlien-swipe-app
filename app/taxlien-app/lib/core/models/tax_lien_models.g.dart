// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_lien_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaxLien _$TaxLienFromJson(Map<String, dynamic> json) => TaxLien(
  id: json['id'] as String,
  propertyAddress: json['propertyAddress'] as String,
  county: json['county'] as String,
  state: json['state'] as String,
  taxAmount: (json['taxAmount'] as num).toDouble(),
  interestRate: (json['interestRate'] as num).toDouble(),
  auctionDate: DateTime.parse(json['auctionDate'] as String),
  status: json['status'] as String,
  propertyType: json['propertyType'] as String,
  estimatedValue: (json['estimatedValue'] as num).toDouble(),
  assessedValue: (json['assessedValue'] as num).toDouble(),
  description: json['description'] as String,
  images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
  owner: json['owner'] as String?,
  parcelId: json['parcelId'] as String?,
  redemptionDeadline: json['redemptionDeadline'] == null
      ? null
      : DateTime.parse(json['redemptionDeadline'] as String),
  metadata: json['metadata'] as Map<String, dynamic>?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  ownerName: json['ownerName'] as String?,
  city: json['city'] as String?,
  zipCode: json['zipCode'] as String?,
  taxYear: json['taxYear'] == null
      ? null
      : DateTime.parse(json['taxYear'] as String),
  saleDate: json['saleDate'] == null
      ? null
      : DateTime.parse(json['saleDate'] as String),
  issueDate: json['issueDate'] == null
      ? null
      : DateTime.parse(json['issueDate'] as String),
  isSold: json['isSold'] as bool?,
  salePrice: (json['salePrice'] as num?)?.toDouble(),
  additionalInfo: json['additionalInfo'] as String?,
  isAvailable: json['isAvailable'] as bool?,
  isLocked: json['isLocked'] as bool? ?? false,
  lockedForNFT: json['lockedForNFT'] as String?,
  noHeirs: json['no_heirs'] as bool?,
  redemptionProbability: (json['redemption_probability'] as num?)?.toDouble(),
  riskScore: (json['risk_score'] as num?)?.toDouble(),
  expectedRoi: (json['expected_roi'] as num?)?.toDouble(),
  paybackMonths: (json['payback_months'] as num?)?.toInt(),
  hasHomesteadExemption: json['has_homestead_exemption'] as bool?,
  hasVeteranExemption: json['has_veteran_exemption'] as bool?,
  hasSeniorExemption: json['has_senior_exemption'] as bool?,
  hasDisabilityExemption: json['has_disability_exemption'] as bool?,
  ownerTenureYears: (json['owner_tenure_years'] as num?)?.toInt(),
  walkScore: (json['walk_score'] as num?)?.toInt(),
  schoolRating: (json['school_rating'] as num?)?.toInt(),
  floodZone: json['flood_zone'] as String?,
  zillowEstimate: (json['zillow_estimate'] as num?)?.toDouble(),
  zillowPriceChange30d: (json['zillow_price_change_30d'] as num?)?.toDouble(),
  zillowLastUpdated: json['zillow_last_updated'] == null
      ? null
      : DateTime.parse(json['zillow_last_updated'] as String),
  lotSizeSqft: (json['lot_size_sqft'] as num?)?.toInt(),
  yearBuilt: (json['year_built'] as num?)?.toInt(),
);

Map<String, dynamic> _$TaxLienToJson(TaxLien instance) => <String, dynamic>{
  'id': instance.id,
  'propertyAddress': instance.propertyAddress,
  'county': instance.county,
  'state': instance.state,
  'taxAmount': instance.taxAmount,
  'interestRate': instance.interestRate,
  'auctionDate': instance.auctionDate.toIso8601String(),
  'status': instance.status,
  'propertyType': instance.propertyType,
  'estimatedValue': instance.estimatedValue,
  'assessedValue': instance.assessedValue,
  'description': instance.description,
  'images': instance.images,
  'owner': instance.owner,
  'parcelId': instance.parcelId,
  'redemptionDeadline': instance.redemptionDeadline?.toIso8601String(),
  'metadata': instance.metadata,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'ownerName': instance.ownerName,
  'city': instance.city,
  'zipCode': instance.zipCode,
  'taxYear': instance.taxYear?.toIso8601String(),
  'saleDate': instance.saleDate?.toIso8601String(),
  'issueDate': instance.issueDate?.toIso8601String(),
  'isSold': instance.isSold,
  'salePrice': instance.salePrice,
  'additionalInfo': instance.additionalInfo,
  'isAvailable': instance.isAvailable,
  'isLocked': instance.isLocked,
  'lockedForNFT': instance.lockedForNFT,
  'no_heirs': instance.noHeirs,
  'redemption_probability': instance.redemptionProbability,
  'risk_score': instance.riskScore,
  'expected_roi': instance.expectedRoi,
  'payback_months': instance.paybackMonths,
  'has_homestead_exemption': instance.hasHomesteadExemption,
  'has_veteran_exemption': instance.hasVeteranExemption,
  'has_senior_exemption': instance.hasSeniorExemption,
  'has_disability_exemption': instance.hasDisabilityExemption,
  'owner_tenure_years': instance.ownerTenureYears,
  'walk_score': instance.walkScore,
  'school_rating': instance.schoolRating,
  'flood_zone': instance.floodZone,
  'zillow_estimate': instance.zillowEstimate,
  'zillow_price_change_30d': instance.zillowPriceChange30d,
  'zillow_last_updated': instance.zillowLastUpdated?.toIso8601String(),
  'lot_size_sqft': instance.lotSizeSqft,
  'year_built': instance.yearBuilt,
};

TaxLienNFT _$TaxLienNFTFromJson(Map<String, dynamic> json) => TaxLienNFT(
  id: json['id'] as String,
  tokenId: json['tokenId'] as String,
  contractAddress: json['contractAddress'] as String,
  ownerAddress: json['ownerAddress'] as String,
  originalLien: TaxLien.fromJson(json['originalLien'] as Map<String, dynamic>),
  nftMetadata: json['nftMetadata'] as String,
  imageUrl: json['imageUrl'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  attributes: (json['attributes'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  mintedAt: DateTime.parse(json['mintedAt'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  soldAt: json['soldAt'] == null
      ? null
      : DateTime.parse(json['soldAt'] as String),
  salePrice: (json['salePrice'] as num?)?.toDouble(),
  status: json['status'] as String,
  metadata: json['metadata'] as Map<String, dynamic>?,
  currentValue: (json['currentValue'] as num?)?.toDouble(),
  transactionHistory: (json['transactionHistory'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
);

Map<String, dynamic> _$TaxLienNFTToJson(TaxLienNFT instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tokenId': instance.tokenId,
      'contractAddress': instance.contractAddress,
      'ownerAddress': instance.ownerAddress,
      'originalLien': instance.originalLien,
      'nftMetadata': instance.nftMetadata,
      'imageUrl': instance.imageUrl,
      'name': instance.name,
      'description': instance.description,
      'attributes': instance.attributes,
      'mintedAt': instance.mintedAt.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'soldAt': instance.soldAt?.toIso8601String(),
      'salePrice': instance.salePrice,
      'status': instance.status,
      'metadata': instance.metadata,
      'currentValue': instance.currentValue,
      'transactionHistory': instance.transactionHistory,
    };
