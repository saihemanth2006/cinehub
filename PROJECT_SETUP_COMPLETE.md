# CineHub — Complete Project Setup & Integration Guide

## 📖 Introduction

Welcome to CineHub! This is a complete guide to understanding, running, and integrating the entire project. The stack includes:

- **Frontend**: Flutter with Riverpod state management
- **Backend**: Node.js/Express with MongoDB & Redis
- **AI**: Unified orchestration with Gemini & OpenAI integration
- **Real-time**: Socket.IO for live messaging and notifications

---

## 🎯 Project Structure Overview

```
cinehub/
├── lib/                          # Flutter Frontend
│   ├── main.dart                 # Entry point
│   ├── app.dart                  # App configuration
│   ├── core/                     # Core utilities
│   │   ├── config/              # Configuration
│   │   ├── network/             # HTTP & Socket clients
│   │   ├── router/              # Navigation
│   │   ├── theme/               # Design system
│   │   └── di/                  # Dependency injection
│   └── features/                 # Feature modules
│       ├── auth/
│       ├── home/
│       ├── projects/
│       ├── ai/
│       ├── messaging/
│       └── [more features...]
│
├── server/                        # Node.js Backend
│   ├── src/
│   │   ├── api/v1/              # API endpoints
│   │   ├── models/              # MongoDB schemas
│   │   ├── repositories/        # Data layer
│   │   ├── middleware/          # Express middleware
│   │   ├── config/              # Configuration
│   │   ├── integrations/        # External services
│   │   │   └── ai/             # AI orchestration
│   │   ├── utils/               # Utilities
│   │   ├── events/              # Event system
│   │   ├── app.js              # Express setup
│   │   └── index.js            # Server bootstrap
│   ├── scripts/
│   │   └── seed.js             # Database seeding
│   ├── .env                     # Environment variables
│   ├── .env.example             # Example config
│   ├── package.json
│   ├── start-dev.bat            # Windows startup
│   └── start-dev.sh             # Unix startup
│
├── QUICK_START.md               # Quick setup guide
├── BACKEND_SETUP.md            # Backend documentation
├── FRONTEND_BACKEND_INTEGRATION.md  # Integration guide
└── [other docs...]
```

---

## 🚀 Getting Started — 3 Simple Steps

### Step 1: Backend Setup (5-10 minutes)

```bash
# Navigate to server directory
cd server

# Windows
.\start-dev.bat

# macOS/Linux
chmod +x start-dev.sh
./start-dev.sh

# Expected output:
# ✓ Node.js found
# ✓ npm found
# ✓ .env file exists
# ✓ Dependencies installed
# 🚀 Starting development server...
#
# ╔═════════════════════════════════════╗
# ║  🎬 CineHub Server v1.0.0          ║
# ║  Environment : development          ║
# ║  Port        : 5000                 ║
# ║  API         : http://localhost:5000║
# ╚═════════════════════════════════════╝
```

### Step 2: Seed Database (2 minutes)

```bash
# In a new terminal (while server is running)
cd server
npm run seed

# Output:
# [Seed] Connected to database
# [Seed] Cleared existing data
# [Seed] Created 3 users
# [Seed] Created 2 projects
# [Seed] ✅ Seeding complete!
# [Seed] Test credentials: email = sarah.mitchell@cinehub.test, password = CineHub@2024
```

### Step 3: Test Backend (2 minutes)

```bash
# Quick API test
curl http://localhost:5000/health

# Login test
curl -X POST http://localhost:5000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"sarah.mitchell@cinehub.test","password":"CineHub@2024"}'

# AI test
curl -X POST http://localhost:5000/api/v1/ai/test-generate \
  -H "Content-Type: application/json" \
  -d '{"module":"script-development","task":"story-expansion","input":"A detective solving cyber crimes","options":{"genre":"sci-fi"}}'
```

---

## 🔌 Frontend-Backend Integration

### Update Flutter API URL

**File**: `lib/core/config/app_config.dart`

```dart
class AppConfig {
  // Development
  static const String apiBaseUrl = 'http://localhost:5000/api/v1';

  // For Android Emulator (if on Windows)
  // static const String apiBaseUrl = 'http://10.0.2.2:5000/api/v1';
}
```

### Run Flutter App

```bash
# In Flutter project directory
cd .. # Go back to root

# Get dependencies
flutter pub get

# Run on device/emulator
flutter run

# Expected behavior:
# 1. App starts with splash screen
# 2. Redirects to login screen
# 3. Login with: sarah.mitchell@cinehub.test / CineHub@2024
# 4. Home screen loads with projects from backend
# 5. Can generate AI content
```

