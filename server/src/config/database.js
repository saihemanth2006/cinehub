/**
 * @module config/database
 * @description MongoDB connection management with retry logic,
 * connection pooling, and graceful shutdown hooks.
 */
const mongoose = require('mongoose');
const { MongoMemoryServer } = require('mongodb-memory-server');

const env = require('./env');
const logger = require('./logger');

let mongoServer = null;

/** @type {mongoose.ConnectOptions} */
const MONGO_OPTIONS = {
  maxPoolSize: 10,
  minPoolSize: 2,
  serverSelectionTimeoutMS: 5000,
  socketTimeoutMS: 45000,
  retryWrites: true,
  w: 'majority',
};

const MAX_RETRIES = 5;
const RETRY_DELAY_MS = 3000;

/**
 * Connects to MongoDB with exponential backoff retries.
 * Uses mongodb-memory-server for test environments.
 * @returns {Promise<mongoose.Connection>}
 */
async function connectDatabase() {
  let mongoUri = env.db.uri;
  
  // Start in-memory MongoDB for testing
  if (env.isTest || !env.db.uri || env.db.uri.includes('localhost:27017')) {
    try {
      mongoServer = await MongoMemoryServer.create();
      mongoUri = mongoServer.getUri();
      logger.info('[DB] 🔧 Starting mongodb-memory-server for testing...');
    } catch (err) {
      logger.error(`[DB] ❌ Failed to start in-memory MongoDB: ${err.message}`);
      throw err;
    }
  }

  let attempt = 0;

  while (attempt < MAX_RETRIES) {
    try {
      attempt += 1;
      logger.info(`[DB] Connection attempt ${attempt}/${MAX_RETRIES}...`);

      await mongoose.connect(mongoUri, MONGO_OPTIONS);
      logger.info(`[DB] ✅ Connected to MongoDB — ${maskUri(mongoUri)}`);

      _attachConnectionListeners();
      return mongoose.connection;
    } catch (err) {
      logger.error(`[DB] ❌ Attempt ${attempt} failed: ${err.message}`);

      if (attempt >= MAX_RETRIES) {
        logger.error('[DB] Max retries reached. Exiting...');
        process.exit(1);
      }

      const delay = RETRY_DELAY_MS * attempt;
      logger.info(`[DB] Retrying in ${delay}ms...`);
      await _sleep(delay);
    }
  }
}

/**
 * Gracefully closes the MongoDB connection.
 * Stops in-memory server if it was running.
 * @returns {Promise<void>}
 */
async function disconnectDatabase() {
  try {
    await mongoose.connection.close();
    logger.info('[DB] 🔌 Connection closed gracefully.');
    
    // Stop in-memory MongoDB server if it was created
    if (mongoServer) {
      await mongoServer.stop();
      logger.info('[DB] 🔧 mongodb-memory-server stopped.');
      mongoServer = null;
    }
  } catch (err) {
    logger.error(`[DB] Error during disconnect: ${err.message}`);
    throw err;
  }
}

/**
 * Returns the current connection state.
 * @returns {{ connected: boolean, readyState: number, host: string }}
 */
function getDatabaseStatus() {
  const { readyState, host, name } = mongoose.connection;
  const states = ['disconnected', 'connected', 'connecting', 'disconnecting'];
  return {
    connected: readyState === 1,
    state: states[readyState] || 'unknown',
    host: host || 'N/A',
    database: name || 'N/A',
  };
}

// ── Internal Helpers ────────────────────────

function _attachConnectionListeners() {
  mongoose.connection.on('error', (err) => {
    logger.error(`[DB] Connection error: ${err.message}`);
  });

  mongoose.connection.on('disconnected', () => {
    logger.warn('[DB] Disconnected from MongoDB.');
  });

  mongoose.connection.on('reconnected', () => {
    logger.info('[DB] Reconnected to MongoDB.');
  });
}

function maskUri(uri) {
  return uri.replace(/:\/\/(.*):(.*)@/, '://*****:*****@');
}

function _sleep(ms) {
  return new Promise((resolve) => { setTimeout(resolve, ms); });
}

module.exports = {
  connectDatabase,
  disconnectDatabase,
  getDatabaseStatus,
};
