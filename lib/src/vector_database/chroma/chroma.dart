import 'dart:convert';

import 'package:chromadb/chromadb.dart';
import 'package:lite_embeddings_dart/lite_embeddings.dart';
import '../../service/exception.dart';
import 'package:uuid/uuid.dart';
import '../vector_database.dart';
import '../../model.dart';

class Chroma extends VectorDatabase {

  static final String segmentIdOrderKey = "segmentIdOrder";
  static final String docsNameKey = "docsName";
  static final String vdbKey = "vdb";
  static final String vdbValue = "chroma";
  static final String embeddingsModelKey = "embeddings_model";
  static final String customKey = "custom";

  late ChromaClient client;
  late String baseUrl;
  Chroma({this.baseUrl = "http://localhost:8000"});
  
  @override
  Future<void> connect() async => client = ChromaClient(baseUrl: baseUrl);

  @override
  Future<void> disconnect() async {}

  @override
  Future<CollectionInfo> createCollection(String docsName, List<Segment> segmentList, LLMSettings llmSettings) async {
    List<String> idList = [];
    List<String> documents = [];
    List<Map<String, dynamic>> metadataList = [];
    int size = segmentList.length;
    Uuid uuid = Uuid();
    String docsIdAsName = uuid.v4();

    for(int i=0; i< size; i++) {
      idList.add(uuid.v4());
      documents.add(segmentList[i].text);

      Map<String, dynamic> systemMetadata = {vdbKey: vdbValue, embeddingsModelKey: llmSettings.llmConfig.model};
      Map<String, dynamic> segmentMetadata = _convertToSegmentMetadata(systemMetadata, segmentList[i].metadata);

      metadataList.add(segmentMetadata);
    }

    Map<String, dynamic> collectionMetadata = {};
    collectionMetadata[segmentIdOrderKey] = jsonEncode(idList);
    collectionMetadata[docsNameKey] = docsName;

    EmbeddingFunction embeddingFunction = OpenAIEmbeddingFunction(llmConfig: llmSettings.llmConfig, listen: llmSettings.listenToken);

    try {
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
    } on ChromaApiClientException catch(e) {
      VectorDatabaseException vdbException = VectorDatabaseException(
          code: e.code??500,
          message: e.message + ": " + (e.body is String ? (e.body as String) : e.body.toString())
      );
      throw vdbException;
    }

    return CollectionInfo(name: docsIdAsName, docsName: docsName);
  }

  Map<String, dynamic> _convertToSegmentMetadata(Map<String, dynamic> systemMetadata, Map<String, dynamic>? customMetadata) {
    Map<String, dynamic> segmentMetadata = Map<String, dynamic>.from(systemMetadata);
    if(customMetadata != null) {
      String customMetadataString = jsonEncode(customMetadata);
      segmentMetadata[customKey] = customMetadataString;
    }
    return segmentMetadata;
  }

  @override
  Future<void> deleteCollection(String collectionName) async {
    try {
      await client.deleteCollection(name: collectionName);
    } on ChromaApiClientException catch(e) {
      VectorDatabaseException vdbException = VectorDatabaseException(
          code: e.code??500,
          message: e.message + ": " + (e.body is String ? (e.body as String) : e.body.toString())
      );
      throw vdbException;
    }
  }

  @override
  Future<List<CollectionInfo>> listCollections() async {
    List<CollectionType> collectionTypeList = await client.listCollections();
    return collectionTypeList.map((collectionType) => CollectionInfo(name: collectionType.name, docsName: collectionType.metadata![docsNameKey] as String)).toList();
  }

  @override
  Future<CollectionInfo> renameCollection(String collectionName, String newDocsName) async {
    Collection collection = await client.getCollection(name: collectionName);
    Map<String, dynamic> metadata = Map<String, dynamic>.from(collection.metadata!);
    metadata[docsNameKey] = newDocsName;
    await collection.modify(name: collectionName, metadata: metadata);
    return CollectionInfo(name: collectionName, docsName: newDocsName);
  }

  @override
  Future<String> insertSegment(String collectionName, Segment segment, int? index, LLMSettings llmSettings) async {
    try {
      String segmentId = Uuid().v4();
      EmbeddingFunction embeddingFunction = OpenAIEmbeddingFunction(llmConfig: llmSettings.llmConfig, listen: llmSettings.listenToken);
      Collection collection = await client.getCollection(name: collectionName, embeddingFunction: embeddingFunction);

      Map<String, dynamic> systemMetadata = {vdbKey: vdbValue, embeddingsModelKey: llmSettings.llmConfig.model};
      Map<String, dynamic> segmentMetadata = _convertToSegmentMetadata(systemMetadata, segment.metadata);

      collection.add(ids: [segmentId], documents: [segment.text], metadatas: [segmentMetadata]);

      Map<String, dynamic> docsMetadata = Map<String, dynamic>.from(collection.metadata!);

      List<String> segmentIdOrder = (jsonDecode(docsMetadata[segmentIdOrderKey])  as List<dynamic>).map((segmentId)=> (segmentId as String)).toList();
      if(index == null || index >= segmentIdOrder.length) {
        segmentIdOrder.add(segmentId);
      } else {
        segmentIdOrder.insert(index, segmentId);
      }

      docsMetadata[segmentIdOrderKey] = jsonEncode(segmentIdOrder);
      await collection.modify(name: collectionName, metadata: docsMetadata);

      return segmentId;
    } on ChromaApiClientException catch(e) {
      VectorDatabaseException vdbException = VectorDatabaseException(
          code: e.code??500,
          message: e.message + ": " + (e.body is String ? (e.body as String) : e.body.toString())
      );
      throw vdbException;
    }
  }

