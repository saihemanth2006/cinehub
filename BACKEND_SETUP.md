# CineHub Backend — Complete Integration & Setup Guide

## 🎯 Overview

The CineHub backend is a production-ready Node.js/Express server with:

- **Authentication**: JWT-based with refresh tokens, roles, and permissions
- **Database**: MongoDB with Mongoose schemas and soft deletes
- **AI Integration**: Unified orchestration supporting Gemini & OpenAI
- **File Upload**: Local & AWS S3 support
- **Real-time**: Socket.IO for live notifications
- **Caching**: Redis for performance and session management
- **Email**: SMTP support for notifications and password resets
- **Error Handling**: Centralized error handling with structured responses
- **Rate Limiting**: API rate limiting to prevent abuse
- **Logging**: Structured logging for debugging and monitoring

---

## 📦 Directory Structure

```
server/
├── src/
│   ├── api/v1/                 # API endpoints (versioned)
│   │   ├── auth/               # Authentication (login, register, etc.)
│   │   ├── users/              # User management
│   │   ├── projects/           # Project CRUD
│   │   ├── scripts/            # Script management
│   │   ├── teams/              # Team collaboration
│   │   ├── portfolios/         # Portfolio pages
│   │   ├── notifications/      # Notifications
│   │   ├── discovery/          # Creator discovery & search
│   │   ├── media/              # Media upload & management
│   │   └── ai/                 # Unified AI endpoint
│   ├── config/                 # Configuration (env, database, redis, logger)
│   ├── models/                 # Mongoose schemas
│   ├── repositories/           # Data access layer
│   ├── middleware/             # Express middleware (auth, validation, etc.)
│   ├── utils/                  # Utilities (errors, responses, tokens, etc.)
│   ├── events/                 # Event emitter & listeners
│   ├── integrations/
│   │   └── ai/                 # AI orchestration system
│   │       ├── orchestrator/   # AI request coordination
│   │       ├── workflows/      # Task definitions & execution
│   │       ├── providers/      # Gemini & OpenAI adapters
│   │       ├── pipelines/      # Advanced AI pipelines
│   │       ├── prompts/        # Prompt templates & engine
│   │       ├── cache/          # AI result caching
│   │       ├── monitoring/     # Usage tracking
│   │       └── queue/          # Async job processing
│   ├── app.js                  # Express app setup
│   └── index.js                # Server bootstrap
├── scripts/
│   └── seed.js                 # Database seeding script
├── .env                        # Environment variables (gitignored)
├── .env.example                # Example configuration
└── package.json                # Dependencies
```

---

## 🚀 Getting Started

### 1. Prerequisites

- **Node.js** ≥ 18.x
- **MongoDB** (local or cloud: MongoDB Atlas)
- **Redis** (optional, for caching/sessions)
- **AI API Keys**: Gemini or OpenAI (or both)

### 2. Install Dependencies

```bash
cd server
npm install
```

### 3. Configure Environment

Copy `.env.example` to `.env` and fill in your values:

```bash
cp .env.example .env
```

**Critical Variables:**

```env
# Server
NODE_ENV=development
PORT=5000
APP_URL=http://localhost:5000
CLIENT_URL=http://localhost:3000

# Database (use MongoDB Atlas in production)
MONGODB_URI=mongodb://localhost:27017/cinehub_dev

# JWT (generate 32+ char random strings)
JWT_ACCESS_SECRET=your_long_random_secret_key_here_32_chars_minimum
JWT_REFRESH_SECRET=your_long_random_refresh_secret_key_here_32_chars

# AI (at least one required)
GEMINI_API_KEY=your_gemini_api_key
# OR
OPENAI_API_KEY=sk-your-openai-api-key
AI_DEFAULT_PROVIDER=gemini
```

### 4. Start MongoDB

**Option A: Local MongoDB**

```bash
# macOS (with Homebrew)
brew services start mongodb-community

# Windows (with MongoDB installed)
mongod
```

**Option B: MongoDB Atlas (Cloud)**

