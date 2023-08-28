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

      final codeCompleter = Completer<String>();

      const client_id = '1000.IYOMEJWSGDHDEEMZ5Q3251CZMYCH7K';
      const client_secret = 'c7de448c801f0093dc2be8acf45753b3d722387c5b';

/*
https://accounts.zoho.com/oauth/v2/auth?scope=ZohoBooks.invoices.CREATE,ZohoBooks.invoices.READ,ZohoBooks.invoices.UPDATE,ZohoBooks.invoices.DELETE&client_id=1000.I0TZTUJ5X012YGJ8YD3OTZSPZC411C&state=testing&response_type=code&redirect_uri=https://abcalc.8u.cz&access_type=offline

https://accounts.zoho.com/oauth/v2/token?code=1000.dd7exxxxxxxxxxxxxxxxxxxxxxxx9bb8.b6c0xxxxxxxxxxxxxxxxxxxxxxxxdca4&client_id=I0TZTUJ5X012YGJ8YD3OTZSPZC411C&client_secret=80ee449522b103070bce13944f4b9eacab7e3ada42&redirect_uri=https://abcalc.8u.cz&grant_type=authorization_code
https://accounts.zoho.com/oauth/v2/token?code=1000.459e236a08bcce606926e95efe047de8.e66506af58933bcceb9c188bace8180e&client_id=I0TZTUJ5X012YGJ8YD3OTZSPZC411C&client_secret=80ee449522b103070bce13944f4b9eacab7e3ada42&redirect_uri=https://abcalc.8u.cz&grant_type=authorization_code
*/
      /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OAuthWeb(
          url:'https://accounts.zoho.com',
          redirectUrlTest: 'https://abcalc.8u.cz',
          onRedirect: (String url)
          {
            try
            {
              Navigator.pop(context);
              final uri = Uri.parse(url);
              final code = uri.queryParameters['code'];
              codeCompleter.complete(code);
            }
            catch (e)
            {
              codeCompleter.completeError(e);
            }
          },
        )),
      );
      return;*/

      // Grant token
      Navigator.push
      (
        context,
        MaterialPageRoute
        (
          settings: const RouteSettings(name: 'OAuthWeb',),
          builder: (context) => OAuthWeb
          (
            url: 'https://accounts.zoho.com/oauth/v2/auth',
            components: const 
            {
              'scope':
              'ZohoBooks.invoices.CREATE,ZohoBooks.invoices.READ,ZohoBooks.invoices.UPDATE,ZohoBooks.invoices.DELETE,ZohoBooks.settings.READ,ZohoBooks.contacts.READ',
              'client_id': client_id,
              'state': 'testing',
              'response_type': 'code',
              'redirect_uri': 'https://abcalc.8u.cz/test',
              'access_type': 'online',
              'prompt': 'mujprompt'
            },
            redirectUrlTest: 'https://abcalc.8u.cz',
            onRedirect: (String url) 
            {
              try 
              {
                Navigator.pop(context);
                final uri = Uri.parse(url);
                final code = uri.queryParameters['code'];
                codeCompleter.complete(code);
              } 
              catch (e) 
              {
                codeCompleter.completeError(e);
              }
            },
          )
        ),
      );

      final code = await codeCompleter.future;

      // Refresh token
      // https://accounts.zoho.com/oauth/v2/token?code=$CODE$&client_id=$CLIENT_ID$V&client_secret=$SECRET$&redirect_uri=http://www.zoho.com/books&grant_type=authorization_code

      //final response = await oAuthGet('https://accounts.zoho.com/oauth/v2/token?code=$code&client_id=$client_id&client_secret=$client_secret&redirect_uri=http://www.zoho.com/books&grant_type=authorization_code',null);
      var response = await oAuthGet
      (
        'https://accounts.zoho.com/oauth/v2/token', 
        {
          'code': code,
          'client_id': client_id,
          'client_secret': client_secret,
          'redirect_uri': 'https://abcalc.8u.cz/test',
          'grant_type': 'authorization_code',
        }
      );

      print(response.toString());

      // ignore: use_build_context_synchronously
      if (!context.mounted) return;


      if (response.containsKey('access_token')) 
      {
        final accessToken = response['access_token'];

        //response = await oAuthGet('https://books.zoho.com/api/v3/invoices', {'authtoken': accessToken});
        print(response.toString());

        final zoho =
        ZohoClient(clientId: client_id, clientSecret: client_secret, redirectUrl: 'https://abcalc.8u.cz/test');
        zoho.accessToken = accessToken;

        final user = await zoho.booksGetCurrentUser();

        final inv = await zoho.get('https://books.zoho.com/api/v3/invoices');

        final items = await zoho.get('https://books.zoho.com/api/v3/items');

        final contacts = await zoho.get('https://books.zoho.com/api/v3/contacts');

        final cr =
        await zoho.get
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
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) 
        {
          print(request.url);
          if (request.url.contains(widget.redirectUrlTest)) 
          {
            widget.onRedirect?.call(request.url);
            return NavigationDecision.prevent;
          } 
          else 
          {
            return NavigationDecision.navigate;
          }
        },
      ),
    )
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

