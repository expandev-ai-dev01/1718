import { Request, Response } from 'express';
import { successResponse } from '@/utils/responseHandler';

/**
 * @summary
 * Handles the health check request.
 *
 * @api {get} /api/v1/external/public/health Health Check
 * @apiName GetHealth
 * @apiGroup Health
 * @apiVersion 1.0.0
 *
 * @apiSuccess {Boolean} success Indicates if the request was successful.
 * @apiSuccess {Object} data Contains the health status.
 * @apiSuccess {String} data.status The status of the service.
 *
 * @example
 * // Returns a success response with the service status.
 * res.status(200).json({
 *   success: true,
 *   data: { status: 'ok' }
 * });
 */
export function getHandler(_req: Request, res: Response): void {
  res.status(200).json(successResponse({ status: 'ok' }));
}
