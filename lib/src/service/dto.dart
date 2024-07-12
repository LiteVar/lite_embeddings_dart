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
class DocsNameDto {
  String docsName;

  DocsNameDto({required this.docsName});

  factory DocsNameDto.fromJson(Map<String, dynamic> json) => _$DocsNameDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DocsNameDtoToJson(this);
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
class DocsTextDto extends DocsNameDto{
  String text;
  String separator;

  DocsTextDto({required super.docsName, required this.text, required this.separator});

  factory DocsTextDto.fromJson(Map<String, dynamic> json) => _$DocsTextDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DocsTextDtoToJson(this);
}

@JsonSerializable()
class CreateDocsTextDto extends DocsTextDto{
  Map<String, dynamic> metadata;

  CreateDocsTextDto({required super.docsName, required super.text, required super.separator, this.metadata = const {}});

  factory CreateDocsTextDto.fromJson(Map<String, dynamic> json) => _$CreateDocsTextDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CreateDocsTextDtoToJson(this);
}

@JsonSerializable()
class SegmentIdDto {
  String id;

  SegmentIdDto({required this.id});

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
  String id;

  DeleteSegmentDto({required super.docsId, required this.id});

  factory DeleteSegmentDto.fromJson(Map<String, dynamic> json) => _$DeleteSegmentDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DeleteSegmentDtoToJson(this);
}

@JsonSerializable()
class DocumentDto extends DocsNameDto{
  List<SegmentDto> segmentList;

  DocumentDto({required super.docsName, required this.segmentList});

  factory DocumentDto.fromJson(Map<String, dynamic> json) => _$DocumentDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DocumentDtoToJson(this);

}

@JsonSerializable()
class SegmentInfoDto extends SegmentDto{
  String id;

  SegmentInfoDto({required this.id, required super.text, required super.metadata});

  factory SegmentInfoDto.fromJson(Map<String, dynamic> json) => _$SegmentInfoDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SegmentInfoDtoToJson(this);

  factory SegmentInfoDto.fromModel(SegmentInfo segmentInfo) => SegmentInfoDto(id: segmentInfo.id, text: segmentInfo.text, metadata: segmentInfo.metadata);

  @override
  SegmentInfo toModel() => SegmentInfo(id: id, text: text, metadata: metadata);
}

@JsonSerializable()
class DocumentInfoDto extends DocsInfoDto{
  List<SegmentInfoDto> segmentInfoList;

  DocumentInfoDto({required super.docsId, required super.docsName, required this.segmentInfoList});

  factory DocumentInfoDto.fromJson(Map<String, dynamic> json) => _$DocumentInfoDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DocumentInfoDtoToJson(this);
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
class SegmentResultDto {
  String id;
  String text;
  Map<String, dynamic>? metadata;
  double distance;

  SegmentResultDto({required this.id, required this.text, required this.metadata, required this.distance});

  factory SegmentResultDto.fromJson(Map<String, dynamic> json) => _$SegmentResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SegmentResultDtoToJson(this);

  factory SegmentResultDto.fromModel(QuerySegmentResult segmentResult) => SegmentResultDto(id: segmentResult.id, text: segmentResult.text, metadata: segmentResult.metadata, distance: segmentResult.distance);
}

@JsonSerializable()
class QueryResultDto extends DocsIdDto {
  List<SegmentResultDto> segmentResultList;

  QueryResultDto({required super.docsId, required this.segmentResultList});

  factory QueryResultDto.fromJson(Map<String, dynamic> json) => _$QueryResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$QueryResultDtoToJson(this);

}