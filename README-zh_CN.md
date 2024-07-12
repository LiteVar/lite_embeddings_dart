# Lite Embeddings for Dart

[English](README.md) · 中文

大模型嵌入工具服务

- 支持的向量数据库: Chroma
- 支持的类型：纯文本，包括`Markdown`、`TXT`

## 使用

### 准备

1. 准备文本文档，可参照 `/example/docs/*.md` 作为样例
2. 文档内具备`分隔符`
    - 如果是`markdown`文档，推荐采用`<!--分隔符-->`作为分隔符，不影响`markdown`渲染后的展示效果
3. 如果需要运行example，在 `example` 文件夹增加 `.env` 文件，并且`.env`文件需要增加如下内容：
     ```properties
     baseUrl = https://xxx.xxx.com         # 大模型接口的BaseURL
     apiKey = sk-xxxxxxxxxxxxxxxxxxxx      # 大模型接口的ApiKey
     ```
4. 使用下方的方法运行Embeddings服务

### 使用EmbeddingsService
- 例子：`/example/lite_embeddings_dart_example.dart`

```dart
Future<void> main() async {
  embeddingsService.init();

  String fileName = "摩尔定律适用于一切.md";
  String fileText = await _buildDocsText(fileName);
  String separator = "<!--分隔符-->";

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
  String questText = "作者意识到什么？";
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
