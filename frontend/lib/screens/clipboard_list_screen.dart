
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import '../widgets/clipboard_item_card.dart';
import '../viewmodels/clipboard_viewmodel.dart';

class ClipboardListScreen extends StatefulWidget {
  const ClipboardListScreen({super.key});

  @override
  State<ClipboardListScreen> createState() => _ClipboardListScreenState();
}

class _ClipboardListScreenState extends State<ClipboardListScreen> {
  late ClipboardViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    // Get services from locator
    _viewModel = GetIt.instance<ClipboardViewModel>();
    
    // Load clipboard items after the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.loadClipboardItems();
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        body: Column(
          children: [
            WindowTitleBarBox(
              child: Row(
                children: [
                  Expanded(child: MoveWindow()),
                  CloseWindowButton(colors: WindowButtonColors(
                    iconNormal: colorScheme.primary,
                    iconMouseOver: colorScheme.error,
                  )),
                ],
              ),
            ),
            Expanded(
              child: Consumer<ClipboardViewModel>(
                builder: (context, viewModel, child) {
                  return viewModel.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : viewModel.hasError
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Error: ${viewModel.errorMessage}'),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: viewModel.loadClipboardItems,
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            )
                          : viewModel.clipboardItems.isEmpty
                              ? const Center(child: Text('No clipboard items found'))
                              : ListView.builder(
                                  itemCount: viewModel.clipboardItems.length,
                                  itemBuilder: (context, index) {
                                    final item = viewModel.clipboardItems[index];
                                    return ClipboardItemCard(
                                      item: item,
                                      onTap: () {
                                        // Handle item tap
                                        viewModel.setCurrentItem(item.id);
                                      },
                                    );
                                  },
                                );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
