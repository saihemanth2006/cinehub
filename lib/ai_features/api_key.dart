// Central place for the Gemini API key used by AI features.
// For production, provide the key via --dart-define=GEMINI_API_KEY=your_key
// or replace the defaultValue below with your secure key retrieval.
const String GEMINI_API_KEY = String.fromEnvironment('GEMINI_API_KEY', defaultValue: 'AIzaSyAID7TQ_4LmY51_yF7O6Fx0BD6dVa9KQuo');

// IMPORTANT: Do NOT commit real API keys to source control. Prefer using
// --dart-define or a secure runtime store (flutter_dotenv, secure storage, backend).
