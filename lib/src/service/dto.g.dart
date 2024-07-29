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

CreateDocsTextRequestDto _$CreateDocsTextRequestDtoFromJson(
        Map<String, dynamic> json) =>
    CreateDocsTextRequestDto(
      docsName: json['docsName'] as String,
      text: json['text'] as String,
      separator: json['separator'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      llmConfig:
          LLMConfigDto.fromJson(json['llmConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateDocsTextRequestDtoToJson(
        CreateDocsTextRequestDto instance) =>
    <String, dynamic>{
      'docsName': instance.docsName,
      'text': instance.text,
      'separator': instance.separator,
      'metadata': instance.metadata,
      'llmConfig': instance.llmConfig,
    };

CreateDocsRequestDto _$CreateDocsRequestDtoFromJson(
        Map<String, dynamic> json) =>
    CreateDocsRequestDto(
      docsName: json['docsName'] as String,
      segmentList: (json['segmentList'] as List<dynamic>)
          .map((e) => SegmentDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      llmConfig:
          LLMConfigDto.fromJson(json['llmConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateDocsRequestDtoToJson(
        CreateDocsRequestDto instance) =>
    <String, dynamic>{
      'docsName': instance.docsName,
      'segmentList': instance.segmentList,
      'llmConfig': instance.llmConfig,
    };

CreateDocsResultDto _$CreateDocsResultDtoFromJson(Map<String, dynamic> json) =>
    CreateDocsResultDto(
      docsId: json['docsId'] as String,
      docsName: json['docsName'] as String,
      tokenUsage:
          TokenUsageDto.fromJson(json['tokenUsage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateDocsResultDtoToJson(
        CreateDocsResultDto instance) =>
    <String, dynamic>{
      'docsId': instance.docsId,
      'docsName': instance.docsName,
      'tokenUsage': instance.tokenUsage,
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

SegmentIdDto _$SegmentIdDtoFromJson(Map<String, dynamic> json) => SegmentIdDto(
      segmentId: json['segmentId'] as String,
    );

Map<String, dynamic> _$SegmentIdDtoToJson(SegmentIdDto instance) =>
    <String, dynamic>{
      'segmentId': instance.segmentId,
    };

SegmentUpsertResultDto _$SegmentUpsertResultDtoFromJson(
        Map<String, dynamic> json) =>
    SegmentUpsertResultDto(
      segmentId: json['segmentId'] as String,
      tokenUsage:
          TokenUsageDto.fromJson(json['tokenUsage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SegmentUpsertResultDtoToJson(
        SegmentUpsertResultDto instance) =>
    <String, dynamic>{
      'segmentId': instance.segmentId,
      'tokenUsage': instance.tokenUsage,
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
      llmConfig:
          LLMConfigDto.fromJson(json['llmConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InsertSegmentDtoToJson(InsertSegmentDto instance) =>
    <String, dynamic>{
      'docsId': instance.docsId,
      'segment': instance.segment,
      'index': instance.index,
      'llmConfig': instance.llmConfig,
    };

UpdateSegmentDto _$UpdateSegmentDtoFromJson(Map<String, dynamic> json) =>
    UpdateSegmentDto(
      docsId: json['docsId'] as String,
      segment: SegmentInfoDto.fromJson(json['segment'] as Map<String, dynamic>),
      llmConfig:
          LLMConfigDto.fromJson(json['llmConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateSegmentDtoToJson(UpdateSegmentDto instance) =>
    <String, dynamic>{
      'docsId': instance.docsId,
      'segment': instance.segment,
      'llmConfig': instance.llmConfig,
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

QueryRequestDto _$QueryRequestDtoFromJson(Map<String, dynamic> json) =>
    QueryRequestDto(
      docsId: json['docsId'] as String,
      queryText: json['queryText'] as String,
      nResults: (json['nResults'] as num?)?.toInt() ?? 2,
      llmConfig:
          LLMConfigDto.fromJson(json['llmConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QueryRequestDtoToJson(QueryRequestDto instance) =>
    <String, dynamic>{
      'docsId': instance.docsId,
      'queryText': instance.queryText,
      'nResults': instance.nResults,
      'llmConfig': instance.llmConfig,
    };

BatchQueryRequestDto _$BatchQueryRequestDtoFromJson(
        Map<String, dynamic> json) =>
    BatchQueryRequestDto(
      docsId: json['docsId'] as String,
      queryTextList: (json['queryTextList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      nResults: (json['nResults'] as num?)?.toInt() ?? 2,
      llmConfig:
          LLMConfigDto.fromJson(json['llmConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BatchQueryRequestDtoToJson(
        BatchQueryRequestDto instance) =>
    <String, dynamic>{
      'docsId': instance.docsId,
      'queryTextList': instance.queryTextList,
      'nResults': instance.nResults,
      'llmConfig': instance.llmConfig,
    };

QueryResultDto _$QueryResultDtoFromJson(Map<String, dynamic> json) =>
    QueryResultDto(
      docsId: json['docsId'] as String,
      segmentResultList: (json['segmentResultList'] as List<dynamic>)
          .map((e) => SegmentResultDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      tokenUsage:
          TokenUsageDto.fromJson(json['tokenUsage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QueryResultDtoToJson(QueryResultDto instance) =>
    <String, dynamic>{
      'docsId': instance.docsId,
      'segmentResultList': instance.segmentResultList,
      'tokenUsage': instance.tokenUsage,
    };

MultiDocsQueryRequestDto _$MultiDocsQueryRequestDtoFromJson(
        Map<String, dynamic> json) =>
    MultiDocsQueryRequestDto(
      docsIdList: (json['docsIdList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      queryText: json['queryText'] as String,
      nResults: (json['nResults'] as num?)?.toInt() ?? 2,
      removeDuplicates: json['removeDuplicates'] as bool? ?? true,
      llmConfig:
          LLMConfigDto.fromJson(json['llmConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MultiDocsQueryRequestDtoToJson(
        MultiDocsQueryRequestDto instance) =>
    <String, dynamic>{
      'docsIdList': instance.docsIdList,
      'queryText': instance.queryText,
      'nResults': instance.nResults,
      'removeDuplicates': instance.removeDuplicates,
      'llmConfig': instance.llmConfig,
    };

MultiDocsQuerySegmentDto _$MultiDocsQuerySegmentDtoFromJson(
        Map<String, dynamic> json) =>
    MultiDocsQuerySegmentDto(
      docsId: json['docsId'] as String,
      segmentResult: SegmentResultDto.fromJson(
          json['segmentResult'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MultiDocsQuerySegmentDtoToJson(
        MultiDocsQuerySegmentDto instance) =>
    <String, dynamic>{
      'docsId': instance.docsId,
      'segmentResult': instance.segmentResult,
    };

MultiDocsQueryResultDto _$MultiDocsQueryResultDtoFromJson(
        Map<String, dynamic> json) =>
    MultiDocsQueryResultDto(
      segmentResultList: (json['segmentResultList'] as List<dynamic>)
          .map((e) =>
              MultiDocsQuerySegmentDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      tokenUsage:
          TokenUsageDto.fromJson(json['tokenUsage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MultiDocsQueryResultDtoToJson(
        MultiDocsQueryResultDto instance) =>
    <String, dynamic>{
      'segmentResultList': instance.segmentResultList,
      'tokenUsage': instance.tokenUsage,
    };
