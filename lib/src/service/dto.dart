import 'package:json_annotation/json_annotation.dart';
import '../model.dart';

part 'dto.g.dart';

@JsonSerializable()
class LLMConfigDto {
  late String baseUrl;
  late String apiKey;
  late String model;

  LLMConfigDto(
      {required this.baseUrl,
        required this.apiKey,
        required this.model});

  factory LLMConfigDto.fromJson(Map<String, dynamic> json) =>
      _$LLMConfigDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LLMConfigDtoToJson(this);

  LLMConfig toModel() => LLMConfig(baseUrl: baseUrl, apiKey: apiKey, model: model);

}

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
class CreateDocsTextDto {
  String docsName;
  String text;
  String separator;
  Map<String, dynamic> metadata;

  CreateDocsTextDto({required this.docsName, required this.text, required this.separator, this.metadata = const {}});

  factory CreateDocsTextDto.fromJson(Map<String, dynamic> json) => _$CreateDocsTextDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateDocsTextDtoToJson(this);
}

@JsonSerializable()
class SegmentIdDto {
  String segmentId;

  SegmentIdDto({required this.segmentId});

  factory SegmentIdDto.fromJson(Map<String, dynamic> json) => _$SegmentIdDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SegmentIdDtoToJson(this);
}

@JsonSerializable()
class SegmentDto {
  String text;
  Map<String, dynamic> metadata;

  SegmentDto({required this.text, required this.metadata});

  factory SegmentDto.fromJson(Map<String, dynamic> json) => _$SegmentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SegmentDtoToJson(this);

  Segment toModel() => Segment(text: text, metadata: metadata);
}

@JsonSerializable()
class InsertSegmentDto extends DocsIdDto{
  SegmentDto segment;
  int? index;

  InsertSegmentDto({required super.docsId, required this.segment, this.index});

  factory InsertSegmentDto.fromJson(Map<String, dynamic> json) => _$InsertSegmentDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InsertSegmentDtoToJson(this);
}

@JsonSerializable()
class UpdateSegmentDto extends DocsIdDto{
  SegmentInfoDto segment;

  UpdateSegmentDto({required super.docsId, required this.segment});

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
class DocsDto{
  String docsName;
  List<SegmentDto> segmentList;

  DocsDto({required this.docsName, required this.segmentList});

  factory DocsDto.fromJson(Map<String, dynamic> json) => _$DocsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DocsDtoToJson(this);

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
class DocsFullInfoDto extends DocsInfoDto {
  List<SegmentInfoDto> segmentInfoList;

  DocsFullInfoDto({required super.docsId, required super.docsName, required this.segmentInfoList});

  factory DocsFullInfoDto.fromJson(Map<String, dynamic> json) => _$DocsFullInfoDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DocsFullInfoDtoToJson(this);
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

@JsonSerializable()
class QueryDto extends DocsIdDto{
  String queryText;
  int nResults;

  QueryDto({required super.docsId, required this.queryText, this.nResults = 2});

  factory QueryDto.fromJson(Map<String, dynamic> json) => _$QueryDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$QueryDtoToJson(this);
}

@JsonSerializable()
class BatchQueryDto extends DocsIdDto{
  List<String> queryTextList;
  int nResults;

  BatchQueryDto({required super.docsId, required this.queryTextList, this.nResults = 2});

  factory BatchQueryDto.fromJson(Map<String, dynamic> json) => _$BatchQueryDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BatchQueryDtoToJson(this);
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

@JsonSerializable()
class QueryResultDto extends DocsIdDto {
  List<SegmentResultDto> segmentResultList;

  QueryResultDto({required super.docsId, required this.segmentResultList});

  factory QueryResultDto.fromJson(Map<String, dynamic> json) => _$QueryResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$QueryResultDtoToJson(this);

}

@JsonSerializable()
class MultiDocsQueryRequestDto {
  List<String> docsIdList;
  String queryText;
  int nResults;

  MultiDocsQueryRequestDto({required this.docsIdList, required this.queryText, this.nResults = 2});

  factory MultiDocsQueryRequestDto.fromJson(Map<String, dynamic> json) => _$DocsQueryRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DocsQueryRequestDtoToJson(this);
}

@JsonSerializable()
class MultiDocsQueryResultDto extends DocsIdDto {
  SegmentResultDto segmentResult;

  MultiDocsQueryResultDto({required super.docsId, required this.segmentResult});

  factory MultiDocsQueryResultDto.fromJson(Map<String, dynamic> json) => _$DocsQueryResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DocsQueryResultDtoToJson(this);

  factory MultiDocsQueryResultDto.fromModel(MultiDocsQueryResult multiDocsQueryResult) => MultiDocsQueryResultDto(
      docsId: multiDocsQueryResult.docsId,
      segmentResult: SegmentResultDto.fromModel(multiDocsQueryResult.querySegmentResult)
  );
}