import 'package:chromadb/chromadb.dart';
import 'package:dart_openai/dart_openai.dart';
import '../../model.dart';

class OpenAIEmbeddingFunction implements EmbeddingFunction {

  LLMConfig llmConfig;

  OpenAIEmbeddingFunction({ required this.llmConfig, void Function(TokenUsage)? listen}) {
    if(listen != null) addUsageListener(listen);
  }

  final List<Function> _listenerList = [];

  @override
  Future<List<List<double>>> generate(List<Embeddable> input) async {
    List<String> docs = _toDocs(input);
    List<List<double>> embeddings = await _toEmbeddings(docs);
    return embeddings;
  }

  List<String> _toDocs(List<Embeddable> input) {
    List<String> docs = [];
    for (var embeddable in input) {
      if(embeddable.runtimeType == EmbeddableDocument) {
        String doc = (embeddable as EmbeddableDocument).document;
        docs.add(doc);
      }
    }
    return docs;
  }

  Future<List<List<double>>> _toEmbeddings(List<String> docs) async {
    OpenAI.baseUrl = llmConfig.baseUrl;
    OpenAI.apiKey = llmConfig.apiKey;
    OpenAIEmbeddingsModel embedding = await OpenAI.instance.embedding.create(
      model: llmConfig.model,
      input: docs,
    );

    OpenAIEmbeddingsUsageModel? usage = embedding.usage;
    if(usage != null && usage.promptTokens != null && usage.totalTokens != null) {
      TokenUsage tokenUsage = TokenUsage(promptToken: usage.promptTokens!, totalToken: usage.totalTokens!);
      pushTokenUsage(tokenUsage);
    }

    return embedding.data.map((embeddingsData) => embeddingsData.embeddings).toList();
  }

  void pushTokenUsage(TokenUsage tokenUsage) {
    for (var tokenUsageListener in _listenerList) {
      tokenUsageListener(tokenUsage);
    }
  }

  void addUsageListener(void Function(TokenUsage) listen) {
    _listenerList.add(listen);
  }

}