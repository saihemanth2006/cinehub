<!--
  CineHub AI Orchestration System - Architecture & Implementation Guide

  This document provides comprehensive documentation for the centralized AI orchestration
  system powering all intelligent features across the CineHub filmmaking platform.
-->

# CineHub Centralized AI Orchestration System

## 🎯 Overview

The CineHub AI system is a **production-grade, centralized orchestration layer** that powers all AI-driven filmmaking features through a single unified API endpoint. Instead of multiple disconnected AI services, the entire ecosystem uses **ONE coherent orchestration brain** with dynamic routing and reusable components.

### Core Principles

- **Single Point of Entry**: All AI operations go through `POST /ai/generate`
- **Modular Design**: 7 independent AI modules with 30+ specialized tasks
- **Reusable Components**: Shared prompt templates, validators, and response parsers
- **Provider Agnostic**: Supports OpenAI, Gemini, or any provider
- **Enterprise Features**: Caching, rate limiting, monitoring, async processing

---

## 📊 Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    FLUTTER FRONTEND                            │
│  (AI Cards, Typing Animations, Responsive Layouts)            │
└────────────────────────────┬────────────────────────────────────┘
                             │
                ┌────────────▼────────────┐
                │   AI Service Layer      │
                │ (ai_service.dart)       │
                └────────────┬────────────┘
                             │
                ┌────────────▼────────────────────────────┐
                │  Unified Endpoint                      │
                │  POST /ai/generate                     │
                │  { module, task, input, options }      │
                └────────────┬─────────────────────────────┘
                             │
        ┌────────────────────▼────────────────────────┐
        │        AI ORCHESTRATOR (Core Brain)         │
        │                                            │
        │  1. Route workflow (module + task)         │
        │  2. Compile prompt from templates         │
        │  3. Check cache                            │
        │  4. Call AI provider                       │
        │  5. Validate & parse response              │
        │  6. Return structured JSON                 │
        └────────┬─────────────┬──────────┬──────────┘
                 │             │          │
        ┌────────▼─────┐ ┌─────▼──────┐ ┌┴─────────┐
        │  Prompt      │ │  Cache     │ │ Gateway  │
        │  Engine      │ │  (Redis)   │ │ (Multi   │
        │  (Templates) │ │            │ │ Provider)│
        └──────────────┘ └────────────┘ └──────────┘
                             │
        ┌────────────────────▼────────────────────────┐
        │     AI PROVIDERS (Pluggable)               │
        │                                            │
        │  • OpenAI (GPT-4, GPT-4o)                  │
        │  • Gemini (Gemini Pro, Flash)              │
        │  • Additional providers (Groq, etc.)       │
        └────────────────────────────────────────────┘
