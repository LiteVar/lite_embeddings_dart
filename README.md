# Lite Embeddings for Dart

English · [中文](README-zh_CN.md)

LLM Embedding tool for Dart

- Support Vector Database: Chroma
- Support file type：pure text, include `Markdown`、`TXT`

## Usage

### Prepare

1. Docs file, according to `/example/docs/*.md`
2. `Separator` in the file
    - If `markdown` file, recommend to use `<!--SEPARATOR-->` as separator, for NOT show it in `markdown` after rendering
3. Add `.env` file in the `example` folder, and add below content in the `.env` file：
     ```properties
     baseUrl = https://xxx.xxx.com         # LLM API BaseURL
     apiKey = sk-xxxxxxxxxxxxxxxxxxxx      # LLM API ApiKey
     ```
4. Use below method to run embeddings service.

### EmbeddingsService
-  According to `/example/lite_embeddings_dart_example.dart`

```dart
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
  CreateDocsTextDto createDocsTextDto = CreateDocsTextDto(docsName: fileName, text: fileText, separator: separator, metadata: {"vdb": "chroma", "embeddings_model": embeddingsModel});
  DocsInfoDto docsInfoDto = await embeddingsService.createDocsByText(createDocsTextDto);
  print("docsInfoDto: ${docsInfoDto.toJson()}");

  /// List Segments
  String docsId = "<FROM DocsInfoDto>";
  DocsIdDto docsIdDto = DocsIdDto(docsId: docsId);
  DocsFullInfoDto? docsFullInfoDto = await embeddingsService.listSegments(docsIdDto);
  print("docsFullInfoDto: ${jsonEncode(docsFullInfoDto?.toJson())}");

  /// Query
  String questText = "Who is author?";
  QueryDto queryDto = QueryDto(docsId: docsId, queryText: questText, nResults: 3);
  QueryResultDto queryResultDto = await embeddingsService.query(queryDto);
  print("queryResultDto: ${jsonEncode(queryResultDto)}");

  /// Update Segment
  SegmentInfoDto segmentInfoDto = SegmentInfoDto(id: segmentId, text: newText, metadata: metadata);
  UpdateSegmentDto updateSegmentDto = UpdateSegmentDto(docsId: docsId, segment: segmentInfoDto);
  await embeddingsService.updateSegment(updateSegmentDto);

  /// Insert Segment
  SegmentDto segmentDto = SegmentDto(text: newText, metadata: metadata);
  InsertSegmentDto insertSegmentDto = InsertSegmentDto(docsId: docsId, segment: segmentDto, index: 2);
  await embeddingsService.insertSegment(insertSegmentDto);

  /// Delete Segment
  DeleteSegmentDto deleteSegmentDto = DeleteSegmentDto(docsId: docsId, id: segmentId);
  await embeddingsService.deleteSegment(deleteSegmentDto);

  /// Rename Docs
  DocsInfoDto docsInfoDto = DocsInfoDto(docsId: docsId, docsName: newDocsName);
  DocsInfoDto docsInfoDtoResult = await embeddingsService.renameDocs(docsInfoDto);

  /// Delete Docs
  DocsIdDto docsIdDto = DocsIdDto(docsId: docsId);
  await embeddingsService.deleteDocs(docsIdDto);

  embeddingsService.dispose();
}
```