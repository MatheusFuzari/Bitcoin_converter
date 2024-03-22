import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum Exchanges { BRL, EUR, DOL }

class _MyHomePageState extends State<MyHomePage> {
  String _price = "0";
  double _value = 0;
  final TextEditingController _userValue = TextEditingController();
  Exchanges? _from = Exchanges.BRL;
  Exchanges? _to = Exchanges.DOL;
  void _recover_price() async {
    String url = "https://blockchain.info/ticker";
    http.Response response = await http.get(Uri.parse(url));
    Map<String, dynamic> data = json.decode(response.body);
    setState(() {
      _price = data["BRL"]["buy"].toString();
    });

    print("Result: " + _price);
    print(response.body);
  }

  void calculateExchange() {
    double taxValue = 0.0;
    /*
      1 EUR -> 5.4 BRL
      1 EUR -> 1.09 DOL
      1 EUR -> 1 EUR
      ----------------------
      1 DOL -> 0.92 EUR
      1 DOL -> 4.98 BRL
      1 DOL -> 1 DOL
      ----------------------
      1 BRL -> 0.2 DOL
      1 BRL -> 0.19 EUR
      1 BRL -> 1 BRL
    */
    if(_from == Exchanges.EUR && _to == Exchanges.BRL){
      taxValue = 5.4;
    }else if(_from == Exchanges.EUR && _to == Exchanges.DOL){
      taxValue = 1.09;
    }else if(_from == Exchanges.DOL && _to == Exchanges.BRL){
      taxValue = 4.98;
    }else if(_from == Exchanges.DOL && _to == Exchanges.EUR){
      taxValue = 0.98;
    }else if(_from == Exchanges.BRL && _to == Exchanges.DOL){
      taxValue = 0.2;
    }else if(_from == Exchanges.BRL && _to == Exchanges.EUR){
      taxValue = 0.19;
    }else{
      taxValue = 1;
    }
    
    setState(() {
      _value = double.parse(_userValue.text) * taxValue;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recover_price();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
                "https://cointimes.com.br/wp-content/uploads/2020/08/Preco-do-Bitcoin-no-Brasil-recorde.jpg"),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Valor do BitCoin: R\$: ${_price}"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: _userValue,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Insira o valor a ser convertido',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Origem'),
                Text('Para'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: ListTile(
                        title: Text("Reais"),
                        leading: Radio<Exchanges>(
                          value: Exchanges.BRL,
                          groupValue: _from,
                          onChanged: (Exchanges? value) {
                            setState(() {
                              _from = value;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: ListTile(
                        title: Text("Dolar"),
                        leading: Radio<Exchanges>(
                          value: Exchanges.DOL,
                          groupValue: _from,
                          onChanged: (Exchanges? value) {
                            setState(() {
                              _from = value;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: ListTile(
                        title: Text("Euro"),
                        leading: Radio<Exchanges>(
                          value: Exchanges.EUR,
                          groupValue: _from,
                          onChanged: (Exchanges? value) {
                            setState(() {
                              _from = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: ListTile(
                        title: Text("Reais"),
                        leading: Radio<Exchanges>(
                          value: Exchanges.BRL,
                          groupValue: _to,
                          onChanged: (Exchanges? value) {
                            setState(() {
                              _to = value;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: ListTile(
                        title: Text("Dolar"),
                        leading: Radio<Exchanges>(
                          value: Exchanges.DOL,
                          groupValue: _to,
                          onChanged: (Exchanges? value) {
                            setState(() {
                              _to = value;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: ListTile(
                        title: Text("Euro"),
                        leading: Radio<Exchanges>(
                          value: Exchanges.EUR,
                          groupValue: _to,
                          onChanged: (Exchanges? value) {
                            setState(() {
                              _to = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Valor Convertido ${_value.toString()}', style: TextStyle(fontSize: 18),),
            ),
            ElevatedButton(
              onPressed:calculateExchange, child: Text("Calcular"))
          ],
        ),
      ),
    );
  }
}