  @override
  Future<void> updateSegment(String collectionName, SegmentInfo segmentInfo, LLMSettings llmSettings) async {
    EmbeddingFunction embeddingFunction = OpenAIEmbeddingFunction(llmConfig: llmSettings.llmConfig, listen: llmSettings.listenToken);
    try {
      Collection collection = await client.getCollection(name: collectionName, embeddingFunction: embeddingFunction);

      GetResponse getResponse = await collection.get(ids: [segmentInfo.id]);
      bool isTextUpdate = (getResponse.documents![0] != segmentInfo.text);
      bool isCustomMetadataNull = (segmentInfo.metadata == null);

      if(isTextUpdate && isCustomMetadataNull) {
        collection.update(
            ids: [segmentInfo.id],
            documents: [segmentInfo.text]
        );
      } else if(isTextUpdate && !isCustomMetadataNull) {
        Map<String, dynamic> metadata = getResponse.metadatas![0]!;
        metadata[customKey] = _updateCustomMetadataString(metadata[customKey]==null?"{}":metadata[customKey], segmentInfo.metadata!);
        collection.update(
            ids: [segmentInfo.id],
            documents: [segmentInfo.text],
            metadatas: [metadata]
        );
      } else if(!isTextUpdate && !isCustomMetadataNull) {
        Map<String, dynamic> metadata = getResponse.metadatas![0]!;
        metadata[customKey] = _updateCustomMetadataString(metadata[customKey]==null?"{}":metadata[customKey], segmentInfo.metadata!);
        List<double> embeddings = getResponse.embeddings![0];
        collection.update(
            ids: [segmentInfo.id],
            embeddings: [embeddings],
            metadatas: [metadata]
        );
        llmSettings.listenToken(TokenUsage(promptToken: 0, totalToken: 0));
      } else {
        llmSettings.listenToken(TokenUsage(promptToken: 0, totalToken: 0));
        // if(!isTextUpdate && isCustomMetadataNull) DO NOTHING
      }

    } on ChromaApiClientException catch(e) {
      VectorDatabaseException vdbException = VectorDatabaseException(
          code: e.code??500,
          message: e.message + ": " + (e.body is String ? (e.body as String) : e.body.toString())
      );
      throw vdbException;
    }
  }

  String _updateCustomMetadataString(String oldCustomMetadataString, Map<String, dynamic> addCustomMetadata) {
    if(addCustomMetadata.isEmpty) {
      return "{}";  //if addCustomMetadata == {}, remove customMetadata
    } else {
      Map<String, dynamic> oldCustomMetadata = jsonDecode(oldCustomMetadataString) as Map<String, dynamic>;
      Map<String, dynamic> segmentMetadata = Map<String, dynamic>.from(oldCustomMetadata);
      segmentMetadata.addAll(addCustomMetadata);
      return jsonEncode(segmentMetadata);
    }
  }

  @override
  Future<void> deleteSegment(String collectionName, String segmentId) async {
    try {
      Collection collection = await client.getCollection(name: collectionName);//, embeddingFunction: embeddingFunction);
      await collection.delete(ids: [segmentId]);

      Map<String, dynamic> metadata = Map<String, dynamic>.from(collection.metadata!);
      List<String> segmentIdOrder = (jsonDecode(metadata[segmentIdOrderKey]) as List<dynamic>).map((segmentId)=> (segmentId as String)).toList();
      segmentIdOrder.remove(segmentId);
      metadata[segmentIdOrderKey] = jsonEncode(segmentIdOrder);
      await collection.modify(name: collectionName, metadata: metadata);
    } on ChromaApiClientException catch(e) {
      VectorDatabaseException vdbException = VectorDatabaseException(
          code: e.code??500,
          message: e.message + ": " + (e.body is String ? (e.body as String) : e.body.toString())
      );
      throw vdbException;
    }
  }

