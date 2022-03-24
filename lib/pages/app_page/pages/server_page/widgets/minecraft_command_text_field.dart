import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/consts/minecraft_command.dart';

class MinecraftCommandTextField extends StatefulWidget {
  const MinecraftCommandTextField({
    Key? key,
    this.enabled,
    this.onSubmitted,
  }) : super(key: key);
  final bool? enabled;
  final void Function(String)? onSubmitted;

  @override
  State<MinecraftCommandTextField> createState() =>
      _MinecraftCommandTextFieldState();
}

class _MinecraftCommandTextFieldState extends State<MinecraftCommandTextField> {
  late TextEditingController _controller;
  late ScrollController _scrollController;
  // late StreamController<String> _suggestionBoxController;
  // late SuggestionsBoxController _suggestionsBoxController;
  late FocusNode _focusNode;
  // late OverlayEntry _overlayEntry;
  late List<MinecraftCommand> _commands;
  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
    _scrollController = ScrollController();
    // _controller.addListener(() {
    // _focusNode.requestFocus();
    // _suggestionsBoxController.open();
    // _overlayEntry = _suggestionBox(keyword: _controller.text);
    // Overlay.of(context)?.insert(_overlayEntry);
    // });
    // _suggestionsBoxController = SuggestionsBoxController();
    _focusNode = FocusNode(skipTraversal: true);
    _commands = getMinecraftCommands().toList();

    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   showOverlay(keyword: '/');
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    // _suggestionBoxController.close();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MinecraftCommandTextField oldWidget) {
    if (widget.enabled != true) {
      setState(() {
        _controller.clear();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   color: Colors.black,
    //   child: TextFormField(
    //     scrollController: _scrollController,
    //     controller: _controller,
    //     focusNode: _focusNode,
    //     enabled: true, //widget.enabled,
    //     decoration: const InputDecoration(
    //       border: InputBorder.none,
    //       isDense: true,
    //       contentPadding: EdgeInsets.symmetric(vertical: 12),
    //     ),
    //     style: Theme.of(context).textTheme.overline?.copyWith(
    //           color: Theme.of(context).colorScheme.onBackground,
    //         ),
    //     onFieldSubmitted: (text) {
    //       final onSubmitted = widget.onSubmitted;
    //       if (onSubmitted != null) {
    //         // onSubmitted(text);
    //         print('submitted! $text');
    //       }
    //       _focusNode.requestFocus();
    //     },
    //   ),
    // );

    // Everything is good except the buggy scroll exceptions....
    return TypeAheadField<MinecraftCommand>(
      scrollController: _scrollController,
      noItemsFoundBuilder: (context) => const SizedBox(),
      debounceDuration: const Duration(milliseconds: 500),
      hideOnLoading: true,
      textFieldConfiguration: TextFieldConfiguration(
        focusNode: _focusNode,
        style: Theme.of(context).textTheme.overline?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
        // enabled: widget.enabled == true,
        enabled: true,
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
        controller: _controller,
        onSubmitted: (text) {
          final onSubmitted = widget.onSubmitted;
          if (onSubmitted != null) {
            onSubmitted(text);
            _controller.clear();
            _focusNode.requestFocus();
          }
        },
      ),
      // getImmediateSuggestions: true,
      suggestionsBoxDecoration: const SuggestionsBoxDecoration(
        constraints: BoxConstraints(maxHeight: 240, maxWidth: 240),
      ),
      // suggestionsBoxController: _suggestionsBoxController,
      suggestionsCallback: (pattern) async {
        if (pattern.isEmpty) return [];
        // Workaround for not scrolling, until https://github.com/AbdulRahmanAlHamali/flutter_typeahead/issues/382 fixed
        final allMatchedCmds = _commands
            .where((element) => element.command.contains(pattern))
            .toList();

        // Sort and Limit to 4
        allMatchedCmds
            .sort((a, b) => a.command.length.compareTo(b.command.length));
        return allMatchedCmds.sublist(0, min(4, allMatchedCmds.length));
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(
            suggestion.command,
          ),
          dense: true,
          subtitle: Text(suggestion.description),
        );
      },
      onSuggestionSelected: (suggestion) {
        _controller.text = suggestion.command;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );

        Future.delayed(Duration.zero)
            .then((value) => _focusNode.requestFocus());
      },
      direction: AxisDirection.up,
      // autoFlipDirection: true,
    );

    // Flutter way, but can't auto change direction, also can't use FractionalTranslation
    // return Autocomplete<MinecraftCommand>(
    //   optionsBuilder: (value) {
    //     if (value.text.isEmpty) return [];
    //     return _commands
    //         .where((element) => element.command.contains(value.text));
    //   },
    //   optionsViewBuilder: (context, onSelected, options) {
    //     return Material(
    //       child: ListView.separated(
    //         itemBuilder: (context, index) {
    //           final option = options.elementAt(index);
    //           return ListTile(
    //             title: Text(option.command),
    //             subtitle: Text(option.description),
    //           );
    //         },
    //         separatorBuilder: (context, index) {
    //           return const Divider();
    //         },
    //         itemCount: options.length,
    //       ),
    //     );
    //   },
    //   fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
    //     return TextField(
    //       controller: controller,
    //       focusNode: focusNode,
    //       enabled: true, // widget.enabled,
    //       decoration: const InputDecoration(
    //         border: InputBorder.none,
    //         isDense: true,
    //         contentPadding: EdgeInsets.symmetric(vertical: 12),
    //       ),
    //       onEditingComplete: onEditingComplete,
    //       style: Theme.of(context).textTheme.overline?.copyWith(
    //             color: Theme.of(context).colorScheme.onBackground,
    //           ),
    //       onSubmitted: (text) {
    //         final onSubmitted = widget.onSubmitted;
    //         if (onSubmitted != null) {
    //           // onSubmitted(text);
    //           print('submitted! $text');
    //         }
    //         focusNode.requestFocus();
    //       },
    //     );
    //   },
    // );
  }