```

---

## 🔧 7 AI Modules & 30+ Tasks

### 1. **Script Development** (6 tasks)

- `generate-script` - Full screenplay from premise
- `story-expansion` - Concept to story outline
- `enhance-dialogue` - Improve dialogue quality
- `develop-character` - Deep character profiles
- `analyze-genre` - Genre classification & market analysis
- `breakdown-scenes` - Production scene breakdown

### 2. **Trailer Concept** (5 tasks)

- `generate-narration` - Compelling narration copy
- `sequence-concept` - Beat sequencing & flow
- `generate-hook` - Attention-grabbing openings
- `structure-trailer` - Complete trailer structure
- `suggest-music-mood` - Music recommendations

### 3. **Video Enhancement** (5 tasks)

- `editing-suggestions` - Editing & pacing recommendations
- `color-grading` - Color palette & grading approach
- `generate-subtitles` - Subtitle creation
- `analyze-pacing` - Scene pacing optimization
- `cinematic-enhancement` - Cinematic effects & techniques

### 4. **Cast & Crew** (4 tasks)

- `recommend-roles` - Required crew positions
- `talent-matching` - Match talent to roles
- `skill-analysis` - Required skills analysis
- `team-composition` - Optimal team structure

### 5. **Production Intelligence** (4 tasks)

- `estimate-budget` - Production budget breakdown
- `schedule-recommendations` - Shooting schedule
- `equipment-suggestions` - Equipment recommendations
- `complexity-analysis` - Production complexity & risks

### 6. **Distribution & Promotion** (5 tasks)

- `recommend-festivals` - Festival recommendations
- `target-audience` - Audience targeting strategy
- `social-captions` - Social media content
- `promotion-strategy` - Marketing strategy
- `generate-copywriting` - Marketing copy

### 7. **Pre-Visualization** (5 tasks)

- `suggest-shots` - Camera shot suggestions
- `camera-angles` - Camera angle recommendations
- `moodboard-prompts` - Image prompts for AI generators
- `lighting-style` - Lighting design
- `visual-storytelling` - Visual enhancement techniques

---

## 💻 Backend Implementation

### File Structure

```
server/src/integrations/ai/
├── ai.gateway.js                 # Multi-provider abstraction
├── index.js                       # Module exports & initialization
├── orchestrator/
│   ├── ai.orchestrator.js        # Main orchestration engine
│   ├── workflow.executor.js      # Workflow routing & execution
│   └── workflow.registry.js      # Workflow mapping table
├── prompts/
│   ├── prompt.engine.js          # Template compilation engine
│   ├── template.registry.js      # Template loading & registration
│   └── templates/
│       ├── script-extra.templates.js
│       ├── trailer.prompts.js
│       ├── video.prompts.js
│       ├── crew.templates.js
│       ├── production.prompts.js
│       ├── distribution.prompts.js
│       └── previz.prompts.js
├── providers/
│   ├── base.provider.js          # Provider interface
│   ├── openai.provider.js        # OpenAI implementation
│   └── gemini.provider.js        # Gemini implementation
├── cache/
│   └── ai.cache.js               # Redis-backed caching
├── queue/
│   └── ai.queue.js               # Async job queue (BullMQ)
├── validation/
│   └── ai.validator.js           # Response validation schemas
├── monitoring/
│   └── ai.monitor.js             # Metrics & logging
└── pipelines/
    └── ai.pipelines.js           # Pre-configured workflows
```

### Key Classes

#### AIOrchestrator

The central execution engine. Coordinates all AI operations.

```javascript
const orchestrator = getOrchestrator();
const result = await orchestrator.execute({
  templateId: "script.generate",
  variables: { prompt: "...", genre: "..." },
  userId: "user123",
  provider: "openai",
});
```

#### WorkflowExecutor

Routes requests based on module + task to the orchestrator.

```javascript
const executor = getWorkflowExecutor();
const result = await executor.execute({
  module: "script-development",
  task: "generate-script",
  input: "A detective...",
  userId: "user123",
});
```

#### WorkflowRegistry

Maps every (module, task) pair to a prompt template + transformation logic.

```javascript
workflowRegistry.register({
  module: "script-development",
  task: "generate-script",
  templateId: "script.generate",
  inputMapper: (input) => ({ prompt: input }),
  outputMapper: (data) => ({ screenplay: data }),
});
```

---

## 🚀 API Usage

### Unified Endpoint

```
POST /ai/generate
Content-Type: application/json

{
  "module": "script-development",
  "task": "generate-script",
  "input": "A detective solving cyber crimes in 2050",
  "options": {
    "provider": "openai"
  }
}
```

### Response Format

```json
{
  "success": true,
  "module": "script-development",
  "task": "generate-script",
  "data": {
    "title": "Cyber Detective 2050",
    "logline": "...",
    "content": "FADE IN:\nEXT. NEO-TOKYO - NIGHT\n...",
    "characters": [...],
    "themes": [...],
    "estimatedRuntime": 120
  },
  "meta": {
    "provider": "openai",
    "model": "gpt-4",
    "tokensUsed": 4250,
    "executionTimeMs": 8450,
    "cached": false,
    "requestId": "req_123abc"
  }
}
```

### Discovery Endpoints

```
GET /ai/capabilities          # All modules & tasks
GET /ai/modules               # List modules
GET /ai/modules/:module/tasks # Tasks for module
GET /ai/health                # System health
GET /ai/usage                 # User's usage stats
```

---

## 📱 Flutter Frontend

### Service Layer

```dart
final aiService = ref.watch(aiServiceProvider);

// Generate content
final response = await aiService.generate(
  module: 'script-development',
  task: 'generate-script',
  input: 'A detective...',
);

