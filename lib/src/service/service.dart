import 'dart:async';

import '../model.dart';
import 'dto.dart';
import '../vector_database/vector_database.dart';

class EmbeddingsService {
  final VectorDatabase _vdb;

  EmbeddingsService(this._vdb);

  Future<void> init() async => await _vdb.connect();
  Future<void> dispose() async => await _vdb.disconnect();

  Future<CreateDocsResultDto> createDocsByText(CreateDocsTextRequestDto createDocsTextDto) async {
    List<String> segmentList = createDocsTextDto.text.split(createDocsTextDto.separator);
    List<SegmentDto> segmentDtoList = [];
    for(String segmentString in segmentList) {
      segmentString = segmentString.trim();
      if(segmentString.isNotEmpty) {
        SegmentDto segmentDto = SegmentDto(text: segmentString, metadata: createDocsTextDto.metadata);
        segmentDtoList.add(segmentDto);
      }
    }
    CreateDocsRequestDto docsDto = CreateDocsRequestDto(docsName: createDocsTextDto.docsName, segmentList: segmentDtoList, llmConfig: createDocsTextDto.llmConfig);
    return await createDocs(docsDto);
  }

  Future<CreateDocsResultDto> createDocs(CreateDocsRequestDto docsDto) async {
    List<Segment> segmentList = [];

    for (SegmentDto segmentDto in docsDto.segmentList) {
      segmentList.add(segmentDto.toModel());
    }

    Completer<TokenUsage> completer = Completer<TokenUsage>();
    LLMSettings llmSettings = LLMSettings(llmConfig: docsDto.llmConfig.toModel(), listenToken: (TokenUsage tokenUsage) => completer.complete(tokenUsage));
    CollectionInfo collectionInfo = await _vdb.createCollection(docsDto.docsName, segmentList, llmSettings);
    TokenUsage tokenUsage = await completer.future;

    CreateDocsResultDto createDocsResultDto = CreateDocsResultDto(docsId: collectionInfo.name, docsName: collectionInfo.docsName, tokenUsage: TokenUsageDto.fromModel(tokenUsage));

    return createDocsResultDto;
  }

  Future<void> deleteDocs(DocsIdDto docsIdDto) async {
    await _vdb.deleteCollection(docsIdDto.docsId);
  }

  Future<List<DocsInfoDto>> listDocs() async {
    List<CollectionInfo> collectionInfoList = await _vdb.listCollections();
    return collectionInfoList.map((collectionInfo)=> DocsInfoDto(docsId: collectionInfo.name, docsName: collectionInfo.docsName)).toList();
  }

  Future<DocsInfoDto> renameDocs(DocsInfoDto docsInfoDto) async {
    CollectionInfo collectionInfo = await _vdb.renameCollection(docsInfoDto.docsId, docsInfoDto.docsName);
    return DocsInfoDto.fromModel(collectionInfo);
  }

  Future<DocsFullInfoDto?> listSegments(DocsIdDto docsIdDto) async {
    CollectionResult? collectionResult = await _vdb.listSegments(docsIdDto.docsId);
    if(collectionResult == null) return null;

    List<SegmentInfoDto> segmentInfoDtoList = collectionResult.segmentList.map((segmentInfo)=> SegmentInfoDto(segmentId: segmentInfo.id, text: segmentInfo.text, metadata: segmentInfo.metadata)).toList();
    DocsFullInfoDto docsFullInfoDto = DocsFullInfoDto(docsId: collectionResult.name,docsName: collectionResult.docsName, segmentInfoList: segmentInfoDtoList);
    return docsFullInfoDto;
  }

  Future<SegmentUpsertResultDto> insertSegment(InsertSegmentDto insertSegmentDto) async {
    Completer<TokenUsage> completer = Completer<TokenUsage>();
    LLMSettings llmSettings = LLMSettings(llmConfig: insertSegmentDto.llmConfig.toModel(), listenToken: (TokenUsage tokenUsage) => completer.complete(tokenUsage));
    String segmentId = await _vdb.insertSegment(insertSegmentDto.docsId, insertSegmentDto.segment.toModel(), insertSegmentDto.index, llmSettings);
    TokenUsage tokenUsage = await completer.future;
    SegmentUpsertResultDto segmentUpsertResultDto = SegmentUpsertResultDto(segmentId: segmentId, tokenUsage: TokenUsageDto.fromModel(tokenUsage));
    return segmentUpsertResultDto;
  }

