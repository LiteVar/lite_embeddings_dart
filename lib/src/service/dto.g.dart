// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LLMConfigDto _$LLMConfigDtoFromJson(Map<String, dynamic> json) => LLMConfigDto(
      baseUrl: json['baseUrl'] as String,
      apiKey: json['apiKey'] as String,
      model: json['model'] as String,
    );

Map<String, dynamic> _$LLMConfigDtoToJson(LLMConfigDto instance) =>
    <String, dynamic>{
      'baseUrl': instance.baseUrl,
      'apiKey': instance.apiKey,
      'model': instance.model,
    };

DocsIdDto _$DocsIdDtoFromJson(Map<String, dynamic> json) => DocsIdDto(
      docsId: json['docsId'] as String,
    );

Map<String, dynamic> _$DocsIdDtoToJson(DocsIdDto instance) => <String, dynamic>{
      'docsId': instance.docsId,
    };

DocsInfoDto _$DocsInfoDtoFromJson(Map<String, dynamic> json) => DocsInfoDto(
      docsId: json['docsId'] as String,
      docsName: json['docsName'] as String,
    );

Map<String, dynamic> _$DocsInfoDtoToJson(DocsInfoDto instance) =>
    <String, dynamic>{
      'docsId': instance.docsId,
      'docsName': instance.docsName,
    };

