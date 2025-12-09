import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const NumerologyApp());
}

const MaterialColor kBrandGreen = MaterialColor(
  0xFF26C258,
  <int, Color>{
    50: Color(0xFFE3F7E9),
    100: Color(0xFFB9ECC8),
    200: Color(0xFF8BE1A4),
    300: Color(0xFF5DD67F),
    400: Color(0xFF39CC64),
    500: Color(0xFF26C258),
    600: Color(0xFF21AE4E),
    700: Color(0xFF1B9842),
    800: Color(0xFF168236),
    900: Color(0xFF0E5F26),
  },
);

class NumerologyApp extends StatelessWidget {
  const NumerologyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnkVidya',
      theme: ThemeData(
        primarySwatch: kBrandGreen,
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF5F8FB),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const NumerologyCalculator(),
    );
  }
}

class NumerologyCalculator extends StatefulWidget {
  const NumerologyCalculator({super.key});

  @override
  State<NumerologyCalculator> createState() => _NumerologyCalculatorState();
}

class _NumerologyCalculatorState extends State<NumerologyCalculator>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  List<int> mappedNumbers = [];
  int totalSum = 0;
  int singleDigit = 0;
  bool hasResult = false;

  final Map<String, int> numerologyMap = {
    'A': 1, 'I': 1, 'J': 1, 'Q': 1, 'Y': 1,
    'B': 2, 'K': 2, 'R': 2,
    'C': 3, 'G': 3, 'L': 3, 'S': 3,
    'D': 4, 'M': 4, 'T': 4,
    'H': 5, 'N': 5, 'E': 5, 'X': 5,
    'U': 6, 'V': 6, 'W': 6,
    'O': 7, 'Z': 7,
    'F': 8, 'P': 8
  };

  final Map<int, String> planetMap = {
    1: "Surya (सूर्य) – Sun",
    2: "Chandra (चन्द्र) – Moon",
    3: "Guru (गुरु/बृहस्पति) – Jupiter",
    4: "Rahu (राहु) – North Node of Moon",
    5: "Budh (बुध) – Mercury",
    6: "Shukra (शुक्र) – Venus",
    7: "Ketu (केतु) – South Node of Moon",
    8: "Shani (शनि) – Saturn",
    9: "Mangal (मंगल) – Mars"
  };

  // ✨ Updated function to support numbers also
  void calculateNumerology(String input) {
    mappedNumbers.clear();
    totalSum = 0;
    singleDigit = 0;

    for (int i = 0; i < input.length; i++) {
      String char = input[i].toUpperCase();

      // If digit (0-9)
      if (RegExp(r'[0-9]').hasMatch(char)) {
        int digit = int.parse(char);
        mappedNumbers.add(digit);
        totalSum += digit;
        continue;
      }

      // Alphabet mapping
      int? value = numerologyMap[char];
      if (value != null) {
        mappedNumbers.add(value);
        totalSum += value;
      } else {
        mappedNumbers.add(0);
      }
    }

    singleDigit = reduceToSingleDigit(totalSum);

    setState(() {
      hasResult = true;
    });
  }

  int reduceToSingleDigit(int num) {
    while (num > 9) {
      num = num
          .toString()
          .split('')
          .map((e) => int.tryParse(e) ?? 0)
          .reduce((a, b) => a + b);
    }
    return num;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1B9842), Color(0xFF5DD67F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Text(
                "AnkVidya",
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 36),
                child: Column(
                  children: [
                    Text(
                      "Find the secret number for your name!\nType any name or word below.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 32),

                    TextField(
                      controller: _controller,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        hintText: "e.g. Sun123",
                      ),
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          calculateNumerology(value.trim());
                        }
                      },
                    ),
                    const SizedBox(height: 18),

                    GestureDetector(
                      onTap: () {
                        if (_controller.text.trim().isNotEmpty) {
                          calculateNumerology(_controller.text.trim());
                        }
                      },
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1B9842), Color(0xFF5DD67F)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            "CALCULATE",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    AnimatedOpacity(
                      opacity: hasResult ? 1 : 0,
                      duration: const Duration(milliseconds: 400),
                      child: hasResult
                          ? resultBox()
                          : const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 26),

                    mappingBox(),
                  ],
                ),
              ),
            ),

            footer(),
          ],
        ),
      ),
    );
  }

  Widget resultBox() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        children: [
          Text("Result for:", style: TextStyle(color: Colors.grey[700])),
          const SizedBox(height: 4),
          Text(
            _controller.text.trim(),
            style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: const Color(0xff4481eb)),
          ),
          const SizedBox(height: 14),

          Wrap(
            alignment: WrapAlignment.center,
            children: mappedNumbers.map((n) {
              return Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: n == 0 ? Colors.grey[300] : const Color(0xffe8f0fd),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  "$n",
                  style: GoogleFonts.poppins(
                    fontSize: 19,
                    color:
                    n == 0 ? Colors.grey[400] : const Color(0xff4481eb),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 22),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              resultTile("Sum", "$totalSum", Colors.blueAccent),
              const SizedBox(width: 18),
              resultTile("Single Digit", "$singleDigit", Colors.orange),
            ],
          ),

          const SizedBox(height: 18),

          planetMap[singleDigit] != null
              ? Column(
            children: [
              Text(
                "Planet for $singleDigit",
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 5),
              Text(
                planetMap[singleDigit]!,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xffF59E42),
                    fontSize: 19),
                textAlign: TextAlign.center,
              ),
            ],
          )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget resultTile(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600])),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
                fontSize: 23, fontWeight: FontWeight.w700, color: color),
          ),
        ),
      ],
    );
  }

  Widget mappingBox() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          "Mapping:\nA,I,J,Q,Y = 1   |   B,K,R = 2   |   C,G,L,S = 3\n"
              "D,M,T = 4   |   H,N,E,X = 5   |   U,V,W = 6\n"
              "O,Z = 7   |   F,P = 8\nNumbers 0–9 = Their own value",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget footer() {
    return Column(
      children: [
        Text("Powered by Maakamakhaya",
            style: TextStyle(color: Colors.black, fontSize: 13)),
        const SizedBox(height: 3),
        Text("Made with ❤️ by Pt Kanwal kant Bhardwaj",
            style: TextStyle(color: Colors.black, fontSize: 13)),
        const SizedBox(height: 3),
        Text("Phone No ❤️ +918860111799",
            style: TextStyle(color: Colors.black, fontSize: 13)),
        const SizedBox(height: 10),
      ],
    );
  }
}