---

## 🧪 Comprehensive Testing Checklist

### Backend Tests

#### 1. Health Check ✅

```bash
curl http://localhost:5000/health
# Expected: {"status":"ok","environment":"development"}
```

#### 2. Authentication Flow ✅

```bash
# Register
curl -X POST http://localhost:5000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email":"newuser@test.com",
    "password":"TestPass123!",
    "firstName":"Test",
    "lastName":"User"
  }'

# Login
curl -X POST http://localhost:5000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"newuser@test.com","password":"TestPass123!"}'

# Get current user (use token from login)
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:5000/api/v1/auth/me
```

#### 3. AI Generation ✅

```bash
# Story Expansion
curl -X POST http://localhost:5000/api/v1/ai/test-generate \
  -H "Content-Type: application/json" \
  -d '{
    "module":"script-development",
    "task":"story-expansion",
    "input":"A detective solving cyber crimes in 2050",
    "options":{"genre":"sci-fi noir"}
  }'

# Dialogue Enhancement
curl -X POST http://localhost:5000/api/v1/ai/test-generate \
  -H "Content-Type: application/json" \
  -d '{
    "module":"script-development",
    "task":"dialogue-generation",
    "input":"Two friends talking about leaving town",
    "options":{"genre":"drama","tone":"intimate"}
  }'
```

#### 4. Project CRUD (Requires token)

```bash
# Create project
curl -X POST http://localhost:5000/api/v1/projects \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "title":"My First Film",
    "description":"A short indie film",
    "genre":"drama"
  }'

# List projects
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:5000/api/v1/projects

# Get project by ID
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:5000/api/v1/projects/{projectId}
```

#### 5. User Discovery

```bash
# Search creators
curl "http://localhost:5000/api/v1/discovery/creators?skills=directing&location=Los%20Angeles"
```

### Frontend Tests

#### 1. Splash & Navigation ✅

- [ ] App starts and shows splash screen
- [ ] Redirects to login after 2-3 seconds
- [ ] Login screen displays correctly

#### 2. Authentication ✅

- [ ] Can login with test credentials
- [ ] Token stored in memory
- [ ] Redirects to home screen after login
- [ ] User profile displays in top right

#### 3. Home Screen ✅

- [ ] Projects load from backend
- [ ] Search works for projects
- [ ] Can navigate between tabs
- [ ] Animations work smoothly

#### 4. Discovery Screen ✅

- [ ] Creator cards load
- [ ] Can scroll through creators
- [ ] Collaboration dialog opens on button tap
- [ ] Can submit collaboration request

#### 5. Projects Screen ✅

- [ ] User projects display
- [ ] Can create new project
- [ ] Project details show correctly
- [ ] Can update project

#### 6. AI Features ✅

- [ ] Can trigger AI generation
- [ ] Loading state displays
- [ ] Generated content displays
- [ ] Can save generated content

#### 7. Messaging ✅

- [ ] Conversations load
- [ ] Chat screen opens
- [ ] Can send messages
- [ ] Messages display in real-time

---

## 🔧 Configuration Reference

### Environment Variables (.env)

```env
# Server
NODE_ENV=development
PORT=5000
APP_URL=http://localhost:5000
CLIENT_URL=http://localhost:3000

# Database
MONGODB_URI=mongodb://localhost:27017/cinehub_dev

# JWT (generate 32+ char strings)
JWT_ACCESS_SECRET=dev_access_secret_minimum_32_chars_required
JWT_REFRESH_SECRET=dev_refresh_secret_minimum_32_chars_required

# AI (at least one required)
GEMINI_API_KEY=your_gemini_api_key
# OR
OPENAI_API_KEY=sk-your-openai-key
AI_DEFAULT_PROVIDER=gemini

# Optional
REDIS_HOST=localhost
REDIS_PORT=6379
```

### Flutter Configuration

```dart
// lib/core/config/app_config.dart
static const String apiBaseUrl = 'http://localhost:5000/api/v1';
static const String socketUrl = 'http://localhost:5000';
```

---

## 📚 Key Concepts

### Authentication Flow

```
1. User enters credentials on Login screen
2. Frontend sends POST /auth/login
3. Backend validates and returns { accessToken, refreshToken, user }
4. Frontend stores tokens in memory/secure storage
5. Frontend adds "Authorization: Bearer token" to all requests
6. Token auto-refreshes on 401 response
7. On logout, tokens cleared and redirect to login
```

