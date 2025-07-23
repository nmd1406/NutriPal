import 'package:flutter/material.dart';

class BMIIndicator extends StatelessWidget {
  final double bmiValue;

  const BMIIndicator({super.key, required this.bmiValue});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.6;
    final double height = 8;
    return Column(
      children: [
        SizedBox(
          width: width,
          height: height + 20,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 12.5,
                child: SizedBox(
                  height: height,
                  width: width,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 25,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      Expanded(flex: 25, child: Container(color: Colors.green)),
                      Expanded(
                        flex: 25,
                        child: Container(color: Colors.yellow.shade600),
                      ),
                      Expanded(
                        flex: 25,
                        child: Container(color: Colors.orange),
                      ),
                      Expanded(
                        flex: 25,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(4),
                              bottomRight: Radius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 100, // temp value
                child: Container(
                  width: 10,
                  height: height + 25,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 1,
                      horizontal: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: "Bạn đang ",
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: "Bình thường",
                style: TextStyle(color: Colors.yellow.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
