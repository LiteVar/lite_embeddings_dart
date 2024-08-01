class LLMConfig {
  String baseUrl;
  String apiKey;
  String model;
  LLMConfig({
    required this.baseUrl,
    required this.apiKey,
    required this.model
  });
}

class TokenUsage {
  int promptToken;
  int totalToken;

  TokenUsage({required this.promptToken, required this.totalToken});
}

class LLMSettings {
  LLMConfig llmConfig;
  Function(TokenUsage tokenUsage) listenToken;

  LLMSettings({required this.llmConfig, required this.listenToken});
}

class CollectionInfo {
  String name;
  String docsName;

  CollectionInfo({required this.name, required this.docsName});
}

class Segment {
  String text;
  Map<String, dynamic>? metadata;

  Segment({required this.text, this.metadata = const {}});
}

class SegmentInfo extends Segment {
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

class MultiDocsQuerySegment{
  String docsId;
  QuerySegmentResult querySegmentResult;

  MultiDocsQuerySegment({required this.docsId, required this.querySegmentResult});
}

class MultiDocsQueryResult{
  List<MultiDocsQuerySegment> multiDocsQuerySegmentList;
  TokenUsage tokenUsage;

  MultiDocsQueryResult({required this.multiDocsQuerySegmentList, required this.tokenUsage});
}