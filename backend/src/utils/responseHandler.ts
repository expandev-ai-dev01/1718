interface SuccessResponse<T> {
  success: true;
  data: T;
  metadata?: Record<string, unknown>;
}

interface ErrorResponse {
  success: false;
  error: {
    code: string;
    message: string;
    details?: any;
  };
  timestamp: string;
}

/**
 * @summary
 * Creates a standardized success response object.
 *
 * @param {T} data The payload to be returned.
 * @param {Record<string, unknown>} [metadata] Optional metadata.
 * @returns {SuccessResponse<T>} The standardized success response.
 */
export function successResponse<T>(
  data: T,
  metadata?: Record<string, unknown>
): SuccessResponse<T> {
  return {
    success: true,
    data,
    ...(metadata && { metadata }),
  };
}

/**
 * @summary
 * Creates a standardized error response object.
 *
 * @param {string} code A unique code for the error.
 * @param {string} message A human-readable error message.
 * @param {any} [details] Optional additional details about the error.
 * @returns {ErrorResponse} The standardized error response.
 */
export function errorResponse(code: string, message: string, details?: any): ErrorResponse {
  return {
    success: false,
    error: {
      code,
      message,
      ...(details && { details }),
    },
    timestamp: new Date().toISOString(),
  };
}
