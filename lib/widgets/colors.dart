import 'dart:ui';

class J3Colors {
  String key;
  J3Colors(this.key);

  final Map<String, int> _color = {
    // Main Colors
    'OrangeLight': 0xFFE65100,
    'Orange': 0xFFE65100,
    'OrangeDark': 0xFFE65100,
    'Dark': 0xFF5C7C8A,
    //
    'Grey': 0xFFF2F3F5,
    'DarkGrey': 0xFFBCC3CF,
    // Text Colors
    'title': 0xFFFA4A0C,
  };

  get color => Color(_color[key] as int);
}
