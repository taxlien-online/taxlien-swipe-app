import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_spacing.dart';
import '../../../core/design/app_radius.dart';
import '../../../core/design/app_typography.dart';
import '../../../core/design/app_shadows.dart';
import '../../../core/design/app_durations.dart';
import '../providers/copilot_provider.dart';

/// Draggable sheet for AI Copilot interaction
class CopilotSheet extends StatefulWidget {
  final VoidCallback? onClose;
  final void Function(Set<String> propertyIds)? onHighlightProperties;

  const CopilotSheet({
    super.key,
    this.onClose,
    this.onHighlightProperties,
  });

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ChangeNotifierProvider(
        create: (_) => CopilotProvider(),
        child: const CopilotSheet(),
      ),
    );
  }

  @override
  State<CopilotSheet> createState() => _CopilotSheetState();
}

class _CopilotSheetState extends State<CopilotSheet> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.2,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.sheetRadius,
            boxShadow: AppShadows.modal,
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.fg3,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppSpacing.xs),
                      decoration: BoxDecoration(
                        gradient: AppColors.brandGradient,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      'Deal Copilot',
                      style: AppTypography.screenTitle,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      color: AppColors.fg2,
                    ),
                  ],
                ),
              ),

              Divider(color: AppColors.line),

              // Content
              Expanded(
                child: Consumer<CopilotProvider>(
                  builder: (context, provider, _) {
                    return ListView(
                      controller: scrollController,
                      padding: EdgeInsets.all(AppSpacing.md),
                      children: [
                        // Suggestions
                        if (provider.currentInput.isEmpty) ...[
                          Text(
                            'Try asking:',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.fg3,
                            ),
                          ),
                          SizedBox(height: AppSpacing.sm),
                          _buildSuggestionChips(provider),
                          SizedBox(height: AppSpacing.lg),
                        ],

                        // Query history
                        if (provider.queryHistory.isNotEmpty) ...[
                          Text(
                            'Recent',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.fg3,
                            ),
                          ),
                          SizedBox(height: AppSpacing.sm),
                          ...provider.queryHistory.reversed
                              .take(5)
                              .map((q) => _buildHistoryItem(q.text)),
                          SizedBox(height: AppSpacing.lg),
                        ],

                        // Response
                        if (provider.lastResponse != null)
                          _buildResponse(provider),

                        // Error
                        if (provider.error != null) _buildError(provider),
                      ],
                    );
                  },
                ),
              ),

              // Input area
              _buildInputArea(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSuggestionChips(CopilotProvider provider) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: provider.suggestions.map((s) {
        return GestureDetector(
          onTap: () => provider.useSuggestion(s),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: AppRadius.chipRadius,
              border: Border.all(color: AppColors.line),
            ),
            child: Text(
              s,
              style: AppTypography.caption.copyWith(color: AppColors.fg1),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHistoryItem(String query) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.xs),
      child: GestureDetector(
        onTap: () {
          _textController.text = query;
          context.read<CopilotProvider>().setInput(query);
        },
        child: Row(
          children: [
            Icon(Icons.history, size: 16, color: AppColors.fg3),
            SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                query,
                style: AppTypography.secondary.copyWith(color: AppColors.fg2),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponse(CopilotProvider provider) {
    final response = provider.lastResponse!;

    return AnimatedContainer(
      duration: AppDurations.normal,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: response.success
            ? AppColors.success.withOpacity(0.1)
            : AppColors.danger.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: response.success
              ? AppColors.success.withOpacity(0.3)
              : AppColors.danger.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                response.success ? Icons.check_circle : Icons.error,
                size: 16,
                color: response.success ? AppColors.success : AppColors.danger,
              ),
              SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  response.success
                      ? '${response.matchCount} properties found'
                      : 'Query failed',
                  style: AppTypography.label.copyWith(
                    color:
                        response.success ? AppColors.success : AppColors.danger,
                  ),
                ),
              ),
            ],
          ),
          if (response.explanation != null) ...[
            SizedBox(height: AppSpacing.xs),
            Text(
              response.explanation!,
              style: AppTypography.secondary,
            ),
          ],
          if (response.hasMatches) ...[
            SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      widget.onHighlightProperties
                          ?.call(response.matchingPropertyIds.toSet());
                    },
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('Highlight'),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Select all matches
                      Navigator.pop(context, response.matchingPropertyIds);
                    },
                    icon: const Icon(Icons.check_circle, size: 16),
                    label: const Text('Select All'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandBlue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildError(CopilotProvider provider) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.danger.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.danger, size: 20),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              provider.error!,
              style: AppTypography.secondary.copyWith(color: AppColors.danger),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: provider.clearError,
            color: AppColors.danger,
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: Consumer<CopilotProvider>(
          builder: (context, provider, _) {
            return Row(
              children: [
                // Voice input button (placeholder)
                IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: () {
                    // TODO: Implement voice input
                  },
                  color: AppColors.fg2,
                ),

                // Text input
                Expanded(
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    onChanged: provider.setInput,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        provider.submitQuery(value);
                        _textController.clear();
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Ask about properties...',
                      hintStyle: AppTypography.body.copyWith(
                        color: AppColors.fg3,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        borderSide: BorderSide(color: AppColors.line),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        borderSide: BorderSide(color: AppColors.line),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        borderSide: BorderSide(color: AppColors.brandBlue),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      isDense: true,
                    ),
                  ),
                ),

                SizedBox(width: AppSpacing.xs),

                // Send button
                Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.brandGradient,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: provider.isProcessing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send),
                    onPressed: provider.isProcessing
                        ? null
                        : () {
                            if (_textController.text.isNotEmpty) {
                              provider.submitQuery(_textController.text);
                              _textController.clear();
                            }
                          },
                    color: Colors.white,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
