import 'dart:convert';
import 'dart:io';
import 'package:chromadb/chromadb.dart';
import 'package:lite_embeddings_dart/lite_embeddings.dart';
import 'package:dotenv/dotenv.dart';

EmbeddingsService embeddingsService = _buildService();
final String embeddingsModel = "text-embedding-ada-002";

Future<void> main() async {
  embeddingsService.init();

  String fileName = "Moore's Law for Everything.md";
  String fileText = await _buildDocsText(fileName);
  String separator = "<!--SEPARATOR-->";

  print("fileName: $fileName, fileTextSize: ${fileText.length}, separator: $separator");

  LLMConfigDto llmConfigDto = _buildLLMConfigDto();

  /// List All Docs
  List<DocsInfoDto> docsInfoDtoList = await embeddingsService.listDocs();
  print("docsNameDtoList: ${jsonEncode(docsInfoDtoList)}");

  /// Create New Docs
  CreateDocsTextRequestDto createDocsTextDto = CreateDocsTextRequestDto(docsName: fileName, text: fileText, separator: separator, llmConfig: llmConfigDto);
  CreateDocsResultDto createDocsResultDto = await embeddingsService.createDocsByText(createDocsTextDto);
  print("docsInfoDto: ${createDocsResultDto.toJson()}");

  /// List Segments
  String docsId = "<FROM DocsInfoDto>";
  DocsIdDto docsIdDto = DocsIdDto(docsId: docsId);
  DocsFullInfoDto? documentInfoDto = await embeddingsService.listSegments(docsIdDto);
  print("documentInfoDto: ${jsonEncode(documentInfoDto?.toJson())}");

  /// Query
  // String queryText = "Who is author?";
  // QueryRequestDto queryRequestDto = QueryRequestDto(docsId: docsId, queryText: queryText, nResults: 3, llmConfig: llmConfigDto);
  // QueryResultDto queryResultDto = await embeddingsService.query(queryRequestDto);
  // print("queryResultDto: ${jsonEncode(queryResultDto.toJson())}");

  /// MultiQuery: Multi Docs query
  // String queryText = "Who is author?";
  // List<String> docsIdList = ["xxx", "yyy", "zzz"];
  // MultiDocsQueryRequestDto multiDocsQueryRequestDto = MultiDocsQueryRequestDto(docsIdList: docsIdList, queryText: queryText, llmConfig: llmConfigDto);
  // MultiDocsQueryResultDto multiDocsQueryResultDto = await embeddingsService.multiDocsQuery(multiDocsQueryRequestDto);
  // print("multiDocsQueryResultDto: ${jsonEncode(multiDocsQueryResultDto.toJson())}");

  /// Update Segment
  // SegmentInfoDto segmentInfoDto = SegmentInfoDto(segmentId: segmentId, text: newText, metadata: metadata);
  // UpdateSegmentDto updateSegmentDto = UpdateSegmentDto(docsId: docsId, segment: segmentInfoDto, llmConfig: llmConfigDto);
  // SegmentUpsertResultDto segmentUpdateResultDto = await embeddingsService.updateSegment(updateSegmentDto);
  // print("segmentUpdateResultDto: ${jsonEncode(segmentUpdateResultDto.toJson())}");

  /// Insert Segment
  // SegmentDto segmentDto = SegmentDto(text: newText, metadata: metadata);
  // InsertSegmentDto insertSegmentDto = InsertSegmentDto(docsId: docsId, segment: segmentDto, index: 2, llmConfig: llmConfigDto);
  // SegmentUpsertResultDto segmentInsertResultDto = await embeddingsService.insertSegment(insertSegmentDto);
  // print("segmentInsertResultDto: ${jsonEncode(segmentInsertResultDto.toJson())}");

  /// Delete Segment
  // DeleteSegmentDto deleteSegmentDto = DeleteSegmentDto(docsId: docsId, segmentId: segmentId);
  // SegmentIdDto segmentIdDto = await embeddingsService.deleteSegment(deleteSegmentDto);
  // print("segmentIdDto: ${jsonEncode(segmentIdDto.toJson())}");

  /// Rename Docs
  // DocsInfoDto docsInfoDto = DocsInfoDto(docsId: docsId, docsName: newDocsName);
  // DocsInfoDto renameResult = await embeddingsService.renameDocs(docsInfoDto);
  // print("renameResult: ${jsonEncode(renameResult.toJson())}");

  /// Delete Docs
  // DocsIdDto docsIdDto = DocsIdDto(docsId: docsId);
  // await embeddingsService.deleteDocs(docsIdDto);

  embeddingsService.dispose();
}

EmbeddingsService _buildService() {
  EmbeddingsService embeddingsService = EmbeddingsService(Chroma(baseUrl: "http://localhost:8000"));
  return embeddingsService;
}

LLMConfigDto _buildLLMConfigDto() {
  DotEnv env = DotEnv();
  env.load(['example/.env']);
  LLMConfigDto llmConfigDto = LLMConfigDto(
    baseUrl: env["baseUrl"]!,
    apiKey: env["apiKey"]!,
    model: embeddingsModel,
  );
  return llmConfigDto;
}

Future<String> _buildDocsText(String docsName) async {
  String folder = "${Directory.current.path}${Platform.pathSeparator}example${Platform.pathSeparator}docs";
  File file = File(folder + Platform.pathSeparator + docsName);
  String docsString = await file.readAsString();
  return docsString;
}

/// [DANGEROUS] RESET whole chroma database
void reset() {
  ChromaClient client = ChromaClient();
  client.reset();
}