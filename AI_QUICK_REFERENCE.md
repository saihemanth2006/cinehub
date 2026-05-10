<!--
  CineHub AI System - Quick Reference Card

  A condensed guide for developers to quickly implement and use the AI system.
-->

# 🎬 CineHub AI System - Quick Reference

## Backend Setup (Node.js)

### Initialize AI System

```javascript
// In your Express app initialization
const {
  getOrchestrator,
  getPipelines,
  getWorkflowExecutor,
  initializeAIQueue,
} = require("./integrations/ai");

// Initialize queues
initializeAIQueue();

// Log available workflows
const executor = getWorkflowExecutor();
const capabilities = executor.listCapabilities();
console.log(`Available modules: ${capabilities.modules.join(", ")}`);
```

### Use the Unified Endpoint

```javascript
// In your Express routes
const router = express.Router();
const { aiLimiter, authenticate, validate } = require("./middleware");
const aiController = require("./api/v1/ai/ai.controller");

router.post(
  "/ai/generate",
  authenticate(),
  aiLimiter,
  validate(validation.unifiedGenerate),
  catchAsync(async (req, res) => {
    const result = await aiController.generate(req);
    ApiResponse.ok(result).send(res);
  }),
);
```

### Request/Response Example

**Request:**

```json
{
  "module": "script-development",
  "task": "generate-script",
  "input": "A detective solving cyber crimes in 2050",
  "options": {
    "provider": "openai"
  }
}
```

**Response:**

```json
{
  "success": true,
  "module": "script-development",
  "task": "generate-script",
  "data": {
    "title": "Cyber Detective 2050",
    "logline": "In a neon-soaked future, a burnt-out detective must solve crimes in the digital underworld.",
    "content": "FADE IN:\nEXT. NEO-TOKYO - NIGHT\n...",
    "characters": [...],
    "themes": [...]
  },
  "meta": {
    "provider": "openai",
    "model": "gpt-4",
    "tokensUsed": 4250,
    "executionTimeMs": 8450,
    "cached": false,
    "requestId": "req_abc123"
  }
}
```

---

## Frontend Setup (Flutter)

### Initialize AI Service

```dart
// In your main.dart or setup
import 'package:cinehub/features/ai/data/services/ai_service.dart';

// Use with Riverpod
final response = await ref.read(aiServiceProvider).generate(
  module: 'script-development',
  task: 'generate-script',
  input: 'A detective solving cyber crimes in 2050',
);
```

### Build UI with AI Widgets

```dart
// Responsive AI module picker
class AIModuleScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modules = ref.watch(aiModulesProvider);

    return modules.when(
      loading: () => AILoadingWidget(message: 'Loading modules...'),
      error: (error, stack) => ErrorWidget(error: error),
      data: (modules) => GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: modules.length,
        itemBuilder: (context, index) {
          return AIModuleCard(
            title: modules[index],
            description: 'Click to explore tasks',
            taskCount: 6,
            onTap: () => _navigateToModule(context, modules[index]),
          );
        },
      ),
    );
  }
}

// Display AI response with expand/collapse
AIResponseCard(
  title: 'Generated Screenplay',
  subtitle: 'Click to expand',
  content: response.data['content'],
  onAction: () => copyToClipboard(response.data['content']),
  expandable: true,
)

// Show typing animation for dramatic effect
TypingTextAnimation(
  text: response.data['title'],
  duration: Duration(milliseconds: 50),
  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
)
```

---

## 7 AI Modules - Quick Access

| Module          | Slug                      | Tasks | Use Case                                                  |
| --------------- | ------------------------- | ----- | --------------------------------------------------------- |
| 📝 Script Dev   | `script-development`      | 6     | Generate scripts, enhance dialogue, character development |
| 🎬 Trailer      | `trailer-concept`         | 5     | Narration, sequencing, hooks, music mood                  |
| 🎥 Video        | `video-enhancement`       | 5     | Editing suggestions, color grading, subtitles             |
| 👥 Cast & Crew  | `cast-crew`               | 4     | Role recommendations, talent matching, team composition   |
| 📊 Production   | `production-intelligence` | 4     | Budget, schedule, equipment, complexity                   |
| 🎯 Distribution | `distribution-promotion`  | 5     | Festival recommendations, audience targeting, promotion   |
| 🎨 Previz       | `pre-visualization`       | 5     | Shot suggestions, camera angles, lighting, mood           |

---

## Common Tasks Mapping

### Script Development

```
module: 'script-development'

- generate-script         → Full screenplay
- story-expansion         → Story outline
- enhance-dialogue        → Improve dialogue
- develop-character       → Character profiles
- analyze-genre           → Genre analysis
- breakdown-scenes        → Production breakdown
```

### Trailer Concept

```
module: 'trailer-concept'

- generate-narration      → Voiceover copy
- sequence-concept        → Beat sequencing
- generate-hook           → Opening hooks
- structure-trailer       → Complete structure
- suggest-music-mood      → Music recommendations
```

### Video Enhancement

```
module: 'video-enhancement'

- editing-suggestions     → Edit recommendations
- color-grading          → Color palette
- generate-subtitles     → Subtitle content
- analyze-pacing         → Pacing analysis
- cinematic-enhancement  → Effects & techniques
```

