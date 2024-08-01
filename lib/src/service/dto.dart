import 'package:json_annotation/json_annotation.dart';
import '../model.dart';

part 'dto.g.dart';

/// LLM

@JsonSerializable()
class LLMConfigDto {
  late String baseUrl;
  late String apiKey;
  late String model;

  LLMConfigDto({
    required this.baseUrl,
    required this.apiKey,
    required this.model
  });

  factory LLMConfigDto.fromJson(Map<String, dynamic> json) => _$LLMConfigDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LLMConfigDtoToJson(this);

  LLMConfig toModel() => LLMConfig(baseUrl: baseUrl, apiKey: apiKey, model: model);

}

@JsonSerializable()
class TokenUsageDto {
  int promptToken;
  int totalToken;

  TokenUsageDto({required this.promptToken, required this.totalToken});

  factory TokenUsageDto.fromJson(Map<String, dynamic> json) => _$TokenUsageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TokenUsageDtoToJson(this);

  factory TokenUsageDto.fromModel(TokenUsage tokenUsage) => TokenUsageDto(promptToken: tokenUsage.promptToken, totalToken: tokenUsage.totalToken);

}

/// Docs

@JsonSerializable()
class DocsIdDto {
  String docsId;

  DocsIdDto({required this.docsId});

  factory DocsIdDto.fromJson(Map<String, dynamic> json) => _$DocsIdDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DocsIdDtoToJson(this);
}

@JsonSerializable()
class DocsInfoDto extends DocsIdDto{
  String docsName;

  DocsInfoDto({required super.docsId, required this.docsName});

  factory DocsInfoDto.fromJson(Map<String, dynamic> json) => _$DocsInfoDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DocsInfoDtoToJson(this);

  factory DocsInfoDto.fromModel(CollectionInfo collectionInfo) => DocsInfoDto(docsId: collectionInfo.name, docsName: collectionInfo.docsName);
}

@JsonSerializable()
class CreateDocsTextRequestDto {
  String docsName;
  String text;
  String separator;
  Map<String, dynamic>? metadata;
  LLMConfigDto llmConfig;

  CreateDocsTextRequestDto({required this.docsName, required this.text, required this.separator, this.metadata , required this.llmConfig});

  factory CreateDocsTextRequestDto.fromJson(Map<String, dynamic> json) => _$CreateDocsTextRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateDocsTextRequestDtoToJson(this);
}

@JsonSerializable()
class CreateDocsRequestDto{
  String docsName;
  List<SegmentDto> segmentList;
  LLMConfigDto llmConfig;

  CreateDocsRequestDto({required this.docsName, required this.segmentList, required this.llmConfig});

  factory CreateDocsRequestDto.fromJson(Map<String, dynamic> json) => _$CreateDocsRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateDocsRequestDtoToJson(this);

}

@JsonSerializable()
class CreateDocsResultDto extends DocsInfoDto{
  TokenUsageDto tokenUsage;

  CreateDocsResultDto({required super.docsId, required super.docsName, required this.tokenUsage});

  factory CreateDocsResultDto.fromJson(Map<String, dynamic> json) => _$CreateDocsResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateDocsResultDtoToJson(this);
}

@JsonSerializable()
class DocsFullInfoDto extends DocsInfoDto {
  List<SegmentInfoDto> segmentInfoList;

  DocsFullInfoDto({required super.docsId, required super.docsName, required this.segmentInfoList});

  factory DocsFullInfoDto.fromJson(Map<String, dynamic> json) => _$DocsFullInfoDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DocsFullInfoDtoToJson(this);
}

/// Segment

@JsonSerializable()
class SegmentIdDto {
  String segmentId;

  SegmentIdDto({required this.segmentId});

  factory SegmentIdDto.fromJson(Map<String, dynamic> json) => _$SegmentIdDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SegmentIdDtoToJson(this);
}

@JsonSerializable()
class SegmentUpsertResultDto extends SegmentIdDto {
  TokenUsageDto tokenUsage;

  SegmentUpsertResultDto({required super.segmentId, required this.tokenUsage});

  factory SegmentUpsertResultDto.fromJson(Map<String, dynamic> json) => _$SegmentUpsertResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SegmentUpsertResultDtoToJson(this);
}

@JsonSerializable()
class SegmentDto {
  String text;
  Map<String, dynamic>? metadata;

  SegmentDto({required this.text, this.metadata});

  factory SegmentDto.fromJson(Map<String, dynamic> json) => _$SegmentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SegmentDtoToJson(this);

  Segment toModel() => Segment(text: text, metadata: metadata);
}

@JsonSerializable()
class InsertSegmentDto extends DocsIdDto{
  SegmentDto segment;
  int? index;
  LLMConfigDto llmConfig;

  InsertSegmentDto({required super.docsId, required this.segment, this.index, required this.llmConfig});

  factory InsertSegmentDto.fromJson(Map<String, dynamic> json) => _$InsertSegmentDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InsertSegmentDtoToJson(this);
}

@JsonSerializable()
class UpdateSegmentDto extends DocsIdDto{
  SegmentInfoDto segment;
  LLMConfigDto llmConfig;

  UpdateSegmentDto({required super.docsId, required this.segment, required this.llmConfig});