  @override
  Future<CollectionResult?> listSegments(String collectionName) async {
    try {
      Collection collection = await client.getCollection(name: collectionName);//, embeddingFunction: embeddingFunction);
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

        SegmentInfo segment = SegmentInfo(
          id: getResponse.ids[i],
          text: getResponse.documents![i]!,
          metadata: (getResponse.metadatas?[i] == null)?{}:_convertToFlatMetadata(getResponse.metadatas![i]!)
        );
        segmentList.add(segment);
      }

      return CollectionResult(name: collectionName, docsName: collection.metadata![docsNameKey], segmentList: segmentList);
    } on ChromaApiClientException catch(e) {
      VectorDatabaseException vdbException = VectorDatabaseException(
          code: e.code??500,
          message: e.message + ": " + (e.body is String ? (e.body as String) : e.body.toString())
      );
      throw vdbException;
    }
  }

  Map<String, dynamic> _convertToFlatMetadata(Map<String, dynamic> metadata) {
    Map<String, dynamic> flatMetadata = {};
    flatMetadata[vdbKey] = metadata[vdbKey];
    flatMetadata[embeddingsModelKey] = metadata[embeddingsModelKey];
    String customMetadataString = metadata[customKey]??"{}";
    Map<String, dynamic> customMetadata = jsonDecode(customMetadataString) as Map<String, dynamic>;
    flatMetadata.addAll(customMetadata);
    return flatMetadata;
  }

  @override
  Future<List<List<QuerySegmentResult>>> query(String collectionName, List<String> queryTexts, LLMSettings llmSettings, { int nResults = 2 }) async {
    EmbeddingFunction embeddingFunction = OpenAIEmbeddingFunction(llmConfig: llmSettings.llmConfig, listen: llmSettings.listenToken);
    List<List<QuerySegmentResult>> segmentResultListList = [];
    try {
      Collection collection = await client.getCollection(name: collectionName, embeddingFunction: embeddingFunction);
      QueryResponse queryResponse = await collection.query(queryTexts: queryTexts, nResults: nResults );

      for(int i=0; i< queryTexts.length; i++) {
        List<QuerySegmentResult> segmentResultList = [];

        for(int j=0; j< queryResponse.ids[i].length; j++) {
          QuerySegmentResult segmentResult = QuerySegmentResult(
              id: queryResponse.ids[i][j],
              text: queryResponse.documents![i][j]!,
              metadata: queryResponse.metadatas?[i][j]==null?{}:_convertToFlatMetadata(queryResponse.metadatas![i][j]!),
              distance: queryResponse.distances![i][j]
          );
          segmentResultList.add(segmentResult);
        }
        segmentResultListList.add(segmentResultList);
      }
    } on ChromaApiClientException catch(e) {
      VectorDatabaseException vdbException = VectorDatabaseException(
        code: e.code??500,
        message: e.message + ": " + (e.body is String ? (e.body as String) : e.body.toString())
      );
      throw vdbException;
    }
    return segmentResultListList;
  }

  Future<List<MultiDocsQuerySegment>> multiQuery(List<String> collectionNameList, String queryText, LLMSettings llmSettings, { int nResults = 2, bool removeDuplicates = true}) async {
    EmbeddingFunction embeddingFunction = OpenAIEmbeddingFunction(llmConfig: llmSettings.llmConfig, listen: llmSettings.listenToken);
    List<List<double>> queryEmbeddings = await embeddingFunction.generate([Embeddable.document(queryText)]);
    List<MultiDocsQuerySegment> multiDocsQuerySegmentList = [];
    for(String collectionName in collectionNameList) {
      try {
        Collection collection = await client.getCollection(name: collectionName);
        QueryResponse queryResponse = await collection.query(
            queryEmbeddings: queryEmbeddings, nResults: nResults);
        for (int i = 0; i < queryResponse.ids[0].length; i++) {
          QuerySegmentResult querySegmentResult = QuerySegmentResult(
              id: queryResponse.ids[0][i],
              text: queryResponse.documents![0][i]!,
              metadata: queryResponse.metadatas?[0][i] == null
                  ? {}
                  : _convertToFlatMetadata(queryResponse.metadatas![0][i]!),
              distance: queryResponse.distances![0][i]
          );
          MultiDocsQuerySegment multiDocsQuerySegment = MultiDocsQuerySegment(docsId: collectionName, querySegmentResult: querySegmentResult);
          multiDocsQuerySegmentList.add(multiDocsQuerySegment);
        }
      } on ChromaApiClientException catch(e) {
        VectorDatabaseException vdbException = VectorDatabaseException(
            code: e.code??500,
            message: e.message + ": " + (e.body is String ? (e.body as String) : e.body.toString())
        );
        throw vdbException;
      }
    }

    if(removeDuplicates) {
      Set<String> distanceSet = {};
      multiDocsQuerySegmentList.retainWhere((multiDocsQuerySegment) => distanceSet.add(multiDocsQuerySegment.querySegmentResult.text));
    }

    multiDocsQuerySegmentList.sort((a, b) => a.querySegmentResult.distance.compareTo(b.querySegmentResult.distance));
    if(multiDocsQuerySegmentList.length > nResults) {
      multiDocsQuerySegmentList.length = nResults;
    }

    return multiDocsQuerySegmentList;
  }
  
}
