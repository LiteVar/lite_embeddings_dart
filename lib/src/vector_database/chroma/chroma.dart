import 'dart:convert';

import 'package:chromadb/chromadb.dart';
import 'package:uuid/uuid.dart';
import '../vector_database.dart';
import '../../model.dart';

class Chroma extends VectorDatabase {

  static final String segmentIdOrderKey = "segmentIdOrder";
  static final String docsNameKey = "docsName";

  late ChromaClient client;
  late String baseUrl;
  EmbeddingFunction embeddingFunction;

  Chroma(this.embeddingFunction, {this.baseUrl = "http://localhost:8000"});
  
  @override
  Future<void> connect() async => client = ChromaClient(baseUrl: baseUrl);

  @override
  Future<void> disconnect() async {}

  @override
  Future<CollectionInfo> createCollection(String docsName, List<Segment> segmentList) async {
    List<String> idList = [];
    List<String> documents = [];
    List<Map<String, dynamic>> metadataList = [];
    int size = segmentList.length;
    Uuid uuid = Uuid();
    String docsIdAsName = uuid.v4();

    for(int i=0; i< size; i++) {
      idList.add(uuid.v4());
      documents.add(segmentList[i].text);
      metadataList.add(segmentList[i].metadata);
    }

    Map<String, dynamic> collectionMetadata = {};
    collectionMetadata[segmentIdOrderKey] = jsonEncode(idList);
    collectionMetadata[docsNameKey] = docsName;

     Collection collection = await client.createCollection(
      name: docsIdAsName,
      metadata: collectionMetadata,
      embeddingFunction: embeddingFunction
    );
    await collection.add(
      ids: idList,
      documents: documents,
      metadatas: metadataList
    );

    return CollectionInfo(name: docsIdAsName, docsName: docsName);
  }

  @override
  Future<void> deleteCollection(String collectionName) async {
    await client.deleteCollection(name: collectionName);
  }

  @override
  Future<List<CollectionInfo>> listCollections() async {
    List<CollectionType> collectionTypeList = await client.listCollections();
    return collectionTypeList.map((collectionType) => CollectionInfo(name: collectionType.name, docsName: collectionType.metadata![docsNameKey] as String)).toList();
  }

  @override
  Future<CollectionInfo> renameCollection(String collectionName, String newDocsName) async {
    Collection collection = await client.getCollection(name: collectionName, embeddingFunction: embeddingFunction);
    Map<String, dynamic> metadata = Map<String, dynamic>.from(collection.metadata!);
    metadata[docsNameKey] = newDocsName;
    await collection.modify(name: collectionName, metadata: metadata);
    return CollectionInfo(name: collectionName, docsName: newDocsName);
  }

  @override
  Future<String> insertSegment(String collectionName, Segment segment, int? index) async {
    String segmentId = Uuid().v4();
    Collection collection = await client.getCollection(name: collectionName, embeddingFunction: embeddingFunction);
    collection.add(ids: [segmentId], documents: [segment.text], metadatas: [segment.metadata]);
    List<String> segmentIdOrder = jsonDecode(collection.metadata![segmentIdOrderKey]);
    if(index == null || index >= segmentIdOrder.length) {
      segmentIdOrder.add(segmentId);
    } else {
      segmentIdOrder.insert(index, segmentId);
    }
    return segmentId;
  }

  @override
  Future<void> updateSegment(String collectionName, SegmentInfo segmentInfo) async {
    Collection collection = await client.getCollection(name: collectionName, embeddingFunction: embeddingFunction);
    collection.update(
      ids: [segmentInfo.id],
      documents: [segmentInfo.text],
      metadatas: [segmentInfo.metadata]
    );
  }

  @override
  Future<void> deleteSegment(String collectionName, String segmentId) async {
    Collection collection = await client.getCollection(name: collectionName, embeddingFunction: embeddingFunction);
    await collection.delete(ids: [segmentId]);
  }

  @override
  Future<CollectionResult?> listSegments(String collectionName) async {
    Collection collection = await client.getCollection(name: collectionName, embeddingFunction: embeddingFunction);
    String segmentIdOrderString = collection.metadata![segmentIdOrderKey];
    List<String> segmentIdOrder = List<String>.from(jsonDecode(segmentIdOrderString));
    GetResponse getResponse = await collection.get();

    if(getResponse.documents == null) return null;

    // Build segmentId-indexId Map, for fetching indexId quickly
    List<String> idList = getResponse.ids;
    Map<String, int> idMap = {};
    for(int i=0; i< idList.length; i++) {
      String id = idList[i];
      idMap[id] = i;
    }

    List<SegmentInfo> segmentList = [];
    for (String segmentId in segmentIdOrder) {
      int i = idMap[segmentId]!;  // fetch indexId quickly
      SegmentInfo segment = SegmentInfo(id: getResponse.ids[i], text: getResponse.documents![i]!, metadata: (getResponse.metadatas?[i] == null)?{}:getResponse.metadatas![i]!);
      segmentList.add(segment);
    }

    return CollectionResult(name: collectionName, docsName: collection.metadata![docsNameKey], segmentList: segmentList);
  }

  @override
  Future<List<List<QuerySegmentResult>>> query(String collectionName, List<String> queryTexts, { int nResults = 2 }) async {
    Collection collection = await client.getCollection(name: collectionName, embeddingFunction: embeddingFunction);

    QueryResponse queryResponse = await collection.query(queryTexts: queryTexts, nResults: nResults );

    List<List<QuerySegmentResult>> segmentResultListList = [];

    for(int i=0; i< queryTexts.length; i++) {
      List<QuerySegmentResult> segmentResultList = [];

      for(int j=0; j< queryResponse.ids[i].length; j++) {
        QuerySegmentResult segmentResult = QuerySegmentResult(
            id: queryResponse.ids[i][j],
            text: queryResponse.documents![i][j]!,
            metadata: queryResponse.metadatas?[i][j]==null?{}:queryResponse.metadatas![i][j]!,
            distance: queryResponse.distances![i][j]
        );
        segmentResultList.add(segmentResult);
      }
      segmentResultListList.add(segmentResultList);
    }
    return segmentResultListList;
  }
  
}