CreateDocsTextDto _$CreateDocsTextDtoFromJson(Map<String, dynamic> json) =>
    CreateDocsTextDto(
      docsName: json['docsName'] as String,
      text: json['text'] as String,
      separator: json['separator'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$CreateDocsTextDtoToJson(CreateDocsTextDto instance) =>
    <String, dynamic>{
      'docsName': instance.docsName,
      'text': instance.text,
      'separator': instance.separator,
      'metadata': instance.metadata,
    };

SegmentIdDto _$SegmentIdDtoFromJson(Map<String, dynamic> json) => SegmentIdDto(
      segmentId: json['segmentId'] as String,
    );

Map<String, dynamic> _$SegmentIdDtoToJson(SegmentIdDto instance) =>
    <String, dynamic>{
      'segmentId': instance.segmentId,
    };

SegmentDto _$SegmentDtoFromJson(Map<String, dynamic> json) => SegmentDto(
      text: json['text'] as String,
      metadata: json['metadata'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$SegmentDtoToJson(SegmentDto instance) =>
    <String, dynamic>{
      'text': instance.text,
      'metadata': instance.metadata,
    };

InsertSegmentDto _$InsertSegmentDtoFromJson(Map<String, dynamic> json) =>
    InsertSegmentDto(
      docsId: json['docsId'] as String,
      segment: SegmentDto.fromJson(json['segment'] as Map<String, dynamic>),
      index: (json['index'] as num?)?.toInt(),
    );

Map<String, dynamic> _$InsertSegmentDtoToJson(InsertSegmentDto instance) =>
    <String, dynamic>{
      'docsId': instance.docsId,
      'segment': instance.segment,
      'index': instance.index,
    };

UpdateSegmentDto _$UpdateSegmentDtoFromJson(Map<String, dynamic> json) =>
    UpdateSegmentDto(
      docsId: json['docsId'] as String,
      segment: SegmentInfoDto.fromJson(json['segment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateSegmentDtoToJson(UpdateSegmentDto instance) =>
    <String, dynamic>{
      'docsId': instance.docsId,
      'segment': instance.segment,
    };

DeleteSegmentDto _$DeleteSegmentDtoFromJson(Map<String, dynamic> json) =>
    DeleteSegmentDto(
      docsId: json['docsId'] as String,
      segmentId: json['segmentId'] as String,
    );

Map<String, dynamic> _$DeleteSegmentDtoToJson(DeleteSegmentDto instance) =>
    <String, dynamic>{
      'docsId': instance.docsId,
      'segmentId': instance.segmentId,
    };

DocsDto _$DocsDtoFromJson(Map<String, dynamic> json) => DocsDto(
      docsName: json['docsName'] as String,
      segmentList: (json['segmentList'] as List<dynamic>)
          .map((e) => SegmentDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DocsDtoToJson(DocsDto instance) => <String, dynamic>{
      'docsName': instance.docsName,
      'segmentList': instance.segmentList,
    };

SegmentInfoDto _$SegmentInfoDtoFromJson(Map<String, dynamic> json) =>
    SegmentInfoDto(
      segmentId: json['segmentId'] as String,
      text: json['text'] as String,
      metadata: json['metadata'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$SegmentInfoDtoToJson(SegmentInfoDto instance) =>
    <String, dynamic>{
      'text': instance.text,
      'metadata': instance.metadata,
      'segmentId': instance.segmentId,
    };

DocsFullInfoDto _$DocsFullInfoDtoFromJson(Map<String, dynamic> json) =>
    DocsFullInfoDto(
      docsId: json['docsId'] as String,
      docsName: json['docsName'] as String,
      segmentInfoList: (json['segmentInfoList'] as List<dynamic>)
          .map((e) => SegmentInfoDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DocsFullInfoDtoToJson(DocsFullInfoDto instance) =>
    <String, dynamic>{
      'docsId': instance.docsId,
      'docsName': instance.docsName,
      'segmentInfoList': instance.segmentInfoList,
    };

TokenUsageDto _$TokenUsageDtoFromJson(Map<String, dynamic> json) =>
    TokenUsageDto(
      promptToken: (json['promptToken'] as num).toInt(),
      totalToken: (json['totalToken'] as num).toInt(),
    );

Map<String, dynamic> _$TokenUsageDtoToJson(TokenUsageDto instance) =>
    <String, dynamic>{
      'promptToken': instance.promptToken,
      'totalToken': instance.totalToken,
    };

QueryDto _$QueryDtoFromJson(Map<String, dynamic> json) => QueryDto(
      docsId: json['docsId'] as String,
      queryText: json['queryText'] as String,
      nResults: (json['nResults'] as num?)?.toInt() ?? 2,
    );

Map<String, dynamic> _$QueryDtoToJson(QueryDto instance) => <String, dynamic>{
      'docsId': instance.docsId,
      'queryText': instance.queryText,
      'nResults': instance.nResults,
    };

BatchQueryDto _$BatchQueryDtoFromJson(Map<String, dynamic> json) =>
    BatchQueryDto(
      docsId: json['docsId'] as String,
      queryTextList: (json['queryTextList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      nResults: (json['nResults'] as num?)?.toInt() ?? 2,
    );

Map<String, dynamic> _$BatchQueryDtoToJson(BatchQueryDto instance) =>
    <String, dynamic>{
      'docsId': instance.docsId,
      'queryTextList': instance.queryTextList,
      'nResults': instance.nResults,
    };

SegmentResultDto _$SegmentResultDtoFromJson(Map<String, dynamic> json) =>
    SegmentResultDto(
      segmentId: json['segmentId'] as String,
      text: json['text'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
      distance: (json['distance'] as num).toDouble(),
    );

Map<String, dynamic> _$SegmentResultDtoToJson(SegmentResultDto instance) =>
    <String, dynamic>{
      'segmentId': instance.segmentId,
      'text': instance.text,
      'metadata': instance.metadata,
      'distance': instance.distance,
    };

QueryResultDto _$QueryResultDtoFromJson(Map<String, dynamic> json) =>
    QueryResultDto(
      docsId: json['docsId'] as String,
      segmentResultList: (json['segmentResultList'] as List<dynamic>)
          .map((e) => SegmentResultDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QueryResultDtoToJson(QueryResultDto instance) =>
    <String, dynamic>{
      'docsId': instance.docsId,
      'segmentResultList': instance.segmentResultList,
    };
