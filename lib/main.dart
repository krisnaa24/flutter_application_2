import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/api_client.dart';
import 'package:flutter_application_2/widgets/drop_down.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiClient client = ApiClient();
  Color mainColor = Color(0xFF212936);
  Color secondColor = Color(0xFF2849E5);
  late List<String> currencies;
  late String from;
  late String to;

  late double rate;
  String result = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    (() async {
      List<String> list = await client.getCurrencies();
      setState(() {
        currencies = list;
      });
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                "Money Convert",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
                child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    onSubmitted: (value) async {
                      rate = await client.getRate(from, to);
                      setState(() {
                        result =
                            (rate * double.parse(value)).toStringAsFixed(3);
                      });
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Input Value to Convert",
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18.0,
                          color: secondColor,
                        )),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customDropDown(currencies, from, (val) {
                        setState(() {
                          from = val;
                        });
                      }),
                      FloatingActionButton(
                        onPressed: () {
                          String temp = from;
                          setState(() {
                            from = to;
                            to = temp;
                          });
                        },
                        child: Icon(Icons.swap_horiz),
                        elevation: 0.0,
                        backgroundColor: secondColor,
                      ),
                      customDropDown(currencies, to, (val) {
                        setState(() {
                          from = val;
                        });
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0)),
                    child: Column(
                      children: [
                        Text(
                          "Result",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(result,
                            style: TextStyle(
                              color: secondColor,
                              fontSize: 36.0,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      )),
    );
  }
}
