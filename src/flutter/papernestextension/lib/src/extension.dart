import 'package:flet/flet.dart';
import 'package:flutter/widgets.dart';

import 'controls/papernest_color_picker.dart';
import 'controls/papernest_date_picker.dart';
import 'controls/papernest_dropdown.dart';
import 'controls/papernest_glide_rail.dart';
import 'controls/papernest_icon_picker.dart';
import 'controls/papernest_textfield.dart';
import 'services/papernest_file_picker.dart';

class Extension extends FletExtension {
  @override
  Widget? createWidget(Key? key, Control control) {
    switch (control.type) {
      case "PaperNestColorPicker":
        return PaperNestColorPickerControl(key: key, control: control);
      case "PaperNestDatePicker":
        return PaperNestDatePickerControl(key: key, control: control);
      case "PaperNestDropdown":
        return PaperNestDropdownControl(key: key, control: control);
      case "PaperNestGlideRail":
        return PaperNestGlideRailControl(key: key, control: control);
      case "PaperNestIconPicker":
        return PaperNestIconPickerControl(key: key, control: control);
      case "PaperNestTextField":
        return PaperNestTextFieldControl(key: key, control: control);
      case "PaperNestFilePicker":
        return PaperNestFilePickerControl(key: key, control: control);
      default:
        return null;
    }
  }
}
