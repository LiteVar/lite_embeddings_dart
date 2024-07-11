import '../model.dart';

abstract class VectorDatabase {
  Future<void> connect();
  Future<void> disconnect();

  Future<CollectionInfo> createCollection(String docsName, List<Segment> segmentList);
  Future<void> deleteCollection(String collectionName);
  Future<List<CollectionInfo>> listCollections();

  Future<CollectionResult?> listSegments(String collectionName);
  Future<String> insertSegment(String collectionName, Segment segment, int? index);
  Future<void> updateSegment(String collectionName, SegmentInfo segmentInfo);
  Future<void> deleteSegment(String collectionName, String segmentId);

  Future<List<List<QuerySegmentResult>>> query(String collectionName, List<String> queryTexts, { int nResults = 2 });

}