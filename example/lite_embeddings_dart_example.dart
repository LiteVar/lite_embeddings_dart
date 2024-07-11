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

  /// List All Docs
  List<DocsInfoDto> docsInfoDtoList = await embeddingsService.listDocs();
  print("docsNameDtoList: ${jsonEncode(docsInfoDtoList)}");

  /// Create New Docs
  // CreateDocsTextDto createDocsTextDto = CreateDocsTextDto(docsName: fileName, text: fileText, separator: separator, metadata: {"vdb": "chroma", "embeddings_model": embeddingsModel});
  // DocsInfoDto docsInfoDto = await embeddingsService.createDocsByText(createDocsTextDto);
  // print("docsInfoDto: ${docsInfoDto.toJson()}");

  /// List Segments
  // String docsId = "<FROM DocsInfoDto>";
  // DocsIdDto docsIdDto = DocsIdDto(docsId: docsId);
  // DocumentInfoDto? documentInfoDto = await embeddingsService.listSegments(docsIdDto);
  // print("documentInfoDto: ${jsonEncode(documentInfoDto?.toJson())}");

  /// Query
  // String questText = "Who is author?";
  // QueryDto queryDto = QueryDto(docsId: docsId, queryText: questText, nResults: 3);
  // QueryResultDto queryResultDto = await embeddingsService.query(queryDto);
  // print("queryResultDto: ${jsonEncode(queryResultDto)}");

  /// Update Segment
  // SegmentInfoDto segmentInfoDto = SegmentInfoDto(id: segmentId, text: newText, metadata: metadata);
  // UpdateSegmentDto updateSegmentDto = UpdateSegmentDto(docsId: docsId, segment: segmentInfoDto);
  // await embeddingsService.updateSegment(updateSegmentDto);

  /// Insert Segment
  // SegmentDto segmentDto = SegmentDto(text: newText, metadata: metadata);
  // InsertSegmentDto insertSegmentDto = InsertSegmentDto(docsId: docsId, segment: segmentDto, index: 2);
  // await embeddingsService.insertSegment(insertSegmentDto);

  /// Delete Segment
  // DeleteSegmentDto deleteSegmentDto = DeleteSegmentDto(docsId: docsId, id: segmentId);
  // await embeddingsService.deleteSegment(deleteSegmentDto);

  /// Rename Docs
  // DocsInfoDto docsInfoDto = DocsInfoDto(docsId: docsId, docsName: newDocsName);
  // DocsInfoDto docsInfoDtoResult = await embeddingsService.renameDocs(docsInfoDto);

  /// Delete Docs
  // DocsIdDto docsIdDto = DocsIdDto(docsId: docsId);
  // await embeddingsService.deleteDocs(docsIdDto);

  embeddingsService.dispose();
}

EmbeddingsService _buildService() {
  LLMConfig llmConfig = _buildLLMConfigDto().toModel();
  OpenAIEmbeddingFunction openAIEmbeddingFunction = OpenAIEmbeddingFunction(llmConfig: llmConfig, listen: listenTokenUsage);
  EmbeddingsService embeddingsService = EmbeddingsService(Chroma(openAIEmbeddingFunction, baseUrl: "http://localhost:8000"));
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

void listenTokenUsage(TokenUsage tokenUsage) {
  print(TokenUsageDto.fromModel(tokenUsage).toJson());
}

/// [DANGEROUS] RESET whole chroma database
void reset() {
  ChromaClient client = ChromaClient();
  client.reset();
}