import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class FlowiseGroup {
  static String getBaseUrl({
    String? question = '',
    String? sessionId = '',
  }) {
    print('DEBUG: getBaseUrl called with question: $question, sessionId: $sessionId');
    return "http://localhost:3000/api/v1/prediction";
  }

  static Map<String, String> headers = {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*", // This is important for CORS
    "Access-Control-Allow-Methods": "POST, GET, OPTIONS", // Allowed methods
    "Access-Control-Allow-Headers": "Content-Type, Authorization",
  };

  static AskquestionCall askquestionCall = AskquestionCall();
  static VoiceChatCall voiceChatCall = VoiceChatCall();
  static ImageChatCall imageChatCall = ImageChatCall();

  static Future<void> testFlowiseConnectivity() async {
    final url = 'http://localhost:3000/api/v1/prediction/bbabe584-9d1e-4d63-9500-f59055d11c0f';
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      print('Flowise connectivity test status code: ${response.statusCode}');
      print('Flowise connectivity test body: ${response.body.substring(0, 100)}...'); // Print first 100 characters
    } catch (e) {
      print('Error in Flowise connectivity test: $e');
    }
  }
}

class AskquestionCall {
  Future<ApiCallResponse> call({
    String? question = '',
    String? sessionId = '',
  }) async {
    print('DEBUG: AskquestionCall.call() started');

    // Run connectivity test before making the API call
    await FlowiseGroup.testFlowiseConnectivity();

    final baseUrl = FlowiseGroup.getBaseUrl(
      question: question,
      sessionId: sessionId,
    );

    final ffApiRequestBody = '''
{
  "question": "$question",
  "overrideConfig": {
    "sessionId": "$sessionId"
  }
}''';
    print('DEBUG: API request body: $ffApiRequestBody');

    try {
      final response = await ApiManager.instance.makeApiCall(
        callName: 'askquestion',
        apiUrl: '$baseUrl/bbabe584-9d1e-4d63-9500-f59055d11c0f',
        callType: ApiCallType.POST,
        headers: FlowiseGroup.headers, // Add headers here
        params: {},
        body: ffApiRequestBody,
        bodyType: BodyType.JSON,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        cache: false,
        isStreamingApi: false,
        alwaysAllowBody: false,
      );
      print('DEBUG: API call completed. Response: ${response.jsonBody}');
      return response;
    } catch (e, stackTrace) {
      print('DEBUG: Exception in API call: $e');
      print('DEBUG: Stack trace: $stackTrace');
      rethrow;
    }
  }

  String? response(dynamic response) {
    print('DEBUG: Parsing response: $response');
    final result = castToType<String>(getJsonField(
      response,
      r'''$.text''',
    ));
    print('DEBUG: Parsed result: $result');
    return result;
  }

  String? sessionId(dynamic response) {
    print('DEBUG: Parsing sessionId from response: $response');
    final result = castToType<String>(getJsonField(
      response,
      r'''$.sessionId''',
    ));
    print('DEBUG: Parsed sessionId: $result');
    return result;
  }
}

class VoiceChatCall {
  Future<ApiCallResponse> call({
    String? data = '',
    String? type = 'audio',
    String? question = '',
    String? sessionId = '',
  }) async {
    final baseUrl = FlowiseGroup.getBaseUrl(
      question: question,
      sessionId: sessionId,
    );

    final ffApiRequestBody = '''
{
  "overrideConfig": {
    "sessionId": "$sessionId"
  },
  "uploads": [
    {
      "data": "data:audio/webm;codecs=opus;base64,$data",
      "type": "audio",
      "name": "audio.wav",
      "mime": "audio/webm"
    }
  ]
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'VoiceChat',
      apiUrl: '$baseUrl/bbabe584-9d1e-4d63-9500-f59055d11c0f',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ImageChatCall {
  Future<ApiCallResponse> call({
    String? imgUrl = '',
    String? question = '',
    String? sessionId = '',
  }) async {
    final baseUrl = FlowiseGroup.getBaseUrl(
      question: question,
      sessionId: sessionId,
    );

    final ffApiRequestBody = '''
{
  "question": "$question",
  "overrideConfig": {
    "sessionId": "$sessionId"
  },
  "uploads": [
    {
      "data": "data:image/png;base64,$imgUrl",
      "name": "Flowise.png",
      "mime": "image/png",
      "type": "url"
    }
  ]
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'ImageChat',
      apiUrl: '$baseUrl/bbabe584-9d1e-4d63-9500-f59055d11c0f',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class FlowiseCombatCall {
  static Future<ApiCallResponse> call({
    String? question = '',
    String? namespace = '',
  }) async {
    final ffApiRequestBody = '''
{
  "question": "$question"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'flowiseCombat',
      apiUrl:
          "http://localhost:3000/api/v1/prediction/bbabe584-9d1e-4d63-9500-f59055d11c0f",
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer tkWSaFpLtEaPlPCmpY9fXsSGBlzWEw1go9nOAE8TgU4',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: true,
      alwaysAllowBody: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}