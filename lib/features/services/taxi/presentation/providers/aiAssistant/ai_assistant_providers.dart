import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether the floating AI-assistant search overlay is currently visible
/// on top of the taxi map. Toggled by tapping the AI icon in [TaxiTopBar].
final aiAssistantVisibilityProvider = StateProvider<bool>((ref) => false);

/// Last prompt entered by the user. Kept separate so typing only rebuilds the
/// overlay's send-button enable state, not the whole map.
final aiAssistantPromptProvider = StateProvider<String>((ref) => '');