  Future<SegmentUpsertResultDto> updateSegment(UpdateSegmentDto updateSegmentDto) async {
    Completer<TokenUsage> completer = Completer<TokenUsage>();
    LLMSettings llmSettings = LLMSettings(llmConfig: updateSegmentDto.llmConfig.toModel(), listenToken: (TokenUsage tokenUsage) => completer.complete(tokenUsage));
    await _vdb.updateSegment(updateSegmentDto.docsId, updateSegmentDto.segment.toModel(), llmSettings);
    TokenUsage tokenUsage = await completer.future;
    SegmentUpsertResultDto segmentUpsertResultDto = SegmentUpsertResultDto(segmentId: updateSegmentDto.segment.segmentId, tokenUsage: TokenUsageDto.fromModel(tokenUsage));
    return segmentUpsertResultDto;
  }

  Future<SegmentIdDto> deleteSegment(DeleteSegmentDto deleteSegmentDto) async {
    await _vdb.deleteSegment(deleteSegmentDto.docsId, deleteSegmentDto.segmentId);
    return SegmentIdDto(segmentId: deleteSegmentDto.segmentId);
  }

  Future<QueryResultDto> query(QueryRequestDto queryRequestDto) async {
    Completer<TokenUsage> completer = Completer<TokenUsage>();
    LLMSettings llmSettings = LLMSettings(llmConfig: queryRequestDto.llmConfig.toModel(), listenToken: (TokenUsage tokenUsage) => completer.complete(tokenUsage));
    List<List<QuerySegmentResult>> segmentResultListList = await _vdb.query(queryRequestDto.docsId, [queryRequestDto.queryText], llmSettings, nResults: queryRequestDto.nResults);
    TokenUsage tokenUsage = await completer.future;
    List<QuerySegmentResult> segmentResultList = segmentResultListList[0];
    List<SegmentResultDto> segmentResultDtoList = segmentResultList.map((segmentResult)=> SegmentResultDto.fromModel(segmentResult)).toList();
    QueryResultDto queryResultDto = QueryResultDto(docsId: queryRequestDto.docsId, segmentResultList: segmentResultDtoList, tokenUsage: TokenUsageDto.fromModel(tokenUsage));
    return queryResultDto;
  }

  Future<List<QueryResultDto>> batchQuery(BatchQueryRequestDto batchQueryRequestDto) async {
    Completer<TokenUsage> completer = Completer<TokenUsage>();
    LLMSettings llmSettings = LLMSettings(llmConfig: batchQueryRequestDto.llmConfig.toModel(), listenToken: (TokenUsage tokenUsage) => completer.complete(tokenUsage));
    List<List<QuerySegmentResult>> segmentResultListList = await _vdb.query(batchQueryRequestDto.docsId, batchQueryRequestDto.queryTextList, llmSettings, nResults: batchQueryRequestDto.nResults);
    TokenUsage tokenUsage = await completer.future;
    List<QueryResultDto> queryResultDtoList = [];
    for(int i=0; i< segmentResultListList.length; i++) {
      List<QuerySegmentResult> segmentResultList = segmentResultListList[i];
      List<SegmentResultDto> segmentResultDtoList = segmentResultList.map((segmentResult)=> SegmentResultDto.fromModel(segmentResult)).toList();
      QueryResultDto queryResultDto = QueryResultDto(docsId: batchQueryRequestDto.docsId, segmentResultList: segmentResultDtoList, tokenUsage: TokenUsageDto.fromModel(tokenUsage));
      queryResultDtoList.add(queryResultDto);
    }
    return queryResultDtoList;
  }

  Future<MultiDocsQueryResultDto> multiDocsQuery(MultiDocsQueryRequestDto multiDocsQueryRequestDto) async {
    Completer<TokenUsage> completer = Completer<TokenUsage>();
    LLMSettings llmSettings = LLMSettings(llmConfig: multiDocsQueryRequestDto.llmConfig.toModel(), listenToken: (TokenUsage tokenUsage) => completer.complete(tokenUsage));
    List<MultiDocsQuerySegment> multiDocsQueryResultList = await _vdb.multiQuery(
      multiDocsQueryRequestDto.docsIdList,
      multiDocsQueryRequestDto.queryText,
      llmSettings,
      nResults: multiDocsQueryRequestDto.nResults,
      removeDuplicates: multiDocsQueryRequestDto.removeDuplicates
    );
    TokenUsage tokenUsage = await completer.future;
    MultiDocsQueryResultDto multiDocsQueryResultDto = MultiDocsQueryResultDto(
        segmentResultList: multiDocsQueryResultList.map((multiDocsQuerySegment)=>MultiDocsQuerySegmentDto.fromModel(multiDocsQuerySegment)).toList(),
        tokenUsage: TokenUsageDto.fromModel(tokenUsage)
    );
    return multiDocsQueryResultDto;
  }
}