
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:provider/provider.dart';
import '../widgets/clipboard_item_card.dart';
import '../viewmodels/clipboard_viewmodel.dart';

class ClipboardListScreen extends StatelessWidget {
  const ClipboardListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return ChangeNotifierProvider(
      create: (context) => ClipboardViewModel(),
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
                  // Load items when first building the widget
                  if (viewModel.state == ClipboardViewState.initial) {
                    viewModel.loadClipboardItems();
                  }
                  
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
