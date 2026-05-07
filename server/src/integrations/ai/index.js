/**
 * @module integrations/ai/index
 * @description AI Integration barrel export — the public API of the AI subsystem.
 * Import from here to access the orchestrator, pipelines, gateway, and monitoring.
 *
 * Usage:
 *   const { orchestrator, pipelines, aiGateway, aiMonitor } = require('../integrations/ai');
 */
const { getRedisClient } = require('../../config/redis');
const { logger } = require('../../config');

const AIOrchestrator = require('./orchestrator/ai.orchestrator');
const AIPipeline = require('./pipelines/ai.pipelines');
const aiGateway = require('./ai.gateway');
const aiMonitor = require('./monitoring/ai.monitor');
const promptEngine = require('./prompts/prompt.engine');
const { AIValidator } = require('./validation/ai.validator');

// Import template registry to ensure all templates are registered at module load
require('./prompts/template.registry');

// ── Singleton Initialization ────────────────────────────

let _orchestrator = null;
let _pipelines = null;

/**
 * Returns the singleton AI Orchestrator instance.
 * Lazily initializes with Redis connection.
 * @returns {AIOrchestrator}
 */
function getOrchestrator() {
  if (!_orchestrator) {
    let redisClient = null;
    try {
      redisClient = getRedisClient();
    } catch (err) {
      logger.warn('[AI] Redis not available — caching and queueing disabled');
    }

    _orchestrator = new AIOrchestrator({ redisClient });
    logger.info('[AI] ✅ Orchestrator initialized');
  }
  return _orchestrator;
}

/**
 * Returns the singleton AI Pipelines instance.
 * @returns {AIPipeline}
 */
function getPipelines() {
  if (!_pipelines) {
    _pipelines = new AIPipeline(getOrchestrator());
    logger.info('[AI] ✅ Pipelines initialized');
  }
  return _pipelines;
}

/**
 * Initializes the async queue processor.
 * Call this during server bootstrap.
 */
function initializeAIQueue() {
  const orchestrator = getOrchestrator();
  orchestrator.initializeQueue();
  logger.info('[AI] ✅ Queue processor initialized');
}

module.exports = {
  // Lazy singletons
  getOrchestrator,
  getPipelines,
  initializeAIQueue,

  // Direct access
  aiGateway,
  aiMonitor,
  promptEngine,
  AIValidator,

  // Classes (for testing / custom instances)
  AIOrchestrator,
  AIPipeline,
};