- Create a cluster on [mongodb.com/cloud/atlas](https://mongodb.com/cloud/atlas)
- Copy connection string and set `MONGODB_URI` in `.env`

### 5. Start Redis (Optional)

```bash
# macOS
brew services start redis

# Windows (with WSL)
redis-server
```

### 6. Run Development Server

```bash
npm run dev
```

Expected output:

```
╔═══════════════════════════════════════════════╗
║                                               ║
║   🎬  CineHub Server v1.0.0                  ║
║                                               ║
║   Environment : development                   ║
║   Port        : 5000                          ║
║   API         : http://localhost:5000/api/v1 ║
║                                               ║
╚═══════════════════════════════════════════════╝
```

---

## 📚 API Endpoints

### Health & Status

```bash
# Health check
GET /api/v1/health

# Root info
GET /
```

### Authentication

```bash
# Register
POST /api/v1/auth/register
{
  "firstName": "John",
  "lastName": "Doe",
  "email": "john@example.com",
  "password": "SecurePass123!"
}

# Login
POST /api/v1/auth/login
{
  "email": "john@example.com",
  "password": "SecurePass123!"
}

# Get current user
GET /api/v1/auth/me
Authorization: Bearer {accessToken}

# Refresh tokens
POST /api/v1/auth/refresh-tokens
{
  "refreshToken": "{refreshToken}"
}

# Logout
POST /api/v1/auth/logout
Authorization: Bearer {accessToken}
```

### AI Generation (Unified Endpoint)

```bash
# Test endpoint (no auth required for dev)
POST /api/v1/ai/test-generate
{
  "module": "script-development",
  "task": "story-expansion",
  "input": "A detective solving cyber crimes in 2050",
  "options": { "genre": "sci-fi noir" }
}

# Production endpoint (requires auth)
POST /api/v1/ai/generate
Authorization: Bearer {accessToken}
{
  "module": "script-development",
  "task": "story-expansion",
  "input": "A detective solving cyber crimes in 2050",
  "options": { "genre": "sci-fi noir" }
}

# List capabilities
GET /api/v1/ai/capabilities
Authorization: Bearer {accessToken}

# List modules
GET /api/v1/ai/modules
Authorization: Bearer {accessToken}

# Get tasks for a module
GET /api/v1/ai/modules/{module}/tasks
Authorization: Bearer {accessToken}
```

### Users

```bash
# Get all users
GET /api/v1/users

# Get user by ID
GET /api/v1/users/{userId}

# Update user
PATCH /api/v1/users/{userId}
{
  "firstName": "Jane",
  "bio": "Film producer and director",
  "location": { "city": "Los Angeles", "country": "USA" }
}

# Search creators
GET /api/v1/discovery/creators?skills=directing&location=Mumbai
```

### Projects

```bash
# Create project
POST /api/v1/projects
{
  "title": "Echoes of Tomorrow",
  "description": "A sci-fi thriller",
  "genre": "sci-fi",
  "status": "in-progress"
}

# Get user's projects
GET /api/v1/projects

# Get project by ID
GET /api/v1/projects/{projectId}

# Update project
PATCH /api/v1/projects/{projectId}
{
  "status": "completed",
  "progress": 100
}
```

### Teams & Collaboration

```bash
# Create team
POST /api/v1/teams
{
  "name": "Creative Squad",
  "description": "Team for indie film projects"
}

# Add team member
POST /api/v1/teams/{teamId}/members
{
  "userId": "{userId}",
  "role": "director"
}

# Get team
GET /api/v1/teams/{teamId}
```

### Media Upload

```bash
# Upload image (multipart/form-data)
POST /api/v1/media/upload
FormData:
  - file: (image file)
  - type: "avatar" | "portfolio" | "cover"

# Upload video (chunked for large files)
POST /api/v1/media/upload/video
FormData:
  - file: (video file)
  - projectId: "{projectId}"
```

---

## 🎬 AI Modules & Tasks

The unified `/ai/generate` endpoint supports:

### 1. Script Development

- **story-expansion**: Develop a story premise into a detailed outline
- **character-development**: Create detailed character backstories
- **dialogue-generation**: Generate realistic dialogue for scenes
- **scene-breakdown**: Break down scenes for production

### 2. Script Enhancement

- **script-analysis**: Analyze existing script for structure and pacing
- **dialogue-improvement**: Improve dialogue quality and authenticity
- **plot-strengthening**: Strengthen plot coherence and arcs

### 3. Genre & Market Analysis

- **genre-analysis**: Classify genre and sub-genres
- **market-analysis**: Analyze market trends and audience
- **comp-titles**: Find comparable films

### 4. Production Planning

- **budget-estimation**: Estimate production budget
- **crew-recommendations**: Recommend crew composition
- **equipment-recommendations**: Suggest equipment and tech

### 5. Creative Assistant

- **brainstorming**: Brainstorm creative ideas
- **problem-solving**: Help solve creative challenges
- **feedback-analysis**: Analyze and provide feedback

---

## 🔑 Authentication & Authorization

### Token Types

- **Access Token**: Short-lived (15 minutes), for API calls
- **Refresh Token**: Long-lived (7 days), for getting new access tokens
- **Reset Token**: For password resets (10 minutes)
- **Verify Email Token**: For email verification (24 hours)

### Using Tokens

```bash
# Include in Authorization header
Authorization: Bearer {accessToken}

# Or in cookies (automatically set by login response)
Authorization: Bearer {accessToken}
```

### User Roles

- `user` - Regular user
- `creator` - Content creator (enhanced features)
- `moderator` - Moderation capabilities
- `admin` - Full system access

---

## 🗄️ Database Seeding

Populate the database with sample data:

```bash
npm run seed
```

This creates:

- 5 sample users
- 10 sample projects
- 5 sample teams
- 20 sample portfolios

---

## 🧪 Testing

### Test Authentication

```bash
# 1. Create a test user
curl -X POST http://localhost:5000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "Test",
    "lastName": "User",
    "email": "test@cinehub.ai",
    "password": "TestPass123!"
  }'

# 2. Login to get tokens
curl -X POST http://localhost:5000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@cinehub.ai",
    "password": "TestPass123!"
  }'

# 3. Use accessToken in subsequent requests
curl -X GET http://localhost:5000/api/v1/auth/me \
  -H "Authorization: Bearer {accessToken}"
```

### Test AI Generation

```bash
# Test endpoint (no auth required)
curl -X POST http://localhost:5000/api/v1/ai/test-generate \
  -H "Content-Type: application/json" \
  -d '{
    "module": "script-development",
    "task": "story-expansion",
    "input": "A detective solving cyber crimes in 2050",
    "options": {"genre": "sci-fi noir"}
  }'
```

Or run the automated test:

```bash
node test-ai.js
```

---

## 🛠️ Development Commands

```bash
# Start dev server with hot reload
npm run dev

# Run production build
npm run prod

# Run tests
npm run test

# Run tests with coverage
npm run test:coverage

# Lint code
npm run lint

# Fix linting issues
npm run lint:fix

# Format code
npm run format

# Seed database
npm run seed

# Database migrations
npm run migrate

# Generate API docs
npm run docs
```

---

## 🔐 Security Best Practices

1. **Environment Variables**: Never commit `.env`, use `.env.example`
2. **JWT Secrets**: Use strong, random 32+ character strings
3. **Password**: Minimum 8 characters, enforced by schema
4. **Rate Limiting**: Enabled on auth endpoints to prevent brute force
5. **CORS**: Only allow requests from `CLIENT_URL`
6. **Helmet**: Security headers enabled
7. **Sanitization**: NoSQL injection prevention
8. **HTTPS**: Use in production only

---

## 🚨 Troubleshooting

### MongoDB Connection Failed

```
Error: connect ECONNREFUSED 127.0.0.1:27017
```

**Solution:**

- Start MongoDB: `brew services start mongodb-community`
- Or use MongoDB Atlas and update `MONGODB_URI`

### JWT Validation Failed

```
Error: Token type mismatch or invalid token
```

**Solution:**

- Check JWT secrets in `.env` are 32+ characters
- Ensure token format: `Authorization: Bearer {token}`

### AI Generation Not Working

```
Error: GEMINI_API_KEY or OPENAI_API_KEY not configured
```

**Solution:**

- Set at least one API key in `.env`
- Get free tier API key from Gemini AI or OpenAI
- Set `AI_DEFAULT_PROVIDER` to available provider

### Redis Connection Optional

If Redis is not available, the system works without caching:

```
[AI] Redis not available — caching and queueing disabled
```

This is fine for development. Redis is optional but recommended for production.

---

## 📊 Monitoring & Logging

Logs are written to:

- **Console**: Real-time output
- **File**: `logs/` directory (created automatically)

Set log level in `.env`:

```env
LOG_LEVEL=debug    # Most verbose
LOG_LEVEL=info     # Default
LOG_LEVEL=warn     # Only warnings
LOG_LEVEL=error    # Only errors
```

---

## 🚀 Production Deployment

### Environment Setup

```env
NODE_ENV=production
PORT=5000
APP_URL=https://cinehub.api.com
CLIENT_URL=https://cinehub.com

# Use strong, unique secrets
JWT_ACCESS_SECRET=generate_strong_random_32_char_string
JWT_REFRESH_SECRET=generate_another_strong_random_32_char_string

# Use MongoDB Atlas connection
MONGODB_URI=mongodb+srv://user:password@cluster.mongodb.net/cinehub_prod

# Use production AI keys
GEMINI_API_KEY=prod_gemini_key
OPENAI_API_KEY=prod_openai_key

# Use Redis in production
REDIS_HOST=your_redis_host
REDIS_PORT=6379
REDIS_PASSWORD=your_redis_password

# Email for notifications
SMTP_HOST=smtp.gmail.com
SMTP_USER=your_email@gmail.com
SMTP_PASS=app_password
```

### Deploy with PM2

```bash
npm install -g pm2

pm2 start src/index.js --name "cinehub-api" --env production

pm2 save
pm2 startup
```

### Deploy with Docker

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY src ./src
EXPOSE 5000
CMD ["node", "src/index.js"]
```

---

## 📝 API Documentation

Auto-generated Swagger docs available at:

```
GET http://localhost:5000/api/v1/docs
```

---

## 🤝 Contributing

1. Follow the established project structure
2. Use the repository pattern for data access
3. Always validate input with Joi
4. Return responses using ApiResponse utility
5. Handle errors with ApiError utility
6. Add tests for new endpoints

---

## 📞 Support

For issues or questions:

1. Check the troubleshooting section above
2. Review error logs in `logs/` directory
3. Check `.env` configuration
4. Verify all prerequisites are installed

---

**Status**: ✅ Production Ready
**Version**: 1.0.0
**Last Updated**: May 8, 2026
