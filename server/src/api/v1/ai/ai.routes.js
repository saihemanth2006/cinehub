/**
 * @module api/v1/ai/ai.routes
 * @description AI API endpoints — the HTTP interface to the CineHub AI orchestration system.
 *
 * Routes:
 * POST   /generate-script     — Generate a script from a premise
 * POST   /enhance-story       — Analyze and enhance an existing script
 * POST   /analyze-genre       — Classify genre with market analysis
 * POST   /estimate-budget     — Estimate production budget
 * POST   /recommend-talent    — Recommend team composition
 * POST   /creative-assist     — Interactive creative assistant
 * POST   /project-insights    — Generate AI project insights
 * GET    /recommendations     — Get personalized recommendations
 * GET    /providers           — List available AI providers
 * GET    /health              — AI system health and metrics
 * GET    /dashboard           — AI analytics dashboard
 * GET    /usage               — Current user's AI usage stats
 * GET    /jobs/:jobId         — Get async job status
 */
const express = require('express');
const catchAsync = require('../../../utils/catchAsync');
const ApiResponse = require('../../../utils/ApiResponse');
const aiService = require('./ai.service');
const { authenticate, aiLimiter, validate } = require('../../../middleware');
const validation = require('./ai.validation');
const { logger } = require('../../../config');

const router = express.Router();

// All AI routes require authentication
router.use(authenticate());

// ── Script Generation ───────────────────────────────────

router.post(
  '/generate-script',
  aiLimiter,
  validate(validation.generateScript),
  catchAsync(async (req, res) => {
    const { projectId, format, provider, ...promptData } = req.body;
    logger.info(`[AI API] Script generation requested by user ${req.user._id}`);

    const result = await aiService.generateScript({
      userId: req.user._id.toString(),
      projectId,
      promptData: { format, ...promptData },
      provider,
      requestId: req.requestId,
    });

    ApiResponse.created(result, 'Script generated successfully').send(res);
  }),
);

// ── Story Enhancement ───────────────────────────────────

router.post(
  '/enhance-story',
  aiLimiter,
  validate(validation.enhanceStory),
  catchAsync(async (req, res) => {
    const { content, logline, genre, focusAreas, provider } = req.body;

    const result = await aiService.enhanceStory({
      userId: req.user._id.toString(),
      content,
      logline,
      genre,
      focusAreas,
      provider,
      requestId: req.requestId,
    });

    ApiResponse.ok(result, 'Story enhancement generated').send(res);
  }),
);

// ── Genre Analysis ──────────────────────────────────────

router.post(
  '/analyze-genre',
  aiLimiter,
  validate(validation.analyzeGenre),
  catchAsync(async (req, res) => {
    const { logline, synopsis, content, provider } = req.body;

    const result = await aiService.analyzeGenre({
      userId: req.user._id.toString(),
      logline,
      synopsis,
      content,
      provider,
      requestId: req.requestId,
    });

    ApiResponse.ok(result, 'Genre analysis generated').send(res);
  }),
);

// ── Budget Estimation ───────────────────────────────────

router.post(
  '/estimate-budget',
  aiLimiter,
  validate(validation.estimateBudget),
  catchAsync(async (req, res) => {
    const { projectType, location, duration, scenes, characters, content, provider } = req.body;

    const result = await aiService.estimateBudget({
      userId: req.user._id.toString(),
      projectType,
      location,
      duration,
      scenes,
      characters,
      content,
      provider,
      requestId: req.requestId,
    });

    ApiResponse.ok(result, 'Budget estimation generated').send(res);
  }),
);

// ── Talent Recommendation ───────────────────────────────

router.post(
  '/recommend-talent',
  aiLimiter,
  validate(validation.recommendTalent),
  catchAsync(async (req, res) => {
    const { projectType, genre, budget, scale, requirements, provider } = req.body;

    const result = await aiService.recommendTalent({
      userId: req.user._id.toString(),
      projectType,
      genre,
      budget,
      scale,
      requirements,
      provider,
      requestId: req.requestId,
    });

    ApiResponse.ok(result, 'Talent recommendations generated').send(res);
  }),
);

// ── Creative Assistant ──────────────────────────────────

router.post(
  '/creative-assist',
  aiLimiter,
  validate(validation.creativeAssist),
  catchAsync(async (req, res) => {
    const { query, projectContext, context, provider } = req.body;

    const result = await aiService.creativeAssist({
      userId: req.user._id.toString(),
      query,
      projectContext,
      context,
      provider,
      requestId: req.requestId,
    });

    ApiResponse.ok(result, 'Creative assistance generated').send(res);
  }),
);

// ── Project Insights ────────────────────────────────────

router.post(
  '/project-insights',
  aiLimiter,
  validate(validation.projectInsights),
  catchAsync(async (req, res) => {
    const { projectId, provider } = req.body;

    // In production, fetch project data from DB. Placeholder for now.
    const result = await aiService.getProjectInsights({
      userId: req.user._id.toString(),
      project: { title: 'Project', type: 'film', status: 'draft' },
      provider,
      requestId: req.requestId,
    });

    ApiResponse.ok(result, 'Project insights generated').send(res);
  }),
);

// ── Recommendations ─────────────────────────────────────

router.get(
  '/recommendations',
  aiLimiter,
  catchAsync(async (req, res) => {
    const result = await aiService.getRecommendations({
      userId: req.user._id.toString(),
      userProfile: req.user,
      requestId: req.requestId,
    });

    ApiResponse.ok(result, 'Recommendations generated').send(res);
  }),
);

// ── Async Job Status ────────────────────────────────────

router.get(
  '/jobs/:jobId',
  validate(validation.getJobStatus),
  catchAsync(async (req, res) => {
    const result = await aiService.getJobStatus(req.params.jobId);
    ApiResponse.ok(result, 'Job status retrieved').send(res);
  }),
);

// ── Provider Information ────────────────────────────────

router.get(
  '/providers',
  catchAsync(async (_req, res) => {
    const { aiGateway } = require('../../../integrations/ai');
    const providers = aiGateway.getAvailableProviders();
    const health = aiGateway.getHealthReport();
    ApiResponse.ok({ providers, health }, 'Providers retrieved').send(res);
  }),
);

// ── AI System Health ────────────────────────────────────

router.get(
  '/health',
  catchAsync(async (_req, res) => {
    const health = aiService.getSystemHealth();
    ApiResponse.ok(health, 'AI system health').send(res);
  }),
);

// ── AI Dashboard ────────────────────────────────────────

router.get(
  '/dashboard',
  catchAsync(async (_req, res) => {
    const dashboard = aiService.getDashboard();
    ApiResponse.ok(dashboard, 'AI dashboard data').send(res);
  }),
);

// ── User Usage Stats ────────────────────────────────────

router.get(
  '/usage',
  catchAsync(async (req, res) => {
    const usage = aiService.getUserUsage(req.user._id.toString());
    ApiResponse.ok(usage, 'User AI usage stats').send(res);
  }),
);

module.exports = router;
