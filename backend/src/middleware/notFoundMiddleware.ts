import { Request, Response } from 'express';

export const notFoundMiddleware = (req: Request, res: Response) => {
  res.status(404).json({
    success: false,
    error: {
      code: 'NOT_FOUND',
      message: `The requested resource '${req.originalUrl}' was not found on this server.`,
    },
    timestamp: new Date().toISOString(),
  });
};