  factory UpdateSegmentDto.fromJson(Map<String, dynamic> json) => _$UpdateSegmentDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UpdateSegmentDtoToJson(this);
}

@JsonSerializable()
class DeleteSegmentDto extends DocsIdDto{
  String segmentId;

  DeleteSegmentDto({required super.docsId, required this.segmentId});

  factory DeleteSegmentDto.fromJson(Map<String, dynamic> json) => _$DeleteSegmentDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DeleteSegmentDtoToJson(this);
}

@JsonSerializable()
class SegmentInfoDto extends SegmentDto{
  String segmentId;

  SegmentInfoDto({required this.segmentId, required super.text, required super.metadata});

  factory SegmentInfoDto.fromJson(Map<String, dynamic> json) => _$SegmentInfoDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SegmentInfoDtoToJson(this);

  factory SegmentInfoDto.fromModel(SegmentInfo segmentInfo) => SegmentInfoDto(segmentId: segmentInfo.id, text: segmentInfo.text, metadata: segmentInfo.metadata);

  @override
  SegmentInfo toModel() => SegmentInfo(id: segmentId, text: text, metadata: metadata);
}

@JsonSerializable()
class SegmentResultDto extends SegmentIdDto {
  String text;
  Map<String, dynamic>? metadata;
  double distance;

  SegmentResultDto({required super.segmentId, required this.text, required this.metadata, required this.distance});

  factory SegmentResultDto.fromJson(Map<String, dynamic> json) => _$SegmentResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SegmentResultDtoToJson(this);

  factory SegmentResultDto.fromModel(QuerySegmentResult segmentResult) => SegmentResultDto(segmentId: segmentResult.id, text: segmentResult.text, metadata: segmentResult.metadata, distance: segmentResult.distance);
}

/// Query

@JsonSerializable()
class QueryRequestDto extends DocsIdDto{
  String queryText;
  int nResults;
  LLMConfigDto llmConfig;

  QueryRequestDto({required super.docsId, required this.queryText, this.nResults = 2, required this.llmConfig});

  factory QueryRequestDto.fromJson(Map<String, dynamic> json) => _$QueryRequestDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$QueryRequestDtoToJson(this);
}

@JsonSerializable()
class BatchQueryRequestDto extends DocsIdDto{
  List<String> queryTextList;
  int nResults;
  LLMConfigDto llmConfig;

  BatchQueryRequestDto({required super.docsId, required this.queryTextList, this.nResults = 2, required this.llmConfig});

  factory BatchQueryRequestDto.fromJson(Map<String, dynamic> json) => _$BatchQueryRequestDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BatchQueryRequestDtoToJson(this);
}

@JsonSerializable()
class QueryResultDto extends DocsIdDto {
  List<SegmentResultDto> segmentResultList;
  TokenUsageDto tokenUsage;

  QueryResultDto({required super.docsId, required this.segmentResultList, required this.tokenUsage});

  factory QueryResultDto.fromJson(Map<String, dynamic> json) => _$QueryResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$QueryResultDtoToJson(this);

}

@JsonSerializable()
class MultiDocsQueryRequestDto {
  List<String> docsIdList;
  String queryText;
  int nResults;
  bool removeDuplicates;
  LLMConfigDto llmConfig;

  MultiDocsQueryRequestDto({required this.docsIdList, required this.queryText, this.nResults = 2, this.removeDuplicates = true, required this.llmConfig});

  factory MultiDocsQueryRequestDto.fromJson(Map<String, dynamic> json) => _$MultiDocsQueryRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MultiDocsQueryRequestDtoToJson(this);
}

@JsonSerializable()
class MultiDocsQuerySegmentDto extends DocsIdDto {
  SegmentResultDto segmentResult;

  MultiDocsQuerySegmentDto({required super.docsId, required this.segmentResult});

  factory MultiDocsQuerySegmentDto.fromJson(Map<String, dynamic> json) => _$MultiDocsQuerySegmentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MultiDocsQuerySegmentDtoToJson(this);

  factory MultiDocsQuerySegmentDto.fromModel(MultiDocsQuerySegment multiDocsQueryResult) =>
    MultiDocsQuerySegmentDto(docsId: multiDocsQueryResult.docsId, segmentResult: SegmentResultDto.fromModel(multiDocsQueryResult.querySegmentResult));
}

@JsonSerializable()
class MultiDocsQueryResultDto {
  List<MultiDocsQuerySegmentDto> segmentResultList;
  TokenUsageDto tokenUsage;

  MultiDocsQueryResultDto({ required this.segmentResultList, required this.tokenUsage});

  factory MultiDocsQueryResultDto.fromJson(Map<String, dynamic> json) => _$MultiDocsQueryResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MultiDocsQueryResultDtoToJson(this);

  factory MultiDocsQueryResultDto.fromModel(MultiDocsQueryResult multiDocsQueryResult) => MultiDocsQueryResultDto(
    segmentResultList: multiDocsQueryResult.multiDocsQuerySegmentList.map((segmentResult)=>MultiDocsQuerySegmentDto.fromModel(segmentResult)).toList(),// SegmentResultDto.fromModel(multiDocsQueryResult.querySegmentResult),
    tokenUsage: TokenUsageDto.fromModel(multiDocsQueryResult.tokenUsage)
  );

}