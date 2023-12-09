import 'dart:math';
import 'package:flutter/material.dart';

class Captcha extends StatefulWidget {
  double lebar, tinggi;
  int jumlahTitikMaks = 10;

  var stokWarna = {
    'merah': Color(0xa9ec1c1c),
    'hijau': Color(0xa922b900),
    'hitam': Color(0xa9000000),
  };
  var warnaTerpakai = {};
  String warnaYangDitanyakan = 'merah';
  int jumlahBangunDatar = 2; // Total shapes

  Captcha(this.lebar, this.tinggi);

  @override
  State<StatefulWidget> createState() => _CaptchaState();

  bool benarkahJawaban(jawaban) {
    return false;
  }
}

class _CaptchaState extends State<Captcha> {
  var random = Random();

  @override
  void initState() {
    super.initState();
    buatPertanyaan();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: widget.lebar,
            height: widget.tinggi,
            child: CustomPaint(
              painter: CaptchaPainter(widget),
            ),
          ),
          Text(
            'Berapa jumlah titik warna ${widget.warnaYangDitanyakan}?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, height: 2),
          ),
          SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: 'Jawaban',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (answer) {
              periksaJawaban(answer);
            },
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Trigger action on button press
              periksaJawaban(answerController.text);
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  TextEditingController answerController = TextEditingController();

  void buatPertanyaan() {
    setState(() {
      var keys = widget.stokWarna.keys.toList();
      widget.warnaYangDitanyakan = keys[random.nextInt(keys.length)];
      widget.jumlahBangunDatar = random.nextInt(3) + 2; // Random shapes between 2 and 4
    });
  }

  void periksaJawaban(String jawaban) {
    // Logic to check the answer
    int answer = widget.warnaTerpakai[widget.warnaYangDitanyakan] ?? 0;
    if (jawaban.isNotEmpty && int.tryParse(jawaban) == answer) {
      // If the answer is correct
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('BENAR')),
      );
      // Implement logic to disable the text field and submit button
      // ...
    } else {
      // If the answer is incorrect, reset and generate a new question
      setState(() {
        buatPertanyaan();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Jawaban salah. Coba lagi!')),
      );
    }
  }
}

class CaptchaPainter extends CustomPainter {
  Captcha captcha;
  var random = Random();

  CaptchaPainter(this.captcha);

  @override
  void paint(Canvas canvas, Size size) {
    var catBingkai = Paint()
      ..color = Color(0xFF000000)
      ..style = PaintingStyle.stroke;
    canvas.drawRect(Offset(0, 0) & Size(captcha.lebar, captcha.tinggi), catBingkai);

    // Draw shapes based on widget.jumlahBangunDatar
    captcha.stokWarna.forEach((key, value) {
      var jumlah = random.nextInt(captcha.jumlahTitikMaks + 1);
      if (jumlah == 0) jumlah = 1;
      captcha.warnaTerpakai[key] = jumlah;

      for (var i = 0; i < jumlah; i++) {
        var catTitik = Paint()
          ..color = value
          ..style = PaintingStyle.fill;
        canvas.drawCircle(
          Offset(
            random.nextDouble() * captcha.lebar,
            random.nextDouble() * captcha.tinggi,
          ),
          6,
          catTitik,
        );
      }
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
