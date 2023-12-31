import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class TextDetectorPainter extends CustomPainter {
  TextDetectorPainter(this.absoluteImageSize, this.elements);

  final Size? absoluteImageSize;
  final List<TextElement>? elements;
  final TextPainter painter = TextPainter(
    textDirection: TextDirection.ltr,
  );

  @override
  void paint(Canvas canvas, Size size) {
    if(absoluteImageSize == null || elements == null) {
      return;
    }

    final double scaleX = size.width / absoluteImageSize!.width;
    final double scaleY = size.height / absoluteImageSize!.height;

    Rect scaleRect(TextElement container) {
      return Rect.fromLTRB(
        container.boundingBox.left * scaleX,
        container.boundingBox.top * scaleY,
        container.boundingBox.right * scaleX,
        container.boundingBox.bottom * scaleY,
      );
    }

    void drawText(TextElement element) {
      painter.text = TextSpan(
        text: element.text,
        style: const TextStyle(
          color: Colors.white,
          backgroundColor: Colors.blue,
          fontSize: 8.0,
        ),
      );
      Offset position = Offset(
        element.boundingBox.left * scaleX + 2.0,
        element.boundingBox.top * scaleY,
      );
      painter.layout();
      painter.paint(canvas, position);
    }

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.blue
      ..strokeWidth = 2.0;

    for (TextElement element in elements!) {
      canvas.drawRect(scaleRect(element), paint);
      drawText(element);
    }
  }

  @override
  bool shouldRepaint(TextDetectorPainter oldDelegate) {
    return true;
  }
}