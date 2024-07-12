import '../model.dart';
import 'dto.dart';
import '../vector_database/vector_database.dart';

class EmbeddingsService {
  final VectorDatabase _vdb;

  EmbeddingsService(this._vdb);

  Future<void> init() async => await _vdb.connect();
  Future<void> dispose() async => await _vdb.disconnect();

  Future<DocsInfoDto> createDocsByText(CreateDocsTextDto createDocsTextDto) async {
    List<String> segmentList = createDocsTextDto.text.split(createDocsTextDto.separator);
    List<SegmentDto> segmentDtoList = [];
    for(String segmentString in segmentList) {
      segmentString = segmentString.trim();
      if(segmentString.isNotEmpty) {
        SegmentDto segmentDto = SegmentDto(text: segmentString, metadata: createDocsTextDto.metadata);
        segmentDtoList.add(segmentDto);
      }
    }
    DocumentDto documentDto = DocumentDto(docsName: createDocsTextDto.docsName, segmentList: segmentDtoList);
    return await createDocs(documentDto);
  }

  Future<DocsInfoDto> createDocs(DocumentDto documentDto) async {
    List<Segment> segmentList = [];

    for (SegmentDto segmentDto in documentDto.segmentList) {
      segmentList.add(segmentDto.toModel());
    }

    CollectionInfo collectionInfo = await _vdb.createCollection(documentDto.docsName, segmentList);

    return DocsInfoDto.fromModel(collectionInfo);
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

  Future<DocumentInfoDto?> listSegments(DocsIdDto docsIdDto) async {
    CollectionResult? collectionResult = await _vdb.listSegments(docsIdDto.docsId);
    if(collectionResult == null) return null;

    List<SegmentInfoDto> segmentInfoDtoList = collectionResult.segmentList.map((segmentInfo)=> SegmentInfoDto(segmentId: segmentInfo.id, text: segmentInfo.text, metadata: segmentInfo.metadata)).toList();
    DocumentInfoDto documentInfoDto = DocumentInfoDto(docsId: collectionResult.name,docsName: collectionResult.docsName, segmentInfoList: segmentInfoDtoList);
    return documentInfoDto;
  }

  Future<SegmentIdDto> insertSegment(InsertSegmentDto insertSegmentDto) async {
    String segmentId = await _vdb.insertSegment(insertSegmentDto.docsId, insertSegmentDto.segment.toModel(), insertSegmentDto.index);
    return SegmentIdDto(segmentId: segmentId);
  }

  Future<SegmentIdDto> updateSegment(UpdateSegmentDto updateSegmentDto) async {
    await _vdb.updateSegment(updateSegmentDto.docsId, updateSegmentDto.segment.toModel());
    return SegmentIdDto(segmentId: updateSegmentDto.segment.segmentId);
  }

  Future<SegmentIdDto> deleteSegment(DeleteSegmentDto deleteSegmentDto) async {
    await _vdb.deleteSegment(deleteSegmentDto.docsId, deleteSegmentDto.segmentId);
    return SegmentIdDto(segmentId: deleteSegmentDto.segmentId);
  }

  Future<QueryResultDto> query(QueryDto queryDto) async {
    List<List<QuerySegmentResult>> segmentResultListList = await _vdb.query(queryDto.docsId, [queryDto.queryText], nResults: queryDto.nResults);
      List<QuerySegmentResult> segmentResultList = segmentResultListList[0];
      List<SegmentResultDto> segmentResultDtoList = segmentResultList.map((segmentResult)=> SegmentResultDto.fromModel(segmentResult)).toList();
      QueryResultDto queryResultDto = QueryResultDto(docsId: queryDto.docsId, segmentResultList: segmentResultDtoList);
    return queryResultDto;
  }

  Future<List<QueryResultDto>> batchQuery(BatchQueryDto batchQueryDto) async {
    List<List<QuerySegmentResult>> segmentResultListList = await _vdb.query(batchQueryDto.docsId, batchQueryDto.queryTextList, nResults: batchQueryDto.nResults);
    List<QueryResultDto> queryResultDtoList = [];
    for(int i=0; i< segmentResultListList.length; i++) {
      List<QuerySegmentResult> segmentResultList = segmentResultListList[i];
      List<SegmentResultDto> segmentResultDtoList = segmentResultList.map((segmentResult)=> SegmentResultDto.fromModel(segmentResult)).toList();
      QueryResultDto queryResultDto = QueryResultDto(docsId: batchQueryDto.docsId, segmentResultList: segmentResultDtoList);
      queryResultDtoList.add(queryResultDto);
    }
    return queryResultDtoList;
  }
}