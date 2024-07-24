class LLMConfig {
  String baseUrl;
  String apiKey;
  String model;
  LLMConfig(
      {required this.baseUrl,
        required this.apiKey,
        required this.model});
}

class TokenUsage {
  int promptToken;
  int totalToken;

  TokenUsage({required this.promptToken, required this.totalToken});
}

class CollectionInfo {
  String name;
  String docsName;

  CollectionInfo({required this.name, required this.docsName});
}

class Segment {
  String text;
  Map<String, dynamic> metadata;

  Segment({required this.text, this.metadata = const {}});
}

class SegmentInfo extends Segment{
  String id;

  SegmentInfo({required this.id, required super.text, super.metadata = const {}});
}

class CollectionResult extends CollectionInfo{
  List<SegmentInfo> segmentList;

  CollectionResult({required super.name, required super.docsName, required this.segmentList});
}

class QuerySegmentResult extends SegmentInfo{
  double distance;

  QuerySegmentResult({required super.id, required super.text, super.metadata = const {}, required this.distance});
}

class MultiDocsQueryResult{
  String docsId;
  QuerySegmentResult querySegmentResult;

  MultiDocsQueryResult({required this.docsId, required this.querySegmentResult});
}