### Cast & Crew

```
module: 'cast-crew'

- recommend-roles        → Required positions
- talent-matching        → Match to roles
- skill-analysis         → Needed skills
- team-composition       → Optimal structure
```

### Production Intelligence

```
module: 'production-intelligence'

- estimate-budget        → Budget breakdown
- schedule-recommendations → Shooting schedule
- equipment-suggestions  → Equipment list
- complexity-analysis    → Risk assessment
```

### Distribution & Promotion

```
module: 'distribution-promotion'

- recommend-festivals    → Festival list
- target-audience        → Audience strategy
- social-captions        → Social media content
- promotion-strategy     → Marketing plan
- generate-copywriting   → Marketing copy
```

### Pre-Visualization

```
module: 'pre-visualization'

- suggest-shots          → Camera shots
- camera-angles          → Camera angles
- moodboard-prompts      → Image prompts
- lighting-style         → Lighting design
- visual-storytelling    → Visual techniques
```

---

## Error Handling

```dart
try {
  final response = await aiService.generate(
    module: 'script-development',
    task: 'generate-script',
    input: input,
  );
  // Use response
} on Exception catch (e) {
  // Handle specific errors
  if (e.toString().contains('timeout')) {
    showSnackbar('Request timeout. Try again.');
  } else if (e.toString().contains('rate limit')) {
    showSnackbar('Rate limit exceeded. Try again later.');
  } else {
    showSnackbar('Error: ${e.toString()}');
  }
}
```

---

## Configuration & Environment

```bash
# Backend Environment Variables
AI_DEFAULT_PROVIDER=openai
OPENAI_API_KEY=sk-...
GEMINI_API_KEY=...
REDIS_URL=redis://localhost:6379
AI_MAX_REQUESTS_PER_USER=50

# Frontend (in app configuration)
const API_BASE_URL = 'https://api.cinehub.dev';
const AI_ENDPOINT = '/api/v1/ai/generate';
```

---

## Performance Tips

### ⚡ Optimization

1. **Use caching**: Most responses cached for 24h by default
2. **Batch requests**: Combine multiple tasks when possible
3. **Async processing**: Use async for >5 second tasks
4. **Provider selection**: Use GPT-4 for complex, Gemini-Flash for simple tasks

### 📊 Monitoring

```dart
// Check AI system health
final health = await aiService.getHealth();
print(health['providers']); // Provider status

// Check your usage
final usage = await aiService.getUsageStats();
print(usage['tokensUsed']);
print(usage['requestsToday']);
```

---

## Testing

```dart
// Test with mock data
final mockResponse = AIResponse(
  success: true,
  module: 'script-development',
  task: 'generate-script',
  data: {'title': 'Test Script', 'content': '...'},
  meta: AIResponseMeta(provider: 'test'),
);

// Unit test
test('AIService generates scripts', () async {
  final service = AIService();
  final response = await service.generate(
    module: 'script-development',
    task: 'generate-script',
    input: 'A detective...',
  );
  expect(response.success, true);
  expect(response.data['title'], isNotEmpty);
});
```

---

## Debugging

```javascript
// Enable verbose logging
process.env.DEBUG = "cinehub:*";

// Check workflow registry
const executor = getWorkflowExecutor();
console.log(executor.listCapabilities());

// Validate input before sending
const { valid, errors } = executor.validateInput(module, task, input);
if (!valid) console.log("Validation errors:", errors);
```

---

## Troubleshooting

| Issue          | Solution                                           |
| -------------- | -------------------------------------------------- |
| Timeouts       | Increase timeout in options, check provider status |
| Rate limit     | Use async processing, implement request queue      |
| Cache miss     | Check Redis connection, verify cache key           |
| Low quality    | Improve input prompt, adjust temperature           |
| Provider error | Switch provider in options, check API key          |

---

## Quick Commands

```bash
# Check health
curl https://api.cinehub.dev/api/v1/ai/health

# List modules
curl https://api.cinehub.dev/api/v1/ai/modules

# Get module tasks
curl https://api.cinehub.dev/api/v1/ai/modules/script-development/tasks

# Test generate (requires auth)
curl -X POST https://api.cinehub.dev/api/v1/ai/test-generate \
  -H 'Content-Type: application/json' \
  -d '{
    "module": "script-development",
    "task": "generate-script",
    "input": "A detective..."
  }'
```

---

## Resources

- 📖 [Full Architecture Guide](./AI_ORCHESTRATION_GUIDE.md)
- 🔌 [API Reference](./docs/api-reference.md)
- 💡 [Prompt Engineering Tips](./docs/prompt-engineering.md)
- 🐛 [Troubleshooting Guide](./docs/troubleshooting.md)
- 🧪 [Testing Guide](./docs/testing.md)

---

## Key Takeaways

✅ **One Endpoint**: Use `POST /ai/generate` for everything  
✅ **Modular Tasks**: 30+ specialized tasks across 7 modules  
✅ **Smart Routing**: System automatically routes to right templates  
✅ **Enterprise Ready**: Caching, rate limiting, monitoring built-in  
✅ **Type Safe**: Full Dart models with JSON serialization  
✅ **Developer Friendly**: Clear error handling and logging

---

**Need Help?** Check the troubleshooting guide or open an issue on GitHub.
