import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final VoidCallback? onClear;

  const CustomSearchBar({
    Key? key,
    required this.controller,
    this.onChanged,
    this.hintText = 'Search...',
    this.onClear,
  }) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.secondary,
          ),
          suffixIcon: AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child:
                widget.controller.text.isNotEmpty
                    ? IconButton(
                      key: ValueKey('clear'),
                      icon: Icon(
                        Icons.clear,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: () {
                        widget.controller.clear();
                        widget.onChanged?.call('');
                        widget.onClear?.call();
                      },
                    )
                    : SizedBox(key: ValueKey('empty')),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
