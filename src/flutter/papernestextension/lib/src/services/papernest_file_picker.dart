import 'package:collection/collection.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flet/flet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/papernest_file_picker.dart';

class PaperNestFilePickerControl extends StatefulWidget {
  final Control control;

  const PaperNestFilePickerControl({
    super.key,
    required this.control,
  });

  @override
  State<PaperNestFilePickerControl> createState() =>
      _PaperNestFilePickerControlState();
}

class _PaperNestFilePickerControlState
    extends State<PaperNestFilePickerControl> {
  List<PlatformFile> _files = <PlatformFile>[];
  bool _dragging = false;
  bool _hovering = false;

  Control get control => widget.control;

  @override
  void initState() {
    super.initState();
    control.addInvokeMethodListener(_invokeMethod);
  }

  @override
  void dispose() {
    control.removeInvokeMethodListener(_invokeMethod);
    super.dispose();
  }

  Future<dynamic> _invokeMethod(String name, dynamic args) async {
    // Certaines méthodes sans argument peuvent être transmises avec `null`
    // par Flet. On normalise systématiquement pour éviter les accès `args[...]`
    // sur une valeur nulle (notamment avec clear_files()).
    final methodArgs = args is Map ? args : <String, dynamic>{};

    switch (name) {
      case "get_files":
        return _serializeFiles(_files);
      case "remove_file":
        return _removeFile(parseInt(methodArgs["file_id"]));
      case "clear_files":
        _clearFiles();
        return null;
      case "upload":
        final files = methodArgs["files"];
        if (files != null && _files.isNotEmpty) {
          await _uploadFiles(files, control.backend.pageUri);
        }
        return null;
      case "pick_files":
        final dialogTitle = methodArgs["dialog_title"] as String?;
        final initialDirectory = methodArgs["initial_directory"] as String?;
        final allowedExtensions = (methodArgs["allowed_extensions"] as List?)
            ?.map((extension) => extension.toString())
            .toList();
        var fileType = parsePaperNestFileType(
          methodArgs["file_type"],
          FileType.any,
        )!;
        if (allowedExtensions != null && allowedExtensions.isNotEmpty) {
          fileType = FileType.custom;
        }
        return _pickFiles(
          dialogTitle: dialogTitle,
          initialDirectory: initialDirectory,
          fileType: fileType,
          allowedExtensions: allowedExtensions,
          allowMultiple: methodArgs["allow_multiple"] ?? false,
          withData: parseBool(methodArgs["with_data"], false)!,
        );
      case "save_file":
        final dialogTitle = methodArgs["dialog_title"] as String?;
        final initialDirectory = methodArgs["initial_directory"] as String?;
        final srcBytes = methodArgs["src_bytes"];
        final allowedExtensions = (methodArgs["allowed_extensions"] as List?)
            ?.map((extension) => extension.toString())
            .toList();
        var fileType = parsePaperNestFileType(
          methodArgs["file_type"],
          FileType.any,
        )!;
        if (allowedExtensions != null && allowedExtensions.isNotEmpty) {
          fileType = FileType.custom;
        }
        if ((kIsWeb || isAndroidMobile() || isIOSMobile()) &&
            srcBytes == null) {
          throw Exception(
            '"src_bytes" is required when saving a file on Web, Android and iOS.',
          );
        }
        if (kIsWeb && methodArgs["file_name"] == null) {
          throw Exception(
            '"file_name" is required when saving a file on Web.',
          );
        }
        return FilePicker.platform.saveFile(
          dialogTitle: dialogTitle,
          fileName: methodArgs["file_name"] != null || !isIOSMobile()
              ? methodArgs["file_name"]
              : "new-file",
          initialDirectory: initialDirectory,
          lockParentWindow: true,
          type: fileType,
          allowedExtensions: allowedExtensions,
          bytes: srcBytes,
        );
      case "get_directory_path":
        final dialogTitle = methodArgs["dialog_title"] as String?;
        final initialDirectory = methodArgs["initial_directory"] as String?;
        if (kIsWeb) {
          throw Exception(
            "Get Directory Path dialog is not supported on web.",
          );
        }
        return FilePicker.platform.getDirectoryPath(
          dialogTitle: dialogTitle,
          initialDirectory: initialDirectory,
          lockParentWindow: true,
        );
      default:
        throw Exception("Unknown PaperNestFilePicker method: $name");
    }
  }

  Future<List<Map<String, dynamic>>> _pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    required FileType fileType,
    List<String>? allowedExtensions,
    required bool allowMultiple,
    required bool withData,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
      lockParentWindow: true,
      type: fileType,
      allowedExtensions: allowedExtensions,
      allowMultiple: allowMultiple,
      withData: withData,
      withReadStream: !withData,
    );
    final selected = result?.files ?? <PlatformFile>[];
    final added = _addFiles(selected);
    return _serializeFiles(added, withData: withData);
  }

  Future<void> _pickFromZone() async {
    if (control.disabled) return;

    var fileType = control.getPaperNestFileType("file_type", FileType.any)!;
    final extensions = _allowedDropExtensions();
    if (extensions.isNotEmpty) fileType = FileType.custom;

    await _pickFiles(
      dialogTitle: control.getString("dialog_title"),
      initialDirectory: null,
      fileType: fileType,
      allowedExtensions: extensions.isEmpty ? null : extensions,
      allowMultiple: control.getBool("allow_multiple", true)!,
      withData: control.getBool("with_data", false)!,
    );
  }

  List<Map<String, dynamic>> _serializeFiles(
    List<PlatformFile> files, {
    bool withData = false,
  }) {
    return files.map((file) {
      final id = _files.indexOf(file);
      return PaperNestFilePickerFile(
        id: id < 0 ? 0 : id,
        name: file.name,
        path: kIsWeb ? null : file.path,
        size: file.size,
        bytes: withData ? file.bytes : null,
      ).toMap();
    }).toList();
  }

  List<String> _allowedDropExtensions() {
    return (control.get<List>("allowed_extensions") ?? <dynamic>[])
        .map((extension) =>
            extension.toString().toLowerCase().replaceFirst('.', ''))
        .where((extension) => extension.isNotEmpty)
        .toList();
  }

  String _fileKey(PlatformFile file) {
    return "${file.path ?? ''}|${file.name}|${file.size}";
  }

  int? _maxFileSizeBytes() {
    final value = control.get("max_file_size");
    if (value == null) return null;
    if (value is num) return value.toInt();

    final raw = value.toString().trim().toUpperCase().replaceAll(',', '.');
    final match = RegExp(r'^([0-9]+(?:\.[0-9]+)?)\s*(B|KB|MB|GB|O|KO|MO|GO)?$')
        .firstMatch(raw);
    if (match == null) return null;

    final amount = double.tryParse(match.group(1)!);
    if (amount == null) return null;
    final unit = match.group(2) ?? 'B';
    final multiplier = switch (unit) {
      'KB' || 'KO' => 1024,
      'MB' || 'MO' => 1024 * 1024,
      'GB' || 'GO' => 1024 * 1024 * 1024,
      _ => 1,
    };
    return (amount * multiplier).round();
  }

  int? _maxFiles() {
    final value = control.getInt("max_files");
    return value != null && value > 0 ? value : null;
  }

  Map<String, dynamic> _fileData(PlatformFile file, {int id = 0}) {
    return PaperNestFilePickerFile(
      id: id,
      name: file.name,
      path: kIsWeb ? null : file.path,
      size: file.size,
      bytes: null,
    ).toMap();
  }

  void _triggerValidationError(
    PlatformFile file,
    String reason,
    String message, {
    dynamic limit,
  }) {
    final data = {
      "file": _fileData(file),
      "reason": reason,
      "message": message,
      "limit": limit,
    };
    control.triggerEvent("validation_error", data);
    control.triggerEvent(reason, data);
  }

  bool _validateFile(PlatformFile file) {
    final allowedExtensions = _allowedDropExtensions();
    final extension = _fileExtension(file.name);
    if (allowedExtensions.isNotEmpty &&
        !allowedExtensions.contains(extension)) {
      _triggerValidationError(
        file,
        "invalid_extension",
        "L'extension .${extension.isEmpty ? '?' : extension} n'est pas autorisée.",
        limit: allowedExtensions,
      );
      return false;
    }

    final maxFileSize = _maxFileSizeBytes();
    if (maxFileSize != null && file.size > maxFileSize) {
      _triggerValidationError(
        file,
        "file_too_large",
        "Le fichier dépasse la taille maximale autorisée (${_formatSize(maxFileSize)}).",
        limit: maxFileSize,
      );
      return false;
    }

    final maxFiles = _maxFiles();
    if (maxFiles != null && _files.length >= maxFiles) {
      _triggerValidationError(
        file,
        "max_files_reached",
        "Le nombre maximal de fichiers ($maxFiles) est atteint.",
        limit: maxFiles,
      );
      return false;
    }

    return true;
  }

  List<PlatformFile> _addFiles(List<PlatformFile> files) {
    if (files.isEmpty) return <PlatformFile>[];

    final existingKeys = _files.map(_fileKey).toSet();
    final added = <PlatformFile>[];
    final duplicates = <PlatformFile>[];
    for (final file in files) {
      if (existingKeys.contains(_fileKey(file))) {
        duplicates.add(file);
        continue;
      }
      if (!_validateFile(file)) continue;
      existingKeys.add(_fileKey(file));
      _files.add(file);
      added.add(file);
    }

    for (final file in duplicates) {
      final existingIndex = _files.indexWhere(
        (selectedFile) => _fileKey(selectedFile) == _fileKey(file),
      );
      control.triggerEvent("duplicate_file", {
        "file": _fileData(file, id: existingIndex < 0 ? 0 : existingIndex),
      });
    }

    if (added.isEmpty) return added;
    if (mounted) setState(() {});

    for (final file in added) {
      control.triggerEvent("file_added", {
        "file": _serializeFiles(<PlatformFile>[file]).first,
      });
    }
    _triggerFilesChanged();
    return added;
  }

  bool _removeFile(int? fileId) {
    if (fileId == null || fileId < 0 || fileId >= _files.length) return false;
    final removed = _files.removeAt(fileId);
    if (mounted) setState(() {});
    control.triggerEvent("file_removed", {
      "file": PaperNestFilePickerFile(
        id: fileId,
        name: removed.name,
        path: kIsWeb ? null : removed.path,
        size: removed.size,
        bytes: null,
      ).toMap(),
    });
    _triggerFilesChanged();
    return true;
  }

  void _clearFiles() {
    if (_files.isEmpty) return;
    final removed = List<PlatformFile>.from(_files);
    _files.clear();
    if (mounted) setState(() {});
    for (var index = 0; index < removed.length; index++) {
      final file = removed[index];
      control.triggerEvent("file_removed", {
        "file": PaperNestFilePickerFile(
          id: index,
          name: file.name,
          path: kIsWeb ? null : file.path,
          size: file.size,
          bytes: null,
        ).toMap(),
      });
    }
    _triggerFilesChanged();
  }

  void _triggerFilesChanged() {
    control.triggerEvent("files_changed", {"files": _serializeFiles(_files)});
  }

  Future<void> _handleDropped(DropDoneDetails details) async {
    final droppedFiles = <PlatformFile>[];

    for (final file in details.files) {
      final size = await file.length();
      droppedFiles.add(
        PlatformFile(
          name: file.name,
          path: kIsWeb ? null : file.path,
          size: size,
          readStream: file.openRead(),
        ),
      );
    }

    if (!mounted) return;
    setState(() => _dragging = false);
    final added = _addFiles(droppedFiles);

    if (added.isNotEmpty) {
      control.triggerEvent(
        "dropped",
        {"files": _serializeFiles(added)},
      );
    }
  }

  Future<void> _uploadFiles(List<dynamic> files, Uri pageUri) async {
    final uploadFiles = files.map(
      (file) => PaperNestFilePickerUploadFile(
        id: file["id"],
        name: file["name"],
        uploadUrl: file["upload_url"],
        method: file["method"],
      ),
    );

    for (final uploadFile in uploadFiles) {
      final selectedFile = ((uploadFile.id != null &&
                  uploadFile.id! >= 0 &&
                  uploadFile.id! < _files.length)
              ? _files[uploadFile.id!]
              : null) ??
          _files.firstWhereOrNull((file) => file.name == uploadFile.name);

      if (selectedFile == null) {
        debugPrint(
          "PaperNestFilePicker: '${uploadFile.name}' introuvable "
          "(id: ${uploadFile.id}).",
        );
        continue;
      }

      try {
        await _uploadFile(
          selectedFile,
          _fullUploadUrl(pageUri, uploadFile.uploadUrl),
          uploadFile.method,
        );
        final index = _files.indexOf(selectedFile);
        if (index >= 0) _removeFile(index);
      } catch (error) {
        _sendProgress(selectedFile.name, null, error.toString());
      }
    }
  }

  Future<void> _uploadFile(
    PlatformFile file,
    String uploadUrl,
    String method,
  ) async {
    final fileReadStream = file.readStream;
    if (fileReadStream == null) {
      throw Exception('Cannot read file from null stream');
    }

    final request = http.StreamedRequest(method, Uri.parse(uploadUrl));
    request.contentLength = file.size;
    _sendProgress(file.name, 0, null);

    double lastSent = 0;
    double progress = 0;
    int bytesSent = 0;

    fileReadStream.listen(
      (chunk) {
        request.sink.add(chunk);
        bytesSent += chunk.length;
        progress = file.size == 0 ? 1 : bytesSent / file.size;
        if (progress >= lastSent) {
          lastSent += 0.1;
          if (progress < 1.0) {
            _sendProgress(file.name, progress, null);
          }
        }
      },
      onDone: request.sink.close,
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode < 200 || response.statusCode > 204) {
      throw Exception(
        "Upload endpoint returned code ${response.statusCode}: ${response.body}",
      );
    }
    _sendProgress(file.name, 1, null);
  }

  void _sendProgress(String name, double? progress, String? error) {
    control.triggerEvent(
      "upload",
      PaperNestFilePickerUploadProgressEvent(
        name: name,
        progress: progress,
        error: error,
      ).toMap(),
    );
  }

  String _fullUploadUrl(Uri pageUri, String uploadUrl) {
    final uploadUri = Uri.parse(uploadUrl);
    if (uploadUri.hasAuthority) return uploadUrl;

    return Uri(
      scheme: pageUri.scheme,
      host: pageUri.host,
      port: pageUri.port,
      path: uploadUri.path,
      query: uploadUri.query,
    ).toString();
  }

  String _formatSize(int size) {
    if (size < 1024) return "$size o";
    if (size < 1024 * 1024) return "${(size / 1024).toStringAsFixed(1)} Ko";
    return "${(size / (1024 * 1024)).toStringAsFixed(1)} Mo";
  }

  String _requestedState() {
    final raw = control.getString("state", "normal") ?? "normal";
    return raw.split('.').last.toLowerCase();
  }

  String _effectiveState() {
    if (control.disabled) return "disabled";
    if (_dragging) return "drag_over";
    final requested = _requestedState();
    if (_hovering && requested == "normal") return "hover";
    return requested;
  }

  Color _stateBorderColor(BuildContext context, String state) {
    final theme = Theme.of(context);
    switch (state) {
      case "hover":
        return control.getColor("hover_border_color", context) ??
            theme.colorScheme.primary.withValues(alpha: 0.72);
      case "drag_over":
        return control.getColor("drag_border_color", context) ??
            theme.colorScheme.primary;
      case "success":
        return control.getColor("success_border_color", context) ?? Colors.green;
      case "error":
        return control.getColor("error_border_color", context) ??
            theme.colorScheme.error;
      case "disabled":
        return control.getColor("disabled_border_color", context) ??
            theme.disabledColor.withValues(alpha: 0.55);
      default:
        return theme.dividerColor;
    }
  }

  Color _stateBackgroundColor(BuildContext context, String state) {
    final theme = Theme.of(context);
    switch (state) {
      case "hover":
        return control.getColor("hover_background_color", context) ??
            theme.colorScheme.primaryContainer.withValues(alpha: 0.12);
      case "drag_over":
        return control.getColor("drag_background_color", context) ??
            theme.colorScheme.primaryContainer.withValues(alpha: 0.28);
      case "success":
        return control.getColor("success_background_color", context) ??
            Colors.green.withValues(alpha: 0.08);
      case "error":
        return control.getColor("error_background_color", context) ??
            theme.colorScheme.errorContainer.withValues(alpha: 0.20);
      case "disabled":
        return control.getColor("disabled_background_color", context) ??
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45);
      default:
        return theme.colorScheme.surface;
    }
  }

  Color _stateIconColor(BuildContext context, String state) {
    final theme = Theme.of(context);
    final custom = control.getColor("icon_color", context);
    if (custom != null) return custom;
    switch (state) {
      case "success":
        return Colors.green;
      case "error":
        return theme.colorScheme.error;
      case "disabled":
        return theme.disabledColor;
      default:
        return theme.colorScheme.primary;
    }
  }

  String _formatConstraintSize(int size) {
    if (size < 1024) return "$size o";
    if (size < 1024 * 1024) {
      return "${(size / 1024).toStringAsFixed(size % 1024 == 0 ? 0 : 1)} Ko";
    }
    if (size < 1024 * 1024 * 1024) {
      return "${(size / (1024 * 1024)).toStringAsFixed(size % (1024 * 1024) == 0 ? 0 : 1)} Mo";
    }
    return "${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} Go";
  }

  List<String> _constraintLabels() {
    if (!control.getBool("show_constraints", false)!) return <String>[];
    final labels = <String>[];
    final extensions = _allowedDropExtensions();
    if (extensions.isNotEmpty) {
      labels.add(extensions.map((e) => e.toUpperCase()).join(' • '));
    }
    final maxSize = _maxFileSizeBytes();
    if (maxSize != null) labels.add("${_formatConstraintSize(maxSize)} maximum");
    final maxFiles = _maxFiles();
    if (maxFiles != null) {
      labels.add("$maxFiles fichier${maxFiles > 1 ? 's' : ''} maximum");
    }
    return labels;
  }

  Widget _defaultZone(BuildContext context) {
    final theme = Theme.of(context);
    final state = _effectiveState();
    final customIcon = control.buildIconOrWidget("icon");
    final iconColor = _stateIconColor(context, state);
    final iconSize = control.getDouble("icon_size", 36)!;
    final title = control.getString("drop_text") ??
        control.getString("empty_title", "Déposez vos fichiers ici")!;
    final subtitle = control.getString("drop_subtitle") ??
        control.getString("empty_subtitle", "ou cliquez pour sélectionner")!;
    final constraints = _constraintLabels();

    final defaultIcon = Icon(
      state == "drag_over"
          ? Icons.file_download_outlined
          : state == "success"
              ? Icons.check_circle_outline
              : state == "error"
                  ? Icons.error_outline
                  : Icons.cloud_upload_outlined,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      constraints: const BoxConstraints(minHeight: 132),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _stateBorderColor(context, state),
          width: state == "drag_over" ? 2 : 1,
        ),
        color: _stateBackgroundColor(context, state),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: IconTheme(
              key: ValueKey<String>(state),
              data: IconThemeData(size: iconSize, color: iconColor),
              child: customIcon ?? defaultIcon,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
          if (constraints.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              constraints.join('  •  '),
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _fileExtension(String fileName) {
    return fileName.contains('.')
        ? fileName.split('.').last.toLowerCase()
        : '';
  }

  bool _isImageExtension(String extension) {
    return <String>{
      'png',
      'jpg',
      'jpeg',
      'gif',
      'bmp',
      'webp',
      'svg',
      'tif',
      'tiff',
    }.contains(extension);
  }

  IconData _fileIcon(String fileName) {
    final extension = _fileExtension(fileName);
    if (extension == 'pdf') return Icons.picture_as_pdf_outlined;
    if (_isImageExtension(extension)) return Icons.image_outlined;
    return Icons.description_outlined;
  }

  Color _fileIconColor(BuildContext context, String fileName) {
    final theme = Theme.of(context);
    final customColor = control.getColor("file_icon_color", context);
    if (customColor != null) return customColor;

    if (!control.getBool("use_file_type_colors", false)!) {
      return theme.colorScheme.primary;
    }

    final extension = _fileExtension(fileName);
    if (extension == 'pdf') return Colors.red;
    if (_isImageExtension(extension)) return Colors.blue;
    return theme.colorScheme.primary;
  }

  Widget _fileList(BuildContext context) {
    if (!control.getBool("show_file_list", true)! || _files.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final showSize = control.getBool("show_file_size", true)!;
    final fileIconSize = control.getDouble("file_icon_size", 20)!;
    return Column(
      children: _files.asMap().entries.map((entry) {
        final index = entry.key;
        final file = entry.value;
        return Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.only(left: 12, right: 4, top: 5, bottom: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Row(
            children: [
              Icon(
                _fileIcon(file.name),
                size: fileIconSize,
                color: _fileIconColor(context, file.name),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  file.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (showSize) ...[
                const SizedBox(width: 10),
                Text(_formatSize(file.size), style: theme.textTheme.bodySmall),
              ],
              IconButton(
                tooltip: "Retirer le fichier",
                icon: const Icon(Icons.close, size: 18),
                onPressed: control.disabled ? null : () => _removeFile(index),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customContent = control.buildWidget("content");
    final zoneContent = customContent ?? _defaultZone(context);
    final dragAndDrop = control.getBool("drag_and_drop", true)!;
    final disabled = control.disabled;

    Widget zone = MouseRegion(
      cursor: disabled || !control.getBool("click_to_pick", true)!
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      onEnter: disabled
          ? null
          : (_) {
              if (!_dragging && mounted) setState(() => _hovering = true);
            },
      onExit: disabled
          ? null
          : (_) {
              if (mounted) setState(() => _hovering = false);
            },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: disabled || !control.getBool("click_to_pick", true)!
            ? null
            : _pickFromZone,
        child: zoneContent,
      ),
    );

    if (dragAndDrop) {
      zone = DropTarget(
        enable: !disabled,
        onDragEntered: (_) {
          setState(() {
            _dragging = true;
            _hovering = false;
          });
          control.triggerEvent("entered");
        },
        onDragExited: (_) {
          setState(() {
            _dragging = false;
            _hovering = false;
          });
          control.triggerEvent("exited");
        },
        onDragDone: _handleDropped,
        child: zone,
      );
    }

    return LayoutControl(
      control: control,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 120),
        opacity: _dragging ? 0.86 : 1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [zone, _fileList(context)],
        ),
      ),
    );
  }
}
