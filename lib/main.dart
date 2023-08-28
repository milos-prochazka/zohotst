// ignore_for_file: constant_identifier_names, camel_case_types

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() 
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget 
{
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp
    (
      title: 'Flutter Demo',
      theme: ThemeData
      (
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget 
{
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> 
{
  int _counter = 0;

  void _incrementCounter() 
  {
    setState
    (
      () 
      {
        // This call to setState tells the Flutter framework that something has
        // changed in this State, which causes it to rerun the build method below
        // so that the display can reflect the updated values. If we changed
        // _counter without calling setState(), then the build method would not be
        // called again, and so nothing would appear to happen.
        _counter++;
        test1();
      }
    );
  }

  void test1() async 
  {
    var client = HttpClient();
    try 
    {
      //final url = Uri.parse('https://www.google.com');

      //HttpClientRequest request = await client.getUrl ( url );
      // Optionally set up headers...
      // Optionally write to the request object...
      //HttpClientResponse response = await request.close();
      //
      // Process the response
      //final stringData = await response.transform(const Utf8Decoder(allowMalformed: true)).join();
      //print(stringData);


      const client_id = '1000.IYOMEJWSGDHDEEMZ5Q3251CZMYCH7K';
      const client_secret = 'c7de448c801f0093dc2be8acf45753b3d722387c5b';


        final zoho =
        ZohoClient(clientId: client_id, clientSecret: client_secret, redirectUrl: 'https://abcalc.8u.cz/test');
        String code = await zoho.getOAuthCode(context:context,timeout:const Duration(seconds: 600));

      // Grant token
        String access = await zoho.getAccessToken();
      {

        final user = await zoho.booksGetCurrentUser();

        final org = await zoho.doRequest('https://books.zoho.com/api/v3/organizations');

        final inv = await zoho.doRequest('https://books.zoho.com/api/v3/invoices');

        final items = await zoho.doRequest('https://books.zoho.com/api/v3/items');

        final contacts = await zoho.doRequest('https://books.zoho.com/api/v3/contacts');

        return;

        final cr =
        await zoho.doRequest
        (
          'https://books.zoho.com/api/v3/invoices', requestType: ZohoRequest_Type.POST, jsonData: 
          {
            'customer_id': '4424043000000082003',
            'line_items': 
            [
              {
                //'item_id': '4424043000000085003',
                'rate': 100,
                'quantity': 1,
                'name': 'Toto je nazev',
                'description': 'Toto je popis polozky'
              }
            ]
          }
        );
        final brk = 1;
      }
    } 
    finally 
    {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold
    (
      appBar: AppBar
      (
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center
      (
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column
        (
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>
          [
            const Text
            (
              'You have pushed the button this many times:',
            ),
            Text
            (
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton
      (
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class OAuthWeb extends StatefulWidget 
{
  final String url;
  final Map<String, String>? components;
  final String redirectUrlTest;
  final void Function(String)? onRedirect;

  const OAuthWeb({super.key, required this.url, this.components, required this.redirectUrlTest, this.onRedirect});

  @override
  State<OAuthWeb> createState() => _OAuthWebState();
}

class _OAuthWebState extends State<OAuthWeb> 
{
  WebViewController? _controller;

  @override
  void initState() 
  {
    /*final builder = StringBuffer(widget.url);
    if (widget.components != null)
    {
      builder.write('?');
      builder.writeAll(widget.components!.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}'), '&');
    }*/

    super.initState();

    final uri = buildUri(widget.url, widget.components);

    _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate
    (
      NavigationDelegate
      (
        onProgress: (int progress) 
        {
          // Update loading bar.
        },
        onPageStarted: (String url)
        {
          print ('onPageStarted: $url');
        },
        onPageFinished: (String url) 
        {
          print ('onPageFinished: $url');
        },
        onWebResourceError: (WebResourceError error) 
        {
          print ('onWebResourceError: $error');
        },
        onNavigationRequest: (NavigationRequest request) 
        {
          print(request.url);
          if (request.url.contains(widget.redirectUrlTest)) 
          {
            widget.onRedirect?.call(request.url);
            Navigator.pop(context);
            return NavigationDecision.prevent;
          } 
          else 
          {
            return NavigationDecision.navigate;
          }
        },
      ),
    )
    ..setUserAgent('Mozilla/5.0 (Linux; Android 10; Redmi Note 8 Pro) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.88 Mobile Safari/537.36')
    ..loadRequest(uri, headers: {'Accept': '*/*'});
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar(title: const Text('Flutter Simple Example')),
      body: WebViewWidget(controller: _controller!),
    );
  }
}


Uri buildUri(String url, [Map<String, String>? components]) 
{
  final builder = StringBuffer(url);
  if (components != null) 
  {
    builder.write('?');
    builder.writeAll
    (
      components.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}'), '&'
    );
  }
  return Uri.parse(builder.toString());
}


/// Klient pro Zoho API

class ZohoClient 
{
  /// Client ID - získá se při registraci aplikace
  final String clientId;

  /// Client Secret - získá se při registraci aplikace
  final String clientSecret;

  /// Redirect URL - získá se při registraci aplikace
  final String redirectUrl;

  /// Kód pro získání access tokenu
  String code = '';

  /// Access token
  String accessToken = '';

  /// Výsledek posledního dotazu
  Map<String, dynamic>? lastResponse;

  /// HTTP klient
  final httpClient = HttpClient();

  /// Scope - seznam oprávnění vyžadovaných aplikací
  var scope = <String>{};

  /// Zoho API URL
  String zohoApis = 'https://www.zohoapis.com';

  /// Zoho Accounts URL
  String zohoAccounts = 'https://accounts.zoho.com';

  /// Zoho OAuth URL
  String zohoAuth = '/oauth/v2/auth';

  /// OAuth Completer - slouží pro čekání na získání kódu pomocí WebView
  Completer<String>? oauthCompleter;

  /// Konstruktor
  ZohoClient({required this.clientId, required this.clientSecret, required this.redirectUrl, Set<String>? scope}) 
  {
    if (scope != null) 
    {
      this.scope = scope;
    }
  }

  /// Získání informací o přihlášeném uživateli
  Future<Map> booksGetCurrentUser() => doRequest('$zohoApis/books/v3/users/me');

  /// Provedení dotazu na Zoho API
  /// - [url] - URL dotazu.
  /// - [requestType] - typ dotazu (GET, POST, PUT, DELETE).
  /// - [components] - parametry dotazu.
  /// - [jsonData] - data pro POST a PUT dotazy.
  /// - [return] - výsledek dotazu ve formátu Map (json).
  /// 
  Future<Map> doRequest(String url,
    {ZohoRequest_Type requestType = ZohoRequest_Type.GET, Map<String, String>? components, dynamic jsonData}) async 
  {
    // Přidání scope do parametrů
    final uri = buildUri(url, components);

    // Vytvoření HTTP klienta
    final client = HttpClient();

    try 
    {
      HttpClientRequest request;

      // Vytvoření requestu podle typu	
      switch (requestType) 
      {
        case ZohoRequest_Type.GET:
        request = await client.getUrl(uri);
        break;

        case ZohoRequest_Type.POST:
        request = await client.postUrl(uri);
        break;

        case ZohoRequest_Type.PUT:
        request = await client.putUrl(uri);
        break;

        case ZohoRequest_Type.DELETE:
        request = await client.deleteUrl(uri);
        break;

        default:
        request = await client.getUrl(uri);
        break;
      }

      // Nastavení hlaviček
      request.headers.add('Accept', '*/*');

      // Přidání access tokenu do hlaviček
      if (accessToken.isNotEmpty) 
      {
        request.headers.add('Authorization', 'Zoho-oauthtoken $accessToken');
      }

      // Přidání dat do requestu pro POST a PUT
      if (jsonData != null) 
      {
        request.headers.add('Content-Type', 'application/json');
        request.add(utf8.encode(json.encode(jsonData)));
      }

      // Odeslání requestu
      final response = await request.close();

      // Získání HTTP výsledku
      final code = response.statusCode;

      // Získání dat z response
      final stringData = await response.transform(const Utf8Decoder(allowMalformed: true)).join();

      if ((code / 100) != 2) 
      {
        // Http chyba
        lastResponse = {'error': 'http', 'code': code, 'data': stringData};
        return lastResponse!;
      } 
      else 
      {
        // Zpracování dat
        try 
        {
          final data = jsonDecode(stringData);
          lastResponse = data;
          return data;
        } 
        catch (e) 
        {
          lastResponse = {'error': 'response', 'code': code, 'data': stringData};
          return lastResponse!;
        }
      }
    } 
    catch (e) 
    {
      lastResponse = {'error': 'http', 'code': 0, 'data': e.toString()};
      return lastResponse!;
    } 
    finally 
    {
      // Uzavření HTTP klienta
      client.close();
    }
  }

  /// Získání access tokenu
  Future<String> getAccessToken() async
  {
    accessToken = '';

    /// Konec pokud není k dispozici kód
    if (code.isEmpty)
    {
      throw Exception('code is empty');
    }

    /// Získání access tokenu
    final response = await doRequest
    (
      '$zohoAccounts/oauth/v2/token',
      requestType: ZohoRequest_Type.POST,
      components: 
      {
        'code': code,
        'client_id': clientId,
        'client_secret': clientSecret,
        'redirect_uri': redirectUrl,
        'grant_type': 'authorization_code',
      }
    );

    /// Uložení access tokenu
    accessToken = response['access_token'] ?? '';

    return accessToken;
  }

  void buildAuthCompleter()
  {
    oauthCompleter = Completer<String>();
  }

  Widget buildWebAuthWidget()
  {
    code = '';

    return OAuthWeb(
      url: '$zohoAccounts$zohoAuth',
      components: 
      {
              'scope':
              'ZohoBooks.invoices.CREATE,ZohoBooks.invoices.READ,ZohoBooks.invoices.UPDATE,ZohoBooks.invoices.DELETE,ZohoBooks.settings.READ,ZohoBooks.contacts.READ',
              'client_id': clientId,
              'state': 'testing',
              'response_type': 'code',
              'redirect_uri': redirectUrl,
              'access_type': 'online',
              'prompt': 'mujprompt'
      },
      redirectUrlTest: redirectUrl,
      onRedirect: _oAuthRedirect,
      );
  }

  void _oAuthRedirect(String url) 
  {
    try 
    {
      final uri = Uri.parse(url);
      code = uri.queryParameters['code'] ?? '';
      zohoAccounts = uri.queryParameters['accounts-server'] ?? zohoAccounts;
      oauthCompleter?.complete(code);
    } 
    catch (e) 
    {
      print(e);
    }
  }

  Future<String> oAuthWaitCode(Duration?timeout) async 
  {
    try
    {
      if (oauthCompleter == null) 
      {
        code = '';
      }
      else
      {
        if (timeout!=null)
        {
          bool timeOver =  false;
          final fTimeout = Future.delayed(timeout, () => timeOver = true);
          await Future.any([oauthCompleter!.future, fTimeout]);
          if (timeOver)
          {
            code = '';
          }
        }
        else
        {
          await oauthCompleter!.future;
        }
      }
    }
    finally
    {
      oauthCompleter = null;
    }

    return code;

  }


  Future<String> getOAuthCode({required BuildContext context,Duration? timeout}) async
  {
      buildAuthCompleter();     
      Navigator.push
      (
        context,
        MaterialPageRoute
        (
          settings: const RouteSettings(name: 'OAuthWeb',),
          builder: (context) => buildWebAuthWidget()
          
        ),
      );

      return oAuthWaitCode(timeout);

  }
}

enum ZohoRequest_Type { GET, POST, PUT, DELETE }