// Get capabilities
final capabilities = await aiService.getCapabilities();

// Get module tasks
final tasks = await aiService.getModuleTasks('script-development');
```

### UI Widgets

```dart
// Response card with expand/collapse
AIResponseCard(
  title: 'Generated Script',
  content: response.data,
  onAction: () => copyToClipboard(response.data),
)

// Loading state with animation
AILoadingWidget(
  message: 'Generating screenplay...',
)

// Typing animation
TypingTextAnimation(
  text: 'Generated content appears here...',
  duration: Duration(milliseconds: 50),
)

// Module cards
AIModuleCard(
  title: 'Script Development',
  description: 'Generate screenplays, enhance dialogue...',
  taskCount: 6,
  onTap: () => navigateToModule(),
)
```

---

## 🔄 Request Flow Example

### Generate a Script

**1. Frontend Request**

```dart
final response = await aiService.generate(
  module: 'script-development',
  task: 'generate-script',
  input: 'A detective solving cyber crimes in 2050',
);
```

**2. API Layer (Express)**

```javascript
POST /ai/generate
→ aiController.generate()
→ workflowExecutor.execute()
```

**3. Orchestrator**

```javascript
// 1. Resolve workflow
workflow = workflowRegistry.resolve("script-development", "generate-script");
// Returns: { templateId: 'script.generate', inputMapper, ... }

// 2. Map input
mappedInput = workflow.inputMapper(input);
// { prompt: '...', genre: '...', tone: '...' }

// 3. Check cache
cachedResult = await cache.get(cacheKey);
if (cachedResult) return cachedResult;

// 4. Compile prompt
compiledPrompt = promptEngine.compile("script.generate", mappedInput);

// 5. Call provider
aiResult = await gateway.getProvider().generate(compiledPrompt, config);

// 6. Validate
validated = validator.validate(aiResult, schema);

// 7. Store cache
await cache.set(cacheKey, validated, TTL);

// 8. Parse output
response = workflow.outputMapper(validated);
```

**4. Response**

```json
{
  "success": true,
  "module": "script-development",
  "task": "generate-script",
  "data": { screenplay, characters, themes, ... },
  "meta": { provider, model, tokens, time, ... }
}
```

---

## 🧠 Prompt Management

### Template System

Each module has comprehensive prompt templates with:

- **System Prompt**: Role & instructions for AI
- **User Template**: Variables placeholders
- **Defaults**: Fallback values
- **Generation Config**: Temperature, max tokens, etc.

```javascript
promptEngine.register({
  id: "script.generate",
  systemPrompt: "You are a world-class screenwriter...",
  userPromptTemplate: "Generate a {{format}} script:\n{{prompt}}",
  requiredVariables: ["prompt"],
  optionalVariables: ["genre", "tone"],
  defaults: { genre: "drama", tone: "balanced" },
  generationConfig: { temperature: 0.8, maxTokens: 8192 },
});
```

### Template Compilation

```javascript
// Input
{ prompt: 'A detective...', genre: 'sci-fi', tone: 'noir' }

// Compilation (replaces {{variable}} with values)
'Generate a screenplay script:\n\nA detective...\n\nGenre: sci-fi\nTone: noir'

// Sent to AI with system prompt
```

---

## 🛡️ Error Handling & Validation

### Input Validation

```javascript
const { valid, errors } = executor.validateInput(module, task, input);
if (!valid) {
  throw new ApiError(400, "Validation failed", errors);
}
```

### Output Validation

```javascript
// Schemas verify AI response matches expected structure
validator.validate(aiResponse, {
  title: "string",
  content: "string",
  characters: "array",
  themes: "array",
});
```

### Error Recovery

- **Circuit Breaker**: Automatic provider failover on errors
- **Rate Limiting**: Per-user request quotas
- **Retry Logic**: Automatic retries with exponential backoff
- **Fallback Providers**: Switch to alternate AI provider if primary fails

---

## 📈 Monitoring & Observability

### Metrics Tracked

- Request count per module/task
- Response times (p50, p95, p99)
- Error rates by provider
- Cache hit rates
- Token usage per user
- Queue depth (async jobs)

### Logging

```javascript
logger.info(`[Orchestrator] Executing script-development::generate-script`);
logger.debug(`[Cache] Miss for ${cacheKey}`);
logger.warn(`[Gateway] Provider failure, switching to fallback`);
logger.error(`[Validation] Response validation failed: ${errors}`);
```

---

## ⚙️ Configuration

### Environment Variables

```bash
# AI Providers
AI_DEFAULT_PROVIDER=openai
OPENAI_API_KEY=sk-...
GEMINI_API_KEY=...

