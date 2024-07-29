import '../model.dart';

abstract class VectorDatabase {
  Future<void> connect();
  Future<void> disconnect();

  Future<CollectionInfo> createCollection(String docsName, List<Segment> segmentList, LLMSettings llmSettings);
  Future<void> deleteCollection(String collectionName);
  Future<List<CollectionInfo>> listCollections();
  Future<CollectionInfo> renameCollection(String collectionName, String docsName);

  Future<CollectionResult?> listSegments(String collectionName);
  Future<String> insertSegment(String collectionName, Segment segment, int? index, LLMSettings llmSettings);
  Future<void> updateSegment(String collectionName, SegmentInfo segmentInfo, LLMSettings llmSettings);
  Future<void> deleteSegment(String collectionName, String segmentId);

  Future<List<List<QuerySegmentResult>>> query(String collectionName, List<String> queryTexts, LLMSettings llmSettings, { int nResults = 2 });
  Future<List<MultiDocsQuerySegment>> multiQuery(List<String> collectionNameList, String queryText, LLMSettings llmSettings, { int nResults = 2, bool removeDuplicates = true });

}