// A more robust logger (like Winston or Pino) can be implemented here.
// For this foundation, we'll use a simple console wrapper.

const log = (level: 'info' | 'warn' | 'error', message: string, context?: object) => {
  const timestamp = new Date().toISOString();
  const logObject = {
    timestamp,
    level,
    message,
    ...context,
  };
  console[level](JSON.stringify(logObject, null, 2));
};

export const logger = {
  info: (message: string, context?: object) => log('info', message, context),
  warn: (message: string, context?: object) => log('warn', message, context),
  error: (message: string, context?: object) => log('error', message, context),
};
