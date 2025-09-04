import 'package:flutter/material.dart';
import '../viewmodels/clipboard_viewmodel.dart';

class ViewModelProvider extends InheritedWidget {
  final ClipboardViewModel viewModel;
  
  const ViewModelProvider({
    Key? key,
    required this.viewModel,
    required Widget child,
  }) : super(key: key, child: child);
  
  static ClipboardViewModel of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<ViewModelProvider>();
    if (provider == null) {
      throw FlutterError(
        'ViewModelProvider.notFound: No ViewModelProvider ancestor could be found '
        'starting from the context that was passed to ViewModelProvider.of<ClipboardViewModel>(). '
        'This usually happens when the context provided is from the same StatefulWidget '
        'as where the ViewModelProvider is declared, or if the context is from a widget ' 
        'that is above the ViewModelProvider in the widget tree.'
      );
    }
    return provider.viewModel;
  }
  
  @override
  bool updateShouldNotify(ViewModelProvider oldWidget) {
    return viewModel != oldWidget.viewModel;
  }
}
