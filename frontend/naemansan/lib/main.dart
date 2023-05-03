import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';
import 'package:naemansan/screens/home_sccreen.dart';
import 'package:naemansan/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:naemansan/screens/screen_index.dart';

void main() async {
  // 환경변수
  await dotenv.load(fileName: 'assets/config/.env');
  // await dotenv.load(fileName: '.env');

  // spalsh 시간 조절하기
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // prefs 초기화
  final prefs = await SharedPreferences.getInstance();
  // 로그인 여부 확인
  final isLoggedin = prefs.getBool('isLoggedIn') ?? false;
  KakaoSdk.init(nativeAppKey: "${dotenv.env['YOUR_NATIVE_APP_KEY']}");

  runApp(MyApp(isLoggedin: isLoggedin));
  runApp(const App());
}

class MyApp extends StatelessWidget {
  // 로그인 여부 체크
  final bool isLoggedin;
  const MyApp({super.key, required this.isLoggedin});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove(); // 초기화가 끝나는 시점에 삽입
    return MaterialApp(
      // 로그인 여부에 따라 화면 분기
      home: isLoggedin ? const HomeScreen() : LoginScreen(),
    );
  }
}

//---
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '내가 만든 산책로',
      routes: {
        '/index': (context) => const IndexScreen(),
        //지도 하단바 확인
        //'/index': (context) => const MapIndex(),
      },
      initialRoute: '/index',
    );
  }
}