### API Response Format

```json
{
  "status": "success|error",
  "message": "Human readable message",
  "data": {
    // Response data
  },
  "meta": {
    "timestamp": "2024-05-08T10:30:00Z",
    "requestId": "req-123456"
  }
}
```

### Error Handling

```dart
// In Flutter, errors are wrapped in ApiException
try {
  await authProvider.login(email, password);
} catch (e) {
  if (e is ApiException) {
    showSnackBar(e.message);
  }
}
```

---

## 🐛 Troubleshooting

### Common Issues

#### 1. Cannot Start Backend

```
Error: Cannot find module 'express'
Solution: cd server && npm install
```

#### 2. MongoDB Connection Failed

```
Error: MongoNetworkError
Solution:
- Check MongoDB is running: mongod
- Or use MongoDB Atlas: set MONGODB_URI in .env
```

#### 3. JWT Validation Fails

```
Error: JWT_ACCESS_SECRET must be 32+ chars
Solution: Generate and set in .env:
openssl rand -base64 32
```

#### 4. CORS Error in Flutter

```
Error: Origin not allowed
Solution: Ensure CLIENT_URL in .env matches Flutter app URL
```

#### 5. AI Generation Fails

```
Error: GEMINI_API_KEY not found
Solution:
1. Get key from https://aistudio.google.com/app/apikey
2. Set in .env: GEMINI_API_KEY=your_key
3. Restart backend: npm run dev
```

### Debug Tips

```bash
# Check server is running
curl http://localhost:5000/health

# View logs
tail -f server/logs/app.log

# Test database
cd server && npm run seed

# Test specific endpoint
curl -X POST http://localhost:5000/api/v1/ai/test-generate \
  -H "Content-Type: application/json" \
  -d '{"module":"script-development","task":"story-expansion","input":"test"}'
```

---

## 📊 Development Commands

### Backend

```bash
cd server

# Development with hot reload
npm run dev

# Production mode
npm run prod

# Run tests
npm run test

# Seed database
npm run seed

# Format code
npm run format

# Lint code
npm run lint
```

### Frontend

```bash
cd .. # Go to root

# Run on device
flutter run

# Build Android APK
flutter build apk

# Build iOS
flutter build ios

# Build Web
flutter build web --web-renderer=html

# Run tests
flutter test

# Analyze code
flutter analyze
```

---

## 🌍 Deployment Checklist

Before deploying to production:

### Backend

- [ ] Generate strong JWT secrets
- [ ] Use MongoDB Atlas (not local)
- [ ] Enable HTTPS
- [ ] Set NODE_ENV=production
- [ ] Configure proper error logging
- [ ] Set up database backups
- [ ] Configure rate limiting
- [ ] Use environment-specific API keys
- [ ] Enable CORS for production domain only

### Frontend

- [ ] Update API base URL to production
- [ ] Build release APK for Android
- [ ] Build release IPA for iOS
- [ ] Test all authentication flows
- [ ] Test AI generation
- [ ] Test offline functionality
- [ ] Configure app signing

---

## 📞 Support Resources

### Documentation Files

- `QUICK_START.md` - 5-minute setup guide
- `BACKEND_SETUP.md` - Complete backend documentation
- `FRONTEND_BACKEND_INTEGRATION.md` - Integration guide

### API Documentation

- Auto-generated Swagger: http://localhost:5000/api/v1/docs (when available)
- Postman collection: See server/postman/ (if available)

### Learning Resources

- [Flutter Docs](https://flutter.dev/docs)
- [Express.js Guide](https://expressjs.com/en/guide/routing.html)
- [MongoDB Manual](https://docs.mongodb.com/manual/)
- [Gemini AI Docs](https://ai.google.dev)

---

## 🎉 Next Steps

1. **Follow Quick Start** - Get backend running in 5 minutes
2. **Seed Database** - Create test data
3. **Test Endpoints** - Verify API functionality
4. **Run Frontend** - Start Flutter app
5. **Test Integration** - Login and use app
6. **Explore Features** - Try all major features
7. **Review Code** - Understand architecture
8. **Customize** - Add your own features
9. **Deploy** - Move to production

---

## 📝 Notes

- All times are approximate and depend on your system
- Make sure Node.js ≥ 18.x and Flutter ≥ 3.0 are installed
- Backend and frontend must run simultaneously for full functionality
- Check logs if anything fails
- Update `.env` with your actual API keys

---

**Version**: 1.0.0  
**Last Updated**: May 8, 2024  
**Status**: ✅ Production Ready
