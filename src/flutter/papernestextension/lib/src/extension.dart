import 'package:flet/flet.dart';
import 'package:flutter/widgets.dart';

import 'controls/papernest_button.dart';
import 'controls/papernest_dropdown.dart';
import 'controls/papernest_glide_rail.dart';
import 'controls/papernest_textfield.dart';
import 'services/papernest_file_picker.dart';

class Extension extends FletExtension {
  @override
  Widget? createWidget(Key? key, Control control) {
    switch (control.type) {
      case "PaperNestButton":
        return PaperNestButtonControl(key: key, control: control);
      case "PaperNestDropdown":
        return PaperNestDropdownControl(key: key, control: control);
      case "PaperNestGlideRail":
        return PaperNestGlideRailControl(key: key, control: control);
      case "PaperNestTextField":
        return PaperNestTextFieldControl(key: key, control: control);
      case "PaperNestFilePicker":
        return PaperNestFilePickerControl(key: key, control: control);
      default:
        return null;
    }
  }
}