Future<Map> oAuthGet(String url, [Map<String, String>? components]) async 
{
  final uri = buildUri(url, components);
  final client = HttpClient();

  print('oAuthGet: ${uri.toString()}');

  try 
  {
    //final request = await client.getUrl(uri);
    final request = await client.postUrl(uri);
    request.headers.add('Accept', '*/*');
    final response = await request.close();
    final code = response.statusCode;
    final stringData = await response.transform(const Utf8Decoder(allowMalformed: true)).join();

    if (code / 100 != 2) 
    {
      return {'error': 'http', 'code': code, 'data': stringData};
    } 
    else 
    {
      try 
      {
        final data = jsonDecode(stringData);
        return data;
      } 
      catch (e) 
      {
        return {'error': 'response', 'code': code, 'data': stringData};
      }
    }
  } 
  finally 
  {
    client.close();
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

class ZohoClient 
{
  final String clientId;
  final String clientSecret;
  final String redirectUrl;
  String accessToken = '';
  final httpClient = HttpClient();
  var scope = <String>{};
  String zohoApis = 'https://www.zohoapis.com';

  ZohoClient({required this.clientId, required this.clientSecret, required this.redirectUrl, Set<String>? scope}) 
  {
    if (scope != null) 
    {
      this.scope = scope;
    }
  }

  Future<Map> booksGetCurrentUser() => get('$zohoApis/books/v3/users/me');

  Future<Map> get(String url,
    {ZohoRequest_Type requestType = ZohoRequest_Type.GET, Map<String, String>? components, dynamic jsonData}) async 
  {
    final uri = buildUri(url, components);
    final client = HttpClient();

    try 
    {
      HttpClientRequest request;

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

      request.headers.add('Accept', '*/*');
      if (accessToken.isNotEmpty) 
      {
        request.headers.add('Authorization', 'Zoho-oauthtoken $accessToken');
      }

      if (jsonData != null) 
      {
        request.headers.add('Content-Type', 'application/json');
        request.add(utf8.encode(json.encode(jsonData)));
      }

      final response = await request.close();
      final code = response.statusCode;
      final stringData = await response.transform(const Utf8Decoder(allowMalformed: true)).join();

      if (code != 200) 
      {
        return {'error': 'http', 'code': code, 'data': stringData};
      } 
      else 
      {
        try 
        {
          final data = jsonDecode(stringData);
          return data;
        } 
        catch (e) 
        {
          return {'error': 'response', 'code': code, 'data': stringData};
        }
      }
    } 
    catch (e) 
    {
      return {'error': 'http', 'code': 0, 'data': e.toString()};
    } 
    finally 
    {
      client.close();
    }
  }
}

enum ZohoRequest_Type { GET, POST, PUT, DELETE }