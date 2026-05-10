# CineHub Backend — Quick Start & Verification Guide

## ⚡ Quick Start (5 minutes)

### Windows

```bash
# 1. Open PowerShell in the server folder
cd server

# 2. Run the startup script
.\start-dev.bat

# 3. You should see:
# ✓ Node.js found
# ✓ npm found
# ✓ .env file exists
# ✓ Dependencies installed
# 🚀 Starting development server...
```

### macOS/Linux

```bash
# 1. Navigate to server folder
cd server

# 2. Make startup script executable
chmod +x start-dev.sh

# 3. Run the startup script
./start-dev.sh

# 4. You should see the same startup messages
```

---

## 🔍 Verification Checklist

### ✅ Prerequisites Installed

```bash
# Check Node.js (should be ≥18.x)
node --version

# Check npm
npm --version

# Check MongoDB is running
# Windows: mongod command or check Services
# macOS: brew services list | grep mongodb

# Check Redis (optional but recommended)
# Windows: Check if redis-server is running
# macOS: brew services list | grep redis
```

### ✅ Environment Configuration

```bash
# Check .env has all required variables
# Should have:
# - MONGODB_URI (local or Atlas)
# - JWT_ACCESS_SECRET (32+ chars)
# - JWT_REFRESH_SECRET (32+ chars)
# - GEMINI_API_KEY or OPENAI_API_KEY

# View current config
cat .env  # macOS/Linux
type .env # Windows
```

### ✅ Dependencies Installed

```bash
cd server

# Install dependencies
npm install

# Check installation
npm ls | head -20  # Shows main dependencies
```

### ✅ Server Starts Successfully

```bash
# Start in development mode
npm run dev

# Expected output:
# ╔═══════════════════════════════════════════╗
# ║   🎬  CineHub Server v1.0.0              ║
# ║   Environment : development               ║
# ║   Port        : 5000                      ║
# ║   API         : http://localhost:5000    ║
# ╚═══════════════════════════════════════════╝
```

### ✅ Database Connection

```bash
# Check MongoDB
# In another terminal:
cd server
npm run seed

# Should output:
# ✅ Database connected
# ✅ Sample users created
# ✅ Sample projects created
```

---

## 🧪 Testing Endpoints

### 1. Health Check

```bash
curl http://localhost:5000/health
```

**Expected Response:**

```json
{
  "status": "ok",
  "environment": "development"
}
```

### 2. Register & Login

```bash
# Register
curl -X POST http://localhost:5000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "testuser@example.com",
    "password": "TestPass123!",
    "firstName": "Test",
    "lastName": "User"
  }'

# Response should have:
# {
#   "status": "success",
#   "data": {
#     "tokens": {
#       "accessToken": "eyJ...",
#       "refreshToken": "eyJ..."
#     },
#     "user": { ... }
#   }
# }
```

### 3. Get Current User

```bash
# Use the accessToken from login response
curl -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  http://localhost:5000/api/v1/auth/me
```

### 4. AI Generation Test (No Auth Required)

```bash
curl -X POST http://localhost:5000/api/v1/ai/test-generate \
  -H "Content-Type: application/json" \
  -d '{
    "module": "script-development",
    "task": "story-expansion",
    "input": "A detective solving cyber crimes in 2050",
    "options": {"genre": "sci-fi noir"}
  }'

# Response:
# {
#   "status": "success",
#   "data": {
#     "title": "...",
#     "logline": "...",
#     "characters": [...],
#     "threeActStructure": {...}
#   }
# }
```

### 5. Run Automated Test

```bash
npm run test:ai
# or
node test-ai.js
```

---

## 🐛 Troubleshooting

### Issue: Cannot Connect to MongoDB

**Error:**

```
MongoNetworkError: connect ECONNREFUSED 127.0.0.1:27017
```

**Solution:**

```bash
# macOS
brew services start mongodb-community

# Windows - Start MongoDB service or run
mongod

# Or use MongoDB Atlas (cloud)
# 1. Go to mongodb.com/cloud/atlas
# 2. Create a free cluster
# 3. Copy connection string
# 4. Set MONGODB_URI in .env
```

### Issue: JWT Secret Too Short

**Error:**

```
JWT_ACCESS_SECRET must be at least 32 characters
```

**Solution:**

```bash
# Generate strong random strings
# Windows PowerShell:
[Convert]::ToBase64String((1..32 | ForEach-Object { Get-Random -Maximum 256 })) | Out-String

# macOS/Linux:
openssl rand -base64 32

# Update .env with the generated strings
JWT_ACCESS_SECRET=your_generated_string_here
JWT_REFRESH_SECRET=your_another_generated_string_here
```

### Issue: AI API Key Not Found

**Error:**