  // OverlayEntry _suggestionBox({String? keyword}) {
  //   return OverlayEntry(
  //     builder: (context) {
  //       return Material(
  //         color: Colors.transparent,
  //         child: SuggestionBox(
  //           keyword: keyword,
  //         ),
  //       );
  //     },
  //   );
  // }
}

// class SuggestionBox extends StatelessWidget {
//   const SuggestionBox(
//       {Key? key,
//       this.keyword,
//       required this.parentOffset,
//       required this.parentSize})
//       : super(key: key);
//   final String? keyword;
//   final Offset parentOffset;
//   final Size parentSize;

//   @override
//   Widget build(BuildContext context) {
//     final keyword = this.keyword;
//     if (keyword == null || keyword.isEmpty) return Container();
//     List<MinecraftCommand> filteredCommands = [];
//     List<MinecraftCommand> allCommands = getMinecraftCommands().toList();
//     filteredCommands = allCommands
//         .where((command) => command.command.contains(keyword))
//         .toList();
//     return Positioned(
//       top: parentOffset.dy - parentSize.height,
//       left: parentOffset.dx,
//       width: parentSize.width,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(4),
//         child: Material(
//           // Positioned(
//           //   left: 128,
//           //   bottom: 48,
//           //   width: 600,
//           child: IgnorePointer(
//             child: Container(
//               constraints: const BoxConstraints(maxHeight: 200, maxWidth: 300),
//               color: Colors.black54,
//               child: Scrollbar(
//                 // isAlwaysShown: true,
//                 child: ListView.separated(
//                   primary: false,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                   reverse: true,
//                   shrinkWrap: true,
//                   itemCount: filteredCommands.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(filteredCommands[index].command),
//                         Text(filteredCommands[index].description),
//                       ],
//                     );
//                   },
//                   separatorBuilder: (context, index) {
//                     return const SizedBox(
//                       height: 4,
//                     );
//                   },
//                 ),
//               ),
//             ),
//             ignoring: true,
//           ),
//         ),
//       ),
//     );
//   }
// }