# Redis (for caching & queueing)
REDIS_URL=redis://localhost:6379

# Rate Limiting
AI_MAX_REQUESTS_PER_USER=50      # per hour
AI_MAX_TOKENS_PER_MONTH=1000000

# Providers
OPENAI_MODEL=gpt-4-turbo
GEMINI_MODEL=gemini-pro
```

---

## 🚀 Getting Started

### Backend Setup

```bash
# Install dependencies
npm install

# Start server
npm run dev

# Run tests
npm test
```

### Frontend Setup

```bash
# Generate models (JSON serialization)
flutter pub run build_runner build

# Run app
flutter run
```

### First AI Request

```dart
// Get service
final aiService = ref.watch(aiServiceProvider);

// Generate script
final result = await aiService.generate(
  module: 'script-development',
  task: 'generate-script',
  input: 'A detective solving cyber crimes in 2050',
);

// Use response
print(result.data['title']);      // Screenplay title
print(result.data['content']);    // Full screenplay
print(result.meta['tokensUsed']); // Tokens consumed
```

---

## 📊 Performance Considerations

### Caching Strategy

- **Cache Duration**: 24 hours for most operations
- **Cache Key**: Hash of (module, task, input, provider)
- **Hit Rate Target**: 60-70% for common operations
- **Storage**: Redis for distributed deployment

### Async Processing

- **Long Operations**: Use async queue for >5 second tasks
- **Polling**: Client polls `/ai/jobs/:jobId` for status
- **Webhooks**: Optional webhook notifications on completion

### Rate Limiting

- **Per User**: 50 requests/hour (configurable)
- **Per Provider**: 3,500 requests/minute (OpenAI limit)
- **Cooldown**: 60 second circuit breaker on provider failure

---

## 🔐 Security

- **Auth**: Required for all endpoints (JWT token)
- **Rate Limiting**: Per-user and per-IP
- **Input Validation**: Sanitization of user input
- **Output Filtering**: Sensitive data redaction in logs
- **Audit Logging**: Track all AI operations for compliance

---

## 📚 Resources

- [Prompt Engineering Best Practices](./docs/prompt-engineering.md)
- [API Reference](./docs/api-reference.md)
- [Troubleshooting Guide](./docs/troubleshooting.md)
- [Contributing Guidelines](./docs/contributing.md)

---

## 🎓 Advanced Topics

### Custom Workflows

Create specialized workflows for specific use cases:

```javascript
workflowRegistry.register({
  module: "custom-module",
  task: "custom-task",
  templateId: "custom.template",
  inputMapper: (input) => ({
    /* transform */
  }),
  outputMapper: (data) => ({
    /* format */
  }),
  cacheable: true,
});
```

### Provider Switching

Dynamically choose provider based on task requirements:

```javascript
// Use GPT-4 for complex tasks
if (complexity > 0.8) {
  result = await orchestrator.execute({ provider: "openai-4" });
} else {
  result = await orchestrator.execute({ provider: "gemini-flash" });
}
```

### Streaming Responses

For long-running operations:

```dart
final stream = await aiService.generateStream(
  module: 'script-development',
  task: 'generate-script',
  input: 'A detective...',
);

stream.listen((chunk) {
  print(chunk.toString()); // Incremental updates
});
```

---

## 📞 Support & Troubleshooting

**Q: My request is timing out**

- A: Check provider availability via `/ai/health`, increase timeout in options

**Q: Cache isn't working**

- A: Verify Redis connection, check cache TTL in configuration

**Q: Provider rate limit exceeded**

- A: Implement request queuing, use async job processing

**Q: Low token efficiency**

- A: Optimize prompts, use smaller models for simple tasks

---

**Last Updated**: 2026-05-07  
**Version**: 1.0.0  
**Status**: Production Ready