```
GEMINI_API_KEY or OPENAI_API_KEY not configured
```

**Solution:**

```bash
# Get free Gemini API key
# 1. Go to https://aistudio.google.com/app/apikey
# 2. Click "Create API Key"
# 3. Copy the key
# 4. Update .env:
GEMINI_API_KEY=your_api_key_here

# Or use OpenAI
# 1. Go to https://platform.openai.com/api-keys
# 2. Create new secret key
# 3. Update .env:
OPENAI_API_KEY=sk-your-key-here
AI_DEFAULT_PROVIDER=openai
```

### Issue: Port Already in Use

**Error:**

```
Error: listen EADDRINUSE :::5000
```

**Solution:**

```bash
# Windows PowerShell
netstat -ano | findstr :5000
taskkill /PID <PID> /F

# macOS/Linux
lsof -i :5000
kill -9 <PID>

# Or use a different port
PORT=5001 npm run dev
```

### Issue: Dependencies Not Installed

**Error:**

```
Cannot find module 'express'
```

**Solution:**

```bash
cd server
npm install

# If that doesn't work, clear cache and reinstall
npm cache clean --force
rm -rf node_modules package-lock.json
npm install
```

---

## 📊 Monitoring

### View Server Logs

```bash
# Real-time logs (while running)
npm run dev

# View log files
cat logs/app.log
tail -f logs/app.log  # Follow log file
```

### Check System Resources

```bash
# macOS
top -p $(pgrep -f "node.*index.js")

# Windows (Task Manager or)
tasklist | findstr node
```

---

## 🔗 Integration with Flutter

### 1. Update Flutter API Configuration

**File:** `lib/core/config/app_config.dart`

```dart
class AppConfig {
  String get apiBaseUrl => 'http://localhost:5000/api/v1';
  // For real device on Windows from Android Emulator:
  // String get apiBaseUrl => 'http://10.0.2.2:5000/api/v1';
}
```

### 2. Test Backend-to-Frontend Connection

```bash
# Start backend
npm run dev

# In another terminal, start Flutter
cd ..
flutter run
```

### 3. Verify Connection in Flutter App

The app should:

1. ✅ Load splash screen
2. ✅ Redirect to login if not authenticated
3. ✅ Allow login with test user (created by seed)
4. ✅ Show home screen after login
5. ✅ Load projects from backend
6. ✅ Generate AI content when requested

---

## 📝 Database Operations

### Seed Database

```bash
npm run seed

# This creates:
# - 5 test users
# - 10 test projects
# - 5 test teams
# - 20 test portfolios
```

### List Users

```bash
# MongoDB shell
mongosh

# Then run:
use cinehub_dev
db.users.find().pretty()
```

### Clear Database

```bash
# MongoDB shell
mongosh
use cinehub_dev
db.dropDatabase()

# Then re-seed
npm run seed
```

---

## 🚀 Development Workflow

### 1. Start Backend

```bash
cd server
npm run dev
```

### 2. In Another Terminal, Start Frontend

```bash
cd ..
flutter run
```

### 3. Make Changes

- **Backend**: Changes auto-reload (nodemon)
- **Frontend**: Hot reload (Ctrl+R)

### 4. Test APIs

```bash
# Run the test script
cd server
npm run test:ai
```

---

## 🔐 Security Notes

### Development Setup

✅ Good for local development  
❌ Not for production

### For Production

1. ✅ Use strong, unique JWT secrets
2. ✅ Enable HTTPS only
3. ✅ Use MongoDB Atlas instead of local
4. ✅ Set up proper CORS origins
5. ✅ Enable rate limiting stricter
6. ✅ Use environment-specific configurations
7. ✅ Enable HTTPS for all API calls

---

## 📞 Support

### Check Status

```bash
# Is backend running?
curl -s http://localhost:5000/health | jq .

# Is database connected?
curl -s http://localhost:5000/api/v1/auth/me -H "Authorization: Bearer test" 2>&1 | head -20

# Check logs
tail -f server/logs/app.log
```

### Common Commands

```bash
# Start backend dev
npm run dev

# Start backend production
npm run prod

# Run tests
npm run test

# Seed database
npm run seed

# Format code
npm run format

# Lint code
npm run lint

# View API documentation (when available)
open http://localhost:5000/api/v1/docs
```

---

## 📚 Next Steps

1. ✅ Get backend running (`npm run dev`)
2. ✅ Seed database (`npm run seed`)
3. ✅ Test endpoints (use curl or Postman)
4. ✅ Connect Flutter frontend
5. ✅ Test authentication flow
6. ✅ Test AI generation
7. ✅ Test project CRUD
8. ✅ Deploy to production

---

**Last Updated**: May 8, 2024  
**Status**: ✅ Ready for Development
