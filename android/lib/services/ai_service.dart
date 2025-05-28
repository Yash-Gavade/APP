import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:fitquest/models/surprise_model.dart';
import 'package:fitquest/services/auth_service.dart';

class AIService {
  final OpenAI _openai;
  final AuthService _authService;
  
  AIService(this._openai, this._authService);
  
  // Get AI recommendations for nearby surprises
  Future<List<SurpriseModel>> getSurpriseRecommendations(
    LatLng location,
    List<SurpriseModel> nearbySurprises,
  ) async {
    if (nearbySurprises.isEmpty) return [];
    
    final user = _authService.userProfile;
    if (user == null) return [];
    
    // Prepare context for AI
    final context = '''
User Profile:
- Name: ${user.name}
- Level: ${user.level}
- XP: ${user.xp}
- Streak: ${user.streak}
- Badges: ${user.badges?.join(', ') ?? 'None'}

Nearby Surprises:
${nearbySurprises.map((s) => '''
- ${s.title} (${s.type})
  Status: ${s.status}
  XP Reward: ${s.xpReward}
  Required Badges: ${s.requiredBadges?.join(', ') ?? 'None'}
''').join('\n')}

Location: ${location.latitude}, ${location.longitude}
''';
    
    try {
      // Get AI recommendations
      final response = await _openai.chat.create(
        model: 'gpt-4',
        messages: [
          Message(
            role: 'system',
            content: '''
You are a fitness AI assistant that helps users discover surprises and rewards in their area.
Your task is to:
1. Analyze the user's profile and nearby surprises
2. Recommend the most relevant and exciting surprises
3. Generate engaging hints about the surprises' locations
4. Consider the user's level, badges, and preferences
5. Make the experience fun and motivating

Format your response as a JSON array of recommendations, each containing:
{
  "surpriseId": "id of the surprise",
  "hint": "engaging hint about the location",
  "reason": "why this surprise is recommended for this user"
}
''',
          ),
          Message(
            role: 'user',
            content: context,
          ),
        ],
        temperature: 0.7,
      );
      
      // Parse AI recommendations
      final recommendations = _parseAIRecommendations(
        response.choices.first.message.content,
        nearbySurprises,
      );
      
      return recommendations;
    } catch (e) {
      print('Error getting AI recommendations: $e');
      return [];
    }
  }
  
  // Parse AI recommendations from response
  List<SurpriseModel> _parseAIRecommendations(
    String aiResponse,
    List<SurpriseModel> nearbySurprises,
  ) {
    try {
      // TODO: Implement proper JSON parsing
      // For now, return a simple recommendation
      return nearbySurprises.take(1).map((surprise) {
        return surprise.copyWith(
          aiHint: 'I sense something special nearby... Keep exploring!',
        );
      }).toList();
    } catch (e) {
      print('Error parsing AI recommendations: $e');
      return [];
    }
  }
  
  // Handle surprise discovery
  Future<void> onSurpriseDiscovered(String surpriseId) async {
    final user = _authService.userProfile;
    if (user == null) return;
    
    try {
      // Get AI celebration message
      final response = await _openai.chat.create(
        model: 'gpt-4',
        messages: [
          Message(
            role: 'system',
            content: '''
You are celebrating with the user who just discovered a surprise.
Be enthusiastic and encouraging, but keep it brief.
''',
          ),
          Message(
            role: 'user',
            content: '''
User ${user.name} (Level ${user.level}) just discovered a surprise!
''',
          ),
        ],
        temperature: 0.7,
      );
      
      // TODO: Show celebration message to user
      print('AI Celebration: ${response.choices.first.message.content}');
    } catch (e) {
      print('Error getting AI celebration: $e');
    }
  }
  
  // Handle surprise claim
  Future<void> onSurpriseClaimed(String surpriseId) async {
    final user = _authService.userProfile;
    if (user == null) return;
    
    try {
      // Get AI congratulation message
      final response = await _openai.chat.create(
        model: 'gpt-4',
        messages: [
          Message(
            role: 'system',
            content: '''
You are congratulating the user who just claimed a surprise reward.
Be encouraging and suggest what they might discover next.
''',
          ),
          Message(
            role: 'user',
            content: '''
User ${user.name} (Level ${user.level}) just claimed a surprise reward!
''',
          ),
        ],
        temperature: 0.7,
      );
      
      // TODO: Show congratulation message to user
      print('AI Congratulation: ${response.choices.first.message.content}');
    } catch (e) {
      print('Error getting AI congratulation: $e');
    }
  }
  
  // Generate a hint for a surprise
  Future<String> generateSurpriseHint(SurpriseModel surprise) async {
    try {
      final response = await _openai.chat.create(
        model: 'gpt-4',
        messages: [
          Message(
            role: 'system',
            content: '''
You are creating an engaging hint about a surprise location.
The hint should be:
1. Mysterious but not too cryptic
2. Related to fitness or the surprise type
3. Encouraging exploration
4. Fun and exciting
Keep it brief (1-2 sentences).
''',
          ),
          Message(
            role: 'user',
            content: '''
Surprise Details:
- Title: ${surprise.title}
- Type: ${surprise.type}
- Description: ${surprise.description}
- Rewards: ${surprise.rewards}
''',
          ),
        ],
        temperature: 0.7,
      );
      
      return response.choices.first.message.content;
    } catch (e) {
      print('Error generating surprise hint: $e');
      return 'Something special awaits nearby...';
    }
  }
} 