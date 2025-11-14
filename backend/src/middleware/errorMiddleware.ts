import { Request, Response, NextFunction } from 'express';
import { ZodError } from 'zod';
import { config } from '@/config';

interface AppError extends Error {
  statusCode?: number;
  isOperational?: boolean;
}

export const errorMiddleware = (
  err: AppError,
  _req: Request,
  res: Response,
  _next: NextFunction // eslint-disable-line @typescript-eslint/no-unused-vars
) => {
  const statusCode = err.statusCode || 500;
  let message = err.message || 'Something went wrong';

  if (err instanceof ZodError) {
    return res.status(400).json({
      success: false,
      error: {
        code: 'VALIDATION_ERROR',
        message: 'Invalid input data.',
        details: err.errors.map((e) => ({ path: e.path.join('.'), message: e.message })),
      },
      timestamp: new Date().toISOString(),
    });
  }

  // For operational errors, we send a more descriptive message
  if (err.isOperational) {
    message = err.message;
  }

  // In production, we don't want to leak implementation details
  if (config.env === 'production' && !err.isOperational) {
    console.error('UNHANDLED ERROR:', err);
    message = 'Internal Server Error';
  }

  res.status(statusCode).json({
    success: false,
    error: {
      code: err.name.toUpperCase().replace(/ /g, '_'),
      message,
      details: config.env !== 'production' ? err.stack : undefined,
    },
    timestamp: new Date().toISOString(),
  });
